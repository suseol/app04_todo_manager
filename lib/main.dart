import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterTodoApp());
}

class FlutterTodoApp extends StatelessWidget {
  const FlutterTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('플러터 학습 TODO'),
      ),
      body: const Center(
        // STEP 00 핵심: 아직 데이터 없이 화면의 출발점만 만듭니다.
        child: Text('여기에 TODO 목록을 만들어 봅니다.'),
      ),
    );
  }
}
