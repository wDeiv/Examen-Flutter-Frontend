import 'package:flutter/material.dart';
import 'presentation/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Restaurante',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(),
    ),
  );
}
