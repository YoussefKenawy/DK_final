import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeImg extends StatefulWidget {
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeImg> {
  File _image;
  String _url;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              CircleAvatar(
                backgroundImage: _image == null ? null : FileImage(_image),
                radius: 80,
              ),
              GestureDetector(
                child: Icon(Icons.camera_alt),
                onTap: pickImage,
              )
            ],
          ),
          RaisedButton(
            onPressed: () {
              uploadImage(context);
            },
            child: Text("uplaod image"),
          ),
        ],
      ),
    ));
  }

  void pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    //set state bt3ml update kol shwya

    setState(() {
      _image = image;
    });
  }

  Future uploadImage(context) async {
    try {
      FirebaseStorage storage =
          FirebaseStorage(storageBucket: 'gs://fire999-6d8b9.appspot.com');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('success'),
      ));

      setState(() {
        //   _url = url;
      });
    } catch (ex) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(ex.message),
      ));
    }
  }
}
