import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water2/db_operation.dart';
import 'package:water2/screens/clients_page.dart';
import 'package:water2/service/const.dart';

class SettingsPage extends StatelessWidget {
  final TextEditingController _ip =
      new TextEditingController(text: LOGINBASEURL);

  final TextEditingController _baseLogin =
      new TextEditingController(text: BASELOGIN);

  final TextEditingController _basepaswword =
      new TextEditingController(text: BASEPASSWORD);
  DbOperation db = new DbOperation();

  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
              constraints: BoxConstraints(
                maxWidth: 500,
              ),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(""),
                      TextField(
                          controller: _baseLogin,
                          decoration:
                              InputDecoration(labelText: "base auth login")),
                      TextField(
                          controller: _basepaswword,
                          decoration:
                              InputDecoration(labelText: "base auth password")),
                      TextField(
                          controller: _ip,
                          decoration:
                              InputDecoration(labelText: "Server adress")),
                      RaisedButton(
                          color: Colors.blue,
                          child: Text("Изменить",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (_ip.text.isNotEmpty) {
                              _setNewIPAdress(_ip.text, _baseLogin.text,
                                  _basepaswword.text);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ClientsPage()));
                            }
                          })
                    ]),
              )),
        ));
  }

  _setNewIPAdress(String ip, String login, String password) async {
    var db1 = await db.openDb();
    await db.deleteAuth(db1);
    SharedPreferences saveLocation = await SharedPreferences.getInstance();
    saveLocation.setString("IPADRESS", ip);
    saveLocation.setString("BASELOGIN", login);
    saveLocation.setString("BASEPASSWORD", password);
    LOGINBASEURL = ip;
    BASELOGIN = login;
    BASEPASSWORD = password;
  }
}
