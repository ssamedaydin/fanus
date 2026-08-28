/// Bir uygulamanın bugünkü ön plan kullanım istatistiği (Android).
class AppUsageStat {
  const AppUsageStat({
    required this.packageName,
    required this.label,
    required this.foreground,
  });

  factory AppUsageStat.fromMap(Map<Object?, Object?> map) => AppUsageStat(
        packageName: map['packageName']! as String,
        label: map['label']! as String,
        foreground: Duration(milliseconds: map['foregroundMs']! as int),
      );

  final String packageName;
  final String label;
  final Duration foreground;
}

/// Kısıtlanabilir, başlatılabilir bir uygulama (Android).
class InstalledApp {
  const InstalledApp({required this.packageName, required this.label});

  factory InstalledApp.fromMap(Map<Object?, Object?> map) => InstalledApp(
        packageName: map['packageName']! as String,
        label: map['label']! as String,
      );

  final String packageName;
  final String label;
}
