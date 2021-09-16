class CounterpartyResponse {
  List<CounterParties> counterparties;

  CounterpartyResponse({this.counterparties});

  CounterpartyResponse.fromJson(Map<String, dynamic> json) {
    if (json['counterparties'] != null) {
      counterparties = new List<CounterParties>();
      json['counterparties'].forEach((v) {
        counterparties.add(new CounterParties.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.counterparties != null) {
      data['counterparties'] =
          this.counterparties.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CounterParties {
  String name;
  String code;
  String adress;
  String disctrict;
  String primechanie;
  String type;
  String location;

  CounterParties({
    this.name,
    this.code,
    this.adress,
    this.disctrict,
    this.primechanie,
    this.location,
    this.type,
  });
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'code': code,
      'adress': adress,
      'disctrict': disctrict,
      'primechanie': primechanie,
      'type': type,
    };
  }

  CounterParties.fromJson(Map<String, dynamic> json){
    name = json['name'];
    code = json['code'];
    adress = json['adress'];
    disctrict = json['district'];
    primechanie = json['primechanie'];
    location = json['location'];
    type = json['type'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['adress'] = this.adress;
    data['district'] = this.disctrict;
    data['primechanie'] = this.primechanie;
    data['location'] = this.location;
    data['type'] = this.type;
    return data;
  }
}
