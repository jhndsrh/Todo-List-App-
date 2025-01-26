import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/bloc/todo_bloc.dart';
import 'package:todo_app/model/todo_model.dart';

class EditTodoPage extends StatefulWidget {
  final Item todo;

  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with existing todo data
    titleController.text = widget.todo.title;
    descriptionController.text = widget.todo.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextFormField(
            maxLines: 10,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Title and description cannot be empty.',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final updatedTodo = Item(
                id: widget.todo.id,
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                isCompleted: widget.todo.isCompleted,
                createdAt: widget.todo.createdAt,
                updatedAt: DateTime.now(),
              );

              BlocProvider.of<TodoBloc>(context).add(
                UpdateTodoEvent(id: widget.todo.id, updatedTodo: updatedTodo),
              );
              Navigator.pop(context);
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }
}
