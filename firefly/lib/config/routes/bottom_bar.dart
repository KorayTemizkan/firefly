import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';
import 'package:example_messaging/core/constants/route_constants.dart';
import 'package:flutter/material.dart';

// ! Ana navigasyon barı sayfası
// Alt sekmeli navigasyon yapısını (Tabs) yöneten scaffold bileşeni
@RoutePage()
class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Sekmeli yapı konfigürasyonu
    return AutoTabsScaffold(
      // Navigasyon çubuğunda yer alacak sayfalar
      routes: const [HomeRoute(), AiRoute(), ProfileRoute()],

      // ! Alt navigasyon çubuğu tasarımı
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: RouteConstants.homeLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy), 
              label: RouteConstants.aiLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person), 
              label: RouteConstants.profileLabel,
            ),
          ],
        );
      },
    );
  }
}
