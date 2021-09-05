import 'package:finalapplication/Screens/main/Login%20screen.dart';
import 'package:finalapplication/Screens/main/RegScreen.dart';
import 'package:flutter/material.dart';
import 'package:finalapplication/constants.dart';
import 'package:finalapplication/Models/ButtonModel.dart';


class MainScreen extends StatelessWidget {
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/logo.png',
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            Center(
              child: Text(
                'S.I.M.P',
                style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Buttonolurins('Login', kblue, Colors.blue, () {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              }, Colors.white, Colors.white, 200, 50),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0.00025),
                child:
                    Buttonolurins('Register', Colors.white, Colors.white, () {
                  Navigator.pushNamed(context, RegScreen.id);
                }, Colors.lightBlueAccent, Colors.black, 200, 50))
          ],
        ),
      ),
    );
  }
}
