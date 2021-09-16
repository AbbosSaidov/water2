class LoginRequest {
  Auth auth;

  LoginRequest({this.auth});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.auth != null) {
      data['auth'] = this.auth.toJson();
    }
    return data;
  }
}

class Auth {
  int id;
  String login;
  String password;
  int isLoginEnded;

  Auth({this.id,this.login,this.password, this.isLoginEnded});

  Auth.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    password = json['password'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
      'userName': login,
      'isLoginEnded': isLoginEnded,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    return data;
  }
}
