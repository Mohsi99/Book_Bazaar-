import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserServices {
  ///Create User
  Future createUser(UserModel model) async {
    return await FirebaseFirestore.instance
        .collection('userCollection')
        .doc(model.docId)
        .set(model.toJson(model.docId.toString()));
  }

  Future<UserModel> getUserByID(String userId) async {
    return await FirebaseFirestore.instance
        .collection("userCollection")
        .doc(userId)
        .get()
        .then((user) => UserModel.fromJson(user.data()!));
  }

  Future updateProfile(UserModel model) async {
    return await FirebaseFirestore.instance
        .collection("userCollection")
        .doc(model.docId)
        .update({
      'name': model.name,
      'phone': model.phone,
      'address': model.address,
      'profileImageUrl': model.profileImageUrl, // NEW FIELD
    });
  }

}