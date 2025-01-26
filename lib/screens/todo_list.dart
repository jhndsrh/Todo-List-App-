import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/bloc/todo_bloc.dart';
import 'package:todo_app/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();
    // Memastikan konteks berada dalam hierarki BlocProvider
    context.read<TodoBloc>().add(FetchTodoEvent());
    final bloc = BlocProvider.of<TodoBloc>(context, listen: false);
    print('Bloc instance: $bloc'); // Log instance Bloc, pastikan valid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final todos = state.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title.isNotEmpty ? todo.title : "Untitled"),
                  subtitle: Text(todo.description.isNotEmpty
                      ? todo.description
                      : "No description"),
                );
              },
            );
          } else if (state is TodoError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('No Todos available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToAddPage(context),
        label: const Text('Add Todo'),
      ),
    );
  }

  void navigateToAddPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<TodoBloc>(context),
          child: const AddTodoPage(),
        ),
      ),
    );
  }
}
