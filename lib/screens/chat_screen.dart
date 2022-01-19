import 'package:chat_flutter/custom_widgets/msg_bubble.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_service.dart';
import 'login_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? _firebaseUser;

class ChatScreen extends StatefulWidget {
  static const id = '/chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? msg;
  final _controller = TextEditingController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  void getCurrentUser(){
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _firebaseUser = user;
        print(user);
      }
    } catch (e) {
      print(e);
      Navigator.pushNamed(context, LoginScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await FirebaseService().signOutFromGoogle();
                Navigator.pop(context);
              }),
        ],
        title: const Text('Fire Chat'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        msg = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _controller.clear();
                      _firestore.collection('messages').add({
                        'text': msg,
                        'sender': _firebaseUser?.email,
                      });
                    },
                    child: const Text(
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);


  @override

  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data!.docs.reversed;

        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          final messageText = (message.data() as Map)['text'];
          final messageSender = (message.data() as Map)['sender'];

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: messageSender == _firebaseUser?.email,);

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
