import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserListController extends GetxController {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final RxMap<String, XFile?> userImages = <String, XFile?>{}.obs;


  final RxString searchQuery = ''.obs;

  Stream<List<QueryDocumentSnapshot>> getFilteredUsers() {
    return firestore.collection("users").snapshots().map((snapshot) {
      final currentUserId = auth.currentUser?.uid;
      return snapshot.docs
          .where((doc) =>
      doc.id != currentUserId &&
          (doc['name']?.toString().toLowerCase() ?? '')
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    });
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }


  Future<void> pickImage(String userId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      userImages[userId] = image;
    }
  }

}
