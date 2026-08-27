package com.samedaydin.fanus_location

import android.Manifest
import android.app.Activity
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

/**
 * Fanus'un Android konum katmanı: geofence kayıtları, iki aşamalı izin akışı
 * (önce hassas konum, sonra arka plan konumu) ve odak oturumu sırasında çalışan
 * foreground service'in Flutter köprüsü.
 */
class FanusLocationPlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler,
    ActivityAware,
    PluginRegistry.RequestPermissionsResultListener {

    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var geofencingClient: GeofencingClient

    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingPermissionResult: MethodChannel.Result? = null

    private val busListener: (Map<String, Any>) -> Unit = { event ->
        mainHandler.post { eventSink?.success(event) }
    }

    private val geofencePendingIntent: PendingIntent by lazy {
        val intent = Intent(context, GeofenceBroadcastReceiver::class.java)
        // Geofencing API, S ve üzerinde MUTABLE PendingIntent ister.
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        PendingIntent.getBroadcast(context, 0, intent, flags)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        geofencingClient = LocationServices.getGeofencingClient(context)
        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
        GeofenceEventBus.addListener(busListener)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        GeofenceEventBus.removeListener(busListener)
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "hasPermissions" -> result.success(hasAllPermissions())
            "requestPermissions" -> requestPermissions(result)
            "registerAreas" -> registerAreas(call, result)
            "clearAreas" -> clearAreas(result)
            "startTracking" -> {
                ContextCompat.startForegroundService(
                    context,
                    Intent(context, FocusTrackingService::class.java),
                )
                result.success(null)
            }
            "stopTracking" -> {
                context.stopService(Intent(context, FocusTrackingService::class.java))
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    // --- Geofence ---

    private fun registerAreas(call: MethodCall, result: MethodChannel.Result) {
        if (!hasLocationPermission()) {
            result.error("permission_denied", "Konum izni verilmeden geofence kaydedilemez.", null)
            return
        }
        val areas = call.argument<List<Map<String, Any>>>("areas").orEmpty()
        if (areas.isEmpty()) {
            result.success(null)
            return
        }
        val geofences = areas.map { area ->
            Geofence.Builder()
                .setRequestId(area["id"] as String)
                .setCircularRegion(
                    area["latitude"] as Double,
                    area["longitude"] as Double,
                    (area["radiusMeters"] as Double).toFloat(),
                )
                .setExpirationDuration(Geofence.NEVER_EXPIRE)
                .setTransitionTypes(
                    Geofence.GEOFENCE_TRANSITION_ENTER or Geofence.GEOFENCE_TRANSITION_EXIT,
                )
                // Pil dostu: geçiş bildiriminde 1 dakikaya kadar gecikmeyi kabul et.
                .setNotificationResponsiveness(60_000)
                .build()
        }
        val request = GeofencingRequest.Builder()
            .setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
            .addGeofences(geofences)
            .build()
        try {
            geofencingClient.addGeofences(request, geofencePendingIntent)
                .addOnSuccessListener { result.success(null) }
                .addOnFailureListener { e -> result.error("geofence_error", e.message, null) }
        } catch (e: SecurityException) {
            result.error("permission_denied", e.message, null)
        }
    }

    private fun clearAreas(result: MethodChannel.Result) {
        geofencingClient.removeGeofences(geofencePendingIntent)
            .addOnSuccessListener { result.success(null) }
            .addOnFailureListener { e -> result.error("geofence_error", e.message, null) }
    }

    // --- İzin akışı ---

    private fun hasLocationPermission(): Boolean =
        ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) ==
            PackageManager.PERMISSION_GRANTED

    private fun hasBackgroundPermission(): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.Q ||
            ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_BACKGROUND_LOCATION,
            ) == PackageManager.PERMISSION_GRANTED

    private fun hasAllPermissions(): Boolean = hasLocationPermission() && hasBackgroundPermission()

    private fun requestPermissions(result: MethodChannel.Result) {
        val activity = activityBinding?.activity
        if (activity == null) {
            result.error("no_activity", "İzin istemek için görünür bir Activity gerekli.", null)
            return
        }
        if (hasAllPermissions()) {
            result.success(true)
            return
        }
        if (pendingPermissionResult != null) {
            result.error("in_progress", "Zaten bekleyen bir izin isteği var.", null)
            return
        }
        pendingPermissionResult = result
        if (!hasLocationPermission()) {
            val permissions = mutableListOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                permissions.add(Manifest.permission.POST_NOTIFICATIONS)
            }
            ActivityCompat.requestPermissions(activity, permissions.toTypedArray(), REQUEST_FOREGROUND)
        } else {
            requestBackgroundPermission(activity)
        }
    }

    private fun requestBackgroundPermission(activity: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                REQUEST_BACKGROUND,
            )
        } else {
            finishPermissionRequest(true)
        }
    }

    private fun finishPermissionRequest(granted: Boolean) {
        pendingPermissionResult?.success(granted)
        pendingPermissionResult = null
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean {
        when (requestCode) {
            REQUEST_FOREGROUND -> {
                val activity = activityBinding?.activity
                if (!hasLocationPermission() || activity == null) {
                    finishPermissionRequest(hasAllPermissions())
                } else {
                    requestBackgroundPermission(activity)
                }
                return true
            }
            REQUEST_BACKGROUND -> {
                finishPermissionRequest(hasAllPermissions())
                return true
            }
        }
        return false
    }

    // --- ActivityAware ---

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onDetachedFromActivity() {
        activityBinding?.removeRequestPermissionsResultListener(this)
        activityBinding = null
    }

    // --- EventChannel ---

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    companion object {
        private const val METHOD_CHANNEL = "com.samedaydin.fanus/location"
        private const val EVENT_CHANNEL = "com.samedaydin.fanus/location_events"
        private const val REQUEST_FOREGROUND = 4501
        private const val REQUEST_BACKGROUND = 4502
    }
}
