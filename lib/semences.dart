
import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class SeedPage extends StatefulWidget {
  const SeedPage({Key? key}) : super(key: key);

  @override
  State<SeedPage> createState() => _SeedPageState();
}

class _SeedPageState extends State<SeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Semences'),
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
          child: Text("Semences"),
        ),
      ),
    );
  }
}
