# fanus_screen_time

Screen-time tracking and focus-time app restriction for Fanus.

## Android

- **UsageStatsManager** — daily per-app foreground usage. Requires the user to
  grant *Usage access* in system settings (`openUsageAccessSettings()`).
- **AccessibilityService** (`FocusAccessibilityService`) — while the shield is
  enabled, opening a restricted app bounces the user back to the launcher.
  `canRetrieveWindowContent` is `false`; no screen content is read.
- **DevicePolicyManager** — optional device-admin activation with the
  `force-lock` policy; `lockNow()` locks the screen.

## iOS

Uses **FamilyControls** with `.individual` authorization (the Opal model),
**ManagedSettings** shields and **DeviceActivity** monitoring. App selection is
done with the system `FamilyActivityPicker`; the selection never leaves the
device.

One-time Xcode setup (macOS):

1. Add the **Family Controls** capability to the Runner target. On a physical
   device a development-signed build with the development Family Controls
   entitlement is enough for the demo; App Store distribution requires
   requesting the entitlement from Apple.
2. *(Optional, custom shield UI)* File → New → Target →
   **Shield Configuration Extension**, then replace the generated data source
   with `ios/ShieldConfigurationSample/FanusShieldConfigurationExtension.swift`
   and give the extension the Family Controls capability as well.
3. Family Controls does not work on the simulator — test on a device.
