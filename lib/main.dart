import 'package:flutter/material.dart';
import 'package:flutter_simple_pagination/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Pagination',
      home: HomePage(),
    );
  }
}
