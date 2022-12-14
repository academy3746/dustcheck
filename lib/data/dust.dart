
class Dust {
  int pm10; // 미세먼지 지수
  int pm25; // 초미세먼지 지수
  int khai; // 통합대기환경 지수
  String datatime; // 날짜
  double co; // 일산화탄소 지수 (additional)
  double o3; // 오존 지수 (additional)

  Dust({this.pm10, this.pm25, this.khai, this.datatime}); 

  factory Dust.fromJson(Map<String, dynamic> data) {
    return Dust(
      pm10: int.tryParse(data["pm10Value"] ?? "") ?? 0,
      pm25: int.tryParse(data["pm25Value"] ?? "") ?? 0,
      khai: int.tryParse(data["khaiGrade"] ?? "") ?? 0,
      datatime: data["dataTime"] ?? "",
    );
  }
}
