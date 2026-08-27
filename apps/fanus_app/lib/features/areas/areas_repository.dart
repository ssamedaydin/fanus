import 'dart:convert';

import 'package:fanus_core/fanus_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Çalışma alanlarını cihazda saklar.
class AreasRepository {
  AreasRepository(this._prefs);

  static const _key = 'focus_areas';

  final SharedPreferences _prefs;

  List<FocusArea> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => FocusArea.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<FocusArea> areas) => _prefs.setString(
        _key,
        jsonEncode(areas.map((area) => area.toJson()).toList()),
      );
}
