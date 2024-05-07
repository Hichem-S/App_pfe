import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class Test1 extends StatefulWidget {
  @override
  State<Test1> createState() => _TestState();
}

class _TestState extends State<Test1> {
  String? body = "";

  File? _file;

  Future getpost() async {
    var url = Uri.http('http://127.0.0.1:5000', "/admin/user");
    print(url);
    var response = await http.get(Uri.parse("http://10.0.2.2:5000/result"));
    print(response);

    var response_body = await response.body;
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
    var response = await http.put(Uri.parse("http://10.0.2.2:5000/api"),
        body: base64, headers: requestHeaders);

    print(response.body);
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
