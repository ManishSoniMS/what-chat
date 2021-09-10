import '../view/conversation.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomID;
  ChatRoomTile({
    required this.username,
    required this.chatRoomID,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Conversation(
              username: username,
              chatRoomID: chatRoomID,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.05,
          vertical: deviceHeight * 0.01,
        ),
        child: Row(
          children: [
            Container(
              height: deviceWidth * 0.13,
              width: deviceWidth * 0.13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  username.substring(0, 1).toUpperCase().toString(),
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              username,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
