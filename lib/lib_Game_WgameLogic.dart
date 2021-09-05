import 'Mgamelogic.dart';


class wGame extends mGame {
  String matchid;
  int playercount;


  PLAY() async {
   OTL : for (int i = 0; i <= playercount -1 ; i++) {
      if (i == playercount - 1) {
        await databaseReference
            .child('$matchid')
            .child('matchStatus')
            .update({'status': false });
        databaseReference.child('$matchid').child('lilR').update({'Round': 0});
        await Future.delayed(const Duration(seconds: 1));
        databaseReference.child('$matchid').child('lilR').update({'Round': 404});
        databaseReference.child('$matchid').remove();
        break;
      }
      databaseReference.child('$matchid').child('BigR').update({'Round': i});

      for (int i = 0; i < 3; i++) {
        bool a = await databaseReference.child('${matchid}').child('matchStatus').once().then((value) => value.value);
        print('the local variable a is equal to :$a');
        if(a == false || a ==null){
         await databaseReference.child('$matchid').remove();
          break OTL ;
          break ;
        }
        if(i == 0){
         await databaseReference.child('$matchid').child('pandA').remove();
         await databaseReference.child('$matchid').child('lilR').update({'Round': i});
         await Future.delayed(const Duration(seconds: 15));
        }
        else{
          databaseReference.child('$matchid').child('lilR').update({'Round': i});
          await Future.delayed(const Duration(seconds: 20));
        }
      }
    }
  }

  sendThaQuestion(String question) {
    try {
      databaseReference
          .child('$matchid')
          .update({'q': '$question'});
      print('pressed');
    } catch (e) {
      print(e);
    }
  }
}
