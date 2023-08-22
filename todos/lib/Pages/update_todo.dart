import 'package:flutter/material.dart';
import '../../Models/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Constants/api.dart';

class UpdateTodo extends StatefulWidget {
  final Todo todo;

  const UpdateTodo({required this.todo});

  @override
  _UpdateTodoState createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.title;
    descController.text = widget.todo.desc;
  }

  void updateTodo() async {
    try {
      final response = await http.put(
        Uri.parse('$api${widget.todo.id}/'),
        body: jsonEncode({
          'id': widget.todo.id,
          'title': titleController.text,
          'desc': descController.text,
          'status': widget.todo.isDone,
          'date': widget.todo.date,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successfully updated on the server
        Navigator.pop(context); // Navigate back to the previous screen
      } else {
        // Handle error
        print('Failed to update todo. Response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: updateTodo,
              child: Text('Update Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
