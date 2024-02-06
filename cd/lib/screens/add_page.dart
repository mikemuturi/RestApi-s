// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});


  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}


class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children:  [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Title"
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submitData,
            child: const Text("Submit"),
          )
        ],
      ),

    );
  }
  // Future<void> submiData() async
  // {
  //   //Get the data from form

  //   final title = titleController.text;
  //   final description = descriptionController.text;

  //   final body = {
  //     "title": title,
  //     "description": description,
  //     "is_completed": false
  //   };
  //   //Submit data to the server
  //  const url ="https://api.nstack.in/v1/todos";
  //   const uri = Uri;
  //   final response = await http.post(uri, body: jsonEncode(body));

  //   print(response);
 

  //   //show success or fail message based on status
  // }


 Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false.toString(),
    };

    const url = "https://api.nstack.in/v1/todos";
    final Uri uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      showSuccessMessage("Submitted Successfully");
      print(response.body);
    } else {
      showErrorMessage("Unable to submit your request");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message,
    style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}