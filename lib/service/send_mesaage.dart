// import 'package:chat_fmc/services/database.dart';
// import 'package:chat_fmc/view/conversation.dart';
//
// class SendMessage{
//   DatabaseMethods databaseMethods = DatabaseMethods();
//   var messageController = Conversation().chatRoomID;
//
//   sendMessages() {
//     if (messageController.text.isNotEmpty ||
//         uploadedTasksList.isNotEmpty ||
//         selectedFilesList.isNotEmpty) {
//       Map<String, dynamic> messageMap = {
//         "message": messageController.text,
//         "sendBy": Constants.myName,
//         "imageUrl": imageUrl,
//         "videoUrl": videoUrl,
//         "audioUrl": audioUrl,
//         "time": DateTime.now(),
//       };
//       databaseMethods.addConversationMessages(chatRoomID, messageMap);
//       messageController.text = "";
//       imageUrl = "";
//       videoUrl = "";
//       audioUrl = "";
//       databaseMethods.getChatMessages(chatRoomID).then((val) {
//         // setState(() {
//           messageSnapshot = val;
//         // });
//       });
//     }
//   }
// }