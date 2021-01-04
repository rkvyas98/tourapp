import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:typed_data';

import 'package:tour_app/places.dart';

class ImageSearch extends StatefulWidget {
  static const String id = 'Image';
  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: const Text('TourApp : Image Search'),
      ),
      body: _loading
          ? Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
      : Container(
        color: Colors.black87,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Container(
              child: Center(
                child: Text('Click the button bellow to select image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.023,
                  ),
                ),
              ),
            ) : Flexible(child: Image.file(_image)),
            SizedBox(
              height: 20,
            ),
            _outputs != null && _outputs.length>0 && _outputs[0]['confidence']>0.90
                ?  Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white70,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
                  child: FlatButton(
              onPressed:() {
                  String link=redirect(_outputs[0]['label'].toString().substring(2));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Places(link: link)));
                  },
              child: Column(
                  children: [
                    Text(_outputs[0]['label'].toString().substring(2),style: TextStyle(color: Colors.white),),
                    Text((_outputs[0]['confidence']*100).toString(),style: TextStyle(color: Colors.white),)
                  ],
              ),
            ),
                )
                : _image != null ? Container(
              child: Text('No result',style: TextStyle(color: Colors.white),),
            ) :  Container(
              child: Text('',style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        animationSpeed: 200,
        curve: Curves.bounceInOut,
        overlayColor: Colors.black54,
        animatedIcon: AnimatedIcons.ellipsis_search,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: Icon(Icons.image),
            label: 'Pick from gallery',
            onTap: pickImage,
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: Icon(Icons.add_a_photo),
            label: 'Scan from camera',
            onTap: pickImageCamera,
          ),
        ],
      ),

    );
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,
        maxHeight:MediaQuery
            .of(context)
            .size
            .height * 0.6,
        maxWidth: MediaQuery
            .of(context)
            .size
            .width * 0.95);
    if (image == null) return null;
    var imagine = img.decodeImage(File(image.path).readAsBytesSync());
    img.Image thumbnail = img.copyResize(imagine, width: 225,height: 225);
   // File('thumbnail.png')..writeAsBytesSync(img.encodePng(thumbnail));

    setState(() {
      _loading = true;
      _image = image;
    });
    print(image.absolute);
   // recognizeImageBinary(image);
    classifyImage(image);
  }
  pickImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 225, maxWidth: 225);
    if (image == null) return null;

    setState(() {
      _loading = true;
      _image = image;
    });
    // recognizeImageBinary(image);
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    //print(image.path);
    setState(() {
      _loading = false;
      _outputs = output;
    });
    print(_outputs);
  }

  String redirect(String name){
    switch(name){
      case 'TAJ MAHAL': return 'place1';
      break;
      case 'STATUE OF LIBERTY':return 'place5';
      break;
      case 'STATUE OF UNITY':return 'place6';
      break;
      case 'EIFFEL TOWER':return 'place2';
      break;
      case 'ATLANTIS HOTEL':return 'place4';
      break;
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/tour.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
