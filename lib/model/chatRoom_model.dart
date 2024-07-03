import 'package:cloud_firestore/cloud_firestore.dart';
class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? lastMessageTime;

  ChatRoomModel({this.chatRoomId, this.participants, this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chatRoomId'];
    participants = map['participants'];
    lastMessage = map['lastMessage'];
    lastMessageTime = map['lastMessageTime'] != null
        ? (map['lastMessageTime'] as Timestamp).toDate()
        :null;
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}