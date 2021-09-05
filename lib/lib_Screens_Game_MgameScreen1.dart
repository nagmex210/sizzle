import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalapplication/Models/playerAnDanswer.dart';
import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:finalapplication/Models/PlayerCardknockoff.dart';

class MgameScreen1 extends StatefulWidget {
  static String id = 'JAOakjchHBHU8';
  String gameid;
  MgameScreen1({@required this.gameid});
  @override
  _MgameScreenState1 createState() => _MgameScreenState1();
}

class _MgameScreenState1 extends State<MgameScreen1>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  int pageNumber = 0;

  final PageController _pageController = PageController(initialPage: 0);

  String matchid;

  final databaseReference = FirebaseDatabase.instance.reference();

  List<PlayerAndAnswer> playersAndAnswers = [];
  StreamSubscription subscriptiontoanswers;

  Future<void> getquestions() async {
    print('subscribed to the question');

    subscriptiontoanswers =
        databaseReference.child('$matchid').child('lilR').onValue.listen(
            (event) {
              if (event.snapshot.value == 2) {
                ('changed value detected');
                GetTheUsersAndTurnThemintoPlayerBoxes();
                setState(() {});
              }
              setState(() {});
            },
            cancelOnError: false,
            onError: (e) {
              print(e);
            });
  }

  Future<String> GetTheUsersAndTurnThemintoPlayerBoxes() async {
    try {
      playersAndAnswers.clear();
      print('işleme başlandı');
      final PandA =
          await databaseReference.child('$matchid').child('pandA').once();
      print(PandA.value);
      Map<String, dynamic> myMap = new Map<String, dynamic>.from(PandA.value);
      await myMap.forEach((key, value) {
        print('key is :$key');
        print('value is : ${value}');
        print('value answer is :${value['answer']}');
        print('value pp is :${value['pp']}');
        PlayerAndAnswer newobject =
            PlayerAndAnswer(uid: key, answer: value['answer'], pp: value['pp']);
        playersAndAnswers.add(newobject);
      });
      print(playersAndAnswers.length);
      setState(() {});
    } catch (e, s) {
      print('$e : $s');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    matchid = widget.gameid.trim();
    print(matchid);
    GetTheUsersAndTurnThemintoPlayerBoxes();
    getquestions();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('ı have got disposed');
    subscriptiontoanswers.cancel();
    //TODO:sonra şey koyarsın error logunda beni delirtiyor
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
        Container(
        decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/back2-1.png'),
          fit: BoxFit.cover)),
      ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Other players answers',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800,color: Colors.blue),
                ),
                Container(
                  width: 350,
                  margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.black, width: 0.1),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(0, 20))
                      ]),
                  padding: EdgeInsets.only(top: 50),
                  height: 300,
                  child: Center(
                      child: PageView.builder(
                        itemBuilder: (context, index) {
                          return PlayerBoxknockoff(
                            answer: playersAndAnswers[index].answer,
                            ppurllink: playersAndAnswers[index].pp,
                            uid: playersAndAnswers[index].uid,
                          );
                        },
                        physics: BouncingScrollPhysics(),
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (i) {
                          setState(() {
                            pageNumber = i;
                            print(pageNumber);
                          });
                        },
                        itemCount: playersAndAnswers.length,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: playersAndAnswers.length == 0
                      ? null
                      : DotsIndicator(
                    dotsCount: playersAndAnswers.length,
                    position: pageNumber.toDouble(),
                    decorator: DotsDecorator(
                        activeColor: Colors.deepOrangeAccent,
                        size: Size(17, 17),
                        activeSize: Size(18.5, 18.5)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
