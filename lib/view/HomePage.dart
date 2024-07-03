import 'package:chat_app/components/colors.dart';
import 'package:chat_app/model/chatRoom_model.dart';
import 'package:chat_app/services/firebaseHelper.dart';
import 'package:chat_app/view/chatScreen.dart';
import 'package:chat_app/view/searchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/myText.dart';
import '../model/user_model.dart';

class HomePage extends StatefulWidget {
  final User? user;
  final UserModel userModel;

  HomePage({super.key, required this.user, required this.userModel});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print(widget.userModel.name);
    print(widget.user!.uid);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor:primaryLight,
        child: Icon(Icons.search,color:titleColor,),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    user: widget.user,
                    userModel: widget.userModel,
                  )));
        },
      ),
      appBar: AppBar(
        backgroundColor:primaryLight,
        title:MyText(text:'ChatApp',color:titleColor,),
        actions:   [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20,),
            child: Icon(Icons.menu_rounded,color:titleColor,),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('participants.${widget.userModel.uid}', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot dataSnap = snapshot.data as QuerySnapshot;
              return ListView.builder(
                itemCount: dataSnap.docs.length,
                itemBuilder: (context, index) {
                  ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                      dataSnap.docs[index].data() as Map<String, dynamic>);
                  Map<String, dynamic> participants =
                  chatRoomModel.participants!;
                  List<String> participantsKeys = participants.keys.toList();
                  participantsKeys.remove(widget.userModel.uid);
                  if (participantsKeys.isNotEmpty) {
                    return FutureBuilder(
                      future:
                      FirebaseHelper.getUserById(participantsKeys[0]),
                      builder: (context, userData) {
                        if (userData.connectionState ==
                            ConnectionState.done) {
                          if (userData.hasData) {
                            UserModel targetUser =
                            userData.data as UserModel;
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          targetUser: targetUser,
                                          chatRoomModel: chatRoomModel,
                                          userModel: widget.userModel,
                                          user: widget.user!,
                                        )));
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    targetUser.profilePic.toString()),
                              ),
                              title: MyText(
                                  text: targetUser.name.toString()),
                              subtitle: MyText(
                                  text: chatRoomModel.lastMessage
                                      .toString()),
                              trailing:chatRoomModel.lastMessageTime != null
                                  ? MyText(
                                  text: DateFormat('dd MMM yyyy, hh:mm a')
                                      .format(chatRoomModel
                                      .lastMessageTime!))
                                  : null,
                            );
                          } else if (userData.hasError) {
                            return MyText(
                                text: 'Error loading user data');
                          } else {
                            return MyText(text: 'User not found');
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return MyText(text: 'No participants found');
                  }
                },
              );
            } else if (snapshot.hasError) {
              return MyText(text: 'Error loading messages');
            } else {
              return MyText(text: 'No message found');
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}