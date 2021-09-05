
import 'package:finalapplication/Screens/main/Mainmenu.dart';
import 'package:flutter/material.dart';
import 'package:finalapplication/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String useruid;
  final String matchid;
  final String role;
  final String pp;
  final String name;
  ChatScreen(
      {@required this.useruid,
      @required this.matchid,
      @required this.role,
      @required this.pp,
      @required this.name});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String messageText;

  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    print('${widget.matchid}');
    databaseReference = FirebaseDatabase.instance
        .reference()
        .child('${widget.matchid}')
        .child('messages');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                'ARE YOU SURE ?',
                                style: TextStyle(fontSize: 20),
                              ),
                              content: Icon(
                                Icons.warning,
                                size: 50,
                                color: Colors.red[300],
                              ),
                              actions: [
                                RaisedButton.icon(
                                  onPressed: () {
                                    databaseReference.update({
                                      'SERVER ALERT': {
                                        "uid": "SERVER",
                                        "message":
                                        'THIS IS A MESSAGE BY THE SERVER THE OTHER SIDE QUIT THE LOBBY PLEASE QUIT',
                                      }
                                    });
                                    databaseReference.parent().remove();
                                    Navigator.pop(context);
                                    Navigator.popAndPushNamed(
                                        context, Mainmenu.id);
                                    },
                                  icon: Icon(Icons.logout),
                                  label: Text('Quit'),
                                )
                              ],
                            ));
                  })
                ],
              ),
              MessagesStream(
                uid: widget.useruid,
                DR: databaseReference,
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        dynamic time = DateTime.now().millisecondsSinceEpoch;
                        databaseReference.update({
                          '${widget.useruid} at $time ': {
                            "uid": "${widget.useruid}",
                            "message": '${messageText}',
                            "name": "${widget.name}",
                            "pp": "${widget.pp}"
                          }
                        });
                        messageTextController.clear();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatefulWidget {
  final String uid;
  final DatabaseReference DR;
  MessagesStream({this.uid, this.DR});

  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  List<MessageBubble> messageBubbles = [];
  List<MessageBubble> reversedbubbles = [];
  ScrollController _scrollController = ScrollController();
  String pp;
  String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: widget.DR.onChildAdded,
      builder: (context, snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData == false) {
          return Center(
            child: Container(
              color: Colors.white,
            ),
          );
        }
        DataSnapshot dataSnapshot = snapshot.data.snapshot;
        print(dataSnapshot.key);
        print(dataSnapshot.value);
        print(widget.uid);
        Map<String, dynamic> myMap =
            Map<String, dynamic>.from({dataSnapshot.key: dataSnapshot.value});
        myMap.forEach((key, value) {
          final messageText = value['message'];
          final messageSender = value['uid'];
          if(widget.uid != messageSender){
            final pp1 = value['pp'];
            pp = pp1;
            print('PROFİLE PİCTURE İS $pp');
            final name1 = value['name'];
            name = name1;
            print(name);
          }
          print(messageSender);
          final currentUser = widget.uid;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        });
        reversedbubbles = List.from(messageBubbles.reversed);


        print(messageBubbles);

        return Flexible(
          child: Column(
            children: [
              Flexible(
                flex: 1,
                  child: CircleAvatar(
                    backgroundImage: pp == null
                        ? AssetImage('images/yam10.png')
                        : NetworkImage(pp),
                    radius: 50,
                  )),
              Text(name == null ? 'YAM10(bu bir yer tutucudur)' : name,style: TextStyle(fontSize: 18),),
              Flexible(
                flex: 5,
                child: ListView.builder(
                  itemCount: messageBubbles.length,
                  shrinkWrap: false,
                  reverse: true,
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  // ignore: missing_return
                  itemBuilder: (BuildContext context, int i) {
                    return reversedbubbles[i];
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (sender == 'SERVER') {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
              ),
              elevation: 5.0,
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Color(0xFFF2101C) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
