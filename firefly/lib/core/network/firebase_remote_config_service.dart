import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';

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
  String get welcomeMessage =>
      _remoteConfig.getString(FirebaseConstants.welcomeMessageKey);
  String get imageUrl => _remoteConfig.getString(FirebaseConstants.imageUrlKey);
  bool get isHidden => _remoteConfig.getBool(FirebaseConstants.isHiddenKey);
  int get year => _remoteConfig.getInt(FirebaseConstants.yearKey);

  Future<void> setupRemoteConfig() async {
    try {
      // Varsayılan değerler belirlenir
      await _remoteConfig.setDefaults(<String, dynamic>{
        FirebaseConstants.welcomeMessageKey:
            FirebaseConstants.defaultWelcomeMessage,
        FirebaseConstants.imageUrlKey: FirebaseConstants.defaultImageUrl,
        FirebaseConstants.isHiddenKey: FirebaseConstants.defaultIsHidden,
        FirebaseConstants.yearKey: FirebaseConstants.defaultYear,
      });

      // Ne kadar sık sürede güncelleme yapılır
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero,
        ),
      );

      // İlk açılışta verileri çek ve etkinleştir
      await _remoteConfig.fetchAndActivate();

      // Dinle ve ayar değişirse tekrar okumayı sağla.
      _remoteConfig.onConfigUpdated.listen((event) async {
        print(FirebaseConstants.remoteConfigUpdatedLog);
        await _remoteConfig.activate();
        _configUpdateController.add(null);
      });
    } catch (e) {
      print('${FirebaseConstants.remoteConfigErrorLog}$e');
    }
  }

  // ! Servis kaynaklarını temizleme
  void dispose() {
    _configUpdateController.close();
  }
}
