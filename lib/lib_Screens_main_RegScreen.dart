import 'dart:io';

import 'package:finalapplication/Screens/main/Mainmenu.dart';
import 'package:finalapplication/constants.dart';
import 'package:flutter/material.dart';
import 'package:finalapplication/Models/ButtonModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:finalapplication/Models/AuthenticationProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const List<String> GenderList = ['Male', 'Female'];

class RegScreen extends StatefulWidget {
  static String id = 'dkfhgj';

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  CupertinoPicker ios() {
    List<Widget> newlist = [];
    for (String menuitem in GenderList) {
      var menuiitem = Text(menuitem);
      newlist.add(menuiitem);
    }
    return CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 32.0,
        onSelectedItemChanged: (value) {
          int i = value;
          gender = GenderList[i];
          print(gender);
        },
        children: newlist);
  }

  DropdownButton<String> getterdropperbuttonen() {
    List<DropdownMenuItem<String>> newlist = [];

    for (String menuitem in GenderList) {
      var menuiitem = DropdownMenuItem(
        child: Text(menuitem),
        value: menuitem,
      );
      newlist.add(menuiitem);
    }
    print(newlist.length);

    return DropdownButton<String>(
        value: gender,
        items: newlist,
        onChanged: (value) {
          setState(() {
            gender = value;
            print(gender);
          });
        });
  }

  String gender = 'Male';

  int age;

  String name;

  String email;

  String password;

  File img;

  PickedFile _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        img = File(_image.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> Register() async {
    if (email != null &&
        password != null &&
        age != null &&
        name != null &&
        gender != null &&
        _image != null) {
      try {
        String a = await context.read<AuthenticationProvider>().signUp(
            email: email.trim(),
            password: password.trim(),
            age: age,
            name: name,
            Gender: gender,
            image: _image);
        if (a == 'a') {
          Navigator.pushReplacementNamed(context, Mainmenu.id);
        }
      } catch (e) {
        print(e);
      }
    } else {
      EasyLoading.showError('Check Your Credentials');
    }
  }

  @override
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
                  child: Container(
                    width: 200,
                    height: 200,
                    child: FlatButton(
                      onPressed: () {
                        getImage();
                      },
                      color: Colors.black12,
                      child: _image == null
                          ? Icon(
                              Icons.add,
                              size: 100,
                            )
                          : Container(
                              width: 200, height: 200, child: Image.file(img)),
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
                    print(email);
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
                    print(password);
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    name = value;
                    print(name);
                  },
                  decoration:
                      kTextfieldecoration.copyWith(hintText: 'Enter your name'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  // ignore: deprecated_member_use
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    age = int.parse(value);
                    print(age);
                  },
                  decoration:
                      kTextfieldecoration.copyWith(hintText: 'Enter your age'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Platform.isIOS ? ios() : getterdropperbuttonen(),
                ),
                Buttonolurins('Register', kblue, Colors.blue, () {
                  Register();
                }, Colors.white, Colors.white, 200, 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
