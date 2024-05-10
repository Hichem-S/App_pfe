import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_disease_recognition/AboutUs.dart';
import 'HomePage.dart';
import 'AccueilPage.dart';
import 'WebViewContainer.dart';
import 'inscription_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
    void initState() {
      FirebaseAuth.instance.authStateChanges().listen((User ? User)
      {
        if (User == null)
        {
        print(" ================ User is currently signed out !");}
        else{
        print(" ================ User is signed in !");}
      });
      super.initState();
    }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ?  HomePage(): AccueilPage(),
      routes: {
        '/webViewContainer': (context) => const WebViewContainer(),
        '/accueilPage': (context) => AccueilPage(),
        '/inscriptionPage': (context) => InscriptionPage(),
        '/HomePage': (context) => HomePage(),
        '/aboutUs': (context) => AboutUs(), 
      },
    );
  }
}
