// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:example_messaging/config/routes/bottom_bar.dart' as _i4;
import 'package:example_messaging/features/ai/presentation/pages/ai_page.dart'
    as _i1;
import 'package:example_messaging/features/auth/presentation/pages/auth_page.dart'
    as _i2;
import 'package:example_messaging/features/chat/presentation/pages/chat_page.dart'
    as _i3;
import 'package:example_messaging/features/chat/presentation/widgets/full_image_page.dart'
    as _i5;
import 'package:example_messaging/features/home/presentation/pages/home_page.dart'
    as _i6;
import 'package:example_messaging/features/profile/presentation/pages/profile_page.dart'
    as _i7;
import 'package:example_messaging/features/settings/presentation/pages/settings_page.dart'
    as _i8;
import 'package:flutter/material.dart' as _i10;

/// generated route for
/// [_i1.AiPage]
class AiRoute extends _i9.PageRouteInfo<void> {
  const AiRoute({List<_i9.PageRouteInfo>? children})
    : super(AiRoute.name, initialChildren: children);

  static const String name = 'AiRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.AiPage();
    },
  );
}

/// generated route for
/// [_i2.AuthPage]
class AuthRoute extends _i9.PageRouteInfo<void> {
  const AuthRoute({List<_i9.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthPage();
    },
  );
}

/// generated route for
/// [_i3.ChatPage]
class ChatRoute extends _i9.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i10.Key? key,
    required String chatId,
    required String peerName,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(key: key, chatId: chatId, peerName: peerName),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return _i3.ChatPage(
        key: args.key,
        chatId: args.chatId,
        peerName: args.peerName,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({this.key, required this.chatId, required this.peerName});

  final _i10.Key? key;

  final String chatId;

  final String peerName;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, chatId: $chatId, peerName: $peerName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatRouteArgs) return false;
    return key == other.key &&
        chatId == other.chatId &&
        peerName == other.peerName;
  }

  @override
  int get hashCode => key.hashCode ^ chatId.hashCode ^ peerName.hashCode;
}

/// generated route for
/// [_i4.CustomBottomBar]
class CustomBottomBar extends _i9.PageRouteInfo<void> {
  const CustomBottomBar({List<_i9.PageRouteInfo>? children})
    : super(CustomBottomBar.name, initialChildren: children);

  static const String name = 'CustomBottomBar';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.CustomBottomBar();
    },
  );
}

/// generated route for
/// [_i5.FullImagePage]
class FullImageRoute extends _i9.PageRouteInfo<FullImageRouteArgs> {
  FullImageRoute({
    _i10.Key? key,
    required String imageSource,
    required bool isNetworkImage,
    required String heroTag,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         FullImageRoute.name,
         args: FullImageRouteArgs(
           key: key,
           imageSource: imageSource,
           isNetworkImage: isNetworkImage,
           heroTag: heroTag,
         ),
         initialChildren: children,
       );

  static const String name = 'FullImageRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FullImageRouteArgs>();
      return _i5.FullImagePage(
        key: args.key,
        imageSource: args.imageSource,
        isNetworkImage: args.isNetworkImage,
        heroTag: args.heroTag,
      );
    },
  );
}

class FullImageRouteArgs {
  const FullImageRouteArgs({
    this.key,
    required this.imageSource,
    required this.isNetworkImage,
    required this.heroTag,
  });

  final _i10.Key? key;

  final String imageSource;

  final bool isNetworkImage;

  final String heroTag;

  @override
  String toString() {
    return 'FullImageRouteArgs{key: $key, imageSource: $imageSource, isNetworkImage: $isNetworkImage, heroTag: $heroTag}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FullImageRouteArgs) return false;
    return key == other.key &&
        imageSource == other.imageSource &&
        isNetworkImage == other.isNetworkImage &&
        heroTag == other.heroTag;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      imageSource.hashCode ^
      isNetworkImage.hashCode ^
      heroTag.hashCode;
}

/// generated route for
/// [_i6.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomePage();
    },
  );
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute({List<_i9.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.ProfilePage();
    },
  );
}

/// generated route for
/// [_i8.SettingsPage]
class SettingsRoute extends _i9.PageRouteInfo<void> {
  const SettingsRoute({List<_i9.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.SettingsPage();
    },
  );
}
