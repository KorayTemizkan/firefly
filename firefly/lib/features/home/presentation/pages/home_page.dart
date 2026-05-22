import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/core/constants/home_constants.dart';
import 'package:example_messaging/core/widgets/custom_appbar.dart';
import 'package:example_messaging/core/widgets/title_text.dart';
import 'package:example_messaging/features/home/presentation/widgets/active_chats_section.dart';
import 'package:example_messaging/features/home/presentation/widgets/pending_requests_section.dart';
import 'package:example_messaging/features/home/presentation/widgets/sent_requests_section.dart';
import 'package:example_messaging/features/home/presentation/widgets/user_list_section.dart';
import 'package:flutter/material.dart';

// ! Ana Sayfa
// Uygulamanın merkezini oluşturur; sohbetleri, bağlantı isteklerini ve kullanıcı listesini yönetir
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // ! Navigasyon sekmeleri kontrolcüsü
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              // ! Üst Sekmeler (Mesaj, Davet, Sohbet)
              TabBar(
                padding: const EdgeInsets.only(top: 8),
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.circular(16),
                tabs: const [
                  Tab(text: HomeConstants.myMessages),
                  Tab(text: HomeConstants.myInvitations),
                  Tab(text: HomeConstants.myChats),
                ],
              ),

              // ! Sekme içerikleri
              Expanded(
                child: const TabBarView(
                  children: [
                    PendingRequestsSection(),
                    SentRequestsSection(),
                    ActiveChatsSection(),
                  ],
                ),
              ),

              // ! Kullanıcı Listesi Bölümü
              const TitleText(text: HomeConstants.allUsers),
              const UserListSection(),
            ],
          ),
        ),
      ),
    );
  }
}
