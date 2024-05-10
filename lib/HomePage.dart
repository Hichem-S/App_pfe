import 'package:flutter/material.dart';
import 'package:plant_disease_recognition/AccueilPage.dart';
import 'package:plant_disease_recognition/inscription_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Color.fromRGBO(114, 215, 139, 0.298), blurRadius: 20, offset: Offset(0, 10)),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email address';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Email or Phone number",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                      ),
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.04),
                              Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                              SizedBox(height: constraints.maxHeight * 0.04),
                              MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final credential = await _auth.signInWithEmailAndPassword(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                      );
                                      if (credential.user != null) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AccueilPage()));
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: 'No user found for that email.',
                                          btnOkOnPress: () {},
                                        )..show();
                                      } else if (e.code == 'wrong-password') {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: 'Wrong password provided for that user.',
                                          btnOkOnPress: () {},
                                        )..show();
                                      }
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
                                  child: Text("Inscription", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.05),
                              Text("Continue with social media", style: TextStyle(color: Colors.grey)),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {},
                                    height: 50,
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    child: Icon(Icons.facebook, color: Colors.white, size: 30),
                                  ),
                                  SizedBox(width: 20),
                                  MaterialButton(
                                    onPressed: () {},
                                    height: 50,
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    child: Icon(Icons.mail, color: Colors.white, size: 30),
                                  ),
                                ],
                              ),
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
}
