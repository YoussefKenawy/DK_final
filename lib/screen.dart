import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adsManger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'colorr.dart';
import 'profile.dart';

const testDevices = "Your_device_id";

class screen extends StatefulWidget {
  final String ud;
  screen(this.ud);
  @override
  _screenState createState() => _screenState();
}

class _screenState extends State<screen> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevices != null ? <String>['testDevices'] : null,
    keywords: <String>['book', 'game'],
    nonPersonalizedAds: true,
  );

  final _nativeAd = NativeAdmobController();

  AdmobBannerSize bannerSize;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobInterstitial intersitialAd;

  int coins = 0;
  SharedPreferences prefs;
  bool press = false;
  saveData(int coin) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('coin2', coin);
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coin2');
    });
  }

  RewardedVideoAd videoAd = RewardedVideoAd.instance;

  @override
  Future<void> initState() {
    super.initState();
    getData();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);

    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId,
        targetingInfo: MobileAdTargetingInfo());

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        coins = coins + rewardAmount;
      }
    };

    bannerSize = AdmobBannerSize.BANNER;

    intersitialAd = AdmobInterstitial(
        adUnitId: AdmobInterstitial.testAdUnitId,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) intersitialAd.load();
          //  handleEvent(event, args, 'Interstitial');
        });
    _nativeAd.reloadAd(forceRefresh: true);
    intersitialAd.load();
  }

  updataData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    String ud = userData['username'];
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
    userRef.doc(userData.documentID).update({
      "coins": coins.toString(),
    });
  }

  @override
  void dispose() {
    intersitialAd.dispose();
    _nativeAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: btnforGroundColr,
            title: (Center(
                child: Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                /* Container(
                 width:80,
                 child:Image.asset('assets/l1.jfif')
               ),*/
                Text("Deal",
                    style: TextStyle(
                        color: kPrimaryLightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 23)),
                Text("K",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 23)),
                Text("arma",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23)),

                //  Text("  Broker",style:TextStyle(color:Colors.lightBlue,fontWeight:FontWeight.bold,fontSize:21)),
              ],
            ))),
            actions: <Widget>[
              SizedBox(
                width: 20,
              ),
            ]),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where("username", isEqualTo: widget.ud)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              final docs = snapshot.data.docs;
              int len = docs.length;

              if (!snapshot.hasData) return Center(child: Text('Loading'));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
//.where("category", isEqualTo:"tec")
                default:
                  return Container(
                    color: Colors.indigo,
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot posts =
                              snapshot.data.documents[index];
                          int len = snapshot.data.documents.length;
                          return Flexible(
                            child: Column(children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: [
                                    Transform(
                                      transform: Matrix4.skewY(-0.05),
                                      child: Container(
                                        padding: EdgeInsets.all(24),
                                        height: 150,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.indigo[900],
                                              Colors.redAccent,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "About App",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            "to get coins click watch video",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "then click get coins ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "and to convert your coins to money ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "click to make a deal Button ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, left: 150),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Transform(
                                                    transform:
                                                        Matrix4.skewX(-0.05),
                                                    origin: Offset(50.0, 50.0),
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 30,
                                                                right: 30,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: InkWell(
                                                          child: Text(
                                                            'make a deal',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red
                                                                    .shade600,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return profile(widget.ud);
                                                    }));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 70,
                                      left: 210,
                                      child: Image(
                                        image: AssetImage('assets/v3.png'),
                                        height: 102,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 110,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.red,
                                            Colors.pink,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                    SizedBox(
                                      width: 65,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            btnforGroundColr,
                                            Colors.deepPurple
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      width: 120,
                                      height: 70,
                                      child: Center(
                                          child: Text(
                                        "Coins = " + posts.data()['coins'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900),
                                      )),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                width: 110,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.red,
                                      Colors.pink,
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: RaisedButton(
                                    color: Colors.indigo[900],
                                    child: Text(
                                      'get Coins ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    onPressed: () {
                                      videoAd.load(
                                          adUnitId:
                                              RewardedVideoAd.testAdUnitId);

                                      updataData();
                                      videoAd.show();
                                      RewardedVideoAd.instance.listener =
                                          (RewardedVideoAdEvent event,
                                              {String rewardType,
                                              int rewardAmount}) {
                                        if (event ==
                                            RewardedVideoAdEvent.rewarded) {
                                          coins = coins + rewardAmount;
                                        }
                                        saveData(coins);
                                      };
                                    }),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  width: 400,
                                  height: 60,
                                  color: Colors.blue,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  width: 400,
                                  height: 60,
                                  color: Colors.cyan,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red,
                                          Colors.pink,
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                          color: Colors.indigo[900],
                                          child: Text(
                                            'Watch Video ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            videoAd.load(
                                                adUnitId: RewardedVideoAd
                                                    .testAdUnitId);

                                            updataData();
                                            videoAd.show();
                                            RewardedVideoAd.instance.listener =
                                                (RewardedVideoAdEvent event,
                                                    {String rewardType,
                                                    int rewardAmount}) {
                                              if (event ==
                                                  RewardedVideoAdEvent
                                                      .rewarded) {
                                                coins = coins + rewardAmount;
                                              }
                                              saveData(coins);
                                            };
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                      color: Colors.orange,
                                      width: 200,
                                      height: 60,
                                      child: NativeAdmob(
                                        adUnitID: AdsManger.nativeAdunit,
                                        numberAds: 3,
                                        controller: _nativeAd,
                                        type: NativeAdmobType.banner,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                          );
                        }),
                  );
              }
            }));
  }
}
