// 학생용 Checkpoint 1: 목록 + State + 완료 토글까지
// 이 파일부터 다음 실습을 이어서 작성할 수 있습니다.

import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterTodoApp());
}

class TodoItem {
  String title;
  String note;
  bool isDone;

  TodoItem({
    required this.title,
    this.note = '',
    this.isDone = false,
  });
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

// 목록의 완료 상태가 바뀌므로 State가 필요한 화면
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todos = [
    TodoItem(
      title: '플러터 실습 정리하기',
      note: '3주차 카드 UI 코드와 위젯 트리 다시 살펴보기',
      isDone: true,
    ),
    TodoItem(
      title: '안드로이드 스튜디오 단축키 익히기',
      note: '실행, Hot Reload, 코드 정렬 단축키 다시 사용해 보기',
    ),
    TodoItem(
      title: '위젯 인스펙터 사용해 보기',
      note: '화면 요소를 선택하고 위젯 트리 위치 확인하기',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('플러터 학습 TODO')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              horizontalTitleGap: 4,
              leading: Checkbox(
                value: todo.isDone,
                onChanged: (value) {
                  // 상태값을 바꾸고, 변경된 상태로 UI를 다시 구성하도록 알림
                  setState(() {
                    todo.isDone = value ?? false;
                  });
                },
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  // 같은 isDone 값을 체크 표시와 제목 표현에 함께 사용
                  decoration:
                      todo.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: todo.note.isEmpty ? null : Text(todo.note),
            ),
          );
        },
      ),
    );
  }
}
