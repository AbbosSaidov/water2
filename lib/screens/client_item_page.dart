import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water2/blocks/clientPage/bloc/clientpage_bloc.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:water2/service/clientPageRepository/clientpagerepository.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:water2/db_operation.dart';
import 'package:photo_view/photo_view.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:io' as io;
import '../models/counterpartyresponse.dart';
import 'summary_page.dart';

class ClientItemPage extends StatefulWidget {
  ClientItemPage({Key key, @required this.user}) : super(key: key);

  final CounterParties user;

  @override
  _ClientItemPageState createState() => _ClientItemPageState();
}
class _ClientItemPageState extends State<ClientItemPage> {
  bool im1=false;
  bool im2=false;
  bool im3=false;
  File _image1;
  File _image2;
  File _image3;

  Position _currentPosition;
  String _currentAddress;
//  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final TextEditingController _primechanie = new TextEditingController();
  String _primechaniyaText="Примечание";

  @override
  void initState(){
    super.initState();
    getImage2();
    getPrimechaniya();
  }

  Future<void> getPrimechaniya()async{
    SharedPreferences primechaniya1 = await SharedPreferences.getInstance();
   if(primechaniya1.containsKey("prim"+widget.user.code.toString())){
     _primechaniyaText = primechaniya1.getString("prim"+widget.user.code.toString());
     setState(() {});
   }
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
    return BlocProvider(
      create: (context) => ClientpageBloc(repository: ClientPageRepository()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(child: Text('Client:' + widget.user.name)),
          actions: <Widget>[
            Theme(
                data: Theme.of(context).copyWith(
                    accentColor: Colors.blue,
                    primaryColor: Colors.blue,
                    buttonTheme: ButtonThemeData(
                        highlightColor: Colors.blue,
                        buttonColor: Colors.blue,
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: Colors.blue,
                            primaryVariant: Colors.blue,
                            onBackground: Colors.blue),
                        textTheme: ButtonTextTheme.accent)),
                child:  BlocBuilder<ClientpageBloc, ClientpageState>(
                  builder: (context, state) {
                    print("st1="+state.runtimeType.toString());
                    if (state is ClientpageLoading) {
                      return Builder(
                        builder: (context) => CircularProgressIndicator(),
                      );
                    } else if (state is ClientpageLocationFailed){
                      return Center(
                        child: IconButton(
                          icon: Icon(Icons.repeat),
                          color: Colors.redAccent,
                          onPressed: () => {
                            if (_currentAddress != '')
                              {
                                BlocProvider.of<ClientpageBloc>(context).add(
                                    LocationAddPressed(
                                        locationURL: _currentAddress,
                                        user: widget.user))
                              }
                          },
                        ),
                      );
                    }
                    return Builder(
                      builder: (context) => IconButton(
                        onPressed: () async {
                          if(_primechanie.text.toString()!="null" && _primechanie.text.toString().length>0){
                            SharedPreferences savePrimecheniya = await SharedPreferences.getInstance();
                            savePrimecheniya.setString("prim"+widget.user.code.toString(),_primechanie.text.toString());
                          }
                            print('!!!SUCCES!!!' + _currentAddress.toString());
                            if (_currentAddress.toString() != '' &&_currentAddress.toString() != 'null'){
                              BlocProvider.of<ClientpageBloc>(context).add(
                                  LocationAddPressed(
                                      locationURL: _currentAddress,
                                      user: widget.user));
                            }else{
                              _showToast(context, 'Сохранено !', Colors.green);
                              await Future.delayed(const Duration(milliseconds: 100),(){});
                              Navigator.pop(context);
                            }

                        },
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),),
          ],
        ),
        body: BlocBuilder<ClientpageBloc, ClientpageState>(
          builder: (context, state){
            print("st="+state.runtimeType.toString());
            _blocProcess(state);
            if (state is ClientpageLoading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Container(
                padding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                constraints: BoxConstraints(
                  maxWidth: width,
                ),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: width / 5,
                              padding: EdgeInsets.all(5.0),
                              child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: "${widget.user.code}",
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                  )),
                            ),
                            Container(
                              width: width / 18,
                            ),
                            FlatButton(
                              onPressed: () async {
                          //      final List<DateTime> picked =
                          //      await DateRagePicker.showDatePicker(
                          //          context: context,
                          //          initialFirstDate: new DateTime(2020),
                          //          initialLastDate: (new DateTime.now())
                          //              .add(new Duration(days: 7)),
                          //          firstDate: new DateTime(2019),
                          //          lastDate: new DateTime(2023));
                          //      if (picked != null && picked.length == 2) {
                          //        onSearchDate(picked);
                          //      }

                                //  Navigator.of(context).push(
                                //      MaterialPageRoute(
                                //          builder: (context) =>
                                //              SummaryPage()))
                              },
                              color: Colors.blue,
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Сводка",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 4 * width / 5,
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: "${widget.user.name}",
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                        Container(
                          width: 4 * width / 5,
                          padding: EdgeInsets.all(5.0),
                          child: TextField(

                              enabled: false,
                              decoration: InputDecoration(
                                labelText: "${widget.user.adress}",
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                        Container(
                          width: 4 * width / 5,
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: "${widget.user.disctrict}",
                                suffixIcon: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      // value: dropdownValue,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 22,

                                      onChanged: (String newValue) {},
                                      items: <String>[
                                        'One',
                                        'Two',
                                        'Free',
                                        'Four'
                                      ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                    )),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                        // Container(
                        //   width: 4 * width / 5,
                        //   padding: EdgeInsets.all(5.0),
                        //   child: TextField(
                        //       decoration: InputDecoration(
                        //      labelText: "${widget.user.adress}",
                        //     suffixIcon: DropdownButtonHideUnderline(
                        //         child: DropdownButton<String>(
                        //       // value: dropdownValue,
                        //       icon: Icon(Icons.arrow_drop_down),
                        //       iconSize: 22,

                        //       onChanged: (String newValue) {
                        //         setState(() {
                        //           //   dropdownValue = newValue!;
                        //         });
                        //       },
                        //       items: <String>['One', 'Two', 'Free', 'Four']
                        //           .map<DropdownMenuItem<String>>((String value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: Text(value),
                        //         );
                        //       }).toList(),
                        //     )),
                        //     border: new OutlineInputBorder(
                        //       borderRadius: const BorderRadius.all(
                        //         const Radius.circular(10.0),
                        //       ),
                        //     ),
                        //     isDense: true,
                        //     contentPadding: EdgeInsets.all(10),
                        //   )),
                        // ),
                        Container(
                          width: 4 * width / 10,
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: "${widget.user.type}",
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                        Container(
                          width: 4 * width / 5,
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                              controller: _primechanie,
                              decoration: InputDecoration(
                                labelText: _primechaniyaText,
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_sharp,
                              color: Colors.blue,
                            ),
                            Container(
                              width: width / 40,
                            ),
                            Text("Геолокация"),
                            Container(
                              width: width / 40,
                            ),
                            FlatButton(
                              onPressed: () {
                                _showMyDialogLocation();
                              },
                              color: Colors.blue,
                              padding: EdgeInsets.all(6.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Добавить",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: width / 40,
                            ),
                            Flexible(
                              child: FlatButton(
                                onPressed: () {
                                  _launched = _launchInMap();

                                  //opens map
                                },
                                color: Colors.blue,
                                padding: EdgeInsets.all(6.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Открыт на карте",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        im1? Container(
                          width: width,
                          height: 200,
                          child:PhotoView(
                            backgroundDecoration: BoxDecoration(color: Colors.white),
                            imageProvider: FileImage(_image1),
                          ) ,
                        ):Container(),
                        im2?Container(
                          width: width,
                          height: 200,
                          child:PhotoView(
                            backgroundDecoration: BoxDecoration(color: Colors.white),
                            imageProvider: FileImage(_image2),
                          ) ,
                        ):Container(),
                        im3?Container(
                          width: width,
                          height: 200,
                          child:PhotoView(
                            backgroundDecoration: BoxDecoration(color: Colors.white),
                            imageProvider: FileImage(_image3),
                          ) ,
                        ):Container(),
                      ]),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showMyDialog,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }

  _blocProcess(ClientpageState state)async{
    if(state is ClientpageLocationAdded){
      await Future.delayed(const Duration(milliseconds: 500),(){});
      _showToast(context, 'Сохранено !', Colors.green);
      await Future.delayed(const Duration(milliseconds: 100),(){});
      Navigator.pop(context);
    } else if (state is ClientpageLocationFailed) {
      _showToast(context, 'Error', Colors.red);
    }
  }

  Future onSearchDate(var query) async {
    print(query[0]);
    print(query[1]);
    String beginSt = query[0].toString().substring(8, 10) +
        "." +
        query[0].toString().substring(5, 7) +
        "." +
        query[0].toString().substring(0, 4);
    String endSt = query[1].toString().substring(8, 10) +
        "." +
        query[1].toString().substring(5, 7) +
        "." +
        query[1].toString().substring(0, 4);
    print(beginSt);
    print(endSt);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SummaryPage(
                finishDate: endSt,
                startDate: beginSt,
                user: widget.user,
              )),
    );
  }

  void _getLocation() async {
   bool serviceEnabled;
   LocationPermission permission;

   // Test if location services are enabled.
   serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if (!serviceEnabled) {
     // Location services are not enabled don't continue
     // accessing the position and request users of the
     // App to enable the location services.
  //   return Future.error('Location services are disabled.');
   }

   permission = await Geolocator.checkPermission();
   if (permission == LocationPermission.denied) {
     permission = await Geolocator.requestPermission();
     if (permission == LocationPermission.deniedForever) {
       // Permissions are denied forever, handle appropriately.
       return Future.error(
           'Location permissions are permanently denied, we cannot request permissions.');
     }

     if (permission == LocationPermission.denied) {
       // Permissions are denied, next time you could try
       // requesting permissions again (this is also where
       // Android's shouldShowRequestPermissionRationale
       // returned true. According to Android guidelines
       // your App should show an explanatory UI now.
       return Future.error(
           'Location permissions are denied');
     }
   }

   // When we reach here, permissions are granted and we can
   // continue accessing the position of the device.
   _currentPosition = await Geolocator.getCurrentPosition();
   print("got location"+_currentPosition.longitude.toString());
  /* geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position){
      setState(() {
        print("got location"+position.longitude.toString());
        _currentPosition = position;
      });

    }).catchError((e) {
      print(e);
    });*/
 }

  void _showToast(BuildContext context, String text, Color color){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(text),
      ),
    );
  }
  List fileaLL = new List();
  Future getImage2()async{
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = appDocDir.path;
      print("codfe="+widget.user.code.toString());
      fileaLL = io.Directory("$path/").listSync();
      for(int i=0;i<fileaLL.length;i++){
        print("Files="+i.toString()+fileaLL[i].toString());
      }
  //    _image= File('$path/image2.png');
  //    im1= File('$path/image'+widget.user.code.toString()+'1.png').existsSync();
  //    im2= File('$path/image'+widget.user.code.toString()+'2.png').existsSync();
  //    im3= File('$path/image'+widget.user.code.toString()+'3.png').existsSync();
  //    print("st="+im1.toString());
  //    print("st2="+im2.toString());
  //    print("st3="+im3.toString());
  //    setState((){
  //      if(im1){
  //        _image1= File('$path/image'+widget.user.code.toString()+'1.png');
  //      }
  //      if(im2){
  //        _image2= File('$path/image'+widget.user.code.toString()+'2.png');
  //      }
  //      if(im3){
  //        _image3= File('$path/image'+widget.user.code.toString()+'3.png');
  //      }
  //    });
    }catch(Exception){
      print('error taking picture ${Exception.toString()}');
    }
  }

  String _imagepath;
  int xop=1;


  Future saveImage(bool df)async{
    try {
      ImagePicker picker = ImagePicker();
      await picker.getImage(source:df? ImageSource.gallery:ImageSource.camera).then((pickedFile) async {
        // getting a directory path for saving
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String path = appDocDir.path;
        print("path"+path.toString());

        if(im1 && im2 && im3){
          xop++;
        }

        if(!im1){
          _image1 = File(pickedFile.path);im1=true;
          await _image1.copy('$path/image'+widget.user.code.toString()+'1.png');
        }else if(!im2){
          _image2 = File(pickedFile.path);im2=true;
          await _image2.copy('$path/image'+widget.user.code.toString()+'2.png');
        }else if(!im3){
          _image3 = File(pickedFile.path);im3=true;
          await _image3.copy('$path/image'+widget.user.code.toString()+'3.png');
        }else if(xop==2){
          _image1 = File(pickedFile.path);im1=true;
          await _image1.copy('$path/image'+widget.user.code.toString()+'1.png');
        }else if(xop==3){
          _image2 = File(pickedFile.path);im2=true;
          await _image2.copy('$path/image'+widget.user.code.toString()+'2.png');
        }else if(xop==4){
          _image3 = File(pickedFile.path);im3=true;
          await _image3.copy('$path/image'+widget.user.code.toString()+'3.png');
          if(xop==4){xop=1;}
        }
   // copy the file to a new path
   //   final File newImage = await _image.copy('$path/image1.png');
        setState((){});
      });
    } catch (eror){
      print('error taking picture ${eror.toString()}');
    }
  }


  void SaveLocation() async {
    await _getLocation();
    SharedPreferences saveLocation = await SharedPreferences.getInstance();
    saveLocation.setString("${widget.user.code}",
        "https://www.google.com/maps/search/?api=1&query=${_currentPosition.latitude},${_currentPosition.longitude}");
    _currentAddress =
        "https://www.google.com/maps/search/?api=1&query=${_currentPosition.latitude},${_currentPosition.longitude}";
    _showToast(context, 'Геолокация добавлено!', Colors.green);
  }

  Future<void> _launched;

  Future<void> _launchInMap() async {
    SharedPreferences location = await SharedPreferences.getInstance();
    String url = location.getString("${widget.user.code}");
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Поставить фотографию'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(''),
                Text('Откуда хотите выбрать фотографию'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Снимать'),
              onPressed: () {
                saveImage(false);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Из галереи'),
              onPressed: () {
                saveImage(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showMyDialogLocation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Установить геолокацию'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(''),
                Text('Вы действительно хотите установить геолокацию?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Нет'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Да'),
              onPressed: () {
                SaveLocation();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
