import 'package:cached_network_image/cached_network_image.dart';
import 'package:example_messaging/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ! Bildirim Mesajı (Toast/Snackbar) Yardımcısı
// Gelen bildirimleri uygulama içerisinde şık bir Snackbar (Toast) olarak gösterir
abstract class ToastMessage {
  static void show(RemoteNotification notification) {
    final title = notification.title ?? "Yeni Bildirim";
    final body = notification.body ?? "";

    // ! Gelen paketteki görsel URL'ini yakalıyoruz (Android veya iOS platformuna göre)
    final String? imageUrl =
        notification.android?.imageUrl ?? notification.apple?.imageUrl;

    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // ! Koyu tema arka plan
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ! Sol taraftaki ikon
              const Icon(Icons.sports_soccer, color: Colors.green, size: 28),
              const SizedBox(width: 12),

              // ! Orta kısımdaki metinler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // ! EĞER GÖRSEL VARSA EN SAĞ TARAFA EKLE
              if (imageUrl != null && imageUrl.isNotEmpty) ...[
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    // Resim yüklenirken çıkacak geçici yükleme göstergesi
                    placeholder: (context, url) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.white10,
                      child: const Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    // Resim yüklenemezse veya link kırıksa gösterilecek hata ikonu
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.white38,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // ! Snackbar yapılandırması
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        // Kartın yukarıdan aşağıya doğru süzülme efekti için margin
        margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
      ),
    );
  }
}
