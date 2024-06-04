import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:favorite_meals/screens/registerpage.dart';
import 'package:favorite_meals/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/database.dart';
import '../widgets/constant.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<String> _hashPassword(String password) async {
    final hashAlgorithm = Sha256();
    final hashed = await hashAlgorithm.hash(utf8.encode(password));
    return base64.encode(hashed.bytes);
  }

  Future<bool> _validateUser(String username, String password) async {
    final hashedPassword = await _hashPassword(password);
    final user = await DatabaseHelper().getUser(username, hashedPassword);
    return user != null;
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabsScreen(),
        ),
      );
    }
  }

  Future<void> _login(BuildContext context) async {
    final username = user.text;
    final password = pass.text;

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Username & Password Tidak Boleh Kosong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    final isValid = await _validateUser(username, password);

    if (isValid) {
      final hashedPassword = await _hashPassword(password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);
      await prefs.setString('password', hashedPassword);

      if (mounted) {
        Fluttertoast.showToast(
            msg: "Login Berhasil!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TabsScreen(),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Username & Password Salah!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void dispose() {
// Clean up the controller when the widget is disposed.
    user.dispose();
    pass.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Screen',
          style: whiteTextStyle.copyWith(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff130160),
      ),
      backgroundColor: Color(0xffEEEEEE),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang",
                  style: textTextStyle.copyWith(fontSize: 30, fontWeight: bold),
                ),
                SizedBox(height: 11),
                Text(
                  "Masukkan username dan password Anda",
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 64),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: textTextStyle.copyWith(
                          fontSize: 12, fontWeight: bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                      ),
                      child: TextField(
                        controller: user,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan username",
                          hintStyle: textTextStyle.copyWith(
                              fontSize: 12, color: textColor.withOpacity(0.6)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 17),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Password",
                      style: textTextStyle.copyWith(
                          fontSize: 12, fontWeight: bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                      ),
                      child: TextField(
                        controller: pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan password",
                          hintStyle: textTextStyle.copyWith(
                              fontSize: 12, color: textColor.withOpacity(0.6)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 17),
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Remember me",
                          style: greyTextStyle.copyWith(fontSize: 12),
                        )
                      ],
                    ),
                    Text(
                      "Forgot Password ?",
                      style: textTextStyle.copyWith(fontSize: 12),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                    ),
                    onPressed: () {
                      _login(context);
                    },
                    child: Text(
                      "LOGIN",
                      style: whiteTextStyle.copyWith(fontWeight: bold),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 19),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Ooops! Fitur belum tersedia!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://cdn.iconscout.com/icon/free/png-256/free-google-1772223-1507807.png",
                          width: 30,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "SIGN IN WITH GOOGLE",
                          style: textTextStyle.copyWith(fontWeight: bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You don't have an account yet? ",
                      style: secondaryTextStyle.copyWith(fontSize: 12),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: tncTextStyle.copyWith(fontWeight: bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
