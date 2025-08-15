import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc_todo.dart';
import '../blocs/event_todo.dart';
import '../blocs/state_todo.dart';
import '../models/todo.dart';

class PageTodo extends StatefulWidget {
  const PageTodo({Key? key}) : super(key: key);

  @override
  State<PageTodo> createState() => _PageTodoState();
}

class _PageTodoState extends State<PageTodo> {
  final TextEditingController _controller = TextEditingController();
  late TodoBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TodoBloc>(context);
  }

  void _addTodo() {
    if (_controller.text.trim().isEmpty) return;
    _bloc.add(AddTodo(_controller.text.trim()));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: 'Enter a task...'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Add'),
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TodoLoaded) {
                    if (state.todos.isEmpty) {
                      return const Center(child: Text('No  yet.'));
                    }
                    return ListView.separated(
                      itemCount: state.todos.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return ListTile(
                          leading: Checkbox(
                            value: todo.isDone,
                            onChanged: (_) {
                              _bloc.add(ToggleTodo(todo.id));
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _bloc.add(RemoveTodo(todo.id));
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is TodoError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
