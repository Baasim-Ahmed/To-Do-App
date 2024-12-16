// ignore_for_file: unused_import

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class Data {
  List ToDoList = [];
  final url =
      Uri.https('to-do-app-b29d6-default-rtdb.firebaseio.com', 'tasks.json');

  void initData() {
    ToDoList = [
      ["Get your Shit Together", false],
      ["Work Out Nigga", false],
      ["Drink more water", false],
      ["Work on your mental health", false],
    ];
  }

  void updateData() async {
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json'
    }, body: {
      'tasks': ToDoList,
    });
  }

  void getData() async {
    final response = await http.get(url);
    Map<String, dynamic> data = json.decode(response.body);
    for (final i in data.entries) {
      ToDoList = i.value['tasks'];
    }
  }
}
