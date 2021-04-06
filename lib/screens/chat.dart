import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseUser loggeduser;
final _firestore = Firestore.instance;

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _auth = FirebaseAuth.instance;
  String messageText;
  TextEditingController _textEditingControllerController;

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggeduser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    _textEditingControllerController = TextEditingController();
  }

  void streamMessage() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.teal,elevation: 5,automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('message').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }
              final messages = snapshot.data.documents.reversed;
              List<Bubble> messageBubbles = [];
              for (var message in messages) {
                final messageText = message.data['message'];
                final messageSender = message.data['sender'];
                final currentUser = loggeduser.email;
                if (currentUser == messageSender) {}
                final messageBubble = Bubble(
                  message: messageText,
                  sender: messageSender,
                  isMe: currentUser == messageSender,
                );
                messageBubbles.add(messageBubble);
              }
              return Expanded(
                child: ListView(
                  reverse:true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: messageBubbles,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: Colors.teal)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      controller: _textEditingControllerController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write your Message",
                      ),
                      onChanged: (value) {
                        setState(() {
                          messageText = value;
                        });
                      },
                    ),
                  )),
                  IconButton(
                    onPressed: () async {
                      await _firestore.collection('message').add(
                          {'message': messageText, 'sender': loggeduser.email});
                      _textEditingControllerController.clear();
                      print(loggeduser.email);
                      print(messageText);
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;

  const Bubble({Key key, this.sender, this.message, this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Material(
              color: isMe ? Colors.teal :Colors.blueGrey,
              elevation: 5,
              borderRadius: isMe ? BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)):BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "$message",
                  style: TextStyle(color: isMe ?Colors.white:Colors.black, fontSize: 15),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Text(
              "$sender",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
