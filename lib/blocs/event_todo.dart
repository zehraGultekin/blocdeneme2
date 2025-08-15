abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

class RemoveTodo extends TodoEvent {
  final String id;
  RemoveTodo(this.id);
}

class ToggleTodo extends TodoEvent {
  final String id;
  ToggleTodo(this.id);
}
