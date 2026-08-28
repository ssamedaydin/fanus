import 'package:fanus_core/fanus_core.dart';
import 'package:fanus_design/fanus_design.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../i18n/translations.g.dart';
import '../focus/focus_providers.dart';
import 'areas_providers.dart';

/// Harita üzerinde çalışma alanlarını gösterir; uzun basışla yeni alan eklenir.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  static const _istanbul = LatLng(41.015137, 28.979530);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final areas = ref.watch(areasProvider);
    final hasPermissions =
        ref.watch(locationPermissionProvider).value ?? false;

    final circles = {
      for (final area in areas)
        Circle(
          circleId: CircleId(area.id),
          center: LatLng(area.latitude, area.longitude),
          radius: area.radiusMeters,
          strokeWidth: 2,
          strokeColor: theme.colorScheme.primary,
          fillColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
    };
    final markers = {
      for (final area in areas)
        Marker(
          markerId: MarkerId(area.id),
          position: LatLng(area.latitude, area.longitude),
          infoWindow: InfoWindow(
            title: area.name,
            snippet: t.map.deleteMarkerSnippet,
            onTap: () => _confirmDelete(context, ref, area),
          ),
        ),
    };

    return Scaffold(
      appBar: AppBar(title: Text(t.map.title)),
      body: Column(
        children: [
          if (!hasPermissions) const _PermissionBanner(),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: areas.isEmpty
                    ? _istanbul
                    : LatLng(areas.last.latitude, areas.last.longitude),
                zoom: 14,
              ),
              myLocationEnabled: hasPermissions,
              circles: circles,
              markers: markers,
              onLongPress: (position) => _addArea(context, ref, position),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FanusSpacing.sm),
          child: Text(
            t.map.longPressHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }

  Future<void> _addArea(
    BuildContext context,
    WidgetRef ref,
    LatLng position,
  ) async {
    final result = await showDialog<(String, double)>(
      context: context,
      builder: (context) => const _AreaDialog(),
    );
    if (result == null) return;
    final (name, radius) = result;
    await ref.read(areasProvider.notifier).add(
          FocusArea(
            id: 'area-${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            latitude: position.latitude,
            longitude: position.longitude,
            radiusMeters: radius,
          ),
        );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    FocusArea area,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.map.deleteTitle(name: area.name)),
        content: Text(t.map.deleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.map.delete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(areasProvider.notifier).remove(area.id);
    }
  }
}

/// Konum izni verilmediğinde haritanın üstünde gösterilen uyarı.
class _PermissionBanner extends ConsumerWidget {
  const _PermissionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(FanusSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Text(
                t.map.permissionBanner,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: FanusSpacing.sm),
            FilledButton(
              onPressed: () async {
                final granted = await ref
                    .read(fanusLocationProvider)
                    .requestPermissions();
                ref.invalidate(locationPermissionProvider);
                if (granted) {
                  await ref.read(areasProvider.notifier).resyncGeofences();
                }
              },
              child: Text(t.map.grantPermission),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yeni alan için ad ve yarıçap seçtiren diyalog.
class _AreaDialog extends StatefulWidget {
  const _AreaDialog();

  @override
  State<_AreaDialog> createState() => _AreaDialogState();
}

class _AreaDialogState extends State<_AreaDialog> {
  final _nameController = TextEditingController();
  double _radius = 150;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.map.newAreaTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: t.map.areaNameLabel,
              hintText: t.map.areaNameHint,
            ),
          ),
          const SizedBox(height: FanusSpacing.md),
          Text(t.map.radiusLabel(meters: _radius.round())),
          Slider(
            value: _radius,
            min: 100,
            max: 500,
            divisions: 8,
            label: '${_radius.round()} m',
            onChanged: (value) => setState(() => _radius = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.common.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            Navigator.of(context).pop((name, _radius));
          },
          child: Text(t.map.add),
        ),
      ],
    );
  }
}
