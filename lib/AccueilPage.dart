import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:plant_disease_recognition/Login.dart';
import 'package:plant_disease_recognition/Medicaments.dart';
import 'package:plant_disease_recognition/AboutUs.dart';
import 'package:plant_disease_recognition/AboutTheSerre.dart';
import 'package:plant_disease_recognition/PlantDisseaseRecognition.dart';
import 'package:plant_disease_recognition/settings.dart';

class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home Page'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccueilPage()),
                );
              },
            ),
            ListTile(
              title: Text('About The Serre'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutTheSerre()),
                );
              },
            ),
            ListTile(
              title: Text('Plant Disease Recognition'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlantDiseaseRecognition()), // Correctly reference the target page
                );
              },
            ),
            ListTile(
              title: Text('Treatments'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Medicaments()),
                );
              },
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
                        ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Settings()),
);

              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () => signOutUser(context),
            ),
          ],
        ),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Colors.green.shade900,
            Colors.green.shade800,
            Colors.green.shade400,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Center(
              child: Text(
                "Plant Disease Recognition",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to the Plant Disease Recognition System!",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "Our mission is to help in identifying plant disease efficiently. Upload an image of a tomato plant, and our system will analyze it to detect any signs of diseases. Together, let's protect our crops and ensure a healthier harvest!",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            buildHowItWorks(),
            SizedBox(height: 20),
            buildWhyChooseUs(),
            SizedBox(height: 20),
            buildGetStarted(),
            SizedBox(height: 20),
            buildAboutUs(),
          ],
        ),
      ),
    );
  }

  Widget buildHowItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How it works",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "1. Upload Image : Go to the Disease Recognition page and upload an image of a plant with suspected diseases.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          "2. Analysis : Our system will process the image using advanced algorithms to identify potential diseases.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          "3. Results : View the results and recommendations for further action.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildWhyChooseUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Why Choose Us",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "- Accuracy : Our system utilizes state-of-the-art machine learning techniques for accurate disease detection.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          "- User-Friendly : Simple and intuitive interface for seamless user experience.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          "- Fast and Efficient : Receive results in seconds, allowing for quick decision-making.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildGetStarted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Get started",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "Click on the Disease Recognition page in the sidebar to upload an image and experience the power of our Plant Disease Recognition System",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildAboutUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Us",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "Learn more about the project, our team, and our goals on the About Page",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Future<void> signOutUser(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
      await FirebaseAuth.instance.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print('Error signing out: $e');
    } finally {
      Navigator.of(context).pushNamedAndRemoveUntil('/Login', (route) => false);
    }
  }
}
