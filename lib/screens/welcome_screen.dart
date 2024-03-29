import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String pageRoute = "/";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.3,
      upperBound: 100.0,
    );
    controller.forward();
    controller.addListener((){
      setState(() {});
      print(controller.value);
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
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller.value,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PrimaryButton(
                buttonColor: kLightBlue,
                buttonText: "Log In",
                onPressedFunction:  () {
                  //Go to registration screen.
                  Navigator.pushNamed(context, LoginScreen.pageRoute);
                }),
            PrimaryButton(
              buttonColor: kBlue,
              buttonText: "Register",
              onPressedFunction:  () {
              //Go to registration screen.
              Navigator.pushNamed(context, RegistrationScreen.pageRoute);
            }
            ),
          ],
        ),
      ),
    );
  }
}


