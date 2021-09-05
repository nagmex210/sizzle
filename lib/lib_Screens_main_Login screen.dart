import 'package:finalapplication/Screens/main/Mainmenu.dart';
import 'package:flutter/material.dart';
import 'package:finalapplication/constants.dart';
import 'package:finalapplication/Models/ButtonModel.dart';
import 'package:provider/provider.dart';
import 'package:finalapplication/Models/AuthenticationProvider.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'asıohdpcn';
  @override
  String email;
  String password;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                        )
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Buttonolurins('Login', kblue, Colors.blue, () async {
                  try {
                   String a = await context.read<AuthenticationProvider>().signIn(
                      email: email.trim(),
                      password: password.trim(),
                    );
                   if(a =='Signed in!'){
                     Navigator.pushReplacementNamed(context, Mainmenu.id);
                   }
                  } catch (e) {
                    print(e);
                  }
                }, Colors.white, Colors.white, 200, 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
