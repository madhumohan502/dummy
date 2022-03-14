import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sanity_test/sanity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  var cratedAt = "";
  var id = "";
  var rev = "";
  var type = "";
  var updateAt = "";
  var bodyOn = "";
  var bodyOneO = "";
  var bodyTwo = "";
  var headerOne = "";
  var headerTwo = "madhu";

  final SanityClient sanityClient = SanityClient(
    projectId: 'yourprojectid',
    dataset: 'production',
    useCdn: true,
  );
  void _incrementCounter() async {
    print("tapped");

    // const String query = '*[ _type == "movie" ]';
    const String query = '*[_type == "corporateAnnouncement"]';
    List<dynamic> result = await sanityClient.fetch(query: query);
    setState(() {
      cratedAt = result[0]['_createdAt'];
      id = result[0]['_id'];
      rev = result[0]['_rev'];
      type = result[0]['_type'];
      updateAt = result[0]['_updatedAt'];
      bodyOn = result[0]['bodyOne'];
      bodyOneO = result[0]['bodyOneO'];
      bodyTwo = result[0]['bodyTwo'];
      headerOne = result[0]['headerOne'];
      headerTwo = result[0]['headerTwo'];
      // first test
      // from server
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Created at :.." + cratedAt),
            Text("Id :.." + id),
            Text("Rev :.." + rev),
            Text("Type :.." + type),
            Text("Updated At :.." + updateAt),
            Text("Body One :.." + bodyOn),
            Text("Body OneO :.." + bodyOneO),
            Text("Body Two :.." + bodyTwo),
            Text("Header One :.." + headerOne),
            Text("Header Two :.." + headerTwo),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
