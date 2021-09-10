import '../services/auth.dart';
import '../helper/constants.dart';
import '../view/sign_in_screen.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';
import 'package:get_storage/get_storage.dart';

class MyDrawer extends StatelessWidget {
  static const String imageUrl =
      "https://coolthemestores.com/wp-content/uploads/2020/11/demon-slayer-featured.jpg";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.8),
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text(
                  Constants.myName,
                  textScaleFactor: 1.5,
                ),
                accountEmail: Text(
                  Constants.myEmail,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                AuthMethods().signOut();
                // SharedPreferences preferences =
                //     await SharedPreferences.getInstance();
                // preferences.remove(HelperFunctions.userLogInKey);
                // preferences.remove(HelperFunctions.userNameKey);
                // preferences.remove(HelperFunctions.userEmailKey);
                HelperFunctions.saveUserLoggedIn(false);
                GetStorage preferences = GetStorage();
                preferences.remove(HelperFunctions.userNameKey);
                preferences.remove(HelperFunctions.userEmailKey);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
              leading: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.white,
              ),
              title: Text(
                'Log Out',
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
