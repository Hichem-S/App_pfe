import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class PlantDiseaseRecognition extends StatefulWidget {
  @override
  State<PlantDiseaseRecognition> createState() => _PlantDiseaseRecognitionState();
}

class _PlantDiseaseRecognitionState extends State<PlantDiseaseRecognition> {
  String? body = "";

  File? _file;

  Future getpost() async {
    var url = Uri.parse('http://192.168.240.150:5000/admin/user');
    print('Sending GET request to: $url');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var response_body = response.body;
    print(response_body);
  }

  Future uploadImage() async {
    final myfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _file = File(myfile!.path);
    });
  }

  Future predict() async {
    if (_file == null) return "";

    String base64 = base64Encode(_file!.readAsBytesSync());

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var url = Uri.parse("http://192.168.240.150:5000/api");
    print('Sending PUT request to: $url');
    var response = await http.put(url, body: base64, headers: requestHeaders);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    setState(() {
      body = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Disease Recognition'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade900,
              Colors.green.shade800,
              Colors.green.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _file == null
                      ? Center(
                          child: Text(
                            "Image not found",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Image.file(_file!),
                ),
                Expanded(
                  child: Text(
                    body!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => uploadImage(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Color.fromARGB(255, 127, 171, 246), // background color
                      ),
                      child: Text(
                        "Upload",
                        style: TextStyle(color: Colors.white), // text color
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => predict(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: const Color.fromARGB(255, 127, 171, 246), // background color
                      ),
                      child: Text(
                        "Predict",
                        style: TextStyle(color: Colors.white), // text color
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
