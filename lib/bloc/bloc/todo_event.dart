part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class FetchTodoEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;
  final String description;

  AddTodoEvent({required this.title, required this.description}) {
    if (title.isEmpty || description.isEmpty) {
      throw ArgumentError('Title and description cannot be empty.');
    }
  }
}

class ToggleTodo extends TodoEvent {
  final int index;

  ToggleTodo({required this.index});
}

class DeleteTodo extends TodoEvent {
  final int index;

  DeleteTodo({required this.index});
}
