import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Test(),
  ));
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController controller = TextEditingController();
  List<Todo> todos = [];

  String todo = "";

  List<Widget> getTodos() {
    List<Widget> todo = [];
    for (int i = 0; i < todos.length; i++) {
      int todoId = i + 1;

      var listtile = ListTile(
        enabled: todos[i].isCompleted ? false : true,
        trailing: Switch(
          value: todos[i].isCompleted,
          onChanged: (newValue) {
            setState(() {
              todos[i].isCompleted = newValue;
              Timer(
                const Duration(milliseconds: 700),
                () {
                  setState(() {
                    if (todos[i].isCompleted) {
                      todos.add(todos[i]);
                      todos.removeAt(i);
                    } else {
                      todos.insert(0, todos[i]);
                      todos.removeAt(i + 1);
                    }
                  });
                },
              );
            });
          },
        ),
        leading: CircleAvatar(
          child: Text(todoId.toString()),
        ),
        title: Text(todos[i].todo),
        subtitle: Text("${todos[i].date}"),
      );
      todo.add(listtile);
    }
    return todo;
  }

  void addToDo({required DateTime date, required String todo}) {
    setState(() {
      todos.add(Todo(date: date, todo: todo, isCompleted: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  labelText: "Enter Todo", border: OutlineInputBorder()),
              onChanged: (value) {
                todo = value;
              },
            ),
          ),
          Expanded(
              child: ListView(
            physics: const BouncingScrollPhysics(),
            children: getTodos(),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addToDo(date: DateTime.now(), todo: todo);
            controller.clear();
          },
          child: const Icon(
            Icons.add,
            size: 40,
          )),
    );
  }
}

class Todo {
  String todo;
  DateTime date;
  bool isCompleted;
  Todo({required this.todo, required this.date, required this.isCompleted});
}
