class ToDo {
  String? id;
  String? todoText;
  bool? isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "todo_text": todoText,
      "is_done": isDone,
    };
  }

  static ToDo fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todo_text'],
      isDone: json['is_done'],
    );
  }
}
