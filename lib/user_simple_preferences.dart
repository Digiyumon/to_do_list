import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/model/todo.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setTodoList(List<ToDo> todoList) async {
    // Convert each Todo object to JSON and then encode to a list of JSON strings
    List<Map<String, dynamic>> todoListJson =
        todoList.map((todo) => todo.toJson()).toList();

    // turn todoListJson into a JSON string
    String todoListJsonString = jsonEncode(todoListJson);
    // Save the list of JSON strings
    await _preferences!.setString('todoList', todoListJsonString);
  }

  static Future<List<ToDo>> getTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the saved list of JSON strings
    String? todoListJson = prefs.getString('todoList');
    if (todoListJson != null) {
      // Convert each JSON string back to a Todo object
      List<dynamic> todoListJsonList = jsonDecode(todoListJson);
      return todoListJsonList.map((json) => ToDo.fromJson(json)).toList();
    }

    return []; // Return an empty list if nothing is saved
  }
}
