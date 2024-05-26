import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:plant_disease_recognition/AboutUs.dart';
import 'package:plant_disease_recognition/PlantDisseaseRecognition.dart';
import 'package:plant_disease_recognition/notification_handler.dart';
import 'Login.dart';
import 'AccueilPage.dart';
import 'WebViewContainer.dart';
import 'inscription_page.dart';
import 'Settings.dart';

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
      title: 'Plant Disease Recognition',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/webViewContainer': (context) => const WebViewContainer(),
        '/AccueilPage': (context) => AccueilPage(),
        '/inscriptionPage': (context) => InscriptionPage(),
        '/Login': (context) => Login(),
        '/aboutUs': (context) => AboutUs(),
        '/PlantDiseaseRecognition': (context) => PlantDiseaseRecognition(),
        '/Settings': (context) => Settings(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late NotificationHandler notificationHandler;

  @override
  void initState() {
    super.initState();
    notificationHandler = NotificationHandler();
    notificationHandler.initFirebaseMessaging();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is currently signed out!");
      } else {
        print("User is signed in!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.emailVerified)
        ? AccueilPage()
        : Login();
  }
}
