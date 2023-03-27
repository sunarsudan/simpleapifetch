import 'dart:convert';

import 'package:fetchsimpleapi/model/simple_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserApi> apiList = [];

  Future<List<UserApi>> getApi() async {
    var response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        apiList.add(UserApi.fromJson(i));
      }
      return apiList;
    }
    return apiList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Text("hello"),
          Expanded(
            child: FutureBuilder(
              future: getApi(),
              builder: (context, AsyncSnapshot<List<UserApi>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData) {
                  return const Text("something went worng");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: apiList.length,
                      itemBuilder: (context, index) {
                        final lists = apiList[index];

                        return ListTile(
                          title: Text(snapshot.data![index].body.toString()),
                        );
                      });
                } else {
                  return Text("sory");
                }
              },
            ),
          ),
        ],
      )),
    );
  }
}
