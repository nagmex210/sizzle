import 'package:finalapplication/Screens/Game/MainGameScreen.dart';
import 'package:finalapplication/Screens/main/Mainmenu.dart';
import 'package:finalapplication/Screens/Game/Text%20sending%20screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/main/MainScreen.dart';
import 'Screens/main/Login screen.dart';
import 'Screens/main/RegScreen.dart';
import 'Screens/Game/MgameScreen.dart';
import 'package:finalapplication/Screens/Game/Wgamescreen.dart';
import 'package:finalapplication/Screens/main/profilemenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:finalapplication/Models/userDataModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:finalapplication/Models/AuthenticationProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';



void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.hourGlass
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
  configLoading();

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Userdata()),
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
        ),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        initialRoute: '/',
        routes:{
          '/': (context) => Authenticate(),
          MainScreen.id :(context) => MainScreen(),
          LoginScreen.id : (context) => LoginScreen(),
          RegScreen.id : (context) => RegScreen(),
          Mainmenu.id: (context) => Mainmenu(),
          MgameScreen.id: (context) => MgameScreen(),
          Wgamescreen.id : (context) => Wgamescreen(),
          Profilemenu.id : (context) => Profilemenu(),
          TextSendingScreen.id : (context) => TextSendingScreen(),
          MainGameScreen.id :(context)=> MainGameScreen()

        },
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Instance to know the authentication state.
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      //Means that the user is logged in already and hence navigate to HomePage
      return Mainmenu();
    }
    //The user isn't logged in and hence navigate to SignInPage.
    return MainScreen();
  }
}

