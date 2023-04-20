import 'dart:async';
import 'package:flutter/material.dart';
import 'semences.dart';
import 'utils/colors_utils.dart';

class AllproductPage extends StatefulWidget {
  const AllproductPage({Key? key}) : super(key: key);

  @override
  State<AllproductPage> createState() => _AllproductPageState();
}

class _AllproductPageState extends State<AllproductPage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("f9f9f9"),
              hexStringToColor("e3f4d7"),
              hexStringToColor("f9f9f9")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter
            )),

        child: Column(

            children: [
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text('Titre ou nom du produit'),
                        subtitle:
                        Text('Ici vous trouverez un petit descriptif de votre produit.'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text('Titre ou nom du produit'),
                        subtitle:
                        Text('Ici vous trouverez un petit descriptif de votre produit.'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text('Titre ou nom du produit'),
                        subtitle:
                        Text('Ici vous trouverez un petit descriptif de votre produit.'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text('Titre ou nom du produit'),
                        subtitle:
                        Text('Ici vous trouverez un petit descriptif de votre produit.'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text('Titre ou nom du produit'),
                        subtitle:
                        Text('Ici vous trouverez un petit descriptif de votre produit.'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text('Titre ou nom du produit'),
                        subtitle:
                        Text('Ici vous trouverez un petit descriptif de votre produit.'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text('Titre ou nom du produit'),
                        subtitle:
                        Text('Ici vous trouverez un petit descriptif de votre produit.'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.0),
                height: 130.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_circle_left_rounded),
                      color: Colors.lightGreen,
                      onPressed: () {
                        _controller.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                    ),
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        children: [
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: 110.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: 110.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: 110.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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

                        GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SeedPage()),
                                );
                              },

                          child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              ),
                            child: Container(
                              width: 110.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                    IconButton(
                      icon: Icon(Icons.arrow_circle_right_rounded),
                      color: Colors.lightGreen,
                      onPressed: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
