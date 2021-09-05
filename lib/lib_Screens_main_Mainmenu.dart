import 'dart:ui';

import 'package:finalapplication/Models/ButtonModel.dart';
import 'package:finalapplication/Screens/main/profilemenu.dart';
import 'package:flutter/material.dart';
import 'package:finalapplication/Models/userDataModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalapplication/Game/matchamkingLogic.dart';
import 'package:finalapplication/Screens/Game/MainGameScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:finalapplication/Screens/main/Join a game screen.dart';
import 'package:finalapplication/Models/AuthenticationProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Mainmenu extends StatefulWidget {
  static String id = 'SDJFO8909U';
  @override
  _MainmenuState createState() => _MainmenuState();
}

class _MainmenuState extends State<Mainmenu>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  User loggedinuser;
  final databaseReference = FirebaseDatabase.instance.reference();

  void GetCurrentUser() async {
    final user =
        await context.read<AuthenticationProvider>().firebaseAuth.currentUser;
    if (user != null)
      try {
        loggedinuser = user;
        print(loggedinuser.email);
        Provider.of<Userdata>(context, listen: false)
            .updateUserUid(loggedinuser.uid);
        Provider.of<Userdata>(context, listen: false).GetUserpp();
        Provider.of<Userdata>(context, listen: false).GetUserData();
      } catch (e) {
        print(e);
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/backins-1.png'),
                    fit: BoxFit.cover)),
          ),
          Container(
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: SizedBox()),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, top: 10),
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Profilemenu.id);
                              },
                              child: Container(
                                  alignment: FractionalOffset.topCenter,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        Provider.of<Userdata>(context).url == null
                                            ? null
                                            : NetworkImage(
                                                Provider.of<Userdata>(context)
                                                    .url), //NetworkImage(url),
                                    radius: 30,
                                  ))),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text('Sizzle',style:GoogleFonts.balooPaaji(
                                fontSize: 120,
                                fontWeight: FontWeight.w700,
                              )
                              ),
                            ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Buttonolurins(
                                'Join Game', Color(0xFFF2101C), Color(0XFFBB0C36),
                                () async {
                              try {
                                matchMaker makematcher =
                                    matchMaker(myUID: loggedinuser.uid);
                                await makematcher.transformLocation();

                                if (Provider.of<Userdata>(context, listen: false)
                                        .userData['Gender'] ==
                                    'Female') {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => WillPopScope(
                                        onWillPop: ()async => false,
                                        child: AlertDialog(
                                              title: Text(
                                                'Please wait for other players to join',
                                                style:
                                                    TextStyle(color: Colors.black),
                                              ),
                                              content: Container(
                                                  height: 150,
                                                  child: SpinKitPouringHourglass(
                                                      color: Color(0xFF05BFF2))),
                                              actions: [
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      makematcher.subscription
                                                          .cancel();
                                                      databaseReference
                                                          .child(
                                                              '${loggedinuser.uid}')
                                                          .remove();
                                                      Navigator.of(context).pop();
                                                    },
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                    ),
                                                    label: Text('Cancel'))
                                              ],
                                              elevation: 24.0,
                                              backgroundColor: Colors.white,
                                              insetPadding: EdgeInsets.all(10),
                                            ),
                                      ));
                                  await Future.delayed(const Duration(seconds: 15));
                                  await makematcher.createLobbyandDoSomeWaiting(
                                      () async {
                                    makematcher.subscription.cancel();
                                    dynamic count;
                                    await databaseReference
                                        .child('${loggedinuser.uid}')
                                        .child('UserCounter')
                                        .once()
                                        .then((value) {
                                      print(value);
                                      print(value.key);
                                      print(value.value);
                                      count = value.value;
                                    });
                                    print(count);
                                    await EasyLoading.showSuccess(
                                      'GAME STARTED!',
                                    );
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainGameScreen(
                                                  gameid: loggedinuser.uid,
                                                  userid: loggedinuser.uid,
                                                  name: Provider.of<Userdata>(
                                                          context,
                                                          listen: false)
                                                      .userData['name'],
                                                  Role: 'host',
                                                  count: count,
                                                  senderpp: Provider.of<Userdata>(
                                                          context)
                                                      .url,
                                                )));
                                  }, context);
                                } else {
                                  for (int i = 0; i <= 6; i++) {
                                    String ngm = await makematcher.findlobby();
                                    print(ngm);

                                    if (ngm != null) {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Please wait for other players to join',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                content: Container(
                                                    height: 150,
                                                    child:
                                                        SpinKitPouringHourglass(
                                                            color: Colors.blue)),
                                                actions: [
                                                  ElevatedButton.icon(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        await makematcher
                                                            .slavesubscription
                                                            .cancel();
                                                        await databaseReference
                                                            .child('$ngm')
                                                            .child('UserCounter')
                                                            .once()
                                                            .then((value) {
                                                          print(value.value);
                                                          int dp =
                                                              value.value - 1;
                                                          databaseReference
                                                              .child('$ngm')
                                                              .child(
                                                                  'UserCounter')
                                                              .set(dp);
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                      label: Text('Cancel'))
                                                ],
                                                elevation: 24.0,
                                                backgroundColor: Colors.white,
                                                insetPadding: EdgeInsets.all(10),
                                              ));
                                      makematcher.waitinglobby(
                                          context: context,
                                          gmid: ngm,
                                          slavefunc: () {
                                            makematcher.slavesubscription
                                                .cancel();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainGameScreen(
                                                            gameid: ngm,
                                                            userid:
                                                                loggedinuser.uid,
                                                            senderpp: Provider.of<
                                                                        Userdata>(
                                                                    context)
                                                                .url,
                                                            Role: 'slave',
                                                            name: Provider.of<
                                                                        Userdata>(
                                                                    context,
                                                                    listen: false)
                                                                .userData['name'])));
                                          });
                                      break;
                                    } else {
                                      await EasyLoading.showError(
                                          'Cant Find a Game retrying in ${i} ',
                                          duration: Duration(seconds: i + 1));
                                      await Future.delayed(Duration(seconds: i));
                                    }
                                  }
                                }
                              } catch (e, s) {
                                print('$e : $s');
                              }
                            }, Colors.transparent, Colors.white, 300, 60),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Buttonolurins('Join Game with Code',
                                Color(0xFF0872F8), Color(0xFF0163E1), () async {
                              try {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => SingleChildScrollView(
                                          child: Jg(
                                            userid: loggedinuser.uid,
                                            //ppyi anon yap
                                            pp: null,
                                            name: '',
                                          ),
                                        ));
                              } catch (e, s) {
                                print('$e : $s');
                              }
                            }, Colors.transparent, Colors.white, 300, 60),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Buttonolurins('Host a game with a code', Color(0xFF05BFF2),
                                Color(0xFF05BFF2), () async {
                              try {
                                matchMaker makematcher =
                                    matchMaker(myUID: loggedinuser.uid);
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                            'Please wait for other players to join',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  height: 150,
                                                  child: SpinKitPouringHourglass(
                                                      color: Color(0xFF05BFF2))),
                                              Text(
                                                '${loggedinuser.uid} ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                'is your code',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  databaseReference
                                                      .child(
                                                          '${loggedinuser.uid}')
                                                      .remove();
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ),
                                                label: Text('Cancel')),
                                            ElevatedButton.icon(
                                                onPressed: () async {
                                                  dynamic count;
                                                  await databaseReference
                                                      .child(
                                                          '${loggedinuser.uid}')
                                                      .child('UserCounter')
                                                      .once()
                                                      .then((value) {
                                                    print(value);
                                                    print(value.key);
                                                    print(value.value);
                                                    count = value.value;
                                                  });
                                                  print(count);

                                                  if (1 < count) {
                                                    await EasyLoading.showSuccess(
                                                      'GAME STARTED!',
                                                    );
                                                    //burdan push etme yapıyor
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MainGameScreen(
                                                                  gameid:
                                                                      loggedinuser
                                                                          .uid,
                                                                  userid:
                                                                      loggedinuser
                                                                          .uid,
                                                                  Role: 'host',
                                                                  count: count,
                                                                  name: Provider.of<
                                                                              Userdata>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .userData['name'],
                                                                )));
                                                  } else {
                                                    EasyLoading.showError(
                                                        'Game starts with minimum 3 players');
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.forward,
                                                  color: Colors.green,
                                                ),
                                                label: Text('Start'))
                                          ],
                                          elevation: 24.0,
                                          backgroundColor: Colors.white,
                                          insetPadding: EdgeInsets.all(10),
                                        ));

                                await makematcher.createprivatelobby();
                              } catch (e, s) {
                                print('$e : $s');
                              }
                            }, Colors.transparent, Colors.white, 300, 60),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
