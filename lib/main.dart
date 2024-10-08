import 'package:flutter/material.dart';
import 'package:to_do_list/colors.dart';
import 'package:to_do_list/home.dart';
import 'package:to_do_list/user_simple_preferences.dart';
import 'package:to_do_list/widgets/todo_item.dart';

/*
Make it to where information is stored in the device. 
User can confirm deletion of a todo item. 
have the side bar actually fucking do something 


*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
