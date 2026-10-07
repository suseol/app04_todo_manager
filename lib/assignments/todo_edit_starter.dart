// 과제 Starter: Todo 제목과 메모 수정하기
// 시작 상태: 목록에서 Todo를 선택하면 읽기 전용 상세 화면까지 이동합니다.
// 목표: 상세 화면에서 제목과 메모를 수정하고 확인하면 원래 목록의 해당 항목이 갱신되도록 구현합니다.
//
// TODO는 권장 구현 순서입니다.
// 기존 추가, 삭제, 완료 체크 기능이 계속 동작하도록 유지하세요.

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
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('TODO 삭제'),
          content: Text('"${_todos[index].title}" 항목을 삭제할까요?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _todos.removeAt(index);
    });
  }

  void _openTodoDetail(int index) {
    // TODO 6: 상세 화면에서 돌아오는 TodoItem? 결과를 기다리도록 수정하세요.
    // 힌트:
    // - Navigator.push<TodoItem>(...)가 반환하는 값을 await로 받습니다.
    // - 결과가 null이면 목록을 변경하지 않습니다.
    // - 결과가 있으면 setState() 안에서 _todos[index]를 수정 결과로 교체합니다.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailPage(todo: _todos[index]),
      ),
    );
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
                    onTap: () => _openTodoDetail(index),
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

// 현재는 전달받은 Todo를 읽기만 하는 상세 화면입니다.
//
// TODO 1: TodoDetailPage를 StatefulWidget으로 변경하세요.
// 수정 입력값을 관리하고 lifecycle 메서드를 사용하려면 State 객체가 필요합니다.
//
// TODO 2: 수정 화면에서 사용할 Form key와
// 제목, 메모용 TextEditingController를 State에 선언하세요.
//
// TODO 3: initState()에서 controller에 기존 제목과 메모를 넣고,
// dispose()에서 직접 만든 controller를 정리하세요.
//
// TODO 4: 아래 읽기 전용 Text들을 TextFormField로 바꾸세요.
// - 제목과 메모의 기존 값이 입력칸에 표시되어야 합니다.
// - 제목은 빈 문자열이나 공백만 입력할 수 없도록 validator를 작성하세요.
// - 메모는 여러 줄 입력이 가능하고 비어 있어도 됩니다.
//
// TODO 5: '확인' 버튼과 저장 함수를 추가하세요.
// - Form 검증을 통과한 경우에만 저장합니다.
// - 현재 controller의 제목과 메모로 새 TodoItem을 만듭니다.
// - 완료 여부 isDone은 기존 Todo의 값을 유지합니다.
// - Navigator.pop(context, 수정결과)로 이전 화면에 결과를 반환합니다.
class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({
    super.key,
    required this.todo,
  });

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO 상세'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            todo.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(todo.note.isEmpty ? '메모 없음' : todo.note),
          const SizedBox(height: 12),
          Text(todo.isDone ? '완료됨' : '진행 중'),
        ],
      ),
    );
  }
}
