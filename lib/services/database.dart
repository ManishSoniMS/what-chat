import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userInfoMap) {
    FirebaseFirestore.instance
        .collection("users")
        .add(userInfoMap)
        .catchError((error) {
      print(error.toString());
    });
  }

  createChatRoom(String chatRoomID, Map<String, dynamic> chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .set(chatRoomMap)
        .catchError((error) {
      print(error.toString());
    });
  }

  addConversationMessages(String chatRoomID, Map<String, dynamic> messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .add(messageMap)
        .catchError((error) {
      print(error.toString());
    });
  }

  getConversationMessages(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatMessages(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("time", descending: true)
        .get();
  }

  getChatRoom(String userName) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getChatRoomList() async {
    return await FirebaseFirestore.instance.collection("users").get();
  }

  ///upload images
}
