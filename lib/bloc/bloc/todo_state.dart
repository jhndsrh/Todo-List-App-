part of 'todo_bloc.dart';

@immutable
abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Item> todos;

  TodoLoaded({required this.todos});
  @override
  List<Object> get props => [todos];
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});
}

class Todo extends Equatable {
  final String title;
  final String description;
  final bool isCompleted;

  const Todo({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [title, description, isCompleted];
}
