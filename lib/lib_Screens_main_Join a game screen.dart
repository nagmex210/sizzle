import 'package:flutter/material.dart';
import 'package:finalapplication/Screens/Game/MainGameScreen.dart';
import 'package:firebase_database/firebase_database.dart';

class Jg extends StatefulWidget {
  @override
  final String pp;
  final String userid;
  final String name;

  Jg({@required this.userid, @required this.pp,@required this.name});

  @override
  _JgState createState() => _JgState();
}

class _JgState extends State<Jg> {
  String lobbyname;
  final databaseReference = FirebaseDatabase.instance.reference();
  String errrmssg = '';

  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Enter the Code',
                style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30),
              ),
              TextField(
                onChanged: (value) {
                  lobbyname = value;
                  print(lobbyname);
                },
                textAlign: TextAlign.center,
                autofocus: true,
                decoration: InputDecoration(
                  fillColor: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton.icon(
                  onPressed: () async {
                    try {
                      await databaseReference
                          .child('$lobbyname')
                          .once()
                          .then((value) async {
                        print(value.value);
                        if (value.value == null) {
                          print('Cant find the lobby');
                          errrmssg = 'cant find the lobby';
                          setState(() {

                          });
                        }
                        else {
                          await databaseReference
                              .child('$lobbyname')
                              .child('UserCounter')
                              .once()
                              .then((value) {
                            print(value.value);
                            int dp = value.value + 1;
                            databaseReference
                                .child('$lobbyname')
                                .child('UserCounter')
                                .set(dp);
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainGameScreen(
                                        gameid: lobbyname,
                                        userid: widget.userid,
                                        Role: 'slave',
                                        senderpp: widget.pp,
                                    name: widget.name,
                                      )));
                        }
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: Icon(Icons.sensor_door),
                  label: Text(
                    'JOİN!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
              Text(
                errrmssg,
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
