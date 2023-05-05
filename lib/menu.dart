/*import 'dart:async';

import 'package:card_loading/card_loading.dart';
import 'package:citroon/engrais.dart';
import 'package:citroon/semences.dart';
import 'package:citroon/touslesproduits.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'help.dart';
import 'herbicides.dart';
import 'info.dart';
import 'machinerie.dart';
import 'main.dart';
import 'my_drawer_header.dart';
import 'pesticides.dart';
import 'provende.dart';
import 'utils/user_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final PageController _controller = PageController(initialPage: 0);
  bool isConnected = false;
  var currentPage = DrawerSections.touslesproduits;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  int _currentPage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      isLoading = false;
    });
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[600],
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
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("f9f9f9"),
              hexStringToColor("e3f4d7"),
              hexStringToColor("f9f9f9")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter
            )),
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              child:
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 15.0),
                color: Colors.green,

                child: SizedBox(
                  width: double.maxFinite,
                  child: isLoading
                      ? const CardLoading(
                    height: 100,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    margin: EdgeInsets.only(bottom: 0),
                  )
                  : Stack(
                     children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                      child: Icon(Icons.cloudy_snowing,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 0,
                      top: 10,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Mettre ici la Météo',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                     ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
          Expanded(
            child: ResponsiveGridList (
              minItemWidth: 165,
              horizontalGridMargin: 1,
              verticalGridMargin: 1,
              children: [
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=> AllproductPage()),
                  );
                },
                child: Card(
                  elevation: 5.0,
                  child:
                  SizedBox(
                    width: 110.0,
                    child: isLoading
                        ? const CardLoading(
                      height: 100,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      margin: EdgeInsets.only(bottom: 0),
                    )
                    : Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                          child: Icon(Icons.dashboard_outlined,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 0,
                        top: 10,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Tout',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                     ],
                   ),
                 ),
             ),
              ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> HerbicidesPage()),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child:
                    SizedBox(
                      width: 110.0,
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                      : Stack(
                           children: [
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                            child: Icon(Icons.macro_off_outlined,
                              size: 30,
                              color: Colors.black45,
                            ),
                          ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 0,
                          top: 10,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Herbicides',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=> PesticidesPage()),
                  );
                },
                child: Card(
                  elevation: 5.0,
                  child:
                  SizedBox(
                    width: 110.0,
                    child: isLoading
                        ? const CardLoading(
                      height: 100,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      margin: EdgeInsets.only(bottom: 0),
                    )
                    : Stack(
                      children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                        child: Icon(Icons.pest_control_outlined,
                          size: 30,
                          color: Colors.black45,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 0,
                        top: 10,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Pesticides',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                     ],
                   ),
                  ),
                ),
              ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> SeedPage()),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child:
                    SizedBox(
                      width: 110.0,
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                      : Stack(
                        children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                          child: Icon(Icons.spa_outlined,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 0,
                          top: 10,
                          child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Semences',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> FertilizerPage()),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child:
                    SizedBox(
                      width: 110.0,
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                      : Stack(
                          children: [
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                            child: Icon(Icons.compost_outlined,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 0,
                          top: 10,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                                child: const Text(
                                  'Engrais',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> FeedPage()),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child:
                    SizedBox(
                      width: 110.0,
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                      : Stack(
                          children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.pets_outlined,
                                size: 30,
                                color: Colors.green,
                              ),
                            ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 0,
                          top: 10,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                                child: const Text(
                                  'Provende',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> MachinePage()),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child:
                    SizedBox(
                      width: 110.0,
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                      : Stack(
                          children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.agriculture_outlined,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 0,
                          top: 10,
                          child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Machinerie',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> InfoPage()),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child:
                    SizedBox(
                      width: 110.0,
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                      : Stack(
                          children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.touch_app,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 0,
                          top: 10,
                          child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'A propos',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> HelpPage()
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    child:
                    SizedBox(
                      width: 110.0,
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                          : Stack(
                              children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                  child: Icon(Icons.help_outline_outlined,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 0,
                              top: 10,
                              child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Aide',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                ),
               ],
           ),
          ),

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.maxFinite,
                child: Center(
                  child: Text(
                    'Prenez ici votre citroon, guérissez.',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              height: 170.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /*IconButton(
                    icon: const Icon(Icons.arrow_circle_left_rounded),
                    color: Colors.lightGreen,
                    onPressed: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),*/
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      children: [
                        Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: 110.0,
                            child: isLoading
                                ? CardLoading(
                              height: 100,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              margin: EdgeInsets.only(bottom: 0),
                            )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                  Expanded(
                                    child: Image(
                                      image: AssetImage('assets/images/herbicide.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: 110.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Expanded(
                                  child: Image(
                                    image: AssetImage('assets/images/pesticide.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: 110.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Expanded(
                                  child: Image(
                                    image: AssetImage('assets/images/engrais.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(child:
                          Column(
                            children: [
                            Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: 110.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage('assets/images/herbicide.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: 110.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage('assets/images/pesticide.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: 110.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage('assets/images/engrais.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SeedPage()),
                            );
                          },

                          child: Card(
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SizedBox(
                              width: 110.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Expanded(
                                    child: Image(
                                      image: AssetImage('assets/images/semence.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                    ),
                  ),
                  /*IconButton(
                    icon: const Icon(Icons.arrow_circle_right_rounded),
                    color: Colors.lightGreen,
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),*/
                ],
              ),
            ),
          ],
       ),
     ),
    );
  }
}*/
