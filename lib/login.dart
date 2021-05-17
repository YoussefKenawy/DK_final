import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire99/register2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colorr.dart';
import 'register2.dart';
import 'screen2.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  final _formkey = GlobalKey<FormState>();

  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      //Color.fromRGBO(41, 30, 83, 1),
      padding: EdgeInsets.all(16),

      child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
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
                    'Login',
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
              SizedBox(height: 15),
              TextFormField(
                //Email/
                controller: _emailcontroller,
                cursorColor: Colors.purple,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  //fillColor:Colors.white,
                  filled: true,
                  hintText: "Your Email",
                  hintStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Fill Email Input';
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                //Password/
                cursorColor: Colors.deepPurple,
                obscureText: true,
                controller: _passwordcontroller,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  // fillColor: Colors.white,
                  filled: true,

                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Fill Password Input';
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 160,
                child: Container(
                  // color:  Colors.purple,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.deepPurple,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        WidgetsFlutterBinding.ensureInitialized();
                        await Firebase.initializeApp();

                        var result = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailcontroller.text,
                                password: _passwordcontroller.text);

                        final user = FirebaseAuth.instance.currentUser;
                        final userData = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get();
                        String ud = userData['username'];
                        if (result != null) {
                          // pushReplacement
                          print('welcomee');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => screen2(ud)),
                          );
                        } else {
                          print('user not found');
                        }
                      }
                    },
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ),
                      Text(
                        "O R",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 5,
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen2()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  //padding: EdgeInsets.only(left:15,bottom:15,right:15),
                  //alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account ?",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Sign up",
                        style: TextStyle(
                            color: btnforGroundColr,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
