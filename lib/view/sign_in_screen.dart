import '../services/auth.dart';
import '../widgets/header.dart';
import '../view/home_screen.dart';
import '../services/database.dart';
import '../view/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../helper/helper_function.dart';
import '../widgets/text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  static TextEditingController _emailController = TextEditingController();
  static TextEditingController _passwordController = TextEditingController();

  static bool _hidePassword = true;
  showPasswordButton() {
    setState(() {
      if (_hidePassword == true) {
        _hidePassword = false;
      } else {
        _hidePassword = true;
      }
    });
  }

  QuerySnapshot? userInfoSnapshot;
  // QuerySnapshot? snapshotUserInfo;
  // bool _isLoading = false;
  signIn() {
    if (_key.currentState!.validate()) {
      HelperFunctions.saveUserEmail(_emailController.text);
      // setState(() {
      //   _isLoading = true;
      // });
      // _databaseMethods.getUserByUserEmail(_emailController.text).then((value) {
      //   snapshotUserInfo = value;
      //   _helperFunctions.saveUserEmail(snapshotUserInfo!.docs[0]["name"]);
      // });

      AuthMethods()
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then(
        (result) async {
          if (result != null) {
            HelperFunctions.saveUserLoggedIn(true);
            // new
            DatabaseMethods()
                .getUserByUserEmail(_emailController.text)
                .then((value) {
              userInfoSnapshot = value;
            });

            // setState(() async {
            HelperFunctions.saveUsername(userInfoSnapshot!.docs[0]["name"]);
            setState(() {});
            HelperFunctions.saveUserEmail(userInfoSnapshot!.docs[0]["email"]);
            setState(() {});
            // });

            // print(
            //     "check weather getting username or not ${await HelperFunctions.saveUserEmail(userInfoSnapshot!.docs[0]["email"])}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
          // else {
          //   Scaffold.of(context).showSnackBar(
          //       SnackBar(content: Text("Invalid user credentials.")));
          //   setState(() {
          //     _isLoading = false;
          //   });
          // }
        },
      );
    }
  }

  @override
  void initState() {
    _emailController.text = "";
    _passwordController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "WhatChat",
      //     style: Theme.of(context).appBarTheme.titleTextStyle,
      //   ),
      //   automaticallyImplyLeading: false,
      // ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormFieldWidget(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username can't be empty.";
                            }
                            return null;
                          },
                          controller: _emailController,
                          hint: "Email",
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormFieldWidget(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password can't be empty.";
                            } else if (value.length < 8) {
                              return "Password length should be at least 8";
                            }
                            return null;
                          },
                          controller: _passwordController,
                          hint: "Password",
                          obscureText: _hidePassword,
                          suffixIcon: GestureDetector(
                            onTap: showPasswordButton,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceHeight * 0.011,
                                  horizontal: deviceWidth * 0.04),
                              child: FaIcon(
                                _hidePassword
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.04,
                                vertical: deviceHeight * 0.01),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        GestureDetector(
                          onTap: () {
                            signIn();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: deviceWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: deviceHeight * 0.02),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF007EF4),
                                  const Color(0xFF2A75BC),
                                ],
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        Container(
                          alignment: Alignment.center,
                          width: deviceWidth,
                          padding: EdgeInsets.symmetric(
                              vertical: deviceHeight * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Sign In with Google",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          height: deviceHeight * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have account? ",
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  );
                },
                child: Text(
                  "Register now",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
