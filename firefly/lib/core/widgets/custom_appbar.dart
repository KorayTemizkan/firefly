import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';
import 'package:example_messaging/core/utils/extensions.dart';
import 'package:flutter/material.dart';

// ! Özel Uygulama Çubuğu (AppBar)
// Proje genelinde tutarlı bir başlık ve aksiyon yönetimi sunar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('FireFly'),

      actions: [
        // ! Ayarlar sayfasına yönlendirme ikonu
        IconButton(
          onPressed: () => context.router.navigate(SettingsRoute()),
          icon: Icon(Icons.settings, color: context.colorScheme.tertiary),
        ),
      ],
    );
  }

  // ! Çubuk yüksekliği tanımı
  @override
  Size get preferredSize => const Size.fromHeight(56);
}
