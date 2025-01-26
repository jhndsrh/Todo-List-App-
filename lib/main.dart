import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/bloc/todo_bloc.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/screens/todo_list.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) =>
              TodoBloc(TodoRepository())..add(FetchTodoEvent()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoListPage();
  }
}
