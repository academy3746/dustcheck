import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dustcheck/data/dust.dart';

class DustApi {
  final BASE_URL = "http://apis.data.go.kr";

  final String key =
      "VKcfRu%2FyjZ6ftGwn%2FS01DkZLL0mStDbMkH4QO2rjTlkCAM90p61BLBznC78QIadnKi8tanvisXVPVFwB3pEz0w%3D%3D";

  Future<List<Dust>> getDustDate(String stationName) async {
    String url =
        "$BASE_URL/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=$key&returnType=json&numOfRows=100&pageNo=1&stationName=${Uri.encodeQueryComponent(stationName)}&dataTerm=DAILY&ver=1.0";

    final response = await http.get(url);

    // For Debugging
    if (kDebugMode) {
      print(utf8.decode(response.bodyBytes));
    }

    List<Dust> data = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var result = json.decode(body) as Map<String, dynamic>;

      for (final res in result["response"]["body"]["items"]) {
        /*
        coValue: "0.4",
        pm10Value: "28",
        khaiGrade: "2",
        pm25Value: "17",
        dataTime: "2022-12-14 20:00",
        o3Value: "0.020"
        */

        final dust = Dust.fromJson(res as Map<String, dynamic>);
        data.add(dust);
      }

      return data;
    } else {
      return [];
    }
  }
}
