import 'package:flutter/material.dart';
import '../../Constants/api.dart';
import 'package:http/http.dart' as http;

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  void createTodo() async {
    try {
      final response = await http.post(
        Uri.parse(api),
        body: {
          'title': titleController.text,
          'desc': descController.text, // Assuming you want the default status as false
        },
      );

      if (response.statusCode == 201) {
        // Successfully created
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Navigate back to the previous screen
      } else {
        // Handle error
        print('Failed to create todo');
      }
    } catch (e) {
      print('Error creating todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: createTodo,
              child: Text('Create Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
