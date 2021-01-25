import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatMethods {
  final http.Client httpClient = http.Client();
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: false)
        .snapshots();
  }

  // ignore: missing_return
  Future<void> addMessage(
      String chatRoomId, chatMessageData, senderId, receiverId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
    httpClient.get(
      "http://194.59.165.195:8080/pbs-webapi/api/users/$senderId/$receiverId",
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
  }

  Future<bool> checkChatRoomExist(String chatRoomId) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance
          .doc("chatRoom/$chatRoomId")
          .get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }
}
