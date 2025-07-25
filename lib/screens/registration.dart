import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/roundedbutton.dart';
import 'package:flash_chat/screens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {

     static String id = 'registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
} 

class _RegistrationScreenState extends State<RegistrationScreen> {
   final _auth = FirebaseAuth.instance;
   bool showSpinner = false;
   var email;
  var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox( 
                height: 48.0,
              ),
              TextField(textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputFieldDecoration.copyWith(hintText: 'Enter your email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(textAlign: TextAlign.center,
              obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                 decoration: kInputFieldDecoration.copyWith(hintText: 'Enter your password')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register', color: Colors.blueAccent, onPressed: () async{
                setState(() {
                  showSpinner = true;
                });
                try{
                final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                if (newUser != null){
                  Navigator.pushNamed(context, ChatScreen.id);
                }
                setState(() {
                  showSpinner = false;
                });
                }
        
                
                catch (e){
                  print(e);
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}