import 'package:finalapplication/Models/userDataModel.dart';
import 'package:finalapplication/Screens/main/MainScreen.dart';
import 'package:finalapplication/Screens/main/Mainmenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finalapplication/Models/database.dart';
import 'package:finalapplication/Models/AuthenticationProvider.dart';

class Profilemenu extends StatefulWidget {
  static String id = 'ADRG6dfg';

  @override
  _ProfilemenuState createState() => _ProfilemenuState();
}

class _ProfilemenuState extends State<Profilemenu> {
  @override
  Widget build(BuildContext context) {

    final picker = ImagePicker();

    String path;


    Future<String> getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          print(pickedFile.path);
          path = pickedFile.path;
        } else {
          print('No image selected.');
        }
      });
      return pickedFile.path;
    }


    Future updateImage()async{
      final _database = DatabaseService(Uid: Provider.of<Userdata>(context, listen: false).uid);
      await _database.uploadFileWithMetadata(path);
      setState(() {

      });
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButton(
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          InkWell(
            onTap:() async{
              await getImage();
              await updateImage();
              Provider.of<Userdata>(context, listen: false).GetUserpp();


              //change profile pic
            },

            child: Container(
                padding: EdgeInsets.only(top: 15),
                alignment: FractionalOffset.topCenter,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(Provider.of<Userdata>(context).url),
                  radius: 70,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: InkWell(
              onTap: () async{
                await getImage();
               await updateImage();
                Provider.of<Userdata>(context, listen: false).GetUserpp();


                //change profile pic
              },
              child: Text(
                'change profile picture',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue[900]),
              ),
            ),
          ),
          Container(
            height: 300,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  title: Text(' Username: ${Provider.of<Userdata>(context).userData['name']}'),
                ),
                IconButton(icon: Icon(Icons.logout),onPressed:() async{
                 await context.read<AuthenticationProvider>().signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
                      ModalRoute.withName('/')
                  );
                })
              ],
            ),
          )
        ],
      )),
    );
  }
}
