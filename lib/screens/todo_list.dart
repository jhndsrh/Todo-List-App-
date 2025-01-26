import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/bloc/todo_bloc.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/screens/add_page.dart';
import 'package:todo_app/screens/edit_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();

    context.read<TodoBloc>().add(FetchTodoEvent());
    final bloc = BlocProvider.of<TodoBloc>(context, listen: false);
    print('Bloc instance: $bloc');
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
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) =>
                        _onSelectedPopup(context, todo, value),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
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

  void _onSelectedPopup(BuildContext context, Item todo, String value) {
    if (value == 'Edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTodoPage(todo: todo),
        ),
      );
    } else if (value == 'Delete') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this todo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // context.read<TodoBloc>().add(DeleteTodoEvent(id: todo.id));
                  // Navigator.pop(context);

                  // Add error handling
                  try {
                    context.read<TodoBloc>().add(DeleteTodoEvent(id: todo.id));
                    Navigator.pop(context);
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting todo: $error'),
                      ),
                    );
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }
  }
}
