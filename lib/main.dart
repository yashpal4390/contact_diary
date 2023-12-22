// ignore_for_file: prefer_const_constructors

import 'package:contact_diary/provider/contact_provider.dart';
import 'package:contact_diary/view/contact_save.dart';
import 'package:contact_diary/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ContactProvider();
      },
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            "/": (context) => HomePage(),
            "ContactSave":(context) => ContactSave(),
          },
        );
      },
    );
  }
}
