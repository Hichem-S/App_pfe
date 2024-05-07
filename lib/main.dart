import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AccueilPage.dart';
import 'WebViewContainer.dart';
import 'inscription_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/webViewContainer': (context) => WebViewContainer(),
        '/accueilPage': (context) => AccueilPage(),
        '/inscriptionPage': (context) => InscriptionPage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Padding(
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
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
                                    child: TextField(
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
                                    child: TextField(
                                      obscureText: true,
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
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AccueilPage()));
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
            );
          },
        ),
      ),
    );
  }
}
