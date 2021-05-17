import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'colorr.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Duration waitForSplash = Duration(seconds: 7);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/coins.jfif'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
                fit: BoxFit.contain,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 35.0,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico'),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Watch And Earn!'),
                    ],
                    isRepeatingAnimation: true,
                  ),
                )),
            SizedBox(
              width: 200,
              height: 60,
              child: RaisedButton(
                padding: EdgeInsets.all(0.0),
                textColor: Colors.white,
                focusColor: btnbackGroundColr,
                color: btnbackGroundColr,
                shape: StadiumBorder(),
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                },
                child: Ink(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [btnforGroundColr, btnbackGroundColr],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 55,
                      maxWidth: 200,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Open App',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
