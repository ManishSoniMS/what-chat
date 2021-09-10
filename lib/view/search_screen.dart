import '../helper/constants.dart';
import '../services/database.dart';
import '../view/conversation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  QuerySnapshot? searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUsername(_searchController.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  getChatRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoomAndStartConversation({
    required String username,
  }) {
    if (username != Constants.myName) {
      String chatRoomID = getChatRoomID(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomID": chatRoomID,
      };
      databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Conversation(
            username: username,
            chatRoomID: chatRoomID,
          ),
        ),
      );
    } else {
      print("You can't send message to yourself.");
    }
  }

  searchTile({
    required String username,
    required String userEmail,
  }) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.07,
        vertical: deviceHeight * .02,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: style),
              SizedBox(height: deviceHeight * 0.009),
              Text(userEmail, style: style),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username: username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.05,
                  vertical: deviceHeight * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor,
              ),
              child: Text("Message", style: style),
            ),
          )
        ],
      ),
    );
  }

  TextStyle style = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  Widget searchList() {
    return searchSnapshot != null
        ? Expanded(
            child: ListView.builder(
              itemCount: searchSnapshot!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return searchTile(
                    username: searchSnapshot!.docs[index]["name"].toString(),
                    userEmail: searchSnapshot!.docs[index]["email"].toString());
              },
            ),
          )
        : Container();
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    // final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Search",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: initiateSearch(),
                      decoration: InputDecoration(
                        prefixText: "  ",
                        hintText: "Search username...",
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
                    onPressed: initiateSearch,
                    child: Icon(
                      Icons.search,
                      size: deviceWidth * 0.07,
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
