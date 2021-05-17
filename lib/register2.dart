import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class RegisterScreen2 extends StatefulWidget {
  @override
  _RegisterScreen2State createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  String valuechoose;

  void initState() {
    super.initState();
    setState(() {});
  }

  final _formkey = GlobalKey<FormState>();

  TextEditingController _namecontroller = TextEditingController();

  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  TextEditingController _countrycontroller = TextEditingController();

  TextEditingController _phonenumber = TextEditingController();

  TextEditingController _dateofbirth = TextEditingController();

  TextEditingController _gender = TextEditingController();
  File _userImageFile;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  @override
  void dispose() {
    _namecontroller.dispose();

    _emailcontroller.dispose();

    _passwordcontroller.dispose();

    _countrycontroller.dispose();

    _phonenumber.dispose();

    _dateofbirth.dispose();

    _gender.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
        title: Container(width: 60, child: Image.asset('assets/s12.png')),
        // Text('Registeration'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        leading: Icon(Icons.app_registration),
        //elevation:0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              })
        ],
      ),
      body: Container(
        color: Colors.white,
        //Color.fromRGBO(41, 30, 83, 1),
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 5),
              Row(children: <Widget>[
                Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color:Colors.lightBlueAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(50),
                      )),
                  child: Center(
                      child: Text(
                    'Sign up',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  )),
                ),
              ]),
              Container(
                width: 400,
                height: 190,
                color: Colors.lightBlueAccent[300],
                child: Image.asset('assets/signup.png'),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    // color:Colors.lightBlueAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(50),
                    )),
                width: 600,
                height: 370,
                child: Column(
                  children: <Widget>[
                    /* Container(
                        height:90,
                        child:Image.asset('assets/l1.jfif'),
                      ),*/
                    SizedBox(height: 7),
                    TextFormField(
                      controller: _namecontroller,
                      autocorrect: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        //fillColor:Colors.white,
                        filled: true,
                        hintText: "Your Name",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        ),
                        prefixIcon:
                            Icon(Icons.person, color: Colors.deepPurple),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Fill Name';
                        }
                        // return 'Valid Name';
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailcontroller,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        //fillColor:Colors.white,
                        filled: true,
                        hintText: "Your Email",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Fill Email ';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        //fillColor:Colors.white,
                        filled: true,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        ),
                        prefixIcon:
                            Icon(Icons.person, color: Colors.deepPurple),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Fill Password';
                        }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 160,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(29)),
                        color: Colors.deepPurpleAccent,
                        child: Text(
                          " Submit ",
                          style: TextStyle(color: Colors.white, fontSize: 21),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            var result = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailcontroller.text,
                                    password: _passwordcontroller.text);
                            if (result != null) {
                              Firestore.instance
                                  .collection('users')
                                  .document(result.user.uid)
                                  .setData({
                                'username': _namecontroller.text,
                                'email': _emailcontroller.text,
                                'coins': "0",
                              });
                              showDialog(
                                  context: context,
                                  builder: (_) => new AlertDialog(
                                        title: new Text(" Done "),
                                        content: new Text(
                                            "Now you have an account "),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(' OK '),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return LoginScreen();
                                                }),
                                              );
                                            },
                                          )
                                        ],
                                      ));
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }),
                              );
                            } else {
                              print('please try later');
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
