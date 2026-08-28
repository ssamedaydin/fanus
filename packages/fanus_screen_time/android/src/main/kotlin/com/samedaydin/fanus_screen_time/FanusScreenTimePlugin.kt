package com.samedaydin.fanus_screen_time

import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.app.usage.UsageStatsManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Process
import android.provider.Settings
import android.text.TextUtils
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

/**
 * Fanus'un Android ekran süresi katmanı:
 *  * UsageStatsManager ile günlük uygulama kullanım istatistikleri,
 *  * AccessibilityService ile odak sırasında kısıtlı uygulamaların engellenmesi,
 *  * DevicePolicyManager ile yönetici yetkisi ve force-lock entegrasyonu.
 */
class FanusScreenTimePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.samedaydin.fanus/screen_time")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "hasUsageAccess" -> result.success(hasUsageAccess())
            "openUsageAccessSettings" -> {
                openSettings(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                result.success(null)
            }
            "getTodayUsage" -> result.success(todayUsage())
            "getLaunchableApps" -> result.success(launchableApps())
            "isAccessibilityEnabled" -> result.success(isAccessibilityEnabled())
            "openAccessibilitySettings" -> {
                openSettings(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                result.success(null)
            }
            "getRestrictedApps" -> result.success(ShieldPreferences.restrictedApps(context).toList())
            "setRestrictedApps" -> {
                val packages = call.argument<List<String>>("packages").orEmpty()
                ShieldPreferences.setRestrictedApps(context, packages.toSet())
                result.success(null)
            }
            "isShieldEnabled" -> result.success(ShieldPreferences.isShieldEnabled(context))
            "setShieldEnabled" -> {
                ShieldPreferences.setShieldEnabled(context, call.argument<Boolean>("enabled") ?: false)
                result.success(null)
            }
            "isDeviceAdminActive" -> result.success(isDeviceAdminActive())
            "requestDeviceAdmin" -> {
                requestDeviceAdmin()
                result.success(null)
            }
            "lockNow" -> {
                lockNow()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    // --- Kullanım istatistikleri ---

    private fun hasUsageAccess(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName,
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName,
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun todayUsage(): List<Map<String, Any>> {
        val usageStatsManager =
            context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val startOfDay = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startOfDay,
            System.currentTimeMillis(),
        )
        val packageManager = context.packageManager
        return stats
            .filter { it.totalTimeInForeground > 0 }
            .groupBy { it.packageName }
            .map { (packageName, entries) ->
                mapOf(
                    "packageName" to packageName,
                    "label" to appLabel(packageManager, packageName),
                    "foregroundMs" to entries.sumOf { it.totalTimeInForeground },
                )
            }
            .sortedByDescending { it["foregroundMs"] as Long }
    }

    private fun appLabel(packageManager: PackageManager, packageName: String): String = try {
        packageManager
            .getApplicationLabel(packageManager.getApplicationInfo(packageName, 0))
            .toString()
    } catch (_: PackageManager.NameNotFoundException) {
        packageName
    }

    private fun launchableApps(): List<Map<String, String>> {
        val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val packageManager = context.packageManager
        return packageManager.queryIntentActivities(intent, 0)
            .map { info ->
                mapOf(
                    "packageName" to info.activityInfo.packageName,
                    "label" to info.loadLabel(packageManager).toString(),
                )
            }
            .filter { it["packageName"] != context.packageName }
            .distinctBy { it["packageName"] }
            .sortedBy { it["label"]!!.lowercase() }
    }

    // --- Erişilebilirlik kalkanı ---

    private fun isAccessibilityEnabled(): Boolean {
        val expected =
            ComponentName(context, FocusAccessibilityService::class.java).flattenToString()
        val enabled = Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
        ) ?: return false
        val splitter = TextUtils.SimpleStringSplitter(':')
        splitter.setString(enabled)
        return splitter.any { it.equals(expected, ignoreCase = true) }
    }

    // --- Cihaz yöneticisi ---

    private fun devicePolicyManager(): DevicePolicyManager =
        context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager

    private fun adminComponent(): ComponentName =
        ComponentName(context, FocusDeviceAdminReceiver::class.java)

    private fun isDeviceAdminActive(): Boolean =
        devicePolicyManager().isAdminActive(adminComponent())

    private fun requestDeviceAdmin() {
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent())
            putExtra(
                DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                "Fanus, odak ihlallerinde ekranı kilitleyebilmek için yönetici yetkisi ister.",
            )
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    private fun lockNow() {
        if (isDeviceAdminActive()) {
            devicePolicyManager().lockNow()
        }
    }

    private fun openSettings(action: String) {
        context.startActivity(Intent(action).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
    }
}
