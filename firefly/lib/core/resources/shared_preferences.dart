// TODO: İşlev Dışı (düzenleme gerekebilir)

import 'package:example_messaging/core/constants/system_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesWithCache? _prefs;

  static const String _authKey = SystemConstants.authKey;

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {_authKey},
      ),
    );
  }

  bool get isAuthCompleted => _prefs?.getBool(_authKey) ?? false;

  Future<void> toggleAuth() async {
    if (_prefs != null) {
      if (isAuthCompleted) {
        await _prefs?.setBool(_authKey, false);
      } else {
        await _prefs?.setBool(_authKey, true);
      }
    }
  }
}
