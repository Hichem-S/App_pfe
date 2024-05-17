import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Email and Password'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'New Email'),
                  validator: (value) => value != null && value.contains('@') && value.contains('.') ? null : 'Please enter a valid email',
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'New Password'),
                  validator: (value) => value != null && value.length >= 8 ? null : 'Password must be at least 8 characters',
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm New Password'),
                  validator: (value) => value == passwordController.text ? null : 'Passwords do not match',
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('Update'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && confirmPasswordController.text == passwordController.text) {
      try {
        await user.verifyBeforeUpdateEmail(emailController.text.trim());
        user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user!.emailVerified) {
          await firestore.collection('users').doc(user.uid).update({
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(), // Note: Storing passwords in Firestore is not recommended.
          });

          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.leftSlide,
            title: 'Success',
            desc: 'Your email and password have been successfully updated.',
            btnOkOnPress: () {},
          )..show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.leftSlide,
            title: 'Verification Needed',
            desc: 'Please verify your new email to complete the update.',
            btnOkOnPress: () {},
          )..show();
        }
      } on FirebaseAuthException catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Update Failed',
          desc: 'Failed to update email or password. ${e.message}',
          btnOkOnPress: () {},
        )..show();
      }
    }
  }
}
