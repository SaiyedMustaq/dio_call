import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_fluttter_application/NetworkCall.dart';
import 'package:dio_fluttter_application/User.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NetworkCall httpService = NetworkCall();
  late User user;
  bool isLoadig = true;

  @override
  void initState() {
    callApi(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoadig
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: [
                  Text(user.data!.firstName ?? ""),
                  Text(user.data!.lastName ?? ""),
                  Text(user.data!.email ?? ""),
                  Image.network(user.data!.avatar!)
                ],
              ),
            ),
    );
  }

  Future callApi(int id) async {
    Response result = await httpService.request(
      url: 'users/$id',
      method: Method.GET,
      context: context,
    );
    user = User.fromJson(jsonDecode(jsonEncode(result.data)));
    setState(() {
      isLoadig = false;
    });
    if (kDebugMode) {
      print('RESULT $result');
    }
  }
}
