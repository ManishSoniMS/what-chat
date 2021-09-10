import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

class HelperFunctions {
  static const String userLogInKey = "ISLOGGEDIN";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";

  /// Save
  static Future<bool?> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(userLogInKey, isUserLoggedIn);
  }
  // static saveUserLoggedIn(bool isUserLoggedIn) {
  //   GetStorage preferences = GetStorage();
  //   preferences.write(userLogInKey, isUserLoggedIn);
  // }

  // static Future<String?> saveUsername(String userName) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.setString(userNameKey, userName);
  // }
  static saveUsername(String userName) {
    GetStorage preferences = GetStorage();
    preferences.write(userNameKey, userName);
  }

  // static Future<String?> saveUserEmail(String userEmail) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.setString(userEmailKey, userEmail);
  // }
  static saveUserEmail(String userEmail) {
    GetStorage preferences = GetStorage();
    preferences.write(userEmailKey, userEmail);
  }

  /// Get
  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(userLogInKey);
  }
  // static getUserLoggedIn() {
  //   GetStorage preferences = GetStorage();
  //   preferences.read(userLogInKey);
  // }

  // static Future<String?> getUsername() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(userNameKey);
  // }
  static getUsername() {
    GetStorage preferences = GetStorage();
    return preferences.read(userNameKey);
  }

  // static Future<String?> getUserEmail() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(userEmailKey);
  // }
  static getUserEmail() {
    GetStorage preferences = GetStorage();
    return preferences.read(userEmailKey);
  }
}
