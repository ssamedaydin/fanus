import 'package:fanus_core/fanus_core.dart';
import 'package:fanus_design/fanus_design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../i18n/translations.g.dart';
import 'rooms_providers.dart';

/// Katılabilecek ortak odak odalarının listesi.
class RoomsScreen extends ConsumerWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.rooms.title)),
      body: rooms.when(
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(FanusSpacing.sm),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final room = list[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.groups_outlined),
                title: Text(room.name),
                subtitle: Text(t.rooms.memberCount(count: room.memberCount)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(
                  Uri(
                    path: '/rooms/${room.id}',
                    queryParameters: {'name': room.name},
                  ).toString(),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => FanusEmptyState(
          icon: Icons.cloud_off_outlined,
          title: t.rooms.serverError,
          message: t.rooms.serverHint(url: serverBaseUrl),
          action: FilledButton.tonal(
            onPressed: () => ref.invalidate(roomsProvider),
            child: Text(t.common.retry),
          ),
        ),
      ),
    );
  }
}

/// Tek bir odanın canlı görünümü: bağlantı durumu ve üyelerin odak halleri.
class RoomScreen extends ConsumerWidget {
  const RoomScreen({super.key, required this.roomId, required this.roomName});

  final String roomId;
  final String roomName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(roomMembersProvider(roomId)).value ?? const [];
    final status = ref.watch(roomStatusProvider(roomId)).value ??
        RoomConnectionStatus.connecting;

    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: FanusSpacing.md),
            child: Center(child: _StatusChip(status: status)),
          ),
        ],
      ),
      body: members.isEmpty
          ? FanusEmptyState(
              icon: Icons.groups_outlined,
              title: t.rooms.emptyRoom,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(FanusSpacing.sm),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final scheme = Theme.of(context).colorScheme;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(member.name.characters.first.toUpperCase()),
                  ),
                  title: Text(member.name),
                  subtitle: Text(
                    member.focusing ? t.rooms.focusing : t.rooms.idle,
                  ),
                  trailing: member.focusing
                      ? Icon(Icons.center_focus_strong, color: scheme.primary)
                      : Icon(Icons.pause_circle_outline, color: scheme.outline),
                );
              },
            ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final RoomConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      RoomConnectionStatus.connected => (t.rooms.statusConnected, scheme.primary),
      RoomConnectionStatus.reconnecting => (
          t.rooms.statusReconnecting,
          scheme.error
        ),
      RoomConnectionStatus.connecting => (
          t.rooms.statusConnecting,
          scheme.outline
        ),
      RoomConnectionStatus.disconnected => (
          t.rooms.statusDisconnected,
          scheme.outline
        ),
    };
    return Chip(
      avatar: Icon(Icons.circle, size: 10, color: color),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}
