import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';

// ? Bir geliştiricinin uygulama mağazadayken güncelleme yapmadan uzaktan değişiklikler yapmasını sağlayan özelliktir.
/*

flutter pub add firebase_remote_config
Aşağıdaki fonksiyon yazılır
Firebase Console'de remote config etkinleştir
Ayarlamaları yap
Değişiklikleri yayınla butonuna bas

*/
// ! Uzaktan Yapılandırma Servis Katmanı
// Uygulama içerisindeki değişkenleri Firebase üzerinden dinamik olarak güncellemeyi sağlar
class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Değişiklikleri Cubit'e akıtmak için bir Stream açıyoruz
  final StreamController<void> _configUpdateController =
      StreamController<void>.broadcast();

  Stream<void> get onConfigChanged => _configUpdateController.stream;

  // ! Konfigürasyon Değerleri
  // Uzaktan yönetilen parametreleri çeken getter metodları
  String get welcomeMessage => _remoteConfig.getString('welcome_message');
  String get imageUrl => _remoteConfig.getString('image_url');
  bool get isHidden => _remoteConfig.getBool('is_hidden');
  int get year => _remoteConfig.getInt('year');

  Future<void> setupRemoteConfig() async {
    try {
      // Varsayılan değerler belirlenir
      await _remoteConfig.setDefaults(<String, dynamic>{
        'welcome_message': 'Hoş Geldiniz!',
        'image_url': '',
        'is_hidden': false,
        'year': 2026,
      });

      // Ne kadar sık sürede güncelleme yapılır
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(
            minutes: 1,
          ), // 1 dakika boyunca denemeye devam et
          minimumFetchInterval: Duration.zero,
        ), // 10 dakikada bir istek at (Test için 0 yaptım)
      );

      // İLk açılışta verileri çek ve etkinleştir
      await _remoteConfig.fetchAndActivate();

      // Dinle ve ayar değişirse tekrar okumayı sağla.
      _remoteConfig.onConfigUpdated.listen((event) async {
        print("REMOTE CONFIG: Sunucuda değişiklik algılandı! Güncelleniyor...");
        await _remoteConfig.activate();
        _configUpdateController.add(null);
      });
    } catch (e) {
      print('Remote Config Başlatılamadı: $e');
    }
  }

  // ! Servis kaynaklarını temizleme
  void dispose() {
    _configUpdateController.close();
  }
}
