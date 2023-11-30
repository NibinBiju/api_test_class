import 'dart:convert';
import 'package:api_test_class/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? model;
  var jsonData;
  bool isLoad = false;

  List myNewList = [];

  Future<void> fetchData({int index = 0}) async {
    setState(() {
      isLoad = true;
    });
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var response = await http.get(uri);
    print("${response.body}");
    print('${model?.id}');
    var mylist = jsonDecode(response.body);
    myNewList = mylist.map((json) {
      return UserModel(
        name: json['name'],
        id: json['id'],
      );
    }).toList();
    // return myNewList.map((e) => UserModel.fromJson(e)).toList();

    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: myNewList.length,
              itemBuilder: (context, index) => RefreshIndicator(
                onRefresh: () {
                  return fetchData(index: index);
                },
                child: ListTile(
                  title: Text(
                    myNewList[index].name,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(myNewList[index].id.toString()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
