import 'package:admin_shop/detail_menu.dart';
import 'package:admin_shop/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sp;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Memastikan Flutter binding telah diinisialisasi
  await initializeSharedPreferences(); // Menunggu inisialisasi SharedPreferences
  runApp(const MainApp());
}

Future<void> initializeSharedPreferences() async {
  try {
    sp = await SharedPreferences.getInstance();
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
    // Menangani kesalahan inisialisasi jika terjadi
    // Misalnya, Anda bisa menampilkan dialog atau pesan kesalahan kepada pengguna
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}
