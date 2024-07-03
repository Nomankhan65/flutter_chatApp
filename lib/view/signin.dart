
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebaseHelper.dart';
import 'package:chat_app/view/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/colors.dart';
import '../components/myButton.dart';
import '../components/myText.dart';
import '../components/text_field.dart';
import 'HomePage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final auth=FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height*1;
    print('Sinin Build');
    return Scaffold(
      backgroundColor:Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height:height*0.08,),
              const Image(
                  height:200,
                  image:AssetImage('assets/chatIcon.png')),
              SizedBox(height:height*0.06,),
              MyText(
                  text:'LogIn',
                  fontSize: 20, color:primary),
              SizedBox(height:height*0.03,),
              Text_Field(
                controller: email,
                label: 'Email',
                hintText: 'Enter Your Email',
                type: TextInputType.emailAddress,
              ),
              Text_Field(
                controller: password,
                label: 'Password',
                hintText: 'Enter Password',
                type: TextInputType.number,
                obSecure: true,
                suffixIcon: const Icon(Icons.visibility),
              ),
              Padding(
                padding: const EdgeInsets.only(right:30,bottom:40),
                child: Align(
                  alignment:Alignment.centerRight,
                  child: InkWell(
                    onTap: (){
                  //    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ForgotPassword()));
                    },
                    child: MyText(
                      text:'Forgot password?',
                      color:primary,
                    ),
                  ),
                ),
              ),
           MyButton(title: 'Login',  onTap: () async{
                  if(formKey.currentState!.validate()){
                    try
                    {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                        email: email.text,
                        password:  password.text,
                      ).then((value) async {
                        UserModel? userModel=await FirebaseHelper.getUserById(auth.currentUser!.uid);
                        // ignore: use_build_context_synchronously
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>  HomePage(user:auth.currentUser,userModel:userModel!,)));
                      });
                    }on FirebaseAuthException catch(error){
                      Fluttertoast.showToast(msg:error.toString());
                    }finally{

                    }
                  }
              }),
              SizedBox(height:height*0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:   [
                  MyText(
                    text:'Don\'t have account?',
                    fontSize: 16,
                    color:Colors.black54,
                  ),
                  InkWell(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const SignUp()));
                    },
                    child:MyText(
                        text: 'Sign Up',
                        fontSize: 17, color:primary),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}