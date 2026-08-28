import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'features/areas/areas_providers.dart';
import 'i18n/translations.g.dart';

/// Servis anahtarları derleme zamanında verilir; boş bırakılırsa ilgili
/// entegrasyon sessizce devre dışı kalır (demo, anahtarsız da çalışır):
/// `--dart-define=FANUS_ONESIGNAL_APP_ID=...`
/// `--dart-define=FANUS_SENTRY_DSN=...`
const _oneSignalAppId = String.fromEnvironment('FANUS_ONESIGNAL_APP_ID');
const _sentryDsn = String.fromEnvironment('FANUS_SENTRY_DSN');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  final prefs = await SharedPreferences.getInstance();

  if (_oneSignalAppId.isNotEmpty) {
    OneSignal.initialize(_oneSignalAppId);
    // Bildirim izni ana ekrandan, kullanıcı bağlamında istenir;
    // açılışta otomatik izin diyaloğu gösterilmez.
  }

  final app = TranslationProvider(
    child: ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const FanusApp(),
    ),
  );

  if (_sentryDsn.isEmpty) {
    runApp(app);
    return;
  }
  await SentryFlutter.init(
    (options) {
      options
        ..dsn = _sentryDsn
        ..tracesSampleRate = 0.2;
    },
    appRunner: () => runApp(app),
  );
}
