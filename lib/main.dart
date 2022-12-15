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
        primarySwatch: Colors.brown,
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
  List<Color> colors = [
    const Color(0xFF0077c2),
    const Color(0xFF009ba9),
    const Color(0xfffe6300),
    const Color(0xFFd80019)
  ];

  List<String> icons = [
    "assets/img/happy.png",
    "assets/img/sad.png",
    "assets/img/angry.png",
    "assets/img/mad.png"
  ];

  List<String> status = ["좋음", "보통", "나쁨", "매우나쁨"];

  String stationName = "강서구";

  List<Dust> data = [];

  int getStatus(Dust dust) {
    if (dust.pm10 > 150) {
      return 3;
    } else if (dust.pm10 > 80) {
      return 2;
    } else if (dust.pm10 > 30) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getDustData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getPage() {
    if (data.isEmpty) {
      return Container();
    }
    int status_ = getStatus(data.first);

    return Container(
      color: colors[status_],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 60,
          ),
          const Text(
            "현재 위치",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Container(
            height: 12,
          ),
          Text(
            "[$stationName]",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          Container(
            height: 50,
          ),
          SizedBox(
            width: 180,
            height: 180,
            child: Image.asset(
              icons[status_],
              fit: BoxFit.contain,
            ),
          ),
          Container(
            height: 50,
          ),
          Text(
            status[status_],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 12,
          ),
          Text(
            "통합 환경 대기 지수: ${data.first.khai}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void getDustData() async {
    DustApi api = DustApi();
    data = await api.getDustDate(stationName);
    data.removeWhere((t) => t.pm10 == 0);
    setState(() {});
  }
}
