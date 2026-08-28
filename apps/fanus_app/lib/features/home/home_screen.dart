import 'package:fanus_core/fanus_core.dart';
import 'package:fanus_design/fanus_design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../i18n/translations.g.dart';
import '../focus/focus_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(t.app.title)),
      body: ListView(
        padding: const EdgeInsets.all(FanusSpacing.md),
        children: [
          _SessionCard(session: session),
          const SizedBox(height: FanusSpacing.lg),
          _MenuCard(
            icon: Icons.map_outlined,
            title: t.home.menuAreasTitle,
            subtitle: t.home.menuAreasSubtitle,
            onTap: () => context.push('/map'),
          ),
          const SizedBox(height: FanusSpacing.sm),
          _MenuCard(
            icon: Icons.shield_outlined,
            title: t.home.menuScreenTimeTitle,
            subtitle: t.home.menuScreenTimeSubtitle,
            onTap: () => context.push('/screen-time'),
          ),
          const SizedBox(height: FanusSpacing.sm),
          _MenuCard(
            icon: Icons.groups_outlined,
            title: t.home.menuRoomsTitle,
            subtitle: t.home.menuRoomsSubtitle,
            onTap: () => context.push('/rooms'),
          ),
        ],
      ),
    );
  }
}

/// Aktif oturum varken renklenen durum kartı.
class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});

  final FocusSession? session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final active = session != null;

    return Card(
      color: active ? scheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(FanusSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(FanusSpacing.sm),
              decoration: BoxDecoration(
                color: active ? scheme.primary : scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                active ? Icons.center_focus_strong : Icons.bubble_chart_outlined,
                size: 32,
                color: active ? scheme.onPrimary : scheme.primary,
              ),
            ),
            const SizedBox(width: FanusSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    active ? t.home.sessionActiveTitle : t.home.noSessionTitle,
                    style: textTheme.titleMedium?.copyWith(
                      color: active ? scheme.onPrimaryContainer : null,
                    ),
                  ),
                  const SizedBox(height: FanusSpacing.xs),
                  Text(
                    active
                        ? t.home.sessionSince(
                            area: session!.areaId,
                            time: _formatTime(session!.startedAt),
                          )
                        : t.home.noSessionHint,
                    style: textTheme.bodyMedium?.copyWith(
                      color: active
                          ? scheme.onPrimaryContainer.withValues(alpha: 0.8)
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// İkonlu, açıklamalı gezinme kartı.
class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Icon(icon, color: scheme.onPrimaryContainer),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
