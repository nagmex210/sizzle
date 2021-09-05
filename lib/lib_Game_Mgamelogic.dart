import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class mGame {
  mGame({ this.context});
  final context;
  String matchid;
  int BigRound;
  int littleRound;
  bool MatchStatus;
  String myUID;
  bool pafkuf;
  List<String> OtherPlayersUids = [];
  List<String> OtherPlayersProfilePictures = [];
  StreamSubscription<Event> subscription;

  final databaseReference = FirebaseDatabase.instance.reference();

  void dismiss() {
    print(subscription);
    subscription.cancel();
  }




  Future<bool> checkIfUserEliminated() async {
    try {
      await databaseReference
          .child('$matchid')
          .child('eliminatedUser')
          .once()
          .then((value) {
        print(value.value);
        if (value.value == myUID){
          print('kondisyon sağlandı');
          pafkuf= true;
        }
      });
    } catch (e) {
      print(e);
    }
  }



  Future<void> Start(Function UpdateScreen, Function pop) async {
    print('subscribed');
    subscription =
        databaseReference.child('$matchid').child('lilR').onChildChanged.listen(
            (event) async{
              if (event.snapshot.value == 404) {
                dismiss();
                UpdateScreen(404);
              }
              print('${event.snapshot.value} is event snapshot value');
              if (littleRound != event.snapshot.value) {
                littleRound = event.snapshot.value;
                print('${littleRound} is changed little raund value');
                UpdateScreen(this.littleRound);
              }
            },
            cancelOnError: false,
            onError: (e) {
              print(e);
            });
  }
}
