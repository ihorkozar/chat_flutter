import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_flutter/custom_widgets/custom_button.dart';
import 'package:chat_flutter/firebase_service.dart';
import 'package:chat_flutter/screens/login_screen.dart';
import 'package:chat_flutter/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = ColorTween(begin: Colors.greenAccent, end: Colors.white)
        .animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    child: Image.asset('assets/logo.png'),
                    height: 60,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Fire Chat',
                        textStyle: const TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.green,
                        ))
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            CustomButton(
              text: 'Log In',
              onTap: () => Navigator.pushNamed(context, LoginScreen.id),
            ),
            CustomButton(
              text: 'Register',
              onTap: () => Navigator.pushNamed(context, RegistrationScreen.id),
            ),
            SocialCustomButton(
              text: 'Sign Up with Google',
              onTap: () async {
                FirebaseService service = FirebaseService();
                try {
                  await service.signInGoogle()
                      .then((_) => Navigator.pushNamed(context, ChatScreen.id));
                  //Navigator.pushNamed(context, ChatScreen.id);
                } catch (e) {
                  print(e);
                  if (e is FirebaseAuthException) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message.toString())));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Error')));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
