import 'package:flutter/material.dart';
import 'package:lets_chat/constants.dart';
import 'package:lets_chat/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  // CollectionReference firestore =
  //     FirebaseFirestore.instance.collection('messages');
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String messageText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final User? user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("messages").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  List<Text> messageWidgets = [];
                  for (var messages in messages) {
                    final message = messages.data() as Map<String, dynamic>;
                    final messageTxt = message['text'];
                    final messageSender = message['sender'];

                    final messageWidget =
                        Text('$messageTxt from $messageSender');
                    messageWidgets!.add(messageWidget);
                  }

                  //if (messageWidgets != null) {
                  return Column(
                    children: messageWidgets,
                  );

                  // }
                  // else {
                  //   return CircularProgressIndicator();
                  // }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (messageText != '') {
                        _firestore.collection("messages").add({
                          'text': messageText,
                          'sender': loggedInUser.email,
                        }) //.then((value) => print(value.id))
                            .catchError(
                                (error) => print("Failed to add user: $error"));
                      }
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
    );
  }
}
