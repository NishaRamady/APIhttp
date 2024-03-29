import 'dart:convert';
import 'dart:developer';

import 'package:apihttp/postmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class DioScreen extends StatefulWidget {
  const DioScreen({super.key});

  @override
  State<DioScreen> createState() => _DioScreenState();
}

class _DioScreenState extends State<DioScreen> {
  Future<Post?>? post;
  Dio dio = Dio();

  clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  clickCreateButton() {
    setState(() {
      post = createPost("Top Post", "This is the example post");
    });
  }

  clickUpdateButton() {
    setState(() {
      post = updatePost("Updated Post", "This is the example post");
    });
  }

  clickDeleteButton() {
    setState(() {
      post = deletePost();
    });
  }

  // Future<Post> fetchPost() async {
  //   try {

  //     final response = await dio.get('https://jsonplaceholder.typicode.com/posts/1');
  //     log('response is ${response.data}');
  //     if (response.statusCode == 200) {
  //       return Post.fromJson(response.data);
  //     } else {
  //       throw Exception("Failed to load data");
  //     }
  //   } catch (e) {
  //     log('error is $e');
  //     throw e;
  //   }
  // }

  Future<Post> fetchPost() async {
    final response =
        await dio.get("https://jsonplaceholder.typicode.com/posts/1");
    if (response.statusCode == 200) {
      return Post.fromJson(response.data);
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<Post?> deletePost() async {
    try {
      final response =
          await dio.delete("https://jsonplaceholder.typicode.com/posts/1");
      log("response is ${response.data}");
      if (response.statusCode == 200) {
        return null;
      } else {
        throw Exception("failed to load data");
      }
    } catch (e) {
      log("error is $e");
      throw e;
    }
  }

  Future<Post> createPost(String title, String body) async {
    Map<String, dynamic> request = {
      'title': title,
      'body': body,
      'userId': '111'
    };
    try {
      final response = await dio
          .post("https://jsonplaceholder.typicode.com/posts", data: request);
      log("response is ${response.data}");
      if (response.statusCode == 201)
        return Post.fromJson((response.data));
      else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      log("error is $e");
      throw e;
    }
  }

  Future<Post> updatePost(String title, String body) async {
    Map<String, dynamic> request = {
      'title': title,
      'body': body,
      'userId': '111',
      'id': '101'
    };
    try {
      final response = await dio
          .put("https://jsonplaceholder.typicode.com/posts/1", data: request);
      log("response is ${response.data}");
      if (response.statusCode == 200) {
        return Post.fromJson((response.data));
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      log("error is $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Http package"),
      ),
      body: SizedBox(
          height: 500,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<Post?>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Container();
                  } else if (snapshot.hasData) {
                    return buildDataWidget(context, snapshot);
                  } else if (snapshot.hasError) {
                    return Text("error is ${snapshot.error}");
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: clickGetButton,
                  child: const Text("Get"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: clickCreateButton,
                  child: const Text("Create"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: clickUpdateButton,
                  child: const Text("Update"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: clickDeleteButton,
                  child: const Text("Delete"),
                ),
              ),
            ],
          )),
    );
  }
}

Widget buildDataWidget(context, snapshot) {
  return Column(
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
        ),
      ]);
}
