import 'package:bloc/bloc.dart';
import 'package:blocdeneme2/blocs/event_todo.dart';
import 'package:blocdeneme2/blocs/state_todo.dart';
import 'package:blocdeneme2/models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<Todo> _todos = [];

  TodoBloc() : super(TodoInitial()) {
    // Eventleri dinle
    on<AddTodo>(_onAddTodo);
    on<RemoveTodo>(_onRemoveTodo);
    on<ToggleTodo>(_onToggleTodo);
  }
    void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    await Future.delayed(Duration(milliseconds: 300)); // simülasyon
    final todo = Todo(id: DateTime.now().toString(), title: event.title);
    _todos.add(todo);
    emit(TodoLoaded(List.from(_todos))); // kopyasını gönderiyoruz
  }
    void _onRemoveTodo(RemoveTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    await Future.delayed(Duration(milliseconds: 200));
    _todos.removeWhere((todo) => todo.id == event.id);
    emit(TodoLoaded(List.from(_todos)));
  }
   void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    await Future.delayed(Duration(milliseconds: 100));
    final index = _todos.indexWhere((todo) => todo.id == event.id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
    }
    emit(TodoLoaded(List.from(_todos)));
  }
}