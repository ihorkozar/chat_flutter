import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/custom_widgets/custom_button.dart';
import 'package:chat_flutter/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 150.0,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Hero(
                    tag: 'HeroTitle',
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('FireChat',
                            textStyle: const TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kTextRegDecoration.copyWith(
                            prefixIcon: const Icon(
                              Icons.mail,
                              color: Colors.green,
                            ),
                            hintText: 'Enter Your email')),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                        obscureText: true,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kTextRegDecoration.copyWith(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.green,
                            ),
                            hintText: 'Enter Your password')),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Hero(
                    tag: 'loginbutton',
                    child: CustomButton(
                      text: 'Log In',
                      onTap: () async {
                        setState(() {
                          showProgress = true;
                        });
                        try {
                          final UserCredential? newUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            Navigator.popAndPushNamed(context, ChatScreen.id);
                          }
                          setState(() {
                            showProgress = false;
                          });
                        } catch (e) {
                          setState(() {
                            showProgress = false;
                          });
                          if (e is FirebaseAuthException) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message.toString())));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error')));
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, RegistrationScreen.id);
                      },
                      child: const Text(
                        'Or create an account',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.green),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
