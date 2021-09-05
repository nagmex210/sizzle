import 'dart:async';
import 'package:finalapplication/Game/Mgamelogic.dart';
import 'package:finalapplication/Game/WgameLogic.dart';
import 'package:finalapplication/Screens/Game/MgameScreen.dart';
import 'package:finalapplication/Screens/Game/Wgamescreen.dart';
import 'package:finalapplication/Screens/main/Mainmenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalapplication/Screens/Game/Chat screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalapplication/Screens/Game/WaitingScreen.dart';
import 'package:finalapplication/Screens/Game/Text sending screen.dart';
import 'package:finalapplication/Screens/Game/MgameScreen1.dart';

class MainGameScreen extends StatefulWidget {
  static String id = '67890R56YHI';
  String gameid;
  final String Role;
  final String userid;
  final String senderpp;
  final int count;
  final String name;
  MainGameScreen(
      {@required this.gameid,
      @required this.userid,
      this.senderpp,
      @required this.name,
      @required this.Role,
      this.count});

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  User loggedinuser;
  final _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  int littleRound;
  String role;
  StreamSubscription<Event> sub2players;
  StreamSubscription<Event> sub2host;

  mGame xgame = mGame();
  wGame ygame = wGame();
  String question;

  final PageController _pageController = PageController(initialPage: 0);

  Future<void> anti_afk() async {
    print('subscribed');
    sub2players =
        databaseReference.child('${widget.gameid}').child('afk').onValue.listen(
            (event) async {
              print('${event.snapshot.value} is the number of afk players');
              if (role == 'host' && event.snapshot.value !=	null) {
                Map<String, dynamic> myMap =
                await Map<String, dynamic>.from(event.snapshot.value);
                print(myMap.length);
               int newcount = ygame.playercount = widget.count - myMap.length;
               print(newcount);
               ygame.playercount = newcount;
              }
              if (role == 'slave' && event.snapshot.value !=	null) {
                Map<String, dynamic> myMap =
                await Map<String, dynamic>.from(event.snapshot.value);
                print(myMap.length);
                print(myMap);
                myMap.forEach((key, value) {
                  print(key);
                  if (key == widget.userid){
                    sub2host.cancel();
                    xgame.dismiss();
                    UpdateScreen(405);
                  }
                });
              }
            },
            cancelOnError: false,
            onError: (e) {
              print(e);
            });
  }

  Future<void> anti_afk_host() async {
    print('subscribed');
    sub2host =
        databaseReference.child('${widget.gameid}').child('matchStatus').onValue.listen(
                (event) async {
              print(event.snapshot.value);
              if(event.snapshot.value == false){
                ygame.playercount = 0;
                sub2host.cancel();
                xgame.dismiss();
                UpdateScreen(405);
              }
            },
            cancelOnError: false,
            onError: (e) {
              print(e);
            });
  }



  Future<void> UpdateScreen(int i) async {
    if (i == 0) {
      if (role == 'slave') {
        await xgame.checkIfUserEliminated();
        print(xgame.pafkuf);
        bool a = xgame.pafkuf;
        if (a == true) {
          xgame.dismiss();
          UpdateScreen(405);
        }
      }
      _pageController.jumpToPage(0);
    } else if (i == 1) {
      _pageController.jumpToPage(1);
    } else if (i == 2) {
      _pageController.jumpToPage(2);
    } else if (i == 404) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  useruid: widget.userid,
                  matchid: widget.gameid,
                  role: widget.Role,
                  pp: widget.senderpp,
                  name: widget.name,
                )),
      );
    } else if (i == 405) {
      Navigator.popAndPushNamed(context, Mainmenu.id);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sub2players.cancel();
    sub2host.cancel();
    xgame.dismiss();
    super.dispose();
  }

  void hostfunc(String question) {
    ygame.sendThaQuestion(question);
  }

  @override
  void initState() {
    super.initState();
    role = widget.Role;
    ygame.playercount = widget.count;
    String Gameid = widget.gameid;
    anti_afk_host();
    anti_afk();
    if (role == 'host') {
      print(widget.gameid);
      xgame.matchid = Gameid;
      ygame.matchid = Gameid;
      print(xgame.matchid);
      xgame.Start(UpdateScreen, dispose);
      ygame.PLAY();
    } else {
      print(widget.gameid);
      xgame.matchid = Gameid;
      xgame.myUID = widget.userid;
      print(xgame.matchid);
      xgame.Start(UpdateScreen, dispose);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Colors.white,
              child: role == 'host'
                  ? PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        Wgamescreen(
                          toWhere: hostfunc,
                          matchid: widget.gameid,
                        ),
                        WaitingScreen(widget.gameid),
                        MgameScreen(
                          gameid: widget.gameid,
                        ),
                      ],
                    )
                  : PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        WaitingScreen(widget.gameid),
                        TextSendingScreen(
                          gameid: widget.gameid,
                          Senderid: widget.userid,
                          pp: widget.senderpp,
                        ),
                       MgameScreen1(
                         gameid: widget.gameid,
                       )
                      ],
                    )),
      ),
    );
  }
}
