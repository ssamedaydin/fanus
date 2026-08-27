package com.samedaydin.fanus_location

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent

/** GeofencingClient'tan gelen giriş/çıkış geçişlerini olay yoluna aktarır. */
class GeofenceBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val geofencingEvent = GeofencingEvent.fromIntent(intent) ?: return
        if (geofencingEvent.hasError()) return

        val transition = when (geofencingEvent.geofenceTransition) {
            Geofence.GEOFENCE_TRANSITION_ENTER -> "enter"
            Geofence.GEOFENCE_TRANSITION_EXIT -> "exit"
            else -> return
        }
        val timestamp = System.currentTimeMillis()
        geofencingEvent.triggeringGeofences?.forEach { geofence ->
            GeofenceEventBus.emit(
                mapOf(
                    "areaId" to geofence.requestId,
                    "transition" to transition,
                    "timestamp" to timestamp,
                ),
            )
        }
    }
}
