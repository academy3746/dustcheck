import 'package:admob_flutter/admob_flutter.dart';
import 'package:dustcheck/data/api.dart';
import 'package:dustcheck/data/dust.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();
  // Or add a list of test ids.
  // Admob.initialize(testDeviceIds: ['YOUR DEVICE ID']);
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

  List<String> status = [
    "산뜻한 공기를 마음껏 마셔보세요.",
    "가벼운 산보 정도는 괜찮겠어요~",
    "외출을 자제해주세요!",
    "지금 나가면 암 걸립니다..."
  ];

  String stationName = "송도";

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
        onPressed: () async {
          String loc = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const LocationPage()));

          if (loc != null) {
            stationName = loc;
            getDustData();
          }
          InAppReview.instance.requestReview();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.location_on),
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
            height: 40,
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
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 12,
          ),
          Text(
            "통합 환경 대기 지수: ${data.first.khai}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          Expanded(
            child: SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(data.length, (idx) {
                  Dust dust = data[idx];
                  int status_ = getStatus(dust);

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          dust.datatime.replaceAll(" ", "\n"),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 12,
                        ),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: Image.asset(
                            icons[status_],
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          height: 12,
                        ),
                        Text(
                          "${dust.pm10}㎍/㎥",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          AdmobBanner(
              adUnitId: AdmobBanner.testAdUnitId,
              adSize: AdmobBannerSize.BANNER),
          Container(
            height: 30,
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

class LocationPage extends StatefulWidget {
  const LocationPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage> {
  List<String> locations = [
    "송도",
    "강남구",
    "강동구",
    "강북구",
    "강서구",
    "관악구",
    "광진구",
    "구로구",
    "금천구",
    "노원구",
    "도봉구",
    "동대문구",
    "동작구",
    "마포구",
    "서대문구",
    "서초구",
    "성동구",
    "성북구",
    "송파구",
    "양천구",
    "영등포구",
    "용산구",
    "은평구",
    "중구",
    "중랑구",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: List.generate(locations.length, (idx) {
          return ListTile(
            title: Text(locations[idx]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop(locations[idx]);
            },
          );
        }),
      ),
    );
  }
}
