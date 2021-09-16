import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:water2/models/loginrequest.dart';
import 'package:water2/models/loginresponse.dart';
import 'package:water2/service/repositories/login_repository.dart';
import 'package:water2/db_operation.dart';
import 'package:water2/service/const.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  DbOperation db = new DbOperation();

  final LoginRepository repository;

  LoginBloc({
    @required this.repository,
  }) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginPressed) {
      yield* _loginProcess(event, event.request);
    } else if (event is IsLoginnedBefore) {
      yield* _checkDbForLogin(event);
    }
  }

  Stream<LoginState> _loginProcess(
      LoginPressed event, LoginRequest request) async* {
    yield LoginLoading();
    try {
      LoginResponse response = await repository.getResult(request);
      LOGIN=response.login;
      PASSWORD=response.password;

      db.openDb().then((onValue1){
        var fido = new Auth(
          id: 1,
          password: response.password,
          login: response.login,
          isLoginEnded: 1,
        );
        db.insertAuth(fido, onValue1);
      });
      yield LoginLoaded(response: response);
    } catch (err) {
      print('ERROR IS ====$err');
      yield LoginFailed();
    }
  }

  Stream<LoginState> _checkDbForLogin(IsLoginnedBefore event)async*{
    try{
      int x = 0;
      var db1 = await db.openDb();
      var db2 = await db.auths(db1);
      if(db2 != null && db2.length > 0){
        print("log="+db2[0].login.toString());
        print("pass="+db2[0].password.toString());
        print("ende="+db2[0].isLoginEnded.toString());
        LOGIN=db2[0].login;
        PASSWORD=db2[0].password;
        if(db2[0].isLoginEnded == 1){
          x = 1;
        }
      }
      if(x == 1){
        yield Loginned();
      }
    }catch(err){
      print('ERROR IS ====$err');
    }
  }
}
