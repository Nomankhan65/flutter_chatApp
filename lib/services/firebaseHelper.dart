import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class FirebaseHelper{

  static Future<UserModel?> getUserById(String uid) async {
    UserModel? userModel;
     DocumentSnapshot   snapshot= await FirebaseFirestore.instance.collection('users').doc(uid).get();
     if(snapshot.data() != null){
       userModel=UserModel.fromMap(snapshot.data() as Map<String,dynamic>);
     }
     return userModel;
  }
}