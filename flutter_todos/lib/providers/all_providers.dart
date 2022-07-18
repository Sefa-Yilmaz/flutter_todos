import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/models/todo_model.dart';
import 'package:flutter_todos/providers/todo_list_manager.dart';
import 'package:uuid/uuid.dart';

enum TodoListFilter { all, active, completed }

final todoListFilter = StateProvider<TodoListFilter>((ref) => TodoListFilter.all);

final todoListProvider =
    StateNotifierProvider<TodoListManager, List<TodoModel>>(
  (ref) {
    return TodoListManager([
      TodoModel(id: const Uuid().v4(), description: 'Spora git'),
      TodoModel(id: const Uuid().v4(), description: 'Alişverişe git'),
      TodoModel(id: const Uuid().v4(), description: 'Eve git'),
      TodoModel(id: const Uuid().v4(), description: 'TV izle'),
    ]);
  },
);

final filteredTodoList = Provider<List<TodoModel>>(
  (ref) {
    final filter = ref.watch(todoListFilter);
    final todoList = ref.watch(todoListProvider);

    switch (filter) {
      case TodoListFilter.all:
        return todoList;
      case TodoListFilter.completed:
        return todoList.where((element) => element.completed).toList();
      case TodoListFilter.active:
        return todoList.where((element) => !element.completed).toList();
    }
  },
);

final unCompletedTodoCount = Provider<int>((ref) {
  final allTodo = ref.watch(todoListProvider);
  final count = allTodo.where((element) => !element.completed).length;
  return count;
});

final currentTodoPrpvider = Provider<TodoModel>((ref) {
  throw UnimplementedError();
});
