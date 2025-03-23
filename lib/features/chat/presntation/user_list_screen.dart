import 'package:chattingapp/features/auth/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({super.key});

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final currentUserId = auth.currentUser?.uid;

    return GetBuilder(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(title: const Text("Users")),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No users found"));
            }

            final users = snapshot.data!.docs
                .where((doc) => doc.id != currentUserId)
                .toList();

            return ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = users[index].data() as Map<String, dynamic>;
                final uid = users[index].id;
                final name = user["name"] ?? "No Name";
                final email = user["email"] ?? "No Email";

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(name),
                  subtitle: Text(email),
                  onTap: () {
                    // Navigate to ChatScreen with UID and name
                    Get.toNamed(Routes.chatScreen, arguments: {
                      'uid': uid,
                      'name': name,
                      'email': email,
                    });
                  },
                );
              },
            );
          },
        ),
      );
    });
  }
}
