package com.samedaydin.fanus_location

/**
 * Geofence BroadcastReceiver'ı ile Flutter köprüsü arasındaki basit olay yolu.
 * Uygulama süreci yaşadığı sürece (ör. foreground service sayesinde)
 * dinleyiciler olayları alır.
 */
object GeofenceEventBus {
    private val listeners = mutableListOf<(Map<String, Any>) -> Unit>()

    @Synchronized
    fun addListener(listener: (Map<String, Any>) -> Unit) {
        listeners.add(listener)
    }

    @Synchronized
    fun removeListener(listener: (Map<String, Any>) -> Unit) {
        listeners.remove(listener)
    }

    fun emit(event: Map<String, Any>) {
        val snapshot = synchronized(this) { listeners.toList() }
        snapshot.forEach { it(event) }
    }
}
