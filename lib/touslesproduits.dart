import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
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
    return  Scaffold(
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
              Expanded(
                child: ResponsiveGridList (
                  minItemWidth: 165,
                  horizontalGridMargin: 2,
                  verticalGridMargin: 2,
                  children: [
                    Card(
                      child: Stack(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 60.0),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                FlutterLogo(size:48.0),
                                SizedBox(height: 5),
                                Text('Ecopticide',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Expanded(
                                  child: Text(
                                    'Ceci est un produit venu de jupiter pour guérir la terre des ses maux ',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),

                                  ),
                                ),
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Télécharger la fiche technique ?',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Télécharger le PDF ici
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Télécharger'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.cloud_download_outlined),
                                    SizedBox(height: 5),
                                    Text('Fiche',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'XOF 20 000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 10,
                            left: 10,
                            child: Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                height: 130.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_left_rounded),
                      color: Colors.lightGreen,
                      onPressed: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 500),
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
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_right_rounded),
                      color: Colors.lightGreen,
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
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
