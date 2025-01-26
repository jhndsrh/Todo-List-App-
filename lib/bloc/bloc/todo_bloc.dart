import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _repository;

  TodoBloc(this._repository) : super(TodoInitial()) {
    on<FetchTodoEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await _repository.getTodos();
        emit(TodoLoaded(todos: todos));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    });
    on<AddTodoEvent>((event, emit) async {
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(TodoError(message: 'Title and description cannot be empty.'));
        return;
      }

      emit(TodoLoading());
      try {
        final newItem = Item(
          id: '',
          title: event.title,
          description: event.description,
          isCompleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final addedTodo = await _repository.addTodo(newItem);
        if (state is TodoLoaded) {
          final currentState = state as TodoLoaded;
          final updatedTodos = [...currentState.todos, addedTodo];
          emit(TodoLoaded(todos: updatedTodos));
        } else {
          final todos = await _repository.getTodos();
          emit(TodoLoaded(todos: todos));
        }
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    });
  }
}
