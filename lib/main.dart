import 'package:flutter/material.dart';
import 'package:lets_chat/screens/welcome_screen.dart';
import 'package:lets_chat/screens/login_screen.dart';
import 'package:lets_chat/screens/registration_screen.dart';
import 'package:lets_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

//void main() => runApp(Lets_Chat());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Lets_Chat());
}

class Lets_Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: ThemeData.dark().copyWith(
        //   textTheme: TextTheme(
        //     bodyLarge: TextStyle(color: Colors.black54),
        //   ),
        // ),
        debugShowCheckedModeBanner: false,
        //home: WelcomeScreen(),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          LoginScreen.id: (context) => LoginScreen(),
        });
  }
}
