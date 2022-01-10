import 'package:flutter/material.dart';
import 'package:lista_tarefas/Home.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(

        primarySwatch: Colors.purple,
      ),
      home: Home(),
    );
  }
}

