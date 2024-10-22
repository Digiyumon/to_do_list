import 'package:flutter/material.dart';
import 'colors.dart';
import 'widgets/todo_item.dart';
import 'model/todo.dart';
import './user_simple_preferences.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  final _searchController = TextEditingController();
  bool hasSearched = false;
  var loadedList;
  var permLoadedList;

  String _scrollLocation = "Reached start";

  @override
  void initState() {
    super.initState();
    UserSimplePreferences.getTodoList().then((loadedList) {
      setState(() {
        for (ToDo todoo in loadedList) {
          if (!todosList.contains(todoo)) {
            todosList.add(todoo);
          }
        }
        _foundToDo = loadedList;
        permLoadedList = loadedList;
        _scrollController.addListener(() {
          _listenToScrollMoment();
        });
      });
    });
  }

  void _listenToScrollMoment() {
    String currentLocation = '';
    if (_scrollController.offset ==
        _scrollController.position.minScrollExtent) {
      currentLocation = 'reached start';
    } else if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      currentLocation = 'reached end';
    } else {
      currentLocation = 'in between';
    }

    setState(() {
      _scrollLocation = currentLocation;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: _appBar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Search Box and Title Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBox(),
                  //SwitchExample(),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: const Text('ToDo List',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          // The list of todos
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                ToDo todoo = hasSearched ? _foundToDo[index] : todosList[index];
                return TodoItem(
                  todo: todoo,
                  onToDoChanged: _handleToDoChange,
                  onDeleteItem: _handleItemDelete,
                );
              },
              childCount: hasSearched ? _foundToDo.length : todosList.length,
            ),
          ),

          // Space at the bottom to accommodate the text box and button
          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // Adjust this height to your needs
          ),
        ],
      ),

      // AddToDoTextBox and the '+' Button at the bottom
      bottomSheet: Row(
        children: [
          Expanded(
            child: _addToDoTextBox(todoController: _todoController),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20, right: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_todoController.text.isEmpty) {
                  return;
                } else {
                  _addToDoItem(_todoController.text);
                  _todoController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: primaryColor,
                minimumSize: const Size(60, 60),
                elevation: 10,
              ),
              child: const Text(
                '+',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone!;
      UserSimplePreferences.setTodoList(todosList);
      print(_scrollLocation);
    });
  }

  void _handleItemDelete(String id) {
    assert(id != null && id.isNotEmpty,
        "_handleItemDelete was called with a null or empty id");

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    ).then((bool? isDeleted) {
      if (isDeleted != null && isDeleted) {
        _deleteItem(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Item successfully deleted',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _deleteItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      UserSimplePreferences.setTodoList(todosList);
    });
  }

  void _addToDoItem(String toDo) {
    print(todosList);
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todoText: _todoController.text,
          isDone: false));
      UserSimplePreferences.setTodoList(todosList);
    });
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];

    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = _foundToDo
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Container SearchBox() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Icon(
                Icons.search,
                color: MenuIconColor,
                size: 20,
              ),
              prefixIconConstraints:
                  BoxConstraints(maxHeight: 20, minWidth: 25),
              hintText: "Search",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: onSearchBoxChanged));
  }

  void onSearchBoxChanged(String value) {
    _runFilter(value);
    hasSearched = true;
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: MenuIconColor,
            size: 30,
          ),
          Icon(
            Icons.account_circle,
            size: 30,
          )
        ],
      ),
    );
  }
}

class _addToDoTextBox extends StatefulWidget {
  const _addToDoTextBox({
    super.key,
    required TextEditingController todoController,
  }) : _todoController = todoController;

  final TextEditingController _todoController;

  @override
  State<_addToDoTextBox> createState() => _addToDoTextBoxState();
}

class _addToDoTextBoxState extends State<_addToDoTextBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: widget._todoController,
          decoration: InputDecoration(
            hintText: "Add a new ToDo",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
        ));
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.white,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
