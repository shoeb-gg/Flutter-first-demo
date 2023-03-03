import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String country = "bangladesh";
  String countryName = "";
  String population = "";
  String capital = "";
  String currency = "";
  String flagUrl = "";

  void fetchCountry() async {
    if (_countryController.text != '') {
      country = _countryController.text.toLowerCase();
    }
    final res = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/name/$country?fullText=true'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body.toString());

      setState(() {
        countryName = country.toUpperCase();
        population = (data[0]['population']).toString();
        capital = (data[0]['capital'][0]).toString();
        currency = (data[0]['currencies'].keys)
            .toString()
            .replaceAll(RegExp(r"\p{P}", unicode: true), "");
        flagUrl = (data[0]['flags']?['svg']).toString();
      });

      debugPrint('https://restcountries.com/v3.1/name/$country?fullText=true');
      debugPrint(population);
    } else {
      throw Exception("Wrong Country");
    }
    FocusScopeNode currFocus = FocusScope.of(context);
    if (!currFocus.hasPrimaryFocus) {
      currFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currFocus = FocusScope.of(context);
        if (!currFocus.hasPrimaryFocus) {
          currFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                  countryName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(15),
                  height: 220,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: flagUrl != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SvgPicture.network(
                            flagUrl,
                          ),
                        )
                      : const Text("")),
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  alignment: const Alignment(-1.0, 0.0),
                  child: population != ''
                      ? Text(
                          "Population: $population",
                          style: const TextStyle(fontSize: 15),
                        )
                      : const Text("")),
              Container(
                  margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  alignment: const Alignment(-1.0, 0.0),
                  child: capital != ''
                      ? Text(
                          "Capital: $capital",
                          style: const TextStyle(fontSize: 15),
                        )
                      : const Text("")),
              Container(
                  margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  alignment: const Alignment(-1.0, 0.0),
                  child: currency != ''
                      ? Text(
                          "Currency: $currency",
                          style: const TextStyle(fontSize: 15),
                        )
                      : const Text("")),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
