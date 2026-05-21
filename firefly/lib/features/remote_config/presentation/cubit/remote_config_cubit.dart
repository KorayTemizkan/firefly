import 'dart:async';
import 'package:example_messaging/core/network/firebase_remote_config_service.dart';
import 'package:example_messaging/features/remote_config/presentation/cubit/remote_config_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ! Uzaktan Yapılandırma Yönetimi (Cubit)
// Firebase Remote Config değerlerini yönetir ve uygulamadaki UI katmanına güncel verileri iletir
class RemoteConfigCubit extends Cubit<RemoteConfigState> {
  final FirebaseRemoteConfigService _remoteConfigService;
  StreamSubscription? _subscription;

  RemoteConfigCubit(this._remoteConfigService) : super(RemoteConfigInitial());

  // ! Yapılandırma başlatma
  void initRemoteConfig() async {
    // 1. Önce servisin kurulumunu tetikle
    await _remoteConfigService.setupRemoteConfig();

    // 2. İlk gelen verilerle arayüzü besle
    _emitCurrentConfig();

    // 3. Servisten gelecek canlı değişiklikleri dinlemeye başla
    _subscription = _remoteConfigService.onConfigChanged.listen((_) {
      _emitCurrentConfig();
    });
  }

  // ! Mevcut konfigürasyonu state olarak yay
  void _emitCurrentConfig() {
    emit(
      RemoteConfigLoaded(
        welcomeMessage: _remoteConfigService.welcomeMessage,
        imageUrl: _remoteConfigService.imageUrl,
        isHidden: _remoteConfigService.isHidden,
        year: _remoteConfigService.year,
      ),
    );
  }

  // ! Cubit kapatılırken aboneliği sonlandır
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
