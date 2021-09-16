import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water2/models/counterpartyresponse.dart';
import 'package:water2/screens/client_item_page.dart';
import 'package:water2/screens/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water2/blocks/clientsList/clients_list_bloc.dart';
import 'package:water2/service/clientsListRepository/clientListRepository.dart';
import 'package:water2/service/repositories/login_repository.dart';
import 'package:water2/models/loginrequest.dart';
import 'package:water2/screens/login_page.dart';
import 'package:water2/db_operation.dart';
import 'package:water2/service/const.dart';

import '../blocks/clientsList/clients_list_bloc.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientsPage> {
  DbOperation db = new DbOperation();
  int scrollL=1;
  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return BlocProvider(
     create: (context) => ClientsListBloc(
          repository: ClientListRepository(),
          repositoryLogin:LoginRepository() ,
          searchQueryCategory: "Наименование"),
      child: BlocBuilder<ClientsListBloc, ClientsListState>(
          builder: (context, state){

            print("EEEEE" + state.runtimeType.toString());
            if ((state is CategoryHasChanged)) {
              BlocProvider.of<ClientsListBloc>(context)
                  .add(ChangingCategoryFin());
            }

            return Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size(double.infinity, kToolbarHeight),
                child:AppBar(
                  backgroundColor: Colors.blue,
                  leading: (state is Searching) ? const BackButton() : null,
                  title: (state is Searching)
                      ? _buildSearchField(state, context)
                      : Center(child: Text('Client List')),
                  actions: _buildActions(context, state),
                )),
            body: BlocBuilder<ClientsListBloc, ClientsListState>(
              builder: (context, state){
                if (state is ClientsListInitial){
                  BlocProvider.of<ClientsListBloc>(context).add(
                      ListLoading());
                }
                if (state is ClientsListLoading) {
                  scrollL=1;
                  print("qwwwwwwwww" + state.runtimeType.toString());
                  print("qwwwwwwwwwLogin" + LOGIN.toString());
                  BlocProvider.of<ClientsListBloc>(context).add(
                      LoginSuccessfullyPassed(
                          request: LoginRequest(
                              auth: Auth(
                                  login: LOGIN, password: PASSWORD))));
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                if (state is ClientsListLoaded || state is ExitedSearching){
                  var counterParties;
                  if (state is ClientsListLoaded) {
                    counterParties = state.response;
                  } else if (state is ExitedSearching) {
                    counterParties = state.response;
                  }
                  return _listViewOfCounters(counterParties,width);
                }
                else if (state is CategoryHasChanged || state is Searching ||  state is CategoryHasChangedFin){
                  var counterParties;
                  if (state is CategoryHasChanged) {
                    counterParties = state.response;
                  } else if (state is Searching) {
                    counterParties = state.response;
                  } else if (state is SearchHasChanged) {
                    counterParties = state.response;
                  } else if (state is SearchHasChangedFin) {
                    counterParties = state.response;
                  }
                  print("sta=" + state.runtimeType.toString() +
                      counterParties.toString());
                  return _listViewOfCounters(counterParties,width);
                }else{
                  print("qwgggwww" + state.runtimeType.toString());
                  return Center(
                    child: Text("Network problem"),
                  );
                }
              },
            ),
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    //
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Список клиентов',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('Настройки'),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SettingsPage()));
                    },
                  ),
                  ListTile(
                    title: Text('Выход'),
                    onTap: () async {
                      var db1 = await db.openDb();
                      await db.deleteAuth(db1);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );}),
    );
  }
  Widget _listViewOfCounters(var counterParties,var width ){

    print("scr="+scrollL.toString());
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        var metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          if (metrics.pixels == 0){
            print('At top');
            scrollL=1;
            setState((){});
          }
          else{
            scrollL=scrollL+1;
            print('At bottom');
            setState((){});
          }
        }
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
       // physics: ClampingScrollPhysics(),
        //padding: const EdgeInsets.all(5),
        itemCount: counterParties == null ? 0 : counterParties.length+1>scrollL*30? scrollL*30 : counterParties.length+1,
        itemBuilder: (BuildContext context, int index){
          return index==0? Container(
            color: Color.fromRGBO(0, 174, 255, 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 64,
                  width: width / 4,
                  //  color: Colors.purple,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Наимевоние",
                          textAlign: TextAlign.center,
                        ),
                      )),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
                Container(
                  height: 64,
                  width: width / 8,
                  //  color: Colors.purple,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Код",
                          textAlign: TextAlign.center,
                        ),
                      )),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
                Container(
                  height: 64,
                  width: width / 4,
                  //  color: Colors.purple,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Адрес",
                          textAlign: TextAlign.center,
                        ),
                      )),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
                Container(
                  height: 64,
                  width: width / 8,
                  //  color: Colors.purple,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Район",
                          textAlign: TextAlign.center,
                        ),
                      )),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
                /*  Container(
                        height: 64,
                        width: width / 5,
                        //  color: Colors.purple,
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Примечание",
                            textAlign: TextAlign.center,
                          ),
                        )),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.blue, width: 1),
                          ),
                        ),
                      ),*/
                Container(
                  height: 64,
                  width: width / 7,
                  //  color: Colors.purple,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Тип контрагента",
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ],
            ),
          ):
          index==scrollL*30-1 && scrollL*30-1<counterParties.length ? Center(child: CircularProgressIndicator(),) : Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ClientItemPage(
                        user: counterParties[index-1],
                      )));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 64,
                        width: width / 4,
                        //  color: Colors.purple,
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                counterParties[index-1].toJson()['name'],
                                textAlign: TextAlign.center,
                              ),
                            )),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 64,
                        width: width / 8,
                        //  color: Colors.purple,
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                counterParties[index-1].toJson()['code'],
                                textAlign: TextAlign.center,
                              ),
                            )),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 64,
                        width: width / 4,
                        //  color: Colors.purple,
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                counterParties[index-1].toJson()['adress'],
                                textAlign: TextAlign.center,
                              ),
                            )),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 64,
                        width: width / 8,
                        //  color: Colors.purple,
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                counterParties[index-1]
                                    .toJson()['district'],
                                textAlign: TextAlign.center,
                              ),
                            )),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                      /*    Container(
                                  height: 64,
                                  width: width / 5,
                                  //  color: Colors.purple,
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      counterParties[index].toJson()['primechanie'],
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          color: Colors.blue, width: 1),
                                    ),
                                  ),
                                ),*/
                      Container(
                        height: 64,
                        width: width / 7,
                        //  color: Colors.purple,
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                counterParties[index-1].toJson()['type'],
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Colors.blue,
              )
            ],
          );
        },
      ),
    );
  }
  Widget _buildSearchField(ClientsListState state, var context) {
    return TextField(
      controller: (state is Searching) ? state.searchQueryController : null,
      // autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query, state, context),
    );
  }

  List<Widget> _buildActions(var context, var stat) {
    ClientsListBloc clientsListBloc = BlocProvider.of<ClientsListBloc>(context);
    ClientsListState state = stat;
    if ((state is Searching)){
      return <Widget>[
        Row(
          children: [
            Text(
              state.searchQueryCategory.toString(),
              style: TextStyle(fontSize: 17),
            ),
            DropdownButtonHideUnderline(
                child: Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14),
                    child: DropdownButton<String>(
                      // value: dropdownValue,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: 24,

                      onChanged: (String newValue) {
                        print("Cat changed");
                        clientsListBloc
                            .add(ChangingCategory(newCategory: newValue));
                      },
                      items: <String>[
                        'Наименование',
                        'Код',
                        'Адрес',
                        'Район',
                        'Тип контрагента',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ))),
          ],
        )
      ];
    }
    //fghfgh
    return <Widget>[
      IconButton(
          icon: const Icon(Icons.update_rounded),
          onPressed: () {
            BlocProvider.of<ClientsListBloc>(context).add(
                ListLoading());
          }),
      IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            ModalRoute.of(context)
                .addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {
              clientsListBloc.add(ExitSearch());
            }));
            clientsListBloc.add(StartSearch());
          }),
    ];
  }

  void updateSearchQuery(String newQuery, ClientsListState state, var context){
    print("asd=$newQuery");
    print("asdsa=" + state.runtimeType.toString());
    ClientsListBloc clientsListBloc = BlocProvider.of<ClientsListBloc>(context);
    if (state is SearchHasChangedFin) {
      clientsListBloc.add(ChangingSearch(newSearch: newQuery));
    } else if (state is SearchHasChanged) {
      clientsListBloc.add(ChangingSearchFin(newSearch: newQuery));
    } else if (state is Searching) {
      clientsListBloc.add(ChangingSearchFin(newSearch: newQuery));
    }
  }

}
