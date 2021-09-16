import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water2/blocks/login/bloc/login_bloc.dart';
import 'package:water2/models/loginrequest.dart';
import 'package:water2/screens/clients_page.dart';
import 'package:water2/service/const.dart';

import 'package:water2/service/repositories/login_repository.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final TextEditingController _login = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  @override
  void initState(){
    super.initState();
    _checkIPAdress();
  }

  @override
  void dispose(){
    super.dispose();
    _login.dispose();
    _password.dispose();
  }

  @override
  Widget build(context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return BlocProvider(
      create: (context) => LoginBloc(repository: LoginRepository()),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 25,
                ),
                onPressed: () {},
              )
            ],
          ),
          body: BlocProvider(
            create: (context) => LoginBloc(repository: LoginRepository()),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginInitial) {
                  BlocProvider.of<LoginBloc>(context).add(IsLoginnedBefore());
                }
                _loginProcess(state, context);
                return state is LoginLoading ||
                        state is LoginLoaded ||
                        state is Loginned
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 25.0),
                            constraints: BoxConstraints(
                              maxWidth: 500,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset('assets/images/icon1.jpg'),
                                    TextField(
                                        controller: _login,
                                        decoration: InputDecoration(
                                            labelText: "username")),
                                    TextField(
                                        controller: _password,
                                        //   obscureText: true,
                                        decoration: InputDecoration(
                                            labelText: "password")),
                                    RaisedButton(
                                        color: Colors.blue,
                                        child: Text("Log in",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed:(){
                                          if (_login.text.isNotEmpty &&
                                              _password.text.isNotEmpty){
                                            BlocProvider.of<LoginBloc>(context).add(
                                                LoginPressed(
                                                    request: LoginRequest(
                                                        auth: Auth(
                                                            login: _login.text,
                                                            password: _password
                                                                .text))));
                                          }else{
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                content: Text(
                                                    'Maydonlarni to`ldiring!'),
                                                duration:
                                                    Duration(milliseconds: 500),
                                              ),
                                            );
                                          }
                                        })
                                  ]),
                            )),
                      );
              },
            ),
          )),
    );
  }

  _loginProcess(LoginState state, var context)async{
    if (state is LoginLoaded || state is Loginned){
        await Future.delayed(const Duration(milliseconds: 500), () {})
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientsPage()),
        );
      });
    }else if(state is LoginFailed){
      BuildContext con = context;
      this._showToast(con);
    }
  }

  _checkIPAdress()async{
    SharedPreferences saveLocation = await SharedPreferences.getInstance();
   if(saveLocation.containsKey("IPADRESS")){
     String IP = saveLocation.get('IPADRESS');
     LOGINBASEURL = IP;
     print('BASEURLIS ==========${LOGINBASEURL}');
   }
   if(saveLocation.containsKey("BASELOGIN")){
     String IP = saveLocation.get('BASELOGIN');
     BASELOGIN = IP;
     print('BASEURLIS ==========${LOGINBASEURL}');
   }
   if(saveLocation.containsKey("BASEPASSWORD")){
     String IP = saveLocation.get('BASEPASSWORD');
     BASEPASSWORD = IP;
     print('BASEURLIS ==========${LOGINBASEURL}');
   }

  }

  void _showToast(BuildContext context){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: const Text('Kirishda xatolik!'),
      ),
    );
  }
}
