// To parse this JSON data, do
//
//     final summResp = summRespFromJson(jsonString);

import 'dart:convert';

SummResp summRespFromJson(String str) => SummResp.fromJson(json.decode(str));

String summRespToJson(SummResp data) => json.encode(data.toJson());

class SummResp {
  SummResp({
    this.saldoNachalo,
    this.osnova,
    this.itog,
    this.saldoKonets,
  });

  Itog saldoNachalo;
  List<Osnovum> osnova;
  Itog itog;
  Itog saldoKonets;

  factory SummResp.fromJson(Map<String, dynamic> json) => SummResp(
        saldoNachalo: Itog.fromJson(json["saldo_nachalo"]),
        osnova:
            List<Osnovum>.from(json["osnova"].map((x) => Osnovum.fromJson(x))),
        itog: Itog.fromJson(json["itog"]),
        saldoKonets: Itog.fromJson(json["saldo_konets"]),
      );

  Map<String, dynamic> toJson() => {
        "saldo_nachalo": saldoNachalo.toJson(),
        "osnova": List<dynamic>.from(osnova.map((x) => x.toJson())),
        "itog": itog.toJson(),
        "saldo_konets": saldoKonets.toJson(),
      };
}

class Itog {
  Itog({
    this.kolichestvo,
    this.summa,
    this.vozvratTari,
    this.oplata,
  });

  int kolichestvo;
  int summa;
  int vozvratTari;
  int oplata;

  factory Itog.fromJson(Map<String, dynamic> json) => Itog(
        kolichestvo: json["kolichestvo"],
        summa: json["summa"],
        vozvratTari: json["vozvrat_tari"],
        oplata: json["oplata"],
      );

  Map<String, dynamic> toJson() => {
        "kolichestvo": kolichestvo,
        "summa": summa,
        "vozvrat_tari": vozvratTari,
        "oplata": oplata,
      };
}

class Osnovum {
  Osnovum({
    this.data,
    this.dvijenie,
    this.kolichestvo,
    this.summa,
    this.vozvratTari,
    this.oplata,
  });

  String data;
  String dvijenie;
  int kolichestvo;
  int summa;
  int vozvratTari;
  int oplata;

  factory Osnovum.fromJson(Map<String, dynamic> json) => Osnovum(
        data: json["data"],
        dvijenie: json["dvijenie"],
        kolichestvo: json["kolichestvo"],
        summa: json["summa"],
        vozvratTari: json["vozvrat_tari"],
        oplata: json["oplata"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "dvijenie": dvijenie,
        "kolichestvo": kolichestvo,
        "summa": summa,
        "vozvrat_tari": vozvratTari,
        "oplata": oplata,
      };
}
