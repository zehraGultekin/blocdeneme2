import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc_todo.dart';
import '../blocs/event_todo.dart';
import '../blocs/state_todo.dart';
import '../blocs/bloc_counter.dart';


class PageTodoCounter extends StatefulWidget {
  const PageTodoCounter({Key? key}) : super(key: key);

  @override
  State<PageTodoCounter> createState() => _PageTodoCounterState();
}

class _PageTodoCounterState extends State<PageTodoCounter> {
  final TextEditingController _controller = TextEditingController();
  late TodoBloc _todoBloc;
  late CounterBloc _counterBloc;

  @override
  void initState() {
    super.initState();
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    _counterBloc = BlocProvider.of<CounterBloc>(context);
  }

  void _addTodo() {
    if (_controller.text.trim().isEmpty) return;
    _todoBloc.add(AddTodo(_controller.text.trim()));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo + Counter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocConsumer<CounterBloc, CounterState>(
              listener: (context, state) {
                if (state.count % 5 == 0 && state.count != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Counter reached ${state.count}!')),
                  );
                }
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _counterBloc.add(Decrement()),
                    ),
                    Text(
                      '${state.count}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _counterBloc.add(Increment()),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Enter a task...'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addTodo, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 16),
            // --- Todo List BlocBuilder ---
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TodoLoaded) {
                    if (state.todos.isEmpty) return const Center(child: Text('No tasks yet.'));
                    return ListView.separated(
                      itemCount: state.todos.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return ListTile(
                          leading: Checkbox(
                            value: todo.isDone,
                            onChanged: (_) => _todoBloc.add(ToggleTodo(todo.id)),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                                decoration: todo.isDone ? TextDecoration.lineThrough : null),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _todoBloc.add(RemoveTodo(todo.id)),
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
