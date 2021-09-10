import '../services/auth.dart';
import '../widgets/header.dart';
import '../view/home_screen.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';
import '../widgets/text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  static TextEditingController _emailController = TextEditingController();
  static TextEditingController _passwordController = TextEditingController();
  static TextEditingController _usernameController = TextEditingController();

  static bool _isLoading = false;
  static bool _hidePassword = true;
  void showPasswordButton() {
    setState(() {
      if (_hidePassword == true) {
        _hidePassword = false;
      } else {
        _hidePassword = true;
      }
    });
  }

  signMeUp() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Map<String, String> userInfoMap = {
      //   "name": _usernameController.text,
      //   "email": _emailController.text,
      // };
      // HelperFunctions.saveUserEmail(_emailController.text);
      // HelperFunctions.saveUsername(_usernameController.text);
      //
      // setState(() {
      //   _isLoading = true;
      // });
      AuthMethods()
          .signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      )
          .then((result) async {
        //    new
        if (result != null) {
          Map<String, String> userInfoMap = {
            "name": _usernameController.text,
            "email": _emailController.text,
          };
          HelperFunctions.saveUsername(_usernameController.text);
          HelperFunctions.saveUserEmail(_emailController.text);
          setState(() {
            DatabaseMethods().uploadUserInfo(userInfoMap);
            HelperFunctions.saveUserLoggedIn(true);
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
        }
        // setState(() {
        //   DatabaseMethods().uploadUserInfo(userInfoMap);
        //   HelperFunctions.saveUserLoggedIn(true);
        // });
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        // );
        // }
      });
    }
  }

  @override
  void initState() {
    _isLoading = false;
    _usernameController.text = "";
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
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: _key,
                              child: Column(
                                children: [
                                  TextFormFieldWidget(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Username can't be empty.";
                                      }
                                      return null;
                                    },
                                    controller: _usernameController,
                                    hint: "Username",
                                    obscureText: false,
                                  ),
                                  TextFormFieldWidget(
                                    validator: (value) {
                                      return RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(value)
                                          ? null
                                          : "Please provide a valid email ID.";
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
                                ],
                              ),
                            ),
                            SizedBox(height: deviceHeight * 0.03),
                            GestureDetector(
                              onTap: () {
                                signMeUp();
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
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(height: deviceHeight * 0.02),
                          ],
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
                "Already have an account? ",
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "SignIn now",
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
