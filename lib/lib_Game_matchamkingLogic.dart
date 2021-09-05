
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:math';
import 'package:finalapplication/Models/locationservices.dart';
import 'package:geocoding/geocoding.dart';


class matchMaker {
  matchMaker({@required this.myUID});

  Locationservices locationservices = Locationservices();
  String matchid;
  final String myUID;
  StreamSubscription<Event> subscription;
  StreamSubscription<Event> slavesubscription;
  StreamSubscription<Event> privatesubscribtion;

  String country;

  String gameID;
  String uID;
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<String> findlobby()
  async {
    try {
      final lobbies = await databaseReference.once();
      Map<String, dynamic> myMap = new Map<String, dynamic>.from(lobbies.value);
      final List possibleMatches = [];
      myMap.forEach((key, value) {
        final thatcountry = value['Location'];
        final usercount = value['UserCounter'];
        if (country == thatcountry && usercount < 5) {
          possibleMatches.add(key);
        }
      });
      int randomnumber;
      int length = possibleMatches.length;
      if(length < 2){
        randomnumber = 0 ;
      }else{
        randomnumber  = Random().nextInt(length + 1);
      }
      //TODO:burayı güncelle
      String chosenMatchid = possibleMatches[randomnumber];
     await databaseReference
          .child('$chosenMatchid')
          .child('UserCounter')
          .once()
          .then((value) {
        print(value.value);
        int dp = value.value + 1;
        databaseReference.child('$chosenMatchid').child('UserCounter').set(dp);
      });
      print(chosenMatchid);

      return chosenMatchid;
    } catch (e) {
      print(e);
    }
  }

  void transformLocation() async {
    try {
      print('lokasyon çalışıyor');
      await locationservices.getLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationservices.locationData.latitude,
          locationservices.locationData.longitude);
      Placemark PM = placemarks[0];
      country = PM.isoCountryCode;
      print(placemarks);
      print(locationservices.locationData.longitude);
    } catch (e) {
      print(e);
    }
  }

   void createLobbyandDoSomeWaiting(@required Function killfunc,@required BuildContext context) async {
    databaseReference.child('$myUID').set({
      "Location": '${country}',
      "BigR": {"Round": 0},
      "eliminatedUser": {"uid": "USERUİD"},
      "lilR": {"Round": 0},
      "matchStatus": true,
      "pandA": {
      },
      "UserCounter": 0
    });
    print('operation completed');
    print('subscribed');
      subscription = databaseReference
          .child('$myUID')
          .child('UserCounter')
          .onValue
          .listen(
              (event) {
                print(event.snapshot.value);

                if(event.snapshot.value >= 5){
                  killfunc();
                }
              },
              cancelOnError: true,
              onError: (e) {
                print(e);
              });


    }


    void waitinglobby({BuildContext context,Function slavefunc,String gmid})
    {
      slavesubscription = databaseReference
          .child('$gmid')
          .child('UserCounter')
          .onValue
          .listen(
              (event) {
            print(event.snapshot.value);

            if(event.snapshot.value == null ){
              slavesubscription.cancel();
            Navigator.of(context).pop();
            }
            if(event.snapshot.value >= 5){
             slavefunc();
            }
          },
          cancelOnError: true,
          onError: (e) {
            print(e);
          });



    }


  void createprivatelobby() async {
    databaseReference.child('$myUID').set({
      "Location": 'PRİVATELOBBBY',
      "BigR": {"Round": 0},
      "eliminatedUser": {"uid": "USERUİD"},
      "lilR": {"Round": 0},
      "matchStatus": true,
      "pandA": {
      },
      "UserCounter": 0
    });
    print('operation completed');
    print('subscribed');
  }

}
