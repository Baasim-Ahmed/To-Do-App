// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_field, unused_import

import 'package:flutter/material.dart';
import 'package:to_do_app/utilities/dialog_box.dart';
import 'package:to_do_app/utilities/todo_tile.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/data/data.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Data db = Data();

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.ToDoList[index][1] = !db.ToDoList[index][1];
    });
  }

  @override
  void initState() async {
    super.initState();

    final url =
        Uri.https('to-do-app-b29d6-default-rtdb.firebaseio.com', 'tasks.json');

    final response;
    response = await http.get(url);

    if (response.body == null) {
      db.initData();
    } else {
      db.getData();
    }
  }

  void saveTask() {
    setState(() {
      db.ToDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  void newTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      db.ToDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text("                TO - DO"),
        titleTextStyle: TextStyle(fontSize: 30, color: Colors.yellow),
        backgroundColor: Colors.deepPurple[600],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newTask,
        backgroundColor: Colors.purple[200],
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.ToDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.ToDoList[index][0],
            Completed: db.ToDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
