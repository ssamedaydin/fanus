///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsEn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$en app = _Translations$app$en._(_root);
	@override late final _Translations$common$en common = _Translations$common$en._(_root);
	@override late final _Translations$home$en home = _Translations$home$en._(_root);
	@override late final _Translations$map$en map = _Translations$map$en._(_root);
	@override late final _Translations$screenTime$en screenTime = _Translations$screenTime$en._(_root);
	@override late final _Translations$rooms$en rooms = _Translations$rooms$en._(_root);
}

// Path: app
class _Translations$app$en extends Translations$app$tr {
	_Translations$app$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Fanus';
}

// Path: common
class _Translations$common$en extends Translations$common$tr {
	_Translations$common$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancel';
	@override String get open => 'Open';
	@override String get retry => 'Try again';
}

// Path: home
class _Translations$home$en extends Translations$home$tr {
	_Translations$home$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get noSessionTitle => 'No active focus session';
	@override String get noSessionHint => 'A session will start automatically when you enter a work area.';
	@override String get sessionActiveTitle => 'Focus session in progress';
	@override String sessionSince({required Object area, required Object time}) => '${area} · since ${time}';
	@override String get menuAreasTitle => 'Work areas';
	@override String get menuAreasSubtitle => 'Define and manage areas on the map';
	@override String get menuScreenTimeTitle => 'Screen time & restrictions';
	@override String get menuScreenTimeSubtitle => 'Permissions, usage and restricted apps';
	@override String get menuRoomsTitle => 'Focus rooms';
	@override String get menuRoomsSubtitle => 'Focus together, share your status live';
}

// Path: map
class _Translations$map$en extends Translations$map$tr {
	_Translations$map$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Work areas';
	@override String get permissionBanner => '"Always" location permission is required so focus sessions can start automatically.';
	@override String get grantPermission => 'Grant';
	@override String get longPressHint => 'Long-press the map to add a new work area.';
	@override String get newAreaTitle => 'New work area';
	@override String get areaNameLabel => 'Area name';
	@override String get areaNameHint => 'Office, library…';
	@override String radiusLabel({required Object meters}) => 'Radius: ${meters} m';
	@override String get add => 'Add';
	@override String deleteTitle({required Object name}) => 'Delete ${name}?';
	@override String get deleteBody => 'Its geofence registration will be removed as well.';
	@override String get delete => 'Delete';
	@override String get deleteMarkerSnippet => 'Tap to delete';
}

// Path: screenTime
class _Translations$screenTime$en extends Translations$screenTime$tr {
	_Translations$screenTime$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Screen time';
	@override String get refreshTooltip => 'Refresh status';
	@override String get permissionsTitle => 'Permissions';
	@override String get usageAccessTitle => 'Usage access';
	@override String get usageAccessSubtitle => 'To read daily app usage durations';
	@override String get shieldTitle => 'Focus shield (accessibility)';
	@override String get shieldSubtitle => 'To block restricted apps during focus';
	@override String get deviceAdminTitle => 'Device admin (optional)';
	@override String get deviceAdminSubtitle => 'To lock the screen on focus violations';
	@override String get restrictedTitle => 'Restricted apps';
	@override String restrictedCount({required Object count}) => '${count} apps restricted';
	@override String get restrictedSubtitle => 'Blocked during focus sessions';
	@override String get todayUsageTitle => 'Today\'s usage';
	@override String get noUsageTitle => 'No data';
	@override String get noUsageHint => 'Once usage access is granted, today\'s durations will be listed here.';
	@override String minutes({required Object minutes}) => '${minutes} min';
	@override String appsError({required Object error}) => 'Could not load apps: ${error}';
	@override String get usageError => 'Could not load usage data';
	@override String get iosSectionTitle => 'Screen Time';
	@override String get iosAuthTitle => 'Screen Time authorization';
	@override String get iosAuthSubtitle => 'FamilyControls (.individual) authorization';
	@override String get iosPickAppsTitle => 'Choose apps to restrict';
	@override String get iosPickAppsSubtitle => 'Opens the system FamilyActivityPicker';
}

// Path: rooms
class _Translations$rooms$en extends Translations$rooms$tr {
	_Translations$rooms$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Focus rooms';
	@override String memberCount({required Object count}) => '${count} in the room';
	@override String get serverError => 'Could not reach the server';
	@override String serverHint({required Object url}) => 'Start the demo server: dart run fanus_server\n(${url})';
	@override String get defaultRoomName => 'Focus room';
	@override String get emptyRoom => 'Nobody in the room yet';
	@override String get focusing => 'Focusing';
	@override String get idle => 'Idle';
	@override String guestName({required Object id}) => 'Guest-${id}';
	@override String get statusConnected => 'Connected';
	@override String get statusConnecting => 'Connecting…';
	@override String get statusReconnecting => 'Reconnecting…';
	@override String get statusDisconnected => 'Disconnected';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Fanus',
			'common.cancel' => 'Cancel',
			'common.open' => 'Open',
			'common.retry' => 'Try again',
			'home.noSessionTitle' => 'No active focus session',
			'home.noSessionHint' => 'A session will start automatically when you enter a work area.',
			'home.sessionActiveTitle' => 'Focus session in progress',
			'home.sessionSince' => ({required Object area, required Object time}) => '${area} · since ${time}',
			'home.menuAreasTitle' => 'Work areas',
			'home.menuAreasSubtitle' => 'Define and manage areas on the map',
			'home.menuScreenTimeTitle' => 'Screen time & restrictions',
			'home.menuScreenTimeSubtitle' => 'Permissions, usage and restricted apps',
			'home.menuRoomsTitle' => 'Focus rooms',
			'home.menuRoomsSubtitle' => 'Focus together, share your status live',
			'map.title' => 'Work areas',
			'map.permissionBanner' => '"Always" location permission is required so focus sessions can start automatically.',
			'map.grantPermission' => 'Grant',
			'map.longPressHint' => 'Long-press the map to add a new work area.',
			'map.newAreaTitle' => 'New work area',
			'map.areaNameLabel' => 'Area name',
			'map.areaNameHint' => 'Office, library…',
			'map.radiusLabel' => ({required Object meters}) => 'Radius: ${meters} m',
			'map.add' => 'Add',
			'map.deleteTitle' => ({required Object name}) => 'Delete ${name}?',
			'map.deleteBody' => 'Its geofence registration will be removed as well.',
			'map.delete' => 'Delete',
			'map.deleteMarkerSnippet' => 'Tap to delete',
			'screenTime.title' => 'Screen time',
			'screenTime.refreshTooltip' => 'Refresh status',
			'screenTime.permissionsTitle' => 'Permissions',
			'screenTime.usageAccessTitle' => 'Usage access',
			'screenTime.usageAccessSubtitle' => 'To read daily app usage durations',
			'screenTime.shieldTitle' => 'Focus shield (accessibility)',
			'screenTime.shieldSubtitle' => 'To block restricted apps during focus',
			'screenTime.deviceAdminTitle' => 'Device admin (optional)',
			'screenTime.deviceAdminSubtitle' => 'To lock the screen on focus violations',
			'screenTime.restrictedTitle' => 'Restricted apps',
			'screenTime.restrictedCount' => ({required Object count}) => '${count} apps restricted',
			'screenTime.restrictedSubtitle' => 'Blocked during focus sessions',
			'screenTime.todayUsageTitle' => 'Today\'s usage',
			'screenTime.noUsageTitle' => 'No data',
			'screenTime.noUsageHint' => 'Once usage access is granted, today\'s durations will be listed here.',
			'screenTime.minutes' => ({required Object minutes}) => '${minutes} min',
			'screenTime.appsError' => ({required Object error}) => 'Could not load apps: ${error}',
			'screenTime.usageError' => 'Could not load usage data',
			'screenTime.iosSectionTitle' => 'Screen Time',
			'screenTime.iosAuthTitle' => 'Screen Time authorization',
			'screenTime.iosAuthSubtitle' => 'FamilyControls (.individual) authorization',
			'screenTime.iosPickAppsTitle' => 'Choose apps to restrict',
			'screenTime.iosPickAppsSubtitle' => 'Opens the system FamilyActivityPicker',
			'rooms.title' => 'Focus rooms',
			'rooms.memberCount' => ({required Object count}) => '${count} in the room',
			'rooms.serverError' => 'Could not reach the server',
			'rooms.serverHint' => ({required Object url}) => 'Start the demo server: dart run fanus_server\n(${url})',
			'rooms.defaultRoomName' => 'Focus room',
			'rooms.emptyRoom' => 'Nobody in the room yet',
			'rooms.focusing' => 'Focusing',
			'rooms.idle' => 'Idle',
			'rooms.guestName' => ({required Object id}) => 'Guest-${id}',
			'rooms.statusConnected' => 'Connected',
			'rooms.statusConnecting' => 'Connecting…',
			'rooms.statusReconnecting' => 'Reconnecting…',
			'rooms.statusDisconnected' => 'Disconnected',
			_ => null,
		};
	}
}
