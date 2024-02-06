import 'package:cd/screens/add_page.dart';
import 'package:flutter/material.dart';


class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
        // backgroundColor: Colors.deepPurpleAccent,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: NavigateToAddPage,
         label: const Text("Add Todo")),
    );
  }

  // ignore: non_constant_identifier_names
  void NavigateToAddPage(){
     final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
      );
      Navigator.push(context, route);
  }
}