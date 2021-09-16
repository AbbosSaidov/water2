class SummaryReq {
  Auth auth;
  Counterparty counterparty;
  String dateN;
  String dateK;

  SummaryReq({this.auth, this.counterparty, this.dateN, this.dateK});

  SummaryReq.fromJson(Map<String, dynamic> json) {
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
    counterparty = json['counterparty'] != null
        ? new Counterparty.fromJson(json['counterparty'])
        : null;
    dateN = json['dateN'];
    dateK = json['dateK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.auth != null) {
      data['auth'] = this.auth.toJson();
    }
    if (this.counterparty != null) {
      data['counterparty'] = this.counterparty.toJson();
    }
    data['dateN'] = this.dateN;
    data['dateK'] = this.dateK;
    return data;
  }
}

class Auth {
  String login;
  String password;

  Auth({this.login, this.password});

  Auth.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    return data;
  }
}

class Counterparty {
  String name;
  String code;

  Counterparty({this.name, this.code});

  Counterparty.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}
