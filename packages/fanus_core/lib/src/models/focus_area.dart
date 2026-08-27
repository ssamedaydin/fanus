import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_area.freezed.dart';
part 'focus_area.g.dart';

/// Harita üzerinde kullanıcı tarafından tanımlanan dairesel çalışma alanı.
///
/// Geofence kayıtları bu modelden üretilir; [radiusMeters] platformların
/// önerdiği minimum yarıçapın (Android ~100 m) altına düşürülmemelidir.
@freezed
abstract class FocusArea with _$FocusArea {
  const factory FocusArea({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) = _FocusArea;

  factory FocusArea.fromJson(Map<String, dynamic> json) =>
      _$FocusAreaFromJson(json);
}
