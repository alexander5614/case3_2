import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<Posts> fetchPosts() async {
  final response = await http
      .get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));

  if (response.statusCode == 200) {
    return Posts.fromJson(jsonDecode(response.body));
      } else {
    throw Exception("Ошибка при загрузке");
  }
}
class Posts {
  final int userId;
  final int id;
  final String title;
  final String body;

  Posts ({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
});
  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      body: json["body"],
    );
  }
}
class Network extends StatefulWidget {
  const Network ({Key? key}): super(key: key);

  @override
  _NetworkState createState() => _NetworkState();
}
class _NetworkState extends State<Network> {
  late Future<Posts> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Получаем данные из сети",
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Получаем данные из сети"),
        ),
        body: ListView(
          children: [Center(
            child: FutureBuilder<Posts>(
              future: futurePosts,
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Text(snapshot.data!.title,);

                 }  else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
          FutureBuilder<Posts>(
            future: futurePosts,
            builder: (context, snapshot){
              if (snapshot.hasData){
                return Text(snapshot.data!.body,);

              }  else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return const CircularProgressIndicator();
            },
          ),]
        ),
        ),
      );
      }
}