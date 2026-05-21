// TODO: İşlev Dışı (düzenlenecek)

import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/core/network/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

// ! Tam Ekran Görsel Görüntüleyici
// Görselleri zoom edilebilir, Hero animasyonlu ve önbellek destekli olarak tam ekranda sunar
@RoutePage()
class FullImagePage extends StatelessWidget {
  final String imageSource;
  final bool isNetworkImage;
  final String heroTag;

  const FullImagePage({
    super.key,
    required this.imageSource,
    required this.isNetworkImage,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PhotoView(
                // ! Resim kaynağı yönetimi
                // Resmin kaynağını belirliyoruz (İnternet veya Yerel Dosya)
                imageProvider: isNetworkImage
                    ? CachedNetworkImageProvider(
                            imageSource,
                            cacheManager: CustomCacheManager.instance,
                          )
                          as ImageProvider
                    : FileImage(File(imageSource)),

                // ! Zoom ayarları
                // Senin kodundaki profesyonel zoom ayarları
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,

                // ! Hero animasyonu
                // Hero animasyonu için PhotoView'un kendi özel parametresi
                heroAttributes: PhotoViewHeroAttributes(tag: heroTag),

                // ! Yükleme durumu
                // Resim internetten inerken ortada dönecek yükleme animasyonu
                loadingBuilder: (context, event) =>
                    const Center(child: CircularProgressIndicator()),

                // ! Tasarım
                // Arka plan rengi
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),

            // ! Kullanıcı bilgilendirme göstergesi
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 32.0, bottom: 32.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.pinch_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
