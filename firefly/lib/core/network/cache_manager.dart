import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// ! Özel Önbellek Yönetimi
// Uygulama içerisindeki görsellerin yönetimi için özelleştirilmiş CacheManager
class CustomCacheManager {
  static const _imageCacheKey = 'image_cache_key';

  // Private constructor ile dışarıdan "new" ile oluşturmayı engelledik
  CustomCacheManager._internal();

  // Singleton instance ile sınıfın tek bir örneğini sakladık
  static CacheManager instance = CacheManager(
    Config(
      _imageCacheKey,
      stalePeriod: const Duration(
        days: 14,
      ), // Standart 30 gün yerine 14 gün olarak ayarladık
      maxNrOfCacheObjects: 24, // En fazla 24 adet görseli önbellekte tut
      repo:
          JsonCacheInfoRepository(), // Dosyaların meta takibini sağlarız (ne zaman indi, son kullanma tarihi vb.)
      fileService:
          HttpFileService(), // Dosyaların internetten standart HTTP protokolüyle indirileceğini belirttik
    ),
  );
}
