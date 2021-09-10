import 'dart:async';
import '../widgets/drawer.dart';
import '../helper/constants.dart';
import '../services/database.dart';
import '../view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../widgets/chat_room_tile.dart';
import '../helper/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream? _chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: _chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    username: (snapshot.data! as QuerySnapshot)
                        .docs[index]["chatRoomID"]
                        .toString()
                        .replaceAll(Constants.myName, "")
                        .replaceAll("_", ""),
                    chatRoomID: (snapshot.data! as QuerySnapshot)
                        .docs[index]["chatRoomID"]
                        .toString(),
                  );
                },
              )
            : snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Text(
                      "No Chats Available Yet!",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 16,
                      ),
                    ),
                  );
      },
    );
  }

  getUserInfo() async {
    setState(() {
      Constants.myName = HelperFunctions.getUsername().toString();
      Constants.myEmail = HelperFunctions.getUserEmail().toString();
    });
    print("user name stored to Constants.myName: " + Constants.myName);
    print("user email stored to Constants.myEmail: " + Constants.myEmail);
    print("user name stored in helper function: " +
        HelperFunctions.getUsername().toString());

    DatabaseMethods().getChatRoom(Constants.myName).then((value) {
      setState(() {
        _chatRoomStream = value;
      });
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WhatChat",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      drawer: MyDrawer(),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.search),
      ),
    );
  }
}
