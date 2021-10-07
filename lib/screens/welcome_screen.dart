import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_flutter/custom_widgets/custom_button.dart';
import 'package:chat_flutter/screens/login_screen.dart';
import 'package:chat_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
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
      duration: Duration(seconds: 1),
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('assets/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Flash Chat',
                        textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.green,
                        ))
                  ],
                ),
              ],
            ),
            SizedBox(
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
          ],
        ),
      ),
    );
  }
}
