import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/constant.dart';
import 'loginpage.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  Future<void> _logout(BuildContext context) async {
    // Menghapus status login dari shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Fluttertoast.showToast(
        msg: "Anda Telah Logout!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    // Navigasi ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tentang Aplikasi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Selamat datang di InfoinAja, portal berita mobile terdepan di Indonesia yang menyajikan informasi terkini dan terpercaya. Kami memahami betapa pentingnya akses cepat dan mudah ke berita berkualitas di era digital ini. Oleh karena itu, kami hadir untuk memenuhi kebutuhan informasi Anda dengan berbagai kategori berita yang relevan dan aktual.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Dengan desain yang user-friendly dan fitur navigasi yang intuitif, InfoinAja memastikan pengalaman membaca berita Anda menjadi lebih nyaman dan menyenangkan. Anda dapat mengatur notifikasi untuk mendapatkan berita terbaru sesuai dengan minat Anda, sehingga Anda tidak akan pernah ketinggalan informasi penting.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Kami berkomitmen untuk menyajikan berita dengan integritas, akurasi, dan kecepatan. Bergabunglah dengan jutaan pengguna lain yang telah memilih InfoinAja sebagai sumber informasi terpercaya mereka.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                  height: 20), // Optional spacing between paragraph and button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor,
                      ),
                      onPressed: () async {
                        _logout(context);
                      },
                      child: Text('Logout',
                          style: whiteTextStyle.copyWith(fontWeight: bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
