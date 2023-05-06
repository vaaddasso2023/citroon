import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class FertilizerPage extends StatefulWidget {
  const FertilizerPage({Key? key}) : super(key: key);

  @override
  State<FertilizerPage> createState() => _FertilizerPageState();
}

class _FertilizerPageState extends State<FertilizerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Engrais'),
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child:  Center(
          child: Text("Engrais"),
        ),
      ),
    );
  }
}
