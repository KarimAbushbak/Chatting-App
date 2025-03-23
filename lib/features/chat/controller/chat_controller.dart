import 'package:chattingapp/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final String otherUserId;
  final String otherUserName;
  ChatController({
    required this.otherUserId,
    required this.otherUserName,
  });
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late final String currentUserId;
  late final String chatId;
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    currentUserId = auth.currentUser!.uid;
    chatId = _generateChatId(currentUserId, otherUserId);
    super.onInit();
  }

  String _generateChatId(String a, String b) {
    return a.hashCode <= b.hashCode ? '${a}_$b' : '${b}_$a';
  }

  CollectionReference get messagesRef =>
      firestore.collection(Constants.chatsDatabase).doc(chatId).collection(Constants.messagesDatabase);

  Stream<QuerySnapshot> get messagesStream =>
      messagesRef.orderBy(Constants.timestamp, descending: true).snapshots();

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    await messagesRef.add({
      Constants.text: text,
      Constants.senderId: currentUserId,
      Constants.receiverId: otherUserId,
      Constants.timestamp: FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
