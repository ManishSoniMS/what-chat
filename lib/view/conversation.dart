import 'dart:io';
import 'dart:async';
import '../helper/constants.dart';
import '../services/database.dart';
import '../widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Conversation extends StatefulWidget {
  final String username;
  final String chatRoomID;
  Conversation({required this.username, required this.chatRoomID});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController messageController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    setState(() {
      showChats();
    });
    getMessageSnapshot();
    getChatMessageStream();
  }

  /// image Upload
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  List<UploadTask> uploadedTasksList = [];
  List<File> selectedFilesList = [];
  String imageUrl = "";
  Future selectImageFileToUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);
      if (result != null) {
        /// clear all
        selectedFilesList.clear();

        /// for selecting the file
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path.toString());
          selectedFilesList.add(file);
        });

        /// for upload
        selectedFilesList.forEach((file) {
          UploadTask task = uploadImageFileFirebaseStorage(file);
          saveImageUrlToFireStore(task);
          // setState(() {
          uploadedTasksList.add(task);
          // });
        });
      } else {
        print("User has cancelled the selection.");
      }
    } catch (error) {
      print(error.toString());
    }
  }

  uploadImageFileFirebaseStorage(File file) {
    UploadTask task =
        firebaseStorage.ref().child("images/${DateTime.now()}").putFile(file);
    return task;
  }

  saveImageUrlToFireStore(UploadTask task) {
    task.snapshotEvents.listen((snapShot) {
      if (snapShot.state == TaskState.success) {
        snapShot.ref.getDownloadURL().then((value) {
          imageUrl = value.toString();
          sendMessages();
          print("image uploaded successfully  " + imageUrl);
        });
      }
    });
  }

  ///video upload
  String videoUrl = "";
  Future selectVideoFileToUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.video);
      if (result != null) {
        /// clear all
        selectedFilesList.clear();

        /// for selecting the file
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path.toString());
          selectedFilesList.add(file);
        });

        /// for upload
        selectedFilesList.forEach((file) {
          UploadTask task = uploadImageFileFirebaseStorage(file);
          saveVideoUrlToFireStore(task);
          // setState(() {
          uploadedTasksList.add(task);
          // });
        });
      } else {
        print("User has cancelled the selection.");
      }
    } catch (error) {
      print(error.toString());
    }
  }

  uploadVideoFileFirebaseStorage(File file) {
    UploadTask task =
        firebaseStorage.ref().child("video/${DateTime.now()}").putFile(file);
    return task;
  }

  saveVideoUrlToFireStore(UploadTask task) {
    task.snapshotEvents.listen((snapShot) {
      if (snapShot.state == TaskState.success) {
        snapShot.ref.getDownloadURL().then((value) {
          videoUrl = value.toString();
          sendMessages();
          print("image uploaded successfully  " + videoUrl);
        });
      }
    });
  }

  ///audio upload
  String audioUrl = "";
  Future selectAudioFileToUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.audio);
      if (result != null) {
        /// clear all
        selectedFilesList.clear();

        /// for selecting the file
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path.toString());
          selectedFilesList.add(file);
        });

        /// for upload
        selectedFilesList.forEach((file) {
          UploadTask task = uploadImageFileFirebaseStorage(file);
          saveAudioUrlToFireStore(task);
          // setState(() {
          uploadedTasksList.add(task);
          // });
        });
      } else {
        print("User has cancelled the selection.");
      }
    } catch (error) {
      print(error.toString());
    }
  }

  uploadAudioFileFirebaseStorage(File file) {
    UploadTask task =
        firebaseStorage.ref().child("audio/${DateTime.now()}").putFile(file);
    return task;
  }

  saveAudioUrlToFireStore(UploadTask task) {
    task.snapshotEvents.listen((snapShot) {
      if (snapShot.state == TaskState.success) {
        snapShot.ref.getDownloadURL().then((value) {
          videoUrl = value.toString();
          sendMessages();
          print("image uploaded successfully  " + videoUrl);
        });
      }
    });
  }

  /// chat messages
  bool showLoading = true;
  showChats() {
    Future.delayed(Duration(seconds: 1)).then(
      (value) => showLoading = false,
    );
  }

  Timer? timer;
  QuerySnapshot? messageSnapshot;
  getMessageSnapshot() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      databaseMethods.getChatMessages(widget.chatRoomID).then((val) {
        setState(() {
          messageSnapshot = val;
        });
      });
    });
  }

  Stream? chatMessageStream;
  getChatMessageStream() {
    databaseMethods.getConversationMessages(widget.chatRoomID).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
  }

  sendMessages() {
    if (messageController.text.isNotEmpty ||
        uploadedTasksList.isNotEmpty ||
        selectedFilesList.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "imageUrl": imageUrl,
        "videoUrl": videoUrl,
        "audioUrl": audioUrl,
        "time": DateTime.now(),
      };
      databaseMethods.addConversationMessages(widget.chatRoomID, messageMap);
      messageController.text = "";
      imageUrl = "";
      videoUrl = "";
      audioUrl = "";
      databaseMethods.getChatMessages(widget.chatRoomID).then((val) {
        setState(() {
          messageSnapshot = val;
        });
      });
    }
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) => messageSnapshot!.docChanges.isEmpty
          ? Center(
              child: Text(
                "Let's start chatting!",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 75),
              reverse: true,
              itemCount: messageSnapshot!.docs.length,
              itemBuilder: (context, index) {
                return messageSnapshot!.docChanges[index].doc["message"]
                        .toString()
                        .isNotEmpty
                    ? TextTile(
                        message: messageSnapshot!
                            .docChanges[index].doc["message"]
                            .toString(),
                        isSendByMe:
                            messageSnapshot!.docChanges[index].doc["sendBy"] ==
                                    Constants.myName
                                ? true
                                : false,
                      )
                    : messageSnapshot!.docChanges[index].doc["imageUrl"]
                            .toString()
                            .isNotEmpty
                        ? ImageTile(
                            imageUrl: messageSnapshot!
                                .docChanges[index].doc["imageUrl"]
                                .toString(),
                            isSendByMe: messageSnapshot!
                                        .docChanges[index].doc["sendBy"] ==
                                    Constants.myName
                                ? true
                                : false,
                          )
                        : messageSnapshot!.docChanges[index].doc["videoUrl"]
                                .toString()
                                .isNotEmpty
                            ? VideoTile(
                                videoUrl: messageSnapshot!
                                    .docChanges[index].doc["videoUrl"]
                                    .toString(),
                                isSendByMe: messageSnapshot!
                                            .docChanges[index].doc["sendBy"] ==
                                        Constants.myName
                                    ? true
                                    : false,
                              )
                            : AudioTile(
                                audioUrl: messageSnapshot!
                                    .docChanges[index].doc["audioUrl"]
                                    .toString(),
                                isSendByMe: messageSnapshot!
                                            .docChanges[index].doc["sendBy"] ==
                                        Constants.myName
                                    ? true
                                    : false,
                              );
              },
            ),
    );
  }

  ///model bottom sheet for sending media
  void uploadAttachment() {
    showModalBottomSheet(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(),
      context: context,
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ButtonLayout(
              color1: Colors.purple,
              color2: Colors.purple.shade700,
              onTap: () {
                selectImageFileToUpload();
              },
              icon: Icons.image,
              title: "Images",
            ),
            ButtonLayout(
              color1: Colors.orange,
              color2: Colors.orange.shade700,
              onTap: () {
                selectAudioFileToUpload();
              },
              icon: Icons.headset,
              title: "Audio",
            ),
            ButtonLayout(
              color1: Colors.blue,
              color2: Colors.blueAccent.shade700,
              onTap: () {
                selectVideoFileToUpload();
              },
              icon: Icons.video_call_outlined,
              title: "Video",
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.username,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            showLoading
                ? Center(
                    child: Container(
                      height: 70,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballClipRotate,
                        colors: [Colors.white],
                      ),
                    ),
                  )
                : chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        prefixText: "  ",
                        hintText: "Send message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.02),
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      messageController.text.isNotEmpty
                          ? sendMessages()
                          : uploadAttachment();
                    },
                    child: Icon(
                      messageController.text.isNotEmpty
                          ? Icons.send
                          : Icons.attachment_sharp,
                      size: deviceWidth * 0.07,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLayout extends StatelessWidget {
  final icon;
  final onTap;
  final color1;
  final color2;
  final title;
  const ButtonLayout({
    this.icon,
    this.onTap,
    this.color1,
    this.color2,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: deviceWidth * 0.05),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: deviceWidth * 0.15,
          width: deviceWidth * 0.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white60,
          ),
        ),
        // SizedBox(height: deviceWidth * 0.02),
        // Text(
        //   title,
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 12,
        //   ),
        // ),
      ),
    );
  }
}
