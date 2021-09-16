import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:water2/models/counterpartyresponse.dart';
import 'package:water2/models/loginrequest.dart';
import 'package:water2/service/clientsListRepository/clientListRepository.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water2/service/const.dart';
import 'package:water2/service/repositories/login_repository.dart';

import '../../models/counterpartyresponse.dart';
import 'package:water2/db_operation.dart';

part 'clients_list_event.dart';

part 'clients_list_state.dart';

class ClientsListBloc extends Bloc<ClientsListEvent, ClientsListState> {
  final ClientListRepository repository;
  final LoginRepository repositoryLogin;
  DbOperation db = new DbOperation();

  final TextEditingController searchQueryController= TextEditingController();
  String searchQuery = "Search query";
  String searchQueryCategory = "Наименование";
  List<CounterParties> response=[];
  ClientsListBloc({@required this.repository,this.searchQueryCategory,this.repositoryLogin}) : super(ClientsListInitial());

  @override
  Stream<ClientsListState> mapEventToState(
      ClientsListEvent event,
      )async*{
    if(event is LoginSuccessfullyPassed){
      yield* _gettingDataFromBase(event, event.request);
    }else if(event is StartSearch){
      yield* _startingSearch(event);
    }else if(event is ExitSearch){
      yield* _exitingSearch(event);
    }else if(event is ChangingCategory){
      yield* _changingCategorySearch(event,event.newCategory);
    }else if(event is ChangingCategoryFin){
      yield* _changingCategorySearchFin(event);
    }else if(event is ChangingSearch){
      yield* _changingItemSearch(event,event.newSearch);
    }else if(event is ChangingSearchFin){
      yield* _changingItemSearchFin(event,event.newSearch);
    }else if(event is ListLoading){
      yield* _startingListLoad(event);
    }
  }

  Stream<ClientsListState> _gettingDataFromBase(
      LoginSuccessfullyPassed event, LoginRequest request) async* {

    var connectivityResult = await (Connectivity().checkConnectivity());
    bool connected=false;
    if (connectivityResult == ConnectivityResult.mobile) {
      connected=true;
      print('I am connected to a mobile network.');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      connected=true;
      print('I am connected to a wifi network.');
    }
    try {
    if(connected){
      print('connected');

        await repositoryLogin.getResult(LoginRequest(
            auth: Auth(
                login: LOGIN,
                password: PASSWORD
                    )));
        CounterpartyResponse result = await repository.getResult(request);
        var mainResult = result.counterparties;
    /*     var fido1 = new CounterParties(
          name: "name",
          code: "134",
          adress: "adressdfs",
          disctrict: "distict",
          primechanie: "primechanie",
          type: "type",
          location: "https://www.google.com/mapsasd"
        );
        mainResult.add(fido1);
        print("l="+mainResult.length.toString());*/



        if(mainResult!=null && mainResult.length>0){


          SharedPreferences saveLocation = await SharedPreferences.getInstance();
          var db1 = await db.openDbCounterParties();
         // await db.deleteCounterParties(db1);
          int l =mainResult.length;
          print("l2="+l.toString());
          for(int i=0;i<l;i++){


       //     print("l="+i.toString()+mainResult[i].primechanie.toString());
            var fido = new CounterParties(
              name: mainResult[i].name,
              code: mainResult[i].code,
              adress: mainResult[i].adress,
              disctrict: mainResult[i].disctrict,
              primechanie: mainResult[i].primechanie,
              type: mainResult[i].type,
            );
            if(saveLocation.containsKey(mainResult[i].code.toString())){
              await db.updateCounterParties(fido,mainResult[i].code.toString(),db1);
            }else{
              await db.insertCounterParties(fido,db1);
            }
            if(mainResult[i].location.toString()!="null" && mainResult[i].location.toString().length>27 &&
                mainResult[i].location.toString().substring(0,27)=="https://www.google.com/maps"){
              saveLocation.setString(mainResult[i].code.toString(),mainResult[i].location.toString());
            }
          }
        }

      }
    print('not connected');

    int x = 0;
    var db1 = await db.openDbCounterParties();
    var db2 = await db.CounterPartiess(db1);
    List<CounterParties> searchResult =[];

    if(db2 != null && db2.length>0){
      x= 1;
      for(int i=0;i<db2.length;i++){
        searchResult.add(db2[i]);
    /*    if(i==100){
          i=db2.length;
        }*/
      }
    }

    List<CounterParties> searchResult2 =[];
    SharedPreferences primechaniya1 = await SharedPreferences.getInstance();
    if(primechaniya1.containsKey("rayonLength")){
      int lengthofDistrict=primechaniya1.getInt("rayonLength");
      for(int i=0;i<searchResult.length;i++){
        for(int t=0;t<lengthofDistrict;t++){
         // print("q1="+searchResult[i].toJson()["district"].toLowerCase()+"=="+primechaniya1.getString("rayon"+t.toString()));
          if (searchResult[i].toJson()["district"].toLowerCase().contains(primechaniya1.getString("rayon"+t.toString()).toLowerCase())){
            searchResult2.add(searchResult[i]);
         // print("q2");
         // print("df="+searchResult[0].adress);
          }
        }
      }
    }

    if(x==1){
      response = searchResult2;
      yield ClientsListLoaded(response: searchResult2);
    }else{
      yield ClientsListLoaded(response: searchResult2);
    }
    }catch(err){
      print('ERROR IS === $err');
      yield ClientsListLoadingFailed();
    }
  }

  Stream<ClientsListState> _startingSearch(
      StartSearch event) async* {
    yield  Searching(searchQueryCategory:"Наименование",response:this.response);
  }
  Stream<ClientsListState> _startingListLoad(
      ListLoading event) async* {
    yield  ClientsListLoading();
  }
  Stream<ClientsListState> _exitingSearch(
      ExitSearch event) async* {
    yield  ExitedSearching(this.response);
  }
  Stream<ClientsListState> _changingCategorySearch(
      ChangingCategory event,String newCateg)async*{
    this.searchQueryCategory=newCateg;
    yield  CategoryHasChanged(newCateg,this.response);
  }
  Stream<ClientsListState> _changingCategorySearchFin(
      ChangingCategoryFin event)async*{
    yield  CategoryHasChangedFin(this.searchQueryCategory,this.response);
  }
  Stream<ClientsListState> _changingItemSearch(
      ChangingSearch event,String newSearch)async*{
    List<CounterParties> searchResult =[];
    String e="";
    switch(searchQueryCategory){
      case "Наименование" : e ="name" ;break;
      case "Код" : e ="code" ;break;
      case "Адрес" : e ="adress" ;break;
      case "Район" : e ="district" ;break;
      case "Тип контрагента" : e ="type" ;break;
    }
    newSearch=newSearch.replaceAll(new RegExp(r"\s\b|\b\s"), "").toLowerCase();
    print("se=$searchQueryCategory"+"e=$e"+newSearch);

    print("dfddd1="+response[1].toJson()[e].replaceAll(new RegExp(r"\s\b|\b\s"), "").toString().toLowerCase());
    print("dfddd21="+response[1].toJson()[e].replaceAll(new RegExp(r"\s\b|\b\s"), "").toLowerCase().length.toString());

    int len=newSearch.length;
    print("dfddd2="+len.toString());
    for(int i=0;i<response.length;i++){
      String dbResult=response[i].toJson()[e].toString().replaceAll(new RegExp(r"\s\b|\b\s"), "");

      if (len <= dbResult.length &&
          dbResult.contains(newSearch)){
        searchResult.add(response[i]);
        print("df="+dbResult);
      }
    }
    yield  SearchHasChanged(this.searchQueryCategory,searchResult);
  }
  Stream<ClientsListState> _changingItemSearchFin(
      ChangingSearchFin event,String newSearch)async*{
    List<CounterParties> searchResult =[];
    String e="";
    switch(searchQueryCategory){
      case "Наименование" : e ="name" ;break;
      case "Код" : e ="code" ;break;
      case "Адрес" : e ="adress" ;break;
      case "Район" : e ="district" ;break;
      case "Тип контрагента" : e ="type" ;break;
    }
    newSearch=newSearch.replaceAll(new RegExp(r"\s\b|\b\s"), "").toLowerCase();
    print("se=$searchQueryCategory"+"e=$e"+newSearch);

    print("dfddd1="+response[1].toJson()[e].replaceAll(new RegExp(r"\s\b|\b\s"), "").toString().toLowerCase());
    print("dfddd21="+response[1].toJson()[e].replaceAll(new RegExp(r"\s\b|\b\s"), "").toLowerCase().length.toString());

    int len=newSearch.length;
    print("dfddd2="+len.toString());
    for(int i=0;i<response.length;i++){
      String dbResult=response[i].toJson()[e].toString().replaceAll(new RegExp(r"\s\b|\b\s"), "");

      if (len <= dbResult.length &&
          dbResult.contains(newSearch)){
        searchResult.add(response[i]);
        print("df="+dbResult);
      }
    }
    yield  SearchHasChangedFin(this.searchQueryCategory,searchResult);
  }

}