import 'package:finalapplication/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PlayerBox extends StatelessWidget {
  String answer;
  String matchid;
  String ppurllink;
  String uid;
  PlayerBox({@required this.answer,@required this.ppurllink,@required this.uid,@required this.matchid});
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      height: 200,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
              padding: EdgeInsets.only(top: 75),
              alignment: FractionalOffset.topCenter,
              child: CircleAvatar(
                backgroundImage: ppurllink == null
                    ? AssetImage('images/yam10.png')
                    : NetworkImage(ppurllink),
                radius: 50,
              )),
          InkWell(
            onDoubleTap:(){
              EasyLoading.showToast('Successfully selected');
              databaseReference.child('$matchid').child('eliminatedUser').set('$uid');} ,
            child: Container(
                alignment: FractionalOffset.topCenter,
                height: 100.0,
                width: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white70,Colors.white ],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter),
                    //border: Border.all(width: 2, color: Colors.black),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 10))
                    ]),
                child: Center(
                  child: Text(
                    answer,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
