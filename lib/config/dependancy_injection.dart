import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/chat/controller/chat_controller.dart';


initModule() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

}
initAuth() {
  Get.put<AuthController>(AuthController());
}
initChat(String otherUserId, String otherUserName) {
  Get.put<ChatController>(
    ChatController(
      otherUserId: otherUserId,
      otherUserName: otherUserName,
    ),
  );
}

disposeChat() {
  Get.delete<ChatController>();
}




