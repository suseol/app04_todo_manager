// 학생용 Checkpoint 2: Todo 추가 + Form 검증까지
// Checkpoint 1 이후 실습을 놓쳤을 때 이 파일에서 다시 시작할 수 있습니다.

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
    // FormState에 접근해 validate()를 호출하기 위한 key
    final formKey = GlobalKey<FormState>();
    String title = '';
    String note = '';

    // Dialog가 닫힐 때까지 기다렸다가 TodoItem? 결과를 받음
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
                    // 입력 규칙: 오류가 있으면 메시지, 정상이면 null 반환
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
              // 결과 없이 Dialog 닫기
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                // Form에 연결된 validator들을 실행하고 모두 통과했는지 확인
                final isValid = formKey.currentState?.validate() ?? false;
                if (!isValid) {
                  return;
                }

                // 검증된 입력값을 TodoItem으로 만들어 호출한 쪽에 반환
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

    // 취소하거나 결과 없이 닫힌 경우 목록을 변경하지 않음
    if (newTodo == null) {
      return;
    }

    setState(() {
      _todos.add(newTodo);
    });
  }

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
