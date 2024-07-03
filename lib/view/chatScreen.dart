import 'package:chat_app/components/myText.dart';
import 'package:chat_app/model/chatRoom_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../components/colors.dart';
import '../model/user_model.dart';

class ChatScreen extends StatelessWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoomModel;
  final UserModel userModel;
  final User user;
    ChatScreen({super.key,required this.targetUser, required this.chatRoomModel, required this.userModel, required this.user});
  var chatController=TextEditingController();
  var uuid=const Uuid();

  void sendMessage(){
    chatController.text.trim();
    if(chatController.text.isNotEmpty){
      MessageModel newMessage=MessageModel(
        messageId:uuid.v1(),
        sender:userModel.uid,
        createdOn:DateTime.now(),
        text:chatController.text,
        seen:false,
      );
      FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomModel.chatRoomId)
          .collection('messages').doc( newMessage.messageId).set(
        newMessage.toMap()
      );
      chatRoomModel.lastMessage=chatController.text;
      chatRoomModel.lastMessageTime=DateTime.now();
      FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomModel.chatRoomId).update(chatRoomModel.toMap());
      print('message sent');
      chatController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme:IconThemeData(
          color:titleColor
        ),
        backgroundColor:primaryLight,
        title:Row(
          children: [
            CircleAvatar(
              radius:22,
              backgroundColor:imageBgColor,
              backgroundImage:AssetImage(userModel.profilePic.toString()),
            ),
            const SizedBox(width:8,),
            Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                MyText(text:userModel.name.toString(),fontSize:17,color:titleColor,),
                MyText(text:userModel.email.toString(),fontSize:13,color:Colors.black54,),
              ],
            ),
          ],
        ),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(chatRoomModel.chatRoomId)
                  .collection('messages')
                  .orderBy('createdOn', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnap = snapshot.data as QuerySnapshot;
                    return ListView.builder(
                      reverse: true,
                      itemCount: dataSnap.docs.length,
                      itemBuilder: (context, index) {
                        MessageModel currentMessage = MessageModel.fromMap(
                            dataSnap.docs[index].data()
                            as Map<String, dynamic>);
                        return Row(
                          mainAxisAlignment: (currentMessage.sender == userModel.uid)
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: (currentMessage.sender == userModel.uid)
                                      ? Colors.white
                                      : primaryLight,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft: Radius.circular(
                                        (currentMessage.sender == userModel.uid) ? 12 : 0),
                                    bottomRight: Radius.circular(
                                        (currentMessage.sender == userModel.uid) ? 0 : 12),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: MyText(
                                  text: currentMessage.text.toString(),
                                  maxlines: 5,
                                  color: (currentMessage.sender == userModel.uid)
                                      ? Colors.black
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        );
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                      controller:chatController,
                      cursorColor: primary,
                      maxLines:null,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          fillColor: Colors.black12,
                          prefixIcon: const Icon(Icons.insert_emoticon),
                          filled: true,
                          hintText: 'Message',
                          hintStyle:const TextStyle(color:Colors.black26),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              )))),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration:
                    BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () {
                            sendMessage();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
