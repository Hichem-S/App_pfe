import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                        buildTextField(nomController, "Family Name", "Family Name", Icons.person),
                        buildTextField(prenomController, "Name", "Name", Icons.person_outline),
                        buildTextField(emailController, "Email", "Email", Icons.email),
                        buildTextField(phoneNumberController, "Phone number", "Phone number", Icons.phone),
                        buildTextField(passwordController, "Password", "Password", Icons.lock_outline, isPassword: true),
                        buildTextField(confirmPasswordController, "Confirm Password", "Confirm Password", Icons.lock, isPassword: true),
                        SizedBox(height: screenHeight * 0.05),
                        MaterialButton(
                          onPressed: _registerUser,
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
                        SizedBox(height: screenHeight * 0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text == confirmPasswordController.text) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          // Update Firestore upon successful registration
          FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'nom': nomController.text,
            'prenom': prenomController.text,
            'email': emailController.text,
            'phoneNumber': phoneNumberController.text,
            'creationTime': DateTime.now(),
          });

          // Verification email
          userCredential.user!.sendEmailVerification();

          // Success dialog
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.leftSlide,
            title: 'Succès',
            desc: 'Inscription réussie. Vérifiez votre email!',
            btnOkOnPress: () {
              Navigator.of(context).pushReplacementNamed('/Login');
            },
          )..show();
        } on FirebaseAuthException catch (e) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Erreur',
            desc: e.message ?? 'Une erreur est survenue',
            btnOkOnPress: () {},
          )..show();
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Erreur',
          desc: 'Les mots de passe ne correspondent pas.',
          btnOkOnPress: () {},
        )..show();
      }
    }
  }

  Widget buildTextField(TextEditingController controller, String label, String placeholder, IconData icon, {bool isPassword = false}) {
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
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Ce champ ne peut pas être vide';
          }
          return null;
        },
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
