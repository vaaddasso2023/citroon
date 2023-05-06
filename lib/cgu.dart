import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CguPage extends StatefulWidget {
  const CguPage({Key? key}) : super(key: key);

  @override
  State<CguPage> createState() => _CguPageState();
}

class _CguPageState extends State<CguPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('CITROON'),
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
          child: Text("C G U"),
        ),
      ),
    );
  }
}
