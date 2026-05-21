import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';
import 'package:example_messaging/core/widgets/custom_appbar.dart';
import 'package:example_messaging/features/remote_config/presentation/widgets/remote_config_bloc_builder.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

// ! Profil Sayfası
// Kullanıcı bilgilerini, oturum yönetimi seçeneklerini ve uzaktan yapılandırma (Remote Config) verilerini görüntüler
@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Kimlik doğrulama sağlayıcıları
    final providers = [EmailAuthProvider()];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // ! Firebase UI Profile Screen
          // Kullanıcı profil yönetimi ve hesap silme seçeneklerini sunar
          Expanded(
            child: ProfileScreen(
              showDeleteConfirmationDialog: true,
              providers: providers,
              actions: [
                // ! Çıkış yapıldığında Auth sayfasına yönlendir
                SignedOutAction((context) {
                  context.router.replaceAll([const AuthRoute()]);
                }),
              ],
            ),
          ),

          // ! Uzaktan Yapılandırma Bilgileri
          // Remote Config üzerinden gelen dinamik verilerin görüntülendiği bölüm
          const RemoteConfigBlocBuilder(),
        ],
      ),
    );
  }
}
