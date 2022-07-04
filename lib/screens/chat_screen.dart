import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/custom_widgets/msg_bubble.dart';
import 'package:chat_flutter/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? _firebaseUser;

class ChatScreen extends StatefulWidget {
  static const id = '/chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? msg;
  final _controller = TextEditingController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _firebaseUser = user;
      }
    } catch (e) {
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
        elevation: 0,
        // actions: <Widget>[
        //   IconButton(
        //       icon: const Icon(Icons.close),
        //       onPressed: () async {
        //         await FirebaseService().signOutFromGoogle();
        //         Navigator.pop(context);
        //       }),
        // ],
        title: const Text('Fire Chat'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              accountName: Text(_firebaseUser?.displayName ?? 'name'),
              accountEmail: Text(_firebaseUser?.email ?? 'email'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://klike.net/uploads/posts/2019-05/1556708032_1.jpg"),
              ),
            ),
            const Spacer(),
            ListTile(
              isThreeLine: true,
              leading: Icon(Icons.exit_to_app, size: 35,),
              title: Text("Logout"),
              subtitle: Text("Sign out of this account"),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
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
                        'sender': _firebaseUser?.displayName ?? 'name',
                        'senderemail': _firebaseUser?.email ?? 'email',
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
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
            const SizedBox(
              height: 8,
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
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
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
          final data = (message.data() as Map)['timestamp'];
          final currentUserName = _firebaseUser?.displayName;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUserName == messageSender,
            data: DateTime.fromMillisecondsSinceEpoch(data).toString(),
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
