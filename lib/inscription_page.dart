import 'package:flutter/material.dart';
import 'package:plant_disease_recognition/main.dart';  // Ensure this import is correctly configured

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InscriptionPage(),
      ),
    );

class InscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
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
        child: SingleChildScrollView(  // This makes the content scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.1),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Inscription",
                      style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.05),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Welcome",
                      style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.02),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.08),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.1),
                      buildTextField("Nom", "Nom", Icons.person),
                      buildTextField("Prénom", "Prénom", Icons.person_outline),
                      buildTextField("Email", "Email", Icons.email),
                      buildTextField("Phone number", "Phone number", Icons.phone),
                      buildTextField("Mot de passe", "Mot de passe", Icons.lock_outline, isPassword: true),
                      buildTextField("Confirmer Mot de passe", "Confirmer Mot de passe", Icons.lock, isPassword: true),
                      SizedBox(height: screenHeight * 0.05),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        height: 50,
                        color: Colors.green[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            "Connect",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.1), // Additional padding at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String placeholder, IconData icon, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(114, 215, 139, 0.298),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.grey),
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
