import 'package:chat_gen_ai_app/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Champ',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 179, 228, 251),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
