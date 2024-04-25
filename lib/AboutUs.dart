import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: AboutUs(),
   );
 }
}

class AboutUs extends StatelessWidget {
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
       child: SingleChildScrollView(
         padding: EdgeInsets.all(20),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             SizedBox(height: MediaQuery.of(context).size.height * 0.1),
             Center(
               child: Text(
                 "About Us",
                 style: TextStyle(color: Colors.white, fontSize: 40),
               ),
             ),
             SizedBox(height: 20),
             Text(
               "About Dataset",
               style: TextStyle(color: Colors.white, fontSize: 20),
             ),
             SizedBox(height: 10),
             Text(
               "This data is recreated using offline augmentation from the original dataset.\nThe original dataset can be found on this [GitHub repo](https://github.com/original-dataset).\nThis dataset consists of about 25k regular images of healthy and diseased crop leaves categorized into 11 different classes.",
               style: TextStyle(color: Colors.white, fontSize: 16),
             ),
             SizedBox(height: 20),
             Text(
               "Content",
               style: TextStyle(color: Colors.white, fontSize: 20),
             ),
             SizedBox(height: 10),
             Text(
               "1. Train (25,984 images)\n2. Valid (6,698 images)\n3. Test (11 images)",
               style: TextStyle(color: Colors.white, fontSize: 16),
             ),
             SizedBox(height: 20),
             Text(
               "Our Values",
               style: TextStyle(color: Colors.white, fontSize: 20),
             ),
             SizedBox(height: 10),
             Text(
               "- Innovation: We embrace creativity and continuously seek new ways to improve and enhance our services.\n- User-Centricity: Our users are at the heart of everything we do. We prioritize their needs and strive to provide them with the best possible experience.\n- Integrity: We uphold the highest standards of integrity and ethics in all aspects of our work.\n- Collaboration: We believe in the power of collaboration and work closely with our users, partners, and team members to achieve our goals.",
               style: TextStyle(color: Colors.white, fontSize: 16),
             ),
           ],
         ),
       ),
     ),
   );
 }
}
