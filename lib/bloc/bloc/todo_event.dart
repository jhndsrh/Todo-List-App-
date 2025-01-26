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

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final Item updatedTodo;

  UpdateTodoEvent({required this.id, required this.updatedTodo});
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  DeleteTodoEvent({
    required this.id,
  });
}
