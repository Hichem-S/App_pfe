import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AboutTheSerre(),
    ),
  );
}

class AboutTheSerre extends StatelessWidget {
  final String cameraUrl = 'http://192.168.240.162:5000';

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(cameraUrl);
    if (!await canLaunchUrl(url)) {
      throw 'Could not launch $url';
    } else {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> sendCommand(String command) async {
    final Uri url = Uri.parse('http://your-server-url/command/$command');
    if (!await canLaunchUrl(url)) {
      throw 'Could not launch $url';
    } else {
      await launchUrl(url);
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
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Text(
                          "Welcome to the Serre Informations",
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
                            backgroundColor: Colors.green[800],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          onPressed: _launchURL,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.camera_alt),
                              SizedBox(width: 8),
                              Text('Open Camera Stream'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('sensorData')
                                .doc('pSDyoymbI5lQRfRtpA73')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white));
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasData && snapshot.data!.exists) {
                                var document = snapshot.data!.data() as Map<String, dynamic>;
                                return DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text('Sensor', style: TextStyle(color: Colors.white, fontSize: 18))),
                                    DataColumn(label: Text('Value', style: TextStyle(color: Colors.white, fontSize: 18))),
                                  ],
                                  rows: <DataRow>[
                                    DataRow(cells: <DataCell>[
                                      DataCell(Text('Humidity', style: TextStyle(color: Colors.white))),
                                      DataCell(Text('${document['humidity']}%', style: TextStyle(color: Colors.white))),
                                    ]),
                                    DataRow(cells: <DataCell>[
                                      DataCell(Text('Temperature', style: TextStyle(color: Colors.white))),
                                      DataCell(Text('${document['temperature']}°C', style: TextStyle(color: Colors.white))),
                                    ]),
                                  ],
                                );
                              } else {
                                return Text("No data available", style: TextStyle(color: Colors.white));
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => sendCommand("open_watering"),
                            child: Text('Start Watering'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[800],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => sendCommand("stop_watering"),
                            child: Text('Stop Watering'),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
