package com.samedaydin.fanus_screen_time

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.widget.Toast

/**
 * Odak oturumu aktifken kısıtlı uygulamaların açılmasını engeller:
 * pencere değişimini yakalar, kısıtlı pakete geçildiyse kullanıcıyı ana
 * ekrana döndürür. Ekran içeriği okunmaz (canRetrieveWindowContent=false).
 */
class FocusAccessibilityService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        if (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val targetPackage = event.packageName?.toString() ?: return
        if (targetPackage == packageName) return
        if (!ShieldPreferences.isShieldEnabled(this)) return
        if (targetPackage !in ShieldPreferences.restrictedApps(this)) return

        performGlobalAction(GLOBAL_ACTION_HOME)
        Toast.makeText(this, "Fanus: odak sürüyor, bu uygulama kısıtlı", Toast.LENGTH_SHORT).show()
    }

    override fun onInterrupt() = Unit
}
