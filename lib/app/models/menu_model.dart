class MenuModel {
  MenuModel({
    this.aboutUs,
    this.ooruuJalpy,
    this.toyutJalpy,
    this.uruktandyruuJalpy,
    this.bodomal,
    this.koiEchki,
    this.took,
    this.jylky,
  });
  factory MenuModel.fromJson(Map<String, Object> json) {
    return MenuModel(
      aboutUs: json['aboutUs'] as String,
      ooruuJalpy: json['ooruuJalpy'] as String,
      toyutJalpy: json['toyutJalpy'] as String,
      uruktandyruuJalpy: json['uruktandyruuJalpy'] as String,
      bodomal: json['bodomal'] as List,
      koiEchki: json['koiEchki'] as List,
      took: json['took'] as List,
      jylky: json['jylky'] as List,
    );
  }
  final String? aboutUs;
  final String? ooruuJalpy;
  final String? toyutJalpy;
  final String? uruktandyruuJalpy;
  final List? bodomal;
  final List? koiEchki;
  final List? took;
  final List? jylky;

  Map<String, Object> toJson() {
    return {
      'aboutUs': aboutUs!,
      'ooruuJalpy': ooruuJalpy!,
      'toyutJalpy': toyutJalpy!,
      'uruktandyruuJalpy': uruktandyruuJalpy!,
      'bodomal': bodomal!,
      'koiEchki': koiEchki!,
      'took': took!,
      'jylky': jylky!,
    };
  }
}
