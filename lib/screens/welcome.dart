import 'package:flash_chat/screens/login.dart';
import 'package:flash_chat/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/roundedbutton.dart';

class WelcomeScreen extends StatefulWidget {

    static String id = 'welcome';
   
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this);

      animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);

      controller.forward();

      controller.addListener((){
        setState(() {  
        });
      });
  }
    @override
      void dispose(){
        controller.dispose();
        super.dispose();
      }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
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
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(animatedTexts: [TypewriterAnimatedText('Flash Chat',
                     textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),),],
              ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log in', color: Colors.lightBlueAccent, onPressed:(){Navigator.pushNamed(context, LoginScreen.id);}),
            RoundedButton(title: 'Register', color: Colors.blueAccent, onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);},),
            
          ],
        ),
      ),
    );
  }
}

