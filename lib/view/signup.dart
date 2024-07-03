import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/view/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/colors.dart';
import '../components/myButton.dart';
import '../components/myText.dart';
import '../components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var auth = FirebaseAuth.instance;
  final firestoreRef = FirebaseFirestore.instance;
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 1;
    print('signUp Build');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                const Image(
                    height: 200, image: AssetImage('assets/chatIcon.png')),
                MyText(text: 'Create Account', fontSize: 20, color: primary),
                SizedBox(
                  height: height * 0.03,
                ),
                Text_Field(
                    controller: userName,
                    label: 'User Name',
                    hintText: 'Enter Your Name'),
                Text_Field(
                  controller: email,
                  label: 'Email',
                  hintText: 'Enter Your Email',
                  type: TextInputType.emailAddress,
                ),
                Text_Field(
                  controller: password,
                  label: 'Password',
                  hintText: 'Create Password',
                  type: TextInputType.number,
                  obSecure: true,
                  suffixIcon: const Icon(Icons.visibility),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                    MyButton(
                      title: 'SignUp',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                            try {
                              UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                                  email: email.text.toString(),
                                  password: password.text.toString());
                              User? user = userCredential.user;
                              UserModel userModel=UserModel(
                                name:userName.text,
                                uid:user!.uid,
                                email:email.text,
                                profilePic:''
                              );
                              if (user != null) {
                                user.updateDisplayName(userName.text);
                                firestoreRef
                                    .collection('users')
                                    .doc(user.uid)
                                    .set(
                                  userModel.toMap(),
                                );
                                print('created');
                              }
                              Fluttertoast.showToast(
                                  msg: 'Account Created Successfully');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                Fluttertoast.showToast(
                                    msg: 'The password provided is too weak');
                              } else if (e.code == 'email-already-in-use') {
                                Fluttertoast.showToast(
                                    msg:
                                    'The account already exists for that email');
                              }
                            } finally {
                            }
                        }
                }),
                SizedBox(
                  height:height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                        text: 'Already register! ',
                        color: Colors.black54,
                        fontSize: 16),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignIn()));
                      },
                      child:
                      MyText(text: 'Login', color: primary, fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}