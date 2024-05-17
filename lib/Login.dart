import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:plant_disease_recognition/AccueilPage.dart';
import 'package:plant_disease_recognition/inscription_page.dart';

class Login extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        await updateUserInFirestore(userCredential.user);
        Navigator.of(context).pushReplacementNamed("/AccueilPage");
        showInfoDialog('Successfully logged in with Facebook!');
      } else {
        showErrorDialog('Facebook login failed: ${loginResult.status}');
      }
    } catch (e) {
      showErrorDialog('Failed to login with Facebook: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await updateUserInFirestore(userCredential.user);
      Navigator.of(context).pushReplacementNamed("/AccueilPage");
    } catch (e) {
      showErrorDialog('Failed to login with Google: $e');
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      showErrorDialog('Please enter your email address to reset your password.');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      showInfoDialog('A password reset link has been sent to your email.');
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        showErrorDialog('No user found for that email address.');
      } else {
        showErrorDialog('Failed to send reset email: ${e.toString()}');
      }
    }
  }

  Future<void> updateUserInFirestore(User? user) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'lastLogin': DateTime.now(),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: constraints.maxHeight * 0.1),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Login", style: TextStyle(color: Colors.white, fontSize: 40)),
                            SizedBox(height: 10),
                            Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18)),
                          ],
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: constraints.maxHeight * 0.1),
                              buildTextFormField(emailController, "Email or Phone number", "Please enter your email address"),
                              buildTextFormField(passwordController, "Password", "Please enter your password", obscureText: true),
                              SizedBox(height: constraints.maxHeight * 0.04),
                              InkWell(
                                onTap: resetPassword,
                                child: Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.04),
                              MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final UserCredential credential = await _auth.signInWithEmailAndPassword(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                      );
                                      await updateUserInFirestore(credential.user);
                                      if (credential.user != null && credential.user!.emailVerified) {
                                        Navigator.of(context).pushReplacementNamed("/AccueilPage");
                                      } else {
                                        showErrorDialog("Please verify your email before logging in.");
                                      }
                                    } catch (e) {
                                      handleFirebaseAuthException(e as FirebaseAuthException);
                                    }
                                  }
                                },
                                height: 50,
                                color: Colors.green[900],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => InscriptionPage()));
                                },
                                height: 50,
                                color: Colors.green[900],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.05),
                              Text("Continue with social media", style: TextStyle(color: Colors.grey)),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              socialMediaButtons(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String hintText, String errorMessage, {bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void handleFirebaseAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided for that user.';
        break;
      default:
        message = 'An unexpected error occurred. Please try again.';
        break;
    }
    showErrorDialog(message);
  }

  void showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
    )..show();
  }

  void showInfoDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.leftSlide,
      title: 'Info',
      desc: message,
      btnOkOnPress: () {},
    )..show();
  }

  Widget socialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          onPressed: signInWithFacebook,
          height: 50,
          color: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Icon(Icons.facebook, color: Colors.white, size: 30),
        ),
        SizedBox(width: 20),
        MaterialButton(
          onPressed: signInWithGoogle,
          height: 50,
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Icon(Icons.mail, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
