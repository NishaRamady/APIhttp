import 'dart:convert';
import 'dart:developer';

import 'package:apihttp/postmodel2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class HttpShopping extends StatefulWidget {
  const HttpShopping({super.key});

  @override
  State<HttpShopping> createState() => _HttpShoppingState();
}

class _HttpShoppingState extends State<HttpShopping> {
  Future<PostModel?>? post;
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

  Future<PostModel> fetchPost() async {
    try {
      final uri = Uri.parse("https://fakestoreapi.com/products/1");
      final response = await http.get(uri);
      log('response is ${response.body}');
      if (response.statusCode == 200) {
        return PostModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load post");
      }
    } catch (e) {
      log('error during fetchPost:$e');
      throw e;
    }
  }

  Future<PostModel> createPost(String title, String description) async {
    Map<String, dynamic> request = {
      "id": "1",
      "title": title,
      "price": "109.95",
      "description": description,
      "category": "men's clothing",
      "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
      "rating": {"rate": 3.9, "count": 120}
    };
    try {
      final uri = Uri.parse("https://fakestoreapi.com/products");
      final response = await http.post(uri, body: request);
      log('response is ${response.body}');
      if (response.statusCode == 201) {
        return PostModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load post");
      }
    } catch (e) {
      log('error during create is $e');
      throw e;
    }
  }

  Future<PostModel> updatePost(String title, String description) async {
    Map<String, dynamic> request = {
      "id": "1",
      "title": title,
      "price": "109.95",
      "description": description,
      "category": "men's clothing",
      "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
      "rating": {"rate": 3.9, "count": 120}
    };
    final uri = Uri.parse("https://fakestoreapi.com/products/1");
    final response = await http.put(uri, body: request);
    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<PostModel?>? deletePost() async {
    final uri = Uri.parse("https://fakestoreapi.com/products/1");
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      return null;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Http Package"),
        ),
        body: SizedBox(
          height: 500,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<PostModel?>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const CircularProgressIndicator();
                    else if (snapshot.connectionState == ConnectionState.none)
                      return Container();
                    else if (snapshot.hasData)
                      //  return buildDataWidget(context, snapshot.data);
                      return buildDataWidget(context, snapshot);
                    else if (snapshot.hasError)
                      return Text('${snapshot.error}');
                    else
                      return Container();
                  }),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => clickGetButton(),
                  child: const Text("Get"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => clickPostButton(),
                  child: const Text("Post"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => clickUpdateButton(),
                  child: const Text("Update"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => clickDeleteButton(),
                  child: const Text("Delete"),
                ),
              )
            ],
          ),
        ));
  }
}

// Widget buildDataWidget(context, PostModel? model) {
//   log('data is ${model?.title}');
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Text(model?.title ?? ''),
//       ),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(model?.description ?? ''),
//       ),
//     ],
//   );
// }

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
          child: Text(snapshot.data.description),
        )
      ],
    );
