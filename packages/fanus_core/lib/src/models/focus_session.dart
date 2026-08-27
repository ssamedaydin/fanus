import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_session.freezed.dart';
part 'focus_session.g.dart';

/// Bir çalışma alanında geçirilen odak oturumu.
@freezed
abstract class FocusSession with _$FocusSession {
  const FocusSession._();

  const factory FocusSession({
    required String id,
    required String areaId,
    required DateTime startedAt,
    DateTime? endedAt,
  }) = _FocusSession;

  factory FocusSession.fromJson(Map<String, dynamic> json) =>
      _$FocusSessionFromJson(json);

  bool get isActive => endedAt == null;

  Duration elapsed(DateTime now) => (endedAt ?? now).difference(startedAt);
}
