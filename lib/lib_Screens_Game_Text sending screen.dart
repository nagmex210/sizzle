import 'package:finalapplication/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TextSendingScreen extends StatefulWidget {
  static String id = 'İO8T7LFGBNLŞMO';
  final String gameid;
  final Senderid;
  final pp;

  TextSendingScreen({
    @required this.gameid,
    @required this.Senderid,
    this.pp,
  });

  @override
  _TextSendingScreenState createState() => _TextSendingScreenState();
}

class _TextSendingScreenState extends State<TextSendingScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => false;

  final databaseReference = FirebaseDatabase.instance.reference();

  final myController = TextEditingController();
  StreamSubscription subscriptiontoquestion;
  StreamSubscription sub2afk;

  String ansWer;
  bool send = false;
  String question;
  String gameid;
  String Senderid;
  String SenderPP;

  Future<void> getquestions() async {
    print('subscribed to the question');
    subscriptiontoquestion =
        databaseReference.child('$gameid').child('q').onValue.listen(
            (event) {
              print(send);
              print('${event.snapshot.value} is changed value');
              question = event.snapshot.value.toString();
              send = false;
              setState(() {});
            },
            cancelOnError: false,
            onError: (e) {
              print(e);
            });
  }

  Future<void> afkbarrier() async {
    print('subscribed to the question');
    sub2afk =
        databaseReference.child('$gameid').child('lilR').child('Round').onValue.listen(
                (event) async{
              print('${event.snapshot.value} is changed value');
              print('$send');
              if(event.snapshot.value == 2){
                if(send == false){
                  print('success');
                  await databaseReference
                      .child('$gameid')
                      .child('afk')
                      .child('$Senderid')
                      .set({'iamafk': 'iamafk'});
                }
              }
            },
            cancelOnError: false,
            onError: (e) {
              print(e);
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SenderPP = widget.pp;
    gameid = widget.gameid;
    Senderid = widget.Senderid;
    getquestions();
    afkbarrier();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    subscriptiontoquestion.cancel();
    sub2afk.cancel();
    // TODO: implement dispose
    print('succesfully disposed');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/back4-1.png'),
                      fit: BoxFit.cover)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 25.0,left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '$question',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800,color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Container(
                    child: TextField(
                      controller: myController,
                      obscureText: false,
                      maxLines: null,
                      onChanged: (value) {
                        ansWer = value;
                        print(ansWer);
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(fontSize: 40),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kblue, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlue, width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(),
                ),
                OutlinedButton(
                    onPressed: () {
                      try {
                        send = true;
                        databaseReference
                            .child('$gameid')
                            .child('pandA')
                            .child('$Senderid')
                            .update({'answer': '$ansWer', "pp": "$SenderPP"});
                        print('pressed');
                        myController.clear();
                        EasyLoading.showToast('succesfluy sent');
                        setState(() {
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('SEND IT!')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
