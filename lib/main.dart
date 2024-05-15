import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_disease_recognition/AboutUs.dart';
import 'package:plant_disease_recognition/PlantDisseaseRecognition.dart';
import 'Login.dart';
import 'AccueilPage.dart';
import 'WebViewContainer.dart';
import 'inscription_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _MyAppState(),
      routes: {
        '/webViewContainer': (context) => const WebViewContainer(),
        '/AccueilPage': (context) => AccueilPage(),
        '/inscriptionPage': (context) => InscriptionPage(),
        '/Login': (context) => Login(),
        '/aboutUs': (context) => AboutUs(),
        '/PlantDiseaseRecognition': (context) => PlantDiseaseRecognition(),
      },
    );
  }
}

class _MyAppState extends StatefulWidget {
  const _MyAppState({Key? key}) : super(key: key);

  @override
  State<_MyAppState> createState() => _MyAppStateState();
}

class _MyAppStateState extends State<_MyAppState> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(" ================ User is currently signed out !");
      } else {
        print(" ================ User is signed in !");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.emailVerified)
        ? AccueilPage()
        : Login();
  }
}
