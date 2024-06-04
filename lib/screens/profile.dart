import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Unknown';
    final password =
        prefs.getString('password') ?? 'Unknown'; // hashed password

    // Retrieve image from database
    final databasePath = await getDatabasesPath();
    final path =
    join(databasePath, 'app.db'); // Update path to match your database name
    final database = await openDatabase(path);
    final result = await database
        .query('users', where: 'username = ?', whereArgs: [username]);
    final image = result.isNotEmpty ? result.first['image'] : null;

    return {
      'username': username,
      'password': password,
      'image': image,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Error loading profile',
                  style: TextStyle(color: Colors.white),
                );
              } else {
                final userInfo = snapshot.data!;
                final imageBytes = userInfo['image'] != null
                    ? userInfo['image'] as Uint8List?
                    : null;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imageBytes != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.memory(
                            imageBytes!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (imageBytes == null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(userInfo['username'], style: TextStyle(fontSize: 20),),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
