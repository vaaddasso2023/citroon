import 'package:flutter/material.dart';

class HerbicidesPage extends StatefulWidget {
  const HerbicidesPage({Key? key}) : super(key: key);

  @override
  State<HerbicidesPage> createState() => _HerbicidesPageState();
}

class _HerbicidesPageState extends State<HerbicidesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: const Text('Herbicides'),
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
          child: Text("Herbicides"),
        ),
      ),
    );
  }
}
