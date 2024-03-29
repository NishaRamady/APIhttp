// import 'dart:collection';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:html';

// import 'package:apihttp/http.dart';
// import 'package:apihttp/postmodel.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;

// class HttpScreen extends StatefulWidget {
//   const HttpScreen({super.key});

//   @override
//   State<HttpScreen> createState() => _HttpScreenState();
// }

// class _HttpScreenState extends State<HttpScreen> {
//   Future<Post>? post;
//   clickGetButton() {
//     setState(() {
//       post = fetchpost();
//     });
//   }

//   clickPostButton() {
//     setState(() {
//       post = createPost("createPost", "trial");
//     });
//   }

//   clickUpdateButton() {
//     setState(() {
//       post = updatePost("updatePost", "trial");
//     });
//   }

//   clickDeleteButton() {
//     setState(() {
//       post = deletePost();
//     });
//   }

//   Future<Post> fetchpost() async {
//     try {
//       final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
//       final response = await http.get(uri);
//       if (response.statusCode == 200) {
//         return Post.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception("Failed to load data");
//       }
//     } catch (e) {
//       log("error during get is $e");
//       throw e;
//     }
//   }

//   Future<Post> deletePost() async {
//     try {
//       final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
//       final response = await http.delete(uri);
//       if (response.statusCode == 200) {
//         return Post.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception("Failed to load data");
//       }
//     } catch (e) {
//       log("error during delete is $e");
//       throw e;
//     }
//   }

//   Future<Post> createPost(String title, String body) async {
//     Map<String, dynamic> request = {
//       'title': title,
//       'body': body,
//       "userId": '111'
//     };
//     try {
//       final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
//       final response = await http.post(uri, body: request);
//       if (response.statusCode == 201) {
//         return Post.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception("Failed to load post");
//       }
//     } catch (e) {
//       log("error:$e");
//       throw e;
//     }
//   }

//   Future<Post> updatePost(String title, String body) async {
//     Map<String, dynamic> request = {
//       'id': '101',
//       'title': title,
//       'body': body,
//       'userId': '111'
//     };
//     try {
//       final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
//       final response = await http.put(uri, body: request);
//       if (response.statusCode == 200) {
//         return Post.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception("Failed to load data");
//       }
//     } catch (e) {
//       log("error is $e");
//       throw e;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(title: const Text("Http Package")),
//         body: SizedBox(
//           height: 500,
//           width: double.infinity,
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 FutureBuilder<Post>(
//                     future: post,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator();
//                       } else if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Container();
//                       } else if (snapshot.hasData) {
//                         return buildDataWidget(context, snapshot);
//                       } else if (snapshot.hasError) {
//                         return Text('error is ${snapshot.error}');
//                       } else {
//                         return Container();
//                       }

//                     }),
//                      SizedBox(
//                       width: 200,
//                        child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor:Colors.pink ),
//                         onPressed:() => clickGetButton(),
//                         child: const  Text("Get")),
//                      ),
//                     SizedBox(
//                       width:200,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
//                         onPressed:() => clickPostButton(),
//                         child: const Text("Post")),
//                     ),
//                               SizedBox(
//                       width: 200,
//                        child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor:Colors.pink ),
//                         onPressed:() => clickUpdateButton(),
//                         child: const  Text("Update")),
//                      ),
//                     SizedBox(
//                       width:200,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
//                         onPressed:() => clickDeleteButton(),
//                         child: const Text("Delete")),
//                     ),

//               ]),
//         ));
//   }
// }

// Widget buildDataWidget(context, snapshot) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Text(snapshot.data.title),
//       ),
//        Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Text(snapshot.data.body),
//       )
//     ],
//   );
// }

import 'dart:convert';
import 'dart:developer';

import 'package:apihttp/postmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key});

  @override
  State<HttpScreen> createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  Future<Post?>? post;

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

  Future<Post> fetchPost() async {
    try {
      final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
      final response = await http.get(uri);
      log('response is ${response.body}');
      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      log('error is $e');
      throw e;
    }
  }

  Future<Post?> deletePost() async {
    try {
      final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
      final response = await http.delete(uri);
      log("response is ${response.body}");
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
      final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
      final response = await http.post(uri, body: request);
      log("response is ${response.body}");
      if (response.statusCode == 201)
        return Post.fromJson(jsonDecode(response.body));
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
      final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
      final response = await http.put(uri, body: request);
      log("response is ${response.body}");
      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
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
                  onPressed:  clickCreateButton,
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
