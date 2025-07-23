import 'package:flutter/material.dart';
import 'package:rey/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rey & Lenferna',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
