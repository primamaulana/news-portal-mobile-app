import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:favorite_meals/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cryptography/cryptography.dart';
import '../providers/database.dart';
import '../widgets/constant.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  getFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // get from camera
  getFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> showPictureDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Action'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  getFromCamera();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getFromGallery();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Gallery'),
              ),
            ],
          );
        });
  }

  Future<String> _hashPassword(String password) async {
    final hashAlgorithm = Sha256();
    final hashed = await hashAlgorithm.hash(utf8.encode(password));
    return base64.encode(hashed.bytes);
  }

  Future<bool> _registerUser(
      String username, String password, File? image) async {
    final hashedPassword = await _hashPassword(password);
    Uint8List? imageBytes;
    if (image != null) {
      imageBytes = await image.readAsBytes();
    }
    try {
      await DatabaseHelper().insertUser(username, hashedPassword, imageBytes);
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<void> _register(BuildContext context) async {
    final username = user.text;
    final password = pass.text;

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Username dan Password tidak boleh kosong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    final isSuccess = await _registerUser(username, password, _image);

    if (isSuccess) {
      Fluttertoast.showToast(
          msg: "Pendaftaran Berhasil!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Pendaftaran Gagal!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Screen', style: whiteTextStyle.copyWith()),
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
                  "Daftarkan Akun Anda",
                  style: textTextStyle.copyWith(fontSize: 30, fontWeight: bold),
                ),
                SizedBox(height: 11),
                Text(
                  "Masukkan username dan password",
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 64),
                GestureDetector(
                  onTap: showPictureDialog,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage('images/default_avatar.png') as ImageProvider,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: textTextStyle.copyWith(fontSize: 12, fontWeight: bold),
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
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Password",
                      style: textTextStyle.copyWith(fontSize: 12, fontWeight: bold),
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
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
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
                      _register(context);
                    },
                    child: Text(
                      "REGISTER",
                      style: whiteTextStyle.copyWith(fontWeight: bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun? ",
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
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
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

