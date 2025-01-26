import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logger/logger.dart';

import '../bloc/bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
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
                try {
                  BlocProvider.of<TodoBloc>(context).add(
                    AddTodoEvent(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                    ),
                  );
                  BlocProvider.of<TodoBloc>(context).add(FetchTodoEvent());
                  _logger.i("Todo added successfully!");
                  Navigator.pop(context);
                } catch (error) {
                  _logger.e("Error submitting todo: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: Failed to add todo.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Submit')),
        ],
      ),
    );
  }
}
