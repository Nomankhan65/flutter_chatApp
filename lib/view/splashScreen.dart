import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebaseHelper.dart';
import 'package:chat_app/view/HomePage.dart';
import 'package:chat_app/view/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      isLogin(context);
    });
  }
Future<void> isLogin(BuildContext context) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if (user != null) {
    UserModel? thisUserModel=await FirebaseHelper.getUserById(user.uid);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>   HomePage(user: user, userModel: thisUserModel!)));
  }
  else
  {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:Center(child: Image(image: AssetImage('assets/chatIcon.png'))),
    );
  }
}
