import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/model/todo.dart';

class UserSimplePreferences {
  // ignore: unused_field
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /*static Future setTodoList(List<ToDo> todoList) async {
    final json = todoList.map((todo) => todo.toJson()).toList();
    await _preferences!.setStringList('todo_list', json);
  }*/
}
