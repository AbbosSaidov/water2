import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water2/models/summaryResp.dart';
import 'package:water2/service/summaryRepository/summaryrepository.dart';

import '../models/counterpartyresponse.dart';

class SummaryPage extends StatefulWidget {
  final CounterParties user;
  final String startDate;
  final String finishDate;

  const SummaryPage({
    Key key,
    @required this.startDate,
    @required this.finishDate,
    @required this.user,
  }) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  SummaryRepository repository = SummaryRepository();
  List<Osnovum> list = List();
  int t=0;

  @override
  void initState() {
    _getSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(child: Text('Summary List')),
        ),
        body: FutureBuilder(
          future: repository.getSummary(
              widget.user, widget.startDate, widget.finishDate),
          builder: (context, snapshot) {
            print('SNAPSHOT DATA =${snapshot}');

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                ),
              );
            }
            final response = snapshot.data;
            t = num.parse(response.saldoNachalo.kolichestvo.toString());

            list = response.osnova;
            try {
              return Container(
                child: ListView(
                  children:[
                    Container(
                      color: Color.fromRGBO(0, 174, 255, 0.1),
                      child: Row(
                        //addColor
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 128,
                            width: 3 * width / 10,
                            // color: Colors.black12,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Дата",
                                textAlign: TextAlign.center,
                              ),
                            )),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.blue, width: 1),
                              ),
                            ),
                          ),
                         /* Container(
                            height: 128,
                            width: 4 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Движение",
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
                            height: 128,
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Количество",
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
                            height: 128,
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Возврат",
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
                            height: 128,
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Остаток",
                                textAlign: TextAlign.center,
                              ),
                            )),
                            decoration: BoxDecoration(
                              border: Border(
                                  // right: BorderSide(color: Colors.blue, width: 1),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.blue,
                    ),//line
                    Container(
                      color: Color.fromRGBO(0, 174, 255, 0.1),
                      child: Row(
                        //addColor
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 64,
                            width: 3 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Салдо на начало",
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    response.saldoNachalo.kolichestvo
                                        .toString(),
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                response.saldoNachalo.vozvratTari.toString(),
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                (num.parse(response.saldoNachalo.kolichestvo.toString())-num.parse(response.saldoNachalo.vozvratTari.toString())).toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            decoration: BoxDecoration(
                              border: Border(
                                  // right: BorderSide(color: Colors.blue, width: 1),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.blue,
                    ),//line
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        t=t+num.parse(list[index].kolichestvo.toString())-num.parse(list[index].vozvratTari.toString());
                        print("t="+t.toString());
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 64,
                                  width: 3*width / 10,
                                  // color: Colors.black12,
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      list[index].data,
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
                                  width: 2 * width / 10,
                                  //   color: Colors.purple,
                                  child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          list[index].kolichestvo
                                              .toString(),
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
                                  width: 2 * width / 10,
                                  //   color: Colors.purple,
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      list[index].vozvratTari.toString(),
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
                                  width: 2 * width / 10,
                                  //   color: Colors.purple,
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                        (t).toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        // right: BorderSide(color: Colors.blue, width: 1),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: Colors.blue,
                            )
                          ],
                        );
                      },
                    ),
                    Container(
                      color: Color.fromRGBO(0, 174, 255, 0.1),
                      child: Row(
                        //addColor
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 64,
                            width: 3 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Итого",
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    response.itog.kolichestvo.toString(),
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                response.itog.vozvratTari.toString(),
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                (num.parse(response.itog.kolichestvo.toString())-num.parse(response.itog.vozvratTari.toString())).toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            decoration: BoxDecoration(
                              border: Border(
                                  // right: BorderSide(color: Colors.blue, width: 1),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.blue,
                    ),//line
                    Container(
                      color: Color.fromRGBO(0, 174, 255, 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 64,
                            width: 3 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Салдо на конец",
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    response.saldoKonets.kolichestvo.toString(),
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                response.saldoKonets.vozvratTari.toString(),
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
                            width: 2 * width / 10,
                            //   color: Colors.purple,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                (num.parse(response.saldoKonets.kolichestvo.toString())-num.parse(response.saldoKonets.vozvratTari.toString())).toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            decoration: BoxDecoration(
                              border: Border(
                                  // right: BorderSide(color: Colors.blue, width: 1),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } catch (err) {
              return Center(child: Text('$err'));
            }
          },
        ));
  }

  _getSummary() async {}
}
