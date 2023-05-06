import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class PesticidesPage extends StatefulWidget {
  const PesticidesPage({Key? key}) : super(key: key);

  @override
  State<PesticidesPage> createState() => _PesticidesPageState();
}

class _PesticidesPageState extends State<PesticidesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Pesticides'),
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
          child: Text("Pesticides"),
        ),
      ),
    );
  }
}
