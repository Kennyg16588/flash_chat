import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome.dart';
import 'package:flash_chat/screens/login.dart';
import 'package:flash_chat/screens/registration.dart';
import 'package:flash_chat/screens/chat.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() => runApp(FlashChat());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen(),
      },
    );
  }
}