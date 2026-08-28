package com.samedaydin.fanus_screen_time

import android.content.Context

/**
 * Kısıtlı paket listesi ile kalkan durumunun kalıcı kaydı.
 * Plugin (Flutter tarafı) ile AccessibilityService arasında paylaşılır.
 */
object ShieldPreferences {
    private const val PREFS = "fanus_screen_time"
    private const val KEY_RESTRICTED = "restricted_packages"
    private const val KEY_SHIELD = "shield_enabled"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun restrictedApps(context: Context): Set<String> =
        prefs(context).getStringSet(KEY_RESTRICTED, emptySet()) ?: emptySet()

    fun setRestrictedApps(context: Context, packages: Set<String>) {
        prefs(context).edit().putStringSet(KEY_RESTRICTED, packages).apply()
    }

    fun isShieldEnabled(context: Context): Boolean =
        prefs(context).getBoolean(KEY_SHIELD, false)

    fun setShieldEnabled(context: Context, enabled: Boolean) {
        prefs(context).edit().putBoolean(KEY_SHIELD, enabled).apply()
    }
}
