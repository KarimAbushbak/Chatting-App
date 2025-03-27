import 'package:chattingapp/features/auth/view/login_screen.dart';
import 'package:chattingapp/features/auth/view/register_screen.dart';
import 'package:chattingapp/features/chat/presntation/chat_screen.dart';
import 'package:chattingapp/features/chat/presntation/user_list_screen.dart';
import 'package:chattingapp/features/home/view/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/dependancy_injection.dart';
import 'constants.dart';

class Routes {
  static const String splashScreen = '/splash_screen';
  static const String languagePage = '/language_page';
  static const String homeScreen = '/homeScreen';
  static const String outBoarding = '/outBoardingView';
  static const String loginScreen = '/loginScreen';
  static const String registerView = '/registerView';
  static const String profileView = '/profileView';
  static const String detailsView = '/detailsView';
  static const String settingsView = '/settingsView';
  static const String cartView = '/cartView';
  static const String brandView = '/brandView';
  static const String resetPasswordView = '/resetPasswordView';
  static const String addNotes = '/addNotes';
  static const String userListScreen = '/userListScreen';
  static const String chatScreen = '/chatScreen';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        initAuth();
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.registerView:
        initAuth();
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.userListScreen:
        return MaterialPageRoute(builder: (_) => UserListScreen());
    case Routes.chatScreen:
    final args = settings.arguments as Map<String, dynamic>;
    final otherUserId = args['uid'];
    final otherUserName = args['name'];
    disposeChat();
    initChat(otherUserId, otherUserName);
    return MaterialPageRoute(
    builder: (_) => const ChatScreen(),
    );



      default:
        return unDefineRoute();
    }
  }

  static Route<dynamic> unDefineRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text("yt"),
        ),
      ),
    );
  }
}
