import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/routes.dart';
import '../controller/user_list_controller.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({super.key});

  final UserListController controller = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: controller.updateSearch,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.firestore.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allUsers = snapshot.data?.docs ?? [];

                return Obx(() {
                  final currentUserId = controller.auth.currentUser?.uid;
                  final query = controller.searchQuery.value.toLowerCase();

                  final filtered = allUsers.where((doc) {
                    final name = (doc['name'] ?? '').toString().toLowerCase();
                    return doc.id != currentUserId && name.contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No matching users"));
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = filtered[index].data();
                      final uid = filtered[index].id;
                      final name = user["name"] ?? "No Name";
                      final email = user["email"] ?? "No Email";

                      return ListTile(
                        leading: Obx(() {
                          final image = controller.userImages[uid];
                          return GestureDetector(
                            onTap: () => controller.pickImage(uid),
                            child: CircleAvatar(
                              backgroundImage: image != null
                                  ? FileImage(File(image.path))
                                  : null,
                              child: image == null
                                  ? const Icon(Icons.camera_alt)
                                  : null,
                            ),
                          );
                        }),
                        title: Text(name),
                        subtitle: Text(email),
                        onTap: () {
                          Get.toNamed(Routes.chatScreen, arguments: {
                            'uid': uid,
                            'name': name,
                            'email': email,
                          });
                        },
                      );
                    },
                  );
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
