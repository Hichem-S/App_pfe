import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AboutTheSerre(),
      ),
    );

class AboutTheSerre extends StatelessWidget {
  // URL of the Raspberry Pi camera stream
  final String cameraUrl = 'http://192.168.119.162:5000';

  // Function to launch URL
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(cameraUrl);
    if (!await canLaunchUrl(url)) {
      throw 'Could not launch $url';
    } else {
      // Launch the URL in the default browser
      await launchUrl(url, mode: LaunchMode.externalApplication);
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
            end: Alignment.bottomCenter,
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
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: constraints.maxHeight * 0.1),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Welcome to the Camera Stream",
                              style: TextStyle(color: Colors.white, fontSize: 40),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Click the button below to view the camera stream.",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[800], // Dark green background
                                foregroundColor: Colors.white, // White text and icon
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                textStyle: TextStyle(fontSize: 20),
                              ),
                              onPressed: (){
                                Navigator.of(context).pushNamed('/webViewContainer');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.camera_alt), // Camera icon
                                  SizedBox(width: 8), // Space between the icon and text
                                  Text('Open Camera Stream'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
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
