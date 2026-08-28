import 'package:fanus_design/fanus_design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../focus/focus_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(activeSessionProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Fanus')),
      body: ListView(
        padding: const EdgeInsets.all(FanusSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FanusSpacing.md),
              child: session == null
                  ? Row(
                      children: [
                        Icon(
                          Icons.bubble_chart_outlined,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: FanusSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aktif odak oturumu yok',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: FanusSpacing.xs),
                              Text(
                                'Bir çalışma alanına girdiğinde oturum '
                                'otomatik başlayacak.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.center_focus_strong,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: FanusSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Odak oturumu sürüyor',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: FanusSpacing.xs),
                              Text(
                                '${session.areaId} · '
                                '${_formatTime(session.startedAt)} itibarıyla',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: FanusSpacing.md),
          FilledButton.tonalIcon(
            onPressed: () => context.push('/map'),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Çalışma alanlarını yönet'),
          ),
          const SizedBox(height: FanusSpacing.sm),
          FilledButton.tonalIcon(
            onPressed: () => context.push('/screen-time'),
            icon: const Icon(Icons.shield_outlined),
            label: const Text('Ekran süresi ve kısıtlamalar'),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
