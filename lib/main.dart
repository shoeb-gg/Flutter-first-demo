import 'dart:convert';

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
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Explore Countries'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _countryController = TextEditingController();
  String country = "";

  void fetchCountry() async {
    final res = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/name/bangladesh?fullText=true'));

    final data = jsonDecode(res.body);
    final name = data['name'] as List;

    // debugPrint(name);

    setState(() {
      country = data[0].name.common;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: TextField(
              controller: _countryController,
              decoration: InputDecoration(
                  hintText: 'bangladesh',
                  border: const OutlineInputBorder(),
                  labelText: 'Country',
                  suffixIcon: IconButton(
                      onPressed: () {
                        _countryController.clear();
                      },
                      icon: const Icon(Icons.clear))),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(right: 15),
              alignment: const Alignment(1.0, 0.0),
              child: ElevatedButton(
                onPressed: fetchCountry,
                child: const Text('GO!'),
              )),
          Container(
            margin: const EdgeInsets.all(15),
            child: Text(
              'Bangladesh',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
            alignment: const Alignment(-1.0, 0.0),
            child: Text(
              "Population: ",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            alignment: const Alignment(-1.0, 0.0),
            child: Text(
              "Capital: ",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            alignment: const Alignment(-1.0, 0.0),
            child: Text(
              "Currency: ",
              style: const TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
