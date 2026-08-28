import 'dart:io';

import 'package:fanus_design/fanus_design.dart';
import 'package:fanus_screen_time/fanus_screen_time.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screen_time_providers.dart';

/// Ekran süresi istatistikleri, izin akışları ve kısıtlı uygulama yönetimi.
class ScreenTimeScreen extends ConsumerWidget {
  const ScreenTimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekran süresi'),
        actions: [
          IconButton(
            tooltip: 'Durumu yenile',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
              ..invalidate(usageAccessProvider)
              ..invalidate(accessibilityEnabledProvider)
              ..invalidate(deviceAdminProvider)
              ..invalidate(screenTimeAuthorizedProvider)
              ..invalidate(todayUsageProvider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(FanusSpacing.md),
        children:
            Platform.isIOS ? _iosSections(ref) : _androidSections(context, ref),
      ),
    );
  }

  // --- Android ---

  List<Widget> _androidSections(BuildContext context, WidgetRef ref) {
    final restrictedCount =
        ref.watch(restrictedAppsProvider).value?.length ?? 0;
    return [
      _SectionCard(
        title: 'İzinler',
        children: [
          _PermissionTile(
            status: ref.watch(usageAccessProvider),
            title: 'Kullanım erişimi',
            subtitle: 'Günlük uygulama sürelerini okumak için',
            onOpen: () =>
                ref.read(fanusScreenTimeProvider).openUsageAccessSettings(),
          ),
          _PermissionTile(
            status: ref.watch(accessibilityEnabledProvider),
            title: 'Odak kalkanı (erişilebilirlik)',
            subtitle: 'Odak sırasında kısıtlı uygulamaları engellemek için',
            onOpen: () =>
                ref.read(fanusScreenTimeProvider).openAccessibilitySettings(),
          ),
          _PermissionTile(
            status: ref.watch(deviceAdminProvider),
            title: 'Cihaz yöneticisi (isteğe bağlı)',
            subtitle: 'Odak ihlalinde ekranı kilitleyebilmek için',
            onOpen: () =>
                ref.read(fanusScreenTimeProvider).requestDeviceAdmin(),
          ),
        ],
      ),
      const SizedBox(height: FanusSpacing.md),
      _SectionCard(
        title: 'Kısıtlı uygulamalar',
        children: [
          ListTile(
            leading: const Icon(Icons.app_blocking_outlined),
            title: Text('$restrictedCount uygulama kısıtlı'),
            subtitle: const Text('Odak oturumu sırasında engellenir'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showRestrictedAppsSheet(context),
          ),
        ],
      ),
      const SizedBox(height: FanusSpacing.md),
      _SectionCard(
        title: 'Bugünkü kullanım',
        children: [_UsageList(usage: ref.watch(todayUsageProvider))],
      ),
    ];
  }

  void _showRestrictedAppsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (context, scrollController) => Consumer(
          builder: (context, ref, _) {
            final restricted =
                ref.watch(restrictedAppsProvider).value ?? const <String>{};
            return ref.watch(launchableAppsProvider).when(
                  data: (apps) => ListView.builder(
                    controller: scrollController,
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return CheckboxListTile(
                        value: restricted.contains(app.packageName),
                        title: Text(app.label),
                        subtitle: Text(
                          app.packageName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onChanged: (_) => ref
                            .read(restrictedAppsProvider.notifier)
                            .toggle(app.packageName),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) =>
                      Center(child: Text('Uygulamalar alınamadı: $error')),
                );
          },
        ),
      ),
    );
  }

  // --- iOS ---

  List<Widget> _iosSections(WidgetRef ref) {
    return [
      _SectionCard(
        title: 'Ekran Süresi',
        children: [
          _PermissionTile(
            status: ref.watch(screenTimeAuthorizedProvider),
            title: 'Ekran Süresi yetkisi',
            subtitle: 'FamilyControls (.individual) yetkilendirmesi',
            onOpen: () async {
              await ref
                  .read(fanusScreenTimeProvider)
                  .requestScreenTimeAuthorization();
              ref.invalidate(screenTimeAuthorizedProvider);
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_blocking_outlined),
            title: const Text('Kısıtlanacak uygulamaları seç'),
            subtitle: const Text('Sistem seçicisi (FamilyActivityPicker) açılır'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ref.read(fanusScreenTimeProvider).showAppPicker(),
          ),
        ],
      ),
    ];
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FanusSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FanusSpacing.md,
                vertical: FanusSpacing.xs,
              ),
              child: Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.onOpen,
  });

  final AsyncValue<bool> status;
  final String title;
  final String subtitle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final granted = status.value ?? false;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        granted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: granted ? scheme.primary : scheme.outline,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: granted
          ? null
          : TextButton(onPressed: onOpen, child: const Text('Aç')),
    );
  }
}

class _UsageList extends StatelessWidget {
  const _UsageList({required this.usage});

  final AsyncValue<List<AppUsageStat>> usage;

  @override
  Widget build(BuildContext context) {
    return usage.when(
      data: (stats) {
        if (stats.isEmpty) {
          return const ListTile(
            leading: Icon(Icons.hourglass_empty),
            title: Text('Veri yok'),
            subtitle: Text(
              'Kullanım erişimi verildikten sonra bugünkü süreler burada listelenir.',
            ),
          );
        }
        return Column(
          children: [
            for (final stat in stats.take(10))
              ListTile(
                dense: true,
                leading: const Icon(Icons.apps),
                title: Text(stat.label),
                trailing: Text('${stat.foreground.inMinutes} dk'),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(FanusSpacing.md),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => ListTile(
        leading: const Icon(Icons.error_outline),
        title: const Text('Kullanım verisi alınamadı'),
        subtitle: Text('$error'),
      ),
    );
  }
}
