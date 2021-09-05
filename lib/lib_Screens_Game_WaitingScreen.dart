import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';




class WaitingScreen extends StatefulWidget {
 String gmaeid;
 WaitingScreen(this.gmaeid);
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  dynamic round = '0';
  dynamic littleRound ='0';
  String matchid;
  StreamSubscription subscriptiontoanswers;
  final databaseReference = FirebaseDatabase.instance.reference();
  final player = AudioPlayer();

  play()async{
    var duration = await player.setAsset('images/omer.mp3');
    await player.play();
  }
  stop()async{

    await player.stop();
  }


  Future<void> getlil() async {
    print('subscribed to the question');

    subscriptiontoanswers =
        databaseReference.child('$matchid').child('lilR').onValue.listen(
                (event) async {
                  print('this is a cycle');
                  print(event.snapshot.value);
                  print(event.snapshot);
                round =  await databaseReference.child('$matchid').child('BigR').once().then((value) => value.value['Round']);
              littleRound = event.snapshot.value['Round'];
              print(littleRound);
              print(round);
              setState(() {

              });
            },
            cancelOnError: false,
            onError: (e) {
              print(e);
            });
  }



  @override
  void initState() {
    // TODO: implement initState
    matchid = widget.gmaeid;
    getlil();
    play();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscriptiontoanswers.cancel();
    stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitPouringHourglass(
                color: Color(0xFF0163E1),
                size: 50.0,
              ),
              Text(
                'Round : $round',
                style: TextStyle(color: Colors.black, fontSize: 50),
              ),
              Text(
               'section : $littleRound' ,
                style: TextStyle(color: Colors.black54, fontSize: 20),
              ),
              Text(
                'please wait' ,
                style: TextStyle(color: Colors.black45, fontSize: 15),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
