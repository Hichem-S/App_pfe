import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Medicaments(),
    );
  }
}

class Medicaments extends StatelessWidget {
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
                  "Treatments",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              SizedBox(height: 20), // Add some space between the existing text and the added text
              buildMedicamentText("Bacterial Spot (Tache bactérienne) : Oxychlorure de cuivre."),
              buildMedicamentText("Early Blight (Alternariose) : Fongicides à base de cuivre ou de chlorothalonil."),
              buildMedicamentText("Late Blight (Mildiou) : Fongicides à base de cuivre ou de chlorothalonil."),
              buildMedicamentText("Leaf Mold (Mildiou de la feuille) : Fongicides à base de cuivre ou de chlorothalonil."),
              buildMedicamentText("Septoria Leaf Spot (Tache foliaire septorienne) : Fongicides à base de cuivre ou de chlorothalonil."),
              buildMedicamentText("Spider Mites (Acariens rouges) : Acaricides, huiles horticoles, savons insecticides."),
              buildMedicamentText("Target Spot (Cercosporiose) : Fongicides à base de cuivre ou de chlorothalonil."),
              buildMedicamentText("Tomato Yellow Leaf Curl Virus (Virus de la curl feuille jaune de la tomate) : Pas de traitement curatif. Utilisation de variétés résistantes, gestion des vecteurs."),
              buildMedicamentText("Tomato Mosaic Virus (Virus de la mosaïque de la tomate) : Pas de traitement curatif. Utilisation de semences certifiées exemptes de virus, gestion des vecteurs."),
              buildMedicamentText("Powdery Mildew (Oïdium) : Fongicides sulfurés, fongicides à base de bicarbonate de potassium."),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMedicamentText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
