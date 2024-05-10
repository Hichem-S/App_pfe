import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
                        buildTextField(nomController, "Nom", "Nom", Icons.person),
                        buildTextField(prenomController, "Prénom", "Prénom", Icons.person_outline),
                        buildTextField(emailController, "Email", "Email", Icons.email),
                        buildTextField(phoneNumberController, "Phone number", "Phone number", Icons.phone),
                        buildTextField(passwordController, "Mot de passe", "Mot de passe", Icons.lock_outline, isPassword: true),
                        buildTextField(confirmPasswordController, "Confirmer Mot de passe", "Confirmer Mot de passe", Icons.lock, isPassword: true),
                        SizedBox(height: screenHeight * 0.05),
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (passwordController.text == confirmPasswordController.text) {
                                try {
                                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.leftSlide,
                                    title: 'Succès',
                                    desc: 'Inscription réussie. Bienvenue!',
                                    btnOkOnPress: () {
                                      Navigator.of(context).pushReplacementNamed('/accueilPage'); // Ensure this matches your route names
                                    },
                                  )..show();
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Erreur',
                                      desc: 'Le mot de passe fourni est trop faible.',
                                    )..show();
                                  } else if (e.code == 'email-already-in-use') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Erreur',
                                      desc: 'Le compte existe déjà pour cet e-mail.',
                                    )..show();
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Une erreur inconnue s\'est produite : $e')));
                                }
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Erreur',
                                  desc: 'Les mots de passe ne correspondent pas.',
                                )..show();
                              }
                            }
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
