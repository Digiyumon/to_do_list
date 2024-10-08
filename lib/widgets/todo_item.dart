import 'package:flutter/material.dart';
import 'package:to_do_list/colors.dart';
import '../model/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const TodoItem(
      {Key? key, required this.todo, this.onToDoChanged, this.onDeleteItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          print("Tapped");
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        //leading: const Icon(Icons.crop_square_outlined, size: 25),
        leading: IconButton(
          onPressed: () {
            onToDoChanged(todo);
          },
          //icon: const Icon(Icons.crop_square_outlined),
          icon: todo.isDone!
              ? const Icon(
                  Icons.check_box,
                  color: primaryColor,
                )
              : const Icon(Icons.check_box_outline_blank),
          iconSize: 25,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
              fontSize: 15,
              decoration: todo.isDone! ? TextDecoration.lineThrough : null),
        ),
        trailing: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.red),
          child: IconButton(
            onPressed: () {
              onDeleteItem(todo.id);
            },
            icon: const Icon(Icons.delete, color: Colors.white),
            iconSize: 18,
          ),
        ),
      ),
    );
  }
}
