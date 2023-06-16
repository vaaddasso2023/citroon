import 'dart:async';
import 'dart:convert';
import 'package:card_loading/card_loading.dart';
import 'package:citroon/productdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'utils/colors_utils.dart';

class AllproductPage extends StatefulWidget {
  const AllproductPage({Key? key}) : super(key: key);

  @override
  State<AllproductPage> createState() => _AllproductPageState();
}

class _AllproductPageState extends State<AllproductPage> {
  late Stream<QuerySnapshot> _stream;
  final _reference = FirebaseFirestore.instance.collection('intrants');
  bool isLoading = true;
  int _selectedIndex = 0;
  Color _selectedIconColor =  hexStringToColor("2f6241");
  bool isLoadingImage = true;

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.all_out_outlined,),
      label: 'Tout',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart_outlined),
      label: 'Panier',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite_outline_outlined),
      label: 'Favoris',
    ),
  ];


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
        case 2:
          _selectedIconColor = hexStringToColor("2f6241");
          break;
        default:
          _selectedIconColor = hexStringToColor("2f6241");
      }
    });
  }



  @override
  void initState() {
    super.initState();
    _stream = _reference.snapshots();
    isLoading = true;
  }


  List<Favorite> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List<Favorite> favorites = listDocs.map((e) {
      double price;
      if (e['price'] is double) {
        price = e['price'];
      } else {
        try {
          price = double.parse(e['price']);
        } catch (e) {
          price = 0.0; // Set a default value when the parsing fails
        }
      }
      return Favorite(
        productName: e['productname'],
        productDescription: e['description'],
        productPrice:e['price'],
        productImage: e['photo'],
        productType: e['producttype'],
        isFavorite: e['isFavorite'] ?? false,
      );
    }).toList();
    return favorites;
  }



  Future<void> saveFavorites(List<Favorite> favorites) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> favoriteStrings = favorites.map((favorite) => jsonEncode(favorite)).toList();

    await prefs.setStringList('favorites', favoriteStrings);
  }

  void toggleFavorite(Favorite favorite) {
    setState(() {
      favorite.isFavorite = !favorite.isFavorite;
    });
  }


  String generateProductDetailsLink() {
    String baseUrl = 'https://vaadd.page.link/citroon'; // Replace with your own Dynamic Links domain

    String productName = Uri.encodeQueryComponent(['itemProductName'].toString());
     String productImage = Uri.encodeQueryComponent(['itemProductImage'].toString());


    String dynamicLink = '$baseUrl/?productName=$productName&productImage=$productImage'; // &productId=$productId;

   // String dynamicLink = '$baseUrl/?productName=$productName&productImage=$productImage';
    return dynamicLink;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:hexStringToColor("2f6241"),
        title: const Text('Tous les intrants'),
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            padding: const EdgeInsets.only(right: 25.0),
            onPressed: () {
              // do something when the search button is pressed
            },
          ),
        ],
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
            Expanded(

              child: StreamBuilder<QuerySnapshot>(
                  stream: _stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                //Check error
                if (snapshot.hasError) {
                return Center(child: Text('Some error occurred ${snapshot.error}'));
                }
                //Check if data arrived
                if (snapshot.hasData) {
                //get the data
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                //Convert the documents to Maps
                List<Map> items = documents.map((e) =>
                {
                    'id': e.id,
                    'itemProductName' : e['productname'],
                    'itemProductDescription': e['description'],
                    'itemProductPrice': e['price'],
                    'itemProductImage': e['photo'],
                    'itemProductType': e['producttype'],

                }).toList();
                return ResponsiveGridList(
                  minItemWidth: 170,
                  children: List.generate(items.length, (index) {
                    var thisItem = items[index];
                    Favorite favorite = Favorite.fromJson({
                      'productName': thisItem['itemProductName'] as String,
                      'productDescription': thisItem['itemProductDescription'] as String,
                      'productPrice': thisItem['itemProductPrice'],
                      'productImage': thisItem['itemProductImage'] as String,
                      'productType': thisItem['itemProductType'] as String,
                    });
                    return Stack(
                      children: [
                        Card(
                          elevation: 3.0,
                          margin: const EdgeInsets.all(10.0),
                          child: isLoading
                              ? const CardLoading(height: 180)
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>  ProductDetailsPage(thisItem),
                                      transitionDuration: const Duration(milliseconds: 100), // Augmentez la durée de l'animation
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1, 0), // Position de départ (tout à droite)
                                            end: Offset.zero, // Position finale (tout à gauche)
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );

                                },
                                child: SizedBox(
                                  height: 150.0,
                                  child: Image.network(
                                    '${thisItem['itemProductImage']}',
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        isLoadingImage = false; // Chargement terminé
                                        return child;
                                      } else {
                                        isLoadingImage = true; // Chargement en cours
                                        return const CardLoading(height: 180); // Afficher le CardLoading pendant le chargement
                                      }
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      '${thisItem['itemProductName']}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                    child: const Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  '${thisItem['itemProductDescription']}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                       Padding(
                                         padding: const EdgeInsets.all(16.0),
                                         child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
                                      decoration: BoxDecoration(
                                          color:  Colors.grey[300],// hexStringToColor("2f6241")
                                          borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Text(
                                          '${thisItem['itemProductType']}',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                      ),
                                         ),
                                       ),
                                    Container(
                                        child: IconButton(
                                          icon: Icon(
                                            favorite.isFavorite ? Icons.favorite : Icons.favorite_outline,
                                            color: favorite.isFavorite ? Colors.green : Colors.grey,
                                          ),
                                          onPressed: () {
                                            toggleFavorite(favorite);
                                          },
                                        ),

                                    ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.share_rounded,
                                              color: Colors.green,
                                              size: 25,
                                            ),
                                            onPressed: () {
                                            String dynamicLink = generateProductDetailsLink();
                                            String productName = '${thisItem['itemProductName']}';
                                            String sharedText = '$productName\n$dynamicLink';
                                            // Vous pouvez personnaliser sharedText selon vos besoins

                                            Share.share(sharedText);
                                            },
                                          ),

                                        ),

                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),

                        Positioned(
                          top: 35,
                          right: 30,
                          child:
                          isLoading
                              ? const CardLoading(height: 50)
                              : Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${thisItem['itemProductPrice']} FCFA',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                );

                }
                      return const Center(child: CircularProgressIndicator());
                  }
              )
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        // backgroundColor: ,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavigationItemTapped,
        items: _bottomNavigationBarItems,
        selectedItemColor: _selectedIconColor,
      ),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// Classe Favorite

class Favorite {
  final String productName;
  final String productDescription;
  final String productPrice;
  final String productImage;
  final String productType;
  bool isFavorite;

// Ajoutez un getter pour récupérer la valeur du favori
  bool get favorite => isFavorite;

// Ajoutez un setter pour modifier la valeur du favori
  set favorite(bool value) {
    isFavorite = value;
  }


  Favorite({
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImage,
    required this.productType,
    this.isFavorite = false,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      productName: json['productName'],
      productDescription: json['productDescription'],
      productPrice: json['productPrice'], // Parse the string as double
      productImage: json['productImage'],
      productType: json['productType'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productDescription': productDescription,
      'productPrice': productPrice.toString(), // Convert double to string
      'productImage': productImage,
      'productType': productType,
      'isFavorite': isFavorite,
    };
  }
}




