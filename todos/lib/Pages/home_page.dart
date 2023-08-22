import 'package:flutter/Material.dart';
import '../../Constants/api.dart';
import '../../Models/todo.dart';
import '../../Widgets/app_bar.dart';
import 'create_todo.dart';
import 'update_todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> myTodos = [];

  void fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      var data = json.decode(response.body) as List<dynamic>;

      List<Todo> fetchedTodos = data.map<Todo>((todoData) {
        return Todo(
          id: todoData['id'],
          title: todoData['title'],
          desc: todoData['desc'],
          isDone: todoData['status'],
          date: todoData['date'],
        );
      }).toList();

      setState(() {
        myTodos = fetchedTodos;
      });
    } catch (e) {
      print("error is $e");
    }
  }

  Future<void> updateTodoStatus(int id, bool newStatus) async {
    try {
      final updatedTodoIndex = myTodos.indexWhere((todo) => todo.id == id);

      if (updatedTodoIndex != -1) {
        Todo updatedTodo = myTodos[updatedTodoIndex];
        updatedTodo.isDone = newStatus;

        final response = await http.put(
          Uri.parse('$api$id/'),
          body: jsonEncode(
              updatedTodo.toJson()), // Convert the Todo object to JSON
          headers: {
            'Content-Type': 'application/json',
          },
        );

        //print('PUT Request URL: ${Uri.parse('$api$id/')}');
        //print('PUT Request Body: ${jsonEncode(updatedTodo.toJson())}');

        if (response.statusCode == 200) {
          // Successfully updated on the server
          setState(() {
            myTodos[updatedTodoIndex] =
                updatedTodo; // Update the local list with the updated todo
          });
        } else {
          // Handle error
          print(
              'Failed to update todo status. Response: ${response.statusCode}');
        }
      } else {
        print('Todo not found');
      }
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$api$id/'), // Construct the URL with the todo ID
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        // Successfully deleted on the server
        setState(() {
          // Remove the deleted todo from the local list
          myTodos.removeWhere((todo) => todo.id == id);
        });
      } else {
        // Handle error
        print('Failed to delete todo. Response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: ListView.builder(
        itemCount: myTodos.length,
        itemBuilder: (context, index) {
          Todo todo = myTodos[index];
          return ListTile(
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (bool? value) {
                // Update the status of the todo
                updateTodoStatus(todo.id, value ?? false);
              },
            ),
            title: Text(todo.title),
            subtitle: Text(todo.desc),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to the UpdateTodo screen with the todo's data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateTodo(todo: todo),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Delete the todo and update the list
                    deleteTodo(todo.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the CreateTodo screen when FloatingActionButton is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTodo()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
