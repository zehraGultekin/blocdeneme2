import 'package:blocdeneme2/blocs/bloc_counter.dart';
import 'package:blocdeneme2/pages/page_todo_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/bloc_todo.dart';
import 'pages/page_todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
   Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TodoBloc()),
        BlocProvider(create: (_) => CounterBloc()),
      ],
       child: MaterialApp(
        title: 'Todo + Counter BLoC',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const PageTodoCounter(),
      ),
    );
  }

}
