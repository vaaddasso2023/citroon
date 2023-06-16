import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<dynamic, dynamic> thisItem;
  ProductDetailsPage(this.thisItem, {Key? key}) : super(key: key);
  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedIndex = 0;
  Color _selectedIconColor =  hexStringToColor("2f6241");
  late final String videoId; // ID de la vidéo YouTube
  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.help_outline_outlined,),
      label: 'Aide',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_on_outlined),
      label: 'Notification',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.contact_emergency_outlined),
      label: 'Contact',
    ),
  ];

  late String appBarTitle;

  @override
  void initState() {
    super.initState();
    appBarTitle = widget.thisItem['itemProductName'].toString();
  }

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _selectedIconColor = hexStringToColor("2f6241");
          break;
        case 1:
          _selectedIconColor = hexStringToColor("2f6241");
          break;
        default:
          _selectedIconColor = hexStringToColor("2f6241");
      }
    });
  }

  /* String generateProductDetailsLink() {
    // Remplacez cette logique par la génération de votre propre lien dynamique
    String baseUrl =  'https://vaadd.page.link/citroon/ProductDetailsPage/';
    String productname = '${widget.thisItem['itemProductName']}'.toString();
    return baseUrl + productname;
  } */

  /*String generateProductDetailsLink() {
    // Utilisez votre propre Dynamic Links domain
    String baseUrl = 'https://vaadd.page.link/citroon';

    // Paramètres personnalisés que vous souhaitez inclure dans le lien
    Map<String, String> linkParameters = {
      'productName': widget.thisItem['itemProductName'].toString(),
      'productId': widget.thisItem['productId'].toString(),
    };

    // Générer le lien dynamique avec les paramètres
    String dynamicLink = '$baseUrl/?${Uri.encodeQueryComponent(linkParameters)}';

    return dynamicLink;
  }*/

  String generateProductDetailsLink() {
    String baseUrl = 'https://vaadd.page.link/citroon'; // Replace with your own Dynamic Links domain

    String productName = Uri.encodeQueryComponent(widget.thisItem['itemProductName'].toString());
   // String productId = Uri.encodeQueryComponent(widget.thisItem['itemProductImage'].toString());


    String dynamicLink = '$baseUrl/?productName=$productName'; // &productId=$productId;

    return dynamicLink;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: Text('${widget.thisItem['itemProductName']}'),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                String productDetailsLink = generateProductDetailsLink();
                Share.share(productDetailsLink);
              },
            ),
          ),

          /*Container(
            padding: EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () {
                String pageUrl = 'https://vaadd.page.link/citroon/ProductDetailsPage'; // URL de la page à ouvrir (remplacez par votre URL dynamique)
                _launchURL(pageUrl); // Ouvrir l'URL dans le navigateur
              },
            ),
          ),*/
        ],
      ),


      body: Column(
        children: [
          SizedBox(
            height: 150.0,
            width: double.infinity,
            child: Image.network(
              '${widget.thisItem['itemProductImage']}',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                child: Text(
                '${widget.thisItem['itemProductName']}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: const Icon(
                  Icons.verified,
                  color: Colors.green,
                  size: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${widget.thisItem['itemProductPrice']} FCFA',
                    style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 5.0),
               Container(
                 padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
                 child: Text(
                  '${widget.thisItem['itemProductDescription']}',
                   overflow: TextOverflow.ellipsis,
                   maxLines: 6,
                   style: const TextStyle(
                   color: Colors.black54,
                   fontSize: 13,
                   ),
                 ),
               ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        hexStringToColor("f9f9f9"),
                        hexStringToColor("e3f4d7"),
                        hexStringToColor("f9f9f9")
                      ], begin: Alignment.topCenter, end: Alignment.bottomCenter
                      )
                  ),
                  child: Column(
                     children: [
                       BottomAppBar(
                         child: CustomPaint(
                           painter: _BottomAppBarBorderPainter(_selectedIndex), // Utilisez le painter personnalisé
                           child: BottomNavigationBar(
                             elevation: 2,
                             backgroundColor: Colors.grey[150],
                             selectedItemColor: hexStringToColor("2f6241"),
                             unselectedItemColor: Colors.grey,
                             currentIndex: _selectedIndex,
                             onTap: _onBottomNavigationItemTapped,
                             showSelectedLabels: true,
                             showUnselectedLabels: true,
                             selectedIconTheme: const IconThemeData(size: 24),
                             unselectedIconTheme: const IconThemeData(size: 24),
                             items: const [
                               BottomNavigationBarItem(
                                 icon: Icon(Icons.dataset),
                                 label: 'Utilisation',
                               ),
                               BottomNavigationBarItem(
                                 icon: Icon(Icons.read_more_outlined),
                                 label: 'Intrants similaires',
                               ),
                             ],
                           ),
                         ),
                       ),

                       const SizedBox(height: 10.0),

                       IndexedStack(
                         index: _selectedIndex,
                         children: [
                           // Tab de Utilisation
                           Column(
                             children: [
                               const SizedBox(height: 20.0),
                               Container(
                                 child: const Center(
                                   child: Text(
                                     'Tableau des spécifications',
                                     style: TextStyle(
                                       color: Colors.black54,
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16,
                                     ),
                                   ),
                                 ),
                               ),
                               Container(
                                 padding: const EdgeInsets.all(15.0),
                                 child: Table(
                                   border: TableBorder.all(),
                                   children: [
                                     TableRow(
                                       children: [
                                         TableCell(
                                           child: Padding(
                                             padding: EdgeInsets.all(8.0),
                                             child: Center(
                                               child: Text('LIBELLE'),
                                             ),
                                           ),
                                         ),
                                         TableCell(
                                           child: Padding(
                                             padding: EdgeInsets.all(8.0),
                                             child: Center(
                                               child: Text('SPECIFICATIONS'),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                     TableRow(
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Présentation'),
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('...'),
                                           ),
                                         ),
                                       ],
                                     ),
                                     TableRow(
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Type d\'intrant'),
                                           ),
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('${widget.thisItem['itemProductType']}'),
                                           ),
                                         ),
                                       ],
                                     ),
                                     TableRow(
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Nature de l\'intrant'),
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Nature liquide ?'),
                                           ),
                                         ),
                                       ],
                                     ),
                                     TableRow(
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Dosage / application'),
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Ligne 4, Colonne 2'),
                                           ),
                                         ),
                                       ],
                                     ),
                                     TableRow(
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Composition'),
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Ligne 5, Colonne 2'),
                                           ),
                                         ),
                                       ],
                                     ),
                                     TableRow(
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('Certification.s'),
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.all(8.0),
                                           child: Center(
                                             child: Text('...'),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ],
                                 ),
                               ),
                               const SizedBox(height: 10.0),
                               const Text(
                                 'La fiche technique',
                                 style: TextStyle(
                                   color: Colors.black54,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 16,
                                 ),
                               ),
                               const SizedBox(height: 10.0),
                               const Icon(Icons.cloud_download_outlined),
                               const SizedBox(height: 5),
                               const Text(
                                 'Télécharger',
                                 style: TextStyle(
                                   color: Colors.grey,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 16,
                                 ),
                               ),
                               const SizedBox(height: 10.0),
                               /* const Text('Tutoriel youtube',
             style: TextStyle(
               color: Colors.black54,
               fontWeight: FontWeight.bold,
               fontSize: 16,),
           ),*/
                               Center(
                                 child: Container(
                                   width: 300, // Largeur personnalisée
                                   height: 200, // Hauteur personnalisée
                                   margin: const EdgeInsets.all(10), // Marge personnalisée
                                   color: Colors.grey[300], // Couleur de fond personnalisée
                                 ),
                               ),
                               const SizedBox(height: 15.0),
                               const Text(
                                 'Tutoriel audio',
                                 style: TextStyle(
                                   color: Colors.black54,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 16,
                                 ),
                               ),
                               const SizedBox(height: 100.0),
                             ],
                           ),
                           // Tab Intrants similaires
                           Column(
                             children: [
                               Container(
                                 child: const Center(
                                   child: Text('Intrants similaires'),
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action à effectuer lorsque le FloatingActionButton est cliqué
        },
        backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey;
          }
          return Colors.lightGreen;
        }),
        label: const Text('Commander'),
        icon: const Icon(Icons.shopping_cart_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _BottomAppBarBorderPainter extends CustomPainter {
  final int selectedIndex;

  _BottomAppBarBorderPainter(this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green // Couleur de la bordure lorsque l'élément est sélectionné
      ..strokeWidth = 5.0;

    final double itemWidth = size.width / 2; // Calculer la largeur de chaque élément

    // Dessiner la bordure autour de l'élément sélectionné
    canvas.drawLine(
      Offset(itemWidth * selectedIndex, size.height),
      Offset(itemWidth * (selectedIndex + 1), size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

