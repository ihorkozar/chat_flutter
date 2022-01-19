import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:chat_flutter/custom_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextRegDecoration.copyWith(hintText: 'Enter Your email')),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextRegDecoration.copyWith(
                      hintText: 'Enter Your password')),
              const SizedBox(
                height: 24.0,
              ),
              CustomButton(
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
                    if (e is FirebaseAuthException){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error')));
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
