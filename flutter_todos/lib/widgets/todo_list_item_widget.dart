// ignore_for_file: must_be_immutable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/models/todo_model.dart';
import 'package:flutter_todos/providers/all_providers.dart';

class TodoListItemWidget extends ConsumerStatefulWidget {
  const TodoListItemWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodoListItemWidgetState();
}

class _TodoListItemWidgetState extends ConsumerState<TodoListItemWidget> {
  late FocusNode _textFocusNode;
  late TextEditingController _textController;
  bool _hasFocus = false;
  

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currendTodoItem = ref.watch(currentTodoPrpvider);
    return Focus(
      onFocusChange: (isFocused) {
        if (!isFocused) {
          setState(() {
            _hasFocus = false;
          });
          ref.read(todoListProvider.notifier).edit(
              id: currendTodoItem.id,
              newDescription: _textController.text);
        }
      },
      child: ListTile(
        onTap: () {
          setState(() {
            _hasFocus = true;
          });
          _textFocusNode.requestFocus();
          _textController.text = currendTodoItem.description;
        },
        leading: Checkbox(
          value: currendTodoItem.completed,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toggle(currendTodoItem.id);
          },
        ),
        title: _hasFocus
            ? TextField(
                controller: _textController,
                focusNode: _textFocusNode,
              )
            : Text(currendTodoItem.description),
      ),
    );
  }
}
