///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsTr = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$tr app = Translations$app$tr.internal(_root);
	late final Translations$common$tr common = Translations$common$tr.internal(_root);
	late final Translations$home$tr home = Translations$home$tr.internal(_root);
	late final Translations$map$tr map = Translations$map$tr.internal(_root);
	late final Translations$screenTime$tr screenTime = Translations$screenTime$tr.internal(_root);
	late final Translations$rooms$tr rooms = Translations$rooms$tr.internal(_root);
}

// Path: app
class Translations$app$tr {
	Translations$app$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Fanus'
	String get title => 'Fanus';
}

// Path: common
class Translations$common$tr {
	Translations$common$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Vazgeç'
	String get cancel => 'Vazgeç';

	/// tr: 'Aç'
	String get open => 'Aç';

	/// tr: 'Tekrar dene'
	String get retry => 'Tekrar dene';
}

// Path: home
class Translations$home$tr {
	Translations$home$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Aktif odak oturumu yok'
	String get noSessionTitle => 'Aktif odak oturumu yok';

	/// tr: 'Bir çalışma alanına girdiğinde oturum otomatik başlayacak.'
	String get noSessionHint => 'Bir çalışma alanına girdiğinde oturum otomatik başlayacak.';

	/// tr: 'Odak oturumu sürüyor'
	String get sessionActiveTitle => 'Odak oturumu sürüyor';

	/// tr: '$area · $time itibarıyla'
	String sessionSince({required Object area, required Object time}) => '${area} · ${time} itibarıyla';

	/// tr: 'Çalışma alanları'
	String get menuAreasTitle => 'Çalışma alanları';

	/// tr: 'Haritada alan tanımla ve yönet'
	String get menuAreasSubtitle => 'Haritada alan tanımla ve yönet';

	/// tr: 'Ekran süresi ve kısıtlamalar'
	String get menuScreenTimeTitle => 'Ekran süresi ve kısıtlamalar';

	/// tr: 'İzinler, kullanım ve kısıtlı uygulamalar'
	String get menuScreenTimeSubtitle => 'İzinler, kullanım ve kısıtlı uygulamalar';

	/// tr: 'Odak odaları'
	String get menuRoomsTitle => 'Odak odaları';

	/// tr: 'Birlikte odaklan, durumunu canlı paylaş'
	String get menuRoomsSubtitle => 'Birlikte odaklan, durumunu canlı paylaş';
}

// Path: map
class Translations$map$tr {
	Translations$map$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Çalışma alanları'
	String get title => 'Çalışma alanları';

	/// tr: 'Odak oturumlarının otomatik başlaması için "her zaman" konum izni gerekli.'
	String get permissionBanner => 'Odak oturumlarının otomatik başlaması için "her zaman" konum izni gerekli.';

	/// tr: 'İzin ver'
	String get grantPermission => 'İzin ver';

	/// tr: 'Haritaya uzun basarak yeni çalışma alanı ekle.'
	String get longPressHint => 'Haritaya uzun basarak yeni çalışma alanı ekle.';

	/// tr: 'Yeni çalışma alanı'
	String get newAreaTitle => 'Yeni çalışma alanı';

	/// tr: 'Alan adı'
	String get areaNameLabel => 'Alan adı';

	/// tr: 'Ofis, kütüphane…'
	String get areaNameHint => 'Ofis, kütüphane…';

	/// tr: 'Yarıçap: $meters m'
	String radiusLabel({required Object meters}) => 'Yarıçap: ${meters} m';

	/// tr: 'Ekle'
	String get add => 'Ekle';

	/// tr: '$name silinsin mi?'
	String deleteTitle({required Object name}) => '${name} silinsin mi?';

	/// tr: 'Bu alanın geofence kaydı da kaldırılacak.'
	String get deleteBody => 'Bu alanın geofence kaydı da kaldırılacak.';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'Silmek için dokun'
	String get deleteMarkerSnippet => 'Silmek için dokun';
}

// Path: screenTime
class Translations$screenTime$tr {
	Translations$screenTime$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Ekran süresi'
	String get title => 'Ekran süresi';

	/// tr: 'Durumu yenile'
	String get refreshTooltip => 'Durumu yenile';

	/// tr: 'İzinler'
	String get permissionsTitle => 'İzinler';

	/// tr: 'Kullanım erişimi'
	String get usageAccessTitle => 'Kullanım erişimi';

	/// tr: 'Günlük uygulama sürelerini okumak için'
	String get usageAccessSubtitle => 'Günlük uygulama sürelerini okumak için';

	/// tr: 'Odak kalkanı (erişilebilirlik)'
	String get shieldTitle => 'Odak kalkanı (erişilebilirlik)';

	/// tr: 'Odak sırasında kısıtlı uygulamaları engellemek için'
	String get shieldSubtitle => 'Odak sırasında kısıtlı uygulamaları engellemek için';

	/// tr: 'Cihaz yöneticisi (isteğe bağlı)'
	String get deviceAdminTitle => 'Cihaz yöneticisi (isteğe bağlı)';

	/// tr: 'Odak ihlalinde ekranı kilitleyebilmek için'
	String get deviceAdminSubtitle => 'Odak ihlalinde ekranı kilitleyebilmek için';

	/// tr: 'Kısıtlı uygulamalar'
	String get restrictedTitle => 'Kısıtlı uygulamalar';

	/// tr: '$count uygulama kısıtlı'
	String restrictedCount({required Object count}) => '${count} uygulama kısıtlı';

	/// tr: 'Odak oturumu sırasında engellenir'
	String get restrictedSubtitle => 'Odak oturumu sırasında engellenir';

	/// tr: 'Bugünkü kullanım'
	String get todayUsageTitle => 'Bugünkü kullanım';

	/// tr: 'Veri yok'
	String get noUsageTitle => 'Veri yok';

	/// tr: 'Kullanım erişimi verildikten sonra bugünkü süreler burada listelenir.'
	String get noUsageHint => 'Kullanım erişimi verildikten sonra bugünkü süreler burada listelenir.';

	/// tr: '$minutes dk'
	String minutes({required Object minutes}) => '${minutes} dk';

	/// tr: 'Uygulamalar alınamadı: $error'
	String appsError({required Object error}) => 'Uygulamalar alınamadı: ${error}';

	/// tr: 'Kullanım verisi alınamadı'
	String get usageError => 'Kullanım verisi alınamadı';

	/// tr: 'Ekran Süresi'
	String get iosSectionTitle => 'Ekran Süresi';

	/// tr: 'Ekran Süresi yetkisi'
	String get iosAuthTitle => 'Ekran Süresi yetkisi';

	/// tr: 'FamilyControls (.individual) yetkilendirmesi'
	String get iosAuthSubtitle => 'FamilyControls (.individual) yetkilendirmesi';

	/// tr: 'Kısıtlanacak uygulamaları seç'
	String get iosPickAppsTitle => 'Kısıtlanacak uygulamaları seç';

	/// tr: 'Sistem seçicisi (FamilyActivityPicker) açılır'
	String get iosPickAppsSubtitle => 'Sistem seçicisi (FamilyActivityPicker) açılır';
}

// Path: rooms
class Translations$rooms$tr {
	Translations$rooms$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Odak odaları'
	String get title => 'Odak odaları';

	/// tr: '$count kişi odada'
	String memberCount({required Object count}) => '${count} kişi odada';

	/// tr: 'Sunucuya ulaşılamadı'
	String get serverError => 'Sunucuya ulaşılamadı';

	/// tr: 'Demo sunucusunu başlatın: dart run fanus_server ($url)'
	String serverHint({required Object url}) => 'Demo sunucusunu başlatın: dart run fanus_server\n(${url})';

	/// tr: 'Odak odası'
	String get defaultRoomName => 'Odak odası';

	/// tr: 'Odada henüz kimse görünmüyor'
	String get emptyRoom => 'Odada henüz kimse görünmüyor';

	/// tr: 'Odakta'
	String get focusing => 'Odakta';

	/// tr: 'Boşta'
	String get idle => 'Boşta';

	/// tr: 'Misafir-$id'
	String guestName({required Object id}) => 'Misafir-${id}';

	/// tr: 'Bağlı'
	String get statusConnected => 'Bağlı';

	/// tr: 'Bağlanıyor…'
	String get statusConnecting => 'Bağlanıyor…';

	/// tr: 'Yeniden bağlanıyor…'
	String get statusReconnecting => 'Yeniden bağlanıyor…';

	/// tr: 'Bağlantı kesildi'
	String get statusDisconnected => 'Bağlantı kesildi';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Fanus',
			'common.cancel' => 'Vazgeç',
			'common.open' => 'Aç',
			'common.retry' => 'Tekrar dene',
			'home.noSessionTitle' => 'Aktif odak oturumu yok',
			'home.noSessionHint' => 'Bir çalışma alanına girdiğinde oturum otomatik başlayacak.',
			'home.sessionActiveTitle' => 'Odak oturumu sürüyor',
			'home.sessionSince' => ({required Object area, required Object time}) => '${area} · ${time} itibarıyla',
			'home.menuAreasTitle' => 'Çalışma alanları',
			'home.menuAreasSubtitle' => 'Haritada alan tanımla ve yönet',
			'home.menuScreenTimeTitle' => 'Ekran süresi ve kısıtlamalar',
			'home.menuScreenTimeSubtitle' => 'İzinler, kullanım ve kısıtlı uygulamalar',
			'home.menuRoomsTitle' => 'Odak odaları',
			'home.menuRoomsSubtitle' => 'Birlikte odaklan, durumunu canlı paylaş',
			'map.title' => 'Çalışma alanları',
			'map.permissionBanner' => 'Odak oturumlarının otomatik başlaması için "her zaman" konum izni gerekli.',
			'map.grantPermission' => 'İzin ver',
			'map.longPressHint' => 'Haritaya uzun basarak yeni çalışma alanı ekle.',
			'map.newAreaTitle' => 'Yeni çalışma alanı',
			'map.areaNameLabel' => 'Alan adı',
			'map.areaNameHint' => 'Ofis, kütüphane…',
			'map.radiusLabel' => ({required Object meters}) => 'Yarıçap: ${meters} m',
			'map.add' => 'Ekle',
			'map.deleteTitle' => ({required Object name}) => '${name} silinsin mi?',
			'map.deleteBody' => 'Bu alanın geofence kaydı da kaldırılacak.',
			'map.delete' => 'Sil',
			'map.deleteMarkerSnippet' => 'Silmek için dokun',
			'screenTime.title' => 'Ekran süresi',
			'screenTime.refreshTooltip' => 'Durumu yenile',
			'screenTime.permissionsTitle' => 'İzinler',
			'screenTime.usageAccessTitle' => 'Kullanım erişimi',
			'screenTime.usageAccessSubtitle' => 'Günlük uygulama sürelerini okumak için',
			'screenTime.shieldTitle' => 'Odak kalkanı (erişilebilirlik)',
			'screenTime.shieldSubtitle' => 'Odak sırasında kısıtlı uygulamaları engellemek için',
			'screenTime.deviceAdminTitle' => 'Cihaz yöneticisi (isteğe bağlı)',
			'screenTime.deviceAdminSubtitle' => 'Odak ihlalinde ekranı kilitleyebilmek için',
			'screenTime.restrictedTitle' => 'Kısıtlı uygulamalar',
			'screenTime.restrictedCount' => ({required Object count}) => '${count} uygulama kısıtlı',
			'screenTime.restrictedSubtitle' => 'Odak oturumu sırasında engellenir',
			'screenTime.todayUsageTitle' => 'Bugünkü kullanım',
			'screenTime.noUsageTitle' => 'Veri yok',
			'screenTime.noUsageHint' => 'Kullanım erişimi verildikten sonra bugünkü süreler burada listelenir.',
			'screenTime.minutes' => ({required Object minutes}) => '${minutes} dk',
			'screenTime.appsError' => ({required Object error}) => 'Uygulamalar alınamadı: ${error}',
			'screenTime.usageError' => 'Kullanım verisi alınamadı',
			'screenTime.iosSectionTitle' => 'Ekran Süresi',
			'screenTime.iosAuthTitle' => 'Ekran Süresi yetkisi',
			'screenTime.iosAuthSubtitle' => 'FamilyControls (.individual) yetkilendirmesi',
			'screenTime.iosPickAppsTitle' => 'Kısıtlanacak uygulamaları seç',
			'screenTime.iosPickAppsSubtitle' => 'Sistem seçicisi (FamilyActivityPicker) açılır',
			'rooms.title' => 'Odak odaları',
			'rooms.memberCount' => ({required Object count}) => '${count} kişi odada',
			'rooms.serverError' => 'Sunucuya ulaşılamadı',
			'rooms.serverHint' => ({required Object url}) => 'Demo sunucusunu başlatın: dart run fanus_server\n(${url})',
			'rooms.defaultRoomName' => 'Odak odası',
			'rooms.emptyRoom' => 'Odada henüz kimse görünmüyor',
			'rooms.focusing' => 'Odakta',
			'rooms.idle' => 'Boşta',
			'rooms.guestName' => ({required Object id}) => 'Misafir-${id}',
			'rooms.statusConnected' => 'Bağlı',
			'rooms.statusConnecting' => 'Bağlanıyor…',
			'rooms.statusReconnecting' => 'Yeniden bağlanıyor…',
			'rooms.statusDisconnected' => 'Bağlantı kesildi',
			_ => null,
		};
	}
}
