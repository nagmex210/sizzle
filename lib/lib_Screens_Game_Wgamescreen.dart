import 'package:finalapplication/Models/ButtonModel.dart';
import 'package:flutter/material.dart';
import 'package:finalapplication/constants.dart';
import 'dart:math';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class Wgamescreen extends StatefulWidget {
  static String id = 'kjhse789o';
  final Function toWhere;
  final String matchid;
  Wgamescreen({this.toWhere, this.matchid});
  @override
  _WgamescreenState createState() => _WgamescreenState();
}

class _WgamescreenState extends State<Wgamescreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<String> qqRn = [];
  bool status = false;
  String ansWer;
  final myController = TextEditingController();
  final ScrollController _controller = ScrollController();
  StreamSubscription sub2afk;

  Future<void> afkbarrier() async {
    print('subscribed to the question');
    sub2afk = databaseReference
        .child('${widget.matchid}')
        .child('lilR')
        .child('Round')
        .onValue
        .listen(
            (event) async {
              print('${event.snapshot.value} is changed value');
              if (event.snapshot.value == 0 ) {
                status = false;
              }
              print(' $status');
              if (event.snapshot.value == 1 && status == false) {
                print('success');
                await databaseReference
                    .child('${widget.matchid}')
                    .child('matchStatus')
                    .set(false);
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
    afkbarrier();
    qqRn.addAll(questionsRn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sub2afk.cancel();
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
                      image: AssetImage('images/back3-1.png'),
                      fit: BoxFit.cover)),
            ),
            Column(
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        'Pick a Question ',
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700,color: Colors.green),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      index = Random().nextInt(110);
                      final questions = qqRn[index];
                      return ListTile(
                        title: InkWell(
                          highlightColor: Colors.orangeAccent,
                            onTap: () {
                              widget.toWhere(questions);
                              EasyLoading.showToast('successfully selected');
                              status = true;

                              //choose question
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '${questions}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            )),
                      );
                    },
                    itemCount: 4,
                    controller: _controller,
                  ),
                ),
                Flexible(
                  child: Buttonolurins(
                      'Randomize questions 🎲', Colors.lightGreen, Colors.green, () {
                    setState(() {
                      qqRn.clear();

                      qqRn.addAll(questionsRn);
                    });
                  }, Colors.transparent, Colors.white, 300, 50),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
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
                          borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Buttonolurins(
                        'send your own question', Colors.white, Colors.white, () {
                      try {
                        widget.toWhere(ansWer);
                        print('pressed');
                        myController.clear();
                        status = true;
                        EasyLoading.showToast('successfully sent');
                      } catch (e) {
                        print(e);
                      }
                    }, Colors.black, Colors.black, 100, 50),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
