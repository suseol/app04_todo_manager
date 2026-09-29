// 학생용 Checkpoint 3: 삭제 확인 Dialog까지
// 이 다음에는 Navigator를 이용한 상세 화면 이동을 이어서 구현합니다.

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

  Future<void> _showAddTodoDialog() async {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String note = '';

    final newTodo = await showDialog<TodoItem>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('TODO 추가'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: '제목',
                      hintText: '예: 플러터 위젯 복습하기',
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '제목을 입력하세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: '메모',
                      hintText: '선택 사항',
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      note = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                final isValid = formKey.currentState?.validate() ?? false;
                if (!isValid) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  TodoItem(
                    title: title.trim(),
                    note: note.trim(),
                  ),
                );
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );

    if (newTodo == null) {
      return;
    }

    setState(() {
      _todos.add(newTodo);
    });
  }

  Future<void> _confirmDelete(int index) async {
    // Dialog가 닫힐 때까지 기다렸다가 bool? 결과를 받음
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('TODO 삭제'),
          content: Text('"${_todos[index].title}" 항목을 삭제할까요?'),
          actions: [
            TextButton(
              // 취소 결과 반환
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('취소'),
            ),
            FilledButton(
              // 삭제 결과 반환
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    // true일 때만 실제 목록 상태를 변경
    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('플러터 학습 TODO')),
      body: _todos.isEmpty
          ? const Center(
              child: Text('등록된 TODO가 없습니다.'),
            )
          : ListView.builder(
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
                        setState(() {
                          todo.isDone = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: todo.note.isEmpty ? null : Text(todo.note),
                    trailing: IconButton(
                      onPressed: () => _confirmDelete(index),
                      tooltip: '삭제',
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoDialog,
        icon: const Icon(Icons.add),
        label: const Text('TODO 추가'),
      ),
    );
  }
}
