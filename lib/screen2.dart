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

class screen2 extends StatefulWidget {
  final String ud;
  screen2(this.ud);
  @override
  _screenState createState() => _screenState();
}

class _screenState extends State<screen2> {
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
      coins = prefs.getInt('coin2') ?? coins;
    });
  }

  RewardedVideoAd videoAd = RewardedVideoAd.instance;

  @override
  Future<void> initState() {
    super.initState();
    getData();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-9553580055895935~1610407402');

    RewardedVideoAd.instance.load(
        adUnitId: "ca-app-pub-9553580055895935/1690226045",
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
      "coins": coins.toString() ?? null,
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
                return
                    /* FutureBuilder(
                future: _calculation,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      return */
                    Container(
                  color: Color(0xFF6F35A5),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot posts = snapshot.data.documents[index];
                        int len = snapshot.data.documents.length;
                        if (snapshot.data == null)
                          return CircularProgressIndicator();

                        return Container(
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
                                          btnforGroundColr,
                                          Colors.deepPurple
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "The More You Watch The More You Earn!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        " Watch The ads and get 10 coins  ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Hurry up ! and watch now  ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Share us your what you like! ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Click to make the deal  ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 150,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Transform(
                                                transform: Matrix4.skewX(-0.06),
                                                origin: Offset(50.0, 50.0),
                                                child: Material(
                                                  color: Color(0xffB19CD9),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30,
                                                            right: 30,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: InkWell(
                                                      child: Text(
                                                        'make a deal',
                                                        style: TextStyle(
                                                            color: Colors.white,
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
                                  left: 255,
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
                                  width: 130,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        btnforGroundColr,
                                        btnbackGroundColr
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Center(
                                    child: FlatButton(
                                        child: Text(
                                          'Watch Video ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          videoAd.load(
                                              adUnitId:
                                                  "ca-app-pub-9553580055895935/1690226045");
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
                                ),
                                SizedBox(
                                  width: 55,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        btnforGroundColr,
                                        btnbackGroundColr
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  width: 120,
                                  height: 70,
                                  child: Center(
                                      child: Text(
                                    "Coins = " + posts.data()['coins'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
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
                                colors: [btnforGroundColr, btnbackGroundColr],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Center(
                              child: FlatButton(
                                  disabledColor: Colors.transparent,
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
                                            "ca-app-pub-9553580055895935/1690226045");

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
                                      updataData();
                                    };
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  color: Colors.orange,
                                  width: 350,
                                  height: 60,
                                  child: NativeAdmob(
                                    adUnitID: AdsManger.nativeAdunit,
                                    numberAds: 3,
                                    controller: _nativeAd,
                                    type: NativeAdmobType.banner,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ]));
                      }),
                );

              /// });
            }
          },
        ));
  }
}
