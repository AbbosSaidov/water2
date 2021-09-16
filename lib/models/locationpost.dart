import 'dart:convert';

LocationPost locationPostFromJson(String str) =>
    LocationPost.fromJson(json.decode(str));

String locationPostToJson(LocationPost data) => json.encode(data.toJson());

class LocationPost {
  LocationPost({
    this.auth,
    this.counterparty,
  });

  Auth auth;
  Counterparty counterparty;

  factory LocationPost.fromJson(Map<String, dynamic> json) => LocationPost(
        auth: Auth.fromJson(json["auth"]),
        counterparty: Counterparty.fromJson(json["counterparty"]),
      );

  Map<String, dynamic> toJson() => {
        "auth": auth.toJson(),
        "counterparty": counterparty.toJson(),
      };
}

class Auth {
  Auth({
    this.login,
    this.password,
  });

  String login;
  String password;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        login: json["login"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "password": password,
      };
}

class Counterparty {
  Counterparty({
    this.name,
    this.code,
    this.location,
  });

  String name;
  String code;
  String location;

  factory Counterparty.fromJson(Map<String, dynamic> json) => Counterparty(
        name: json["name"],
        code: json["code"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "location": location,
      };
}
