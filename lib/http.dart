import 'dart:convert';
import 'dart:developer';

import 'package:apihttp/postmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Post?>? post;
  clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  clickPostButton() {
    setState(() {
      post = createPost("Top Post", "This is the example post");
    });
  }

  clickUpdateButton() {
    setState(() {
      post = updatePost("Updated Post", "This is the updated post");
    });
  }

  clickDeleteButton() {
    setState(() {
      post = deletePost();
    });
  }

  // Get API request
  Future<Post> fetchPost() async {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
    final response = await http.get(uri);
   
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }


  // Post API request
  Future<Post> createPost(
    String title,
    String body,
  ) async {
    Map<String, dynamic> request = {
      'title': title,
      'body': body,
      "userId": '111'
    };
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.post(uri, body: request);

    log('response is ${response.body}');
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Update Api request

  Future<Post> updatePost(String title, String body) async {
    Map<String, dynamic> request = {
      'id': '101',
      'title': title,
      'body': body,
      'userId': '111'
    };
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
    final response = await http.put(uri, body: request);
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load post");
    }
  }

  // Delete Api request

  Future<Post?>? deletePost() async {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      return null;
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('http package')),
        body: SizedBox(
          height: 500,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<Post?>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const CircularProgressIndicator();
                    else if (snapshot.connectionState == ConnectionState.none)
                      return Container();
                    else if (snapshot.hasData)
                      return buildDataWidget(context, snapshot);
                    else if (snapshot.hasError)
                      return Text('${snapshot.error}');
                    else
                      return Container();
                  }),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () => clickGetButton(),
                    child: const Text("Get"),
                  )),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () => clickPostButton(),
                    child: const Text("Post"),
                  )),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () => clickUpdateButton(),
                    child: const Text("Update"),
                  )),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () => clickDeleteButton(),
                    child: const Text("Delete"),
                  ))
            ],
          ),
        ));
  }
}

Widget buildDataWidget(context, snapshot) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(snapshot.data.title),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(snapshot.data.body),
        )
      ],
    );
