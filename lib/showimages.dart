import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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

class ShowImages extends StatefulWidget {

  @override
  _ShowImagesState createState() => _ShowImagesState();
}
class _ShowImagesState extends State<ShowImages> {

  bool asd=false;
  @override
  void initState(){
    super.initState();
    getImage2();
    sleep1();
  }

  Future sleep1() async {
    await Future.delayed(const Duration(seconds: 4), (){});
    asd=true;
    setState(() {

    });
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
        title: Center(child: Text('Images:')),
      ),
      body: asd ? ListView.builder(
        shrinkWrap: true,
        // physics: ClampingScrollPhysics(),
        //padding: const EdgeInsets.all(5),
        itemCount: fileaLL2.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            width: width,
            height: 200,
            child:PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.white),
              imageProvider: FileImage(fileaLL2[index]),
            ) ,
          );
        },
      ):Center(child: CircularProgressIndicator(),),
    );
  }

  List fileaLL = new List();
  List fileaLL2 = new List();
  Future getImage2()async{
    try {
      final folderName = "asdasd2";
      final path = Directory("storage/emulated/0/$folderName");
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if((await path.exists())){
        return path.path;
      }else{
        path.create();
        return path.path;
      }
     // the error because of this line
     // String filePath = '$directoryPath/${DateTime.now()}.jpg';
     // try {
     //   await _cameraController.takePicture(filePath);
     // } catch (e) {
     //   return null;
     // }
     // return File(filePath);

    }catch(Exception){
      print('error taking picture ${Exception.toString()}');
    }
  }


}
