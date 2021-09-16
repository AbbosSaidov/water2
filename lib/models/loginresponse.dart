class LoginResponse{
  String login;
  String password;
  List<Districts> districts;

  LoginResponse({this.login, this.password, this.districts});

  LoginResponse.fromJson(Map<String, dynamic> json){
    login = json['login'];
    password = json['password'];
    if (json['districts'] != null) {
      districts = new List<Districts>();
      json['districts'].forEach((v) {
        districts.add(new Districts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    if (this.districts != null){
      data['districts'] = this.districts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  String district;

  Districts({this.district});

  Districts.fromJson(Map<String, dynamic> json) {
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['district'] = this.district;
    return data;
  }
}
