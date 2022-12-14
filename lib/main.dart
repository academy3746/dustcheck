import 'package:dustcheck/data/api.dart';
import 'package:dustcheck/data/dust.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Color> colors = [const Color(0xFF0077c2), const Color(0xFF009ba9), const Color(0xfffe6300), const Color(0xFFd80019)];

  List<String> icons = ["assets/img/happy.png", "assets/img/sad.png", "assets/img/angry.png", "assets/img/mad.png"];

  List<String> status = ["좋음", "보통", "나쁨", "매우나쁨"];

  String stationName = "서초구";

  List<Dust> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DustApi api = DustApi();
          List<Dust> data = await api.getDustDate("서초구");
          data.removeWhere((t) => t.pm10 == 0);

          for (final d in data) {
            if (kDebugMode) {
              print("dataTime: ${d.datatime} / pm10Value: ${d.pm10}");
            }
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
