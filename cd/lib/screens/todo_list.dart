import 'dart:convert';

import 'package:cd/screens/add_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
        // backgroundColor: Colors.deepPurpleAccent,
        elevation: 2,
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context,index)
        {
          final item = items[index] as Map;
          final id = item ['_id'] as String;
          return  Card(
            child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}'),),
            title: Text(item['title']),
            subtitle: Text(item['description']),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit')
                {
                    navigateToEditPage(item);
                } else if( value == 'delete')
                {
                    deleteById(id);
                }
              },
              itemBuilder: (context)
              {
              return [
                const PopupMenuItem(
                  child: Text("Edit"),
                value: 'edit',
                ),
                const PopupMenuItem(
                  child: Text('Delete'),
                value: 'delete',
                )
              ];
              }
            ),
            ),
          );
        }
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text("Add Todo")),
    );
    }
    // edit page

    Future <void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(
      builder: (context) =>  AddTodoPage(todo:item),
      );
      await Navigator.push(context, route);
        setState(() {
      isLoading = true;
    });
    fetchTodo();
  }
  // ignore: non_constant_identifier_names
Future <void> navigateToAddPage() async{
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
      );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById (String id) async
  {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
        showErrorMessage("Unable to delete");
    }

  }

Future<void> fetchTodo() async {

    setState(() {
    isLoading = true;
  });

  const url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body) as Map;
    final List<dynamic> result = jsonResponse['items'];
    setState(() {
      items = result;
    });


  } else {

    print('Request failed with status: ${response.statusCode}');
  }
  setState(() {
    isLoading = true;
  });
}

//  void showSuccessMessage(String message) {
//     final snackBar = SnackBar(content: Text(message));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message,
    style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}