import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/myButton.dart';
import 'package:chat_app/components/myText.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/view/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/chatRoom_model.dart';

class SearchScreen extends StatefulWidget {
  final User? user;
  final UserModel? userModel;

    SearchScreen({super.key, this.user,this.userModel});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController=TextEditingController();
  var uuid=const Uuid();

  Future<ChatRoomModel?> getCGatRoomModel(UserModel targetUser)async{
    ChatRoomModel? chatRoom;
  QuerySnapshot snapshot=  await FirebaseFirestore.instance.collection('chatRooms')
        .where('participants.${widget.userModel!.uid}', isEqualTo: true)
        .where('participants.${targetUser!.uid}', isEqualTo: true).get();

    if(snapshot.docs.isNotEmpty){
      print(' chatroom available');
      var docData=snapshot.docs[0].data();
      ChatRoomModel existingChatroom=ChatRoomModel.fromMap(docData as Map<String,dynamic>);
      chatRoom=existingChatroom;

    }
    else
      {
         ChatRoomModel newChatRoom=ChatRoomModel(
           chatRoomId:uuid.v1(),
           lastMessage:'Hi there! I am using ChatApp',
           participants:{
             widget.userModel!.uid.toString():true,
             targetUser.uid.toString():true,
         }
         );
         await FirebaseFirestore.instance.collection('chatRooms').doc(newChatRoom.chatRoomId).set(
           newChatRoom.toMap(),
         );
         chatRoom=newChatRoom;
         print('new chatroom created');
      }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:AppBar(
        iconTheme:IconThemeData(
          color:titleColor
        ),
        backgroundColor:primaryLight,
        title:MyText(text:'Search user',color:titleColor,),

      ),
      body:Column(
        children: [
          Text_Field(controller:searchController, label:'', hintText:'Search user'),
          MyButton(title:'Search', onTap: (){
            setState(() {
            });
          }),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users').where('email', isEqualTo: searchController.text).where('email', isNotEqualTo:widget.user!.email)
                  .snapshots(), // Replace with your query stream
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If there's no data in the snapshot, show a message
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No users found.'),
                  );
                }
                // Otherwise, display the list of users
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    UserModel searchUserModel=UserModel.fromMap(data);
                    return ListTile(
                      onTap:()async{
                        ChatRoomModel? chat= await getCGatRoomModel(searchUserModel);
                        if(chat != null){
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.push(context,MaterialPageRoute(builder: (context)=> ChatScreen(
                            targetUser:searchUserModel,
                            userModel:widget.userModel!,
                            user:widget.user!,
                            chatRoomModel:chat,
                          )));
                        }


                      },
                      leading:CircleAvatar(radius:25,backgroundImage:NetworkImage(searchUserModel.profilePic?? " ")),
                      title: Text(searchUserModel.name.toString()),
                      subtitle: Text(searchUserModel.email.toString()),
                      // Add more fields as needed
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
