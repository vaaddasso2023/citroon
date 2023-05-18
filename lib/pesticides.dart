import 'package:card_loading/card_loading.dart';
import 'package:citroon/touslesproduits.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class PesticidesPage extends StatefulWidget {
  const PesticidesPage({Key? key}) : super(key: key);

  @override
  State<PesticidesPage> createState() => _PesticidesPageState();
}

class _PesticidesPageState extends State<PesticidesPage> {
  final _reference = FirebaseFirestore.instance.collection('intrants');
  late Stream<QuerySnapshot> _stream;
  int _selectedIndex = 0;
  bool isLoading = true;
  bool isFavorite = false;
  Color _selectedIconColor =  hexStringToColor("2f6241");

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.pest_control_outlined,),
      label: 'Pesticides',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_on_outlined),
      label: 'Notification',
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

  List<Map> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List<Map> listItems = listDocs
        .map((e) => {'itemProductName': e['productname'],
      'itemProductDescription': e['description'],
      'itemProductPrice': e['price'],
      'itemProductImage': e['photo'],
      'itemProductType': e['producttype'],
    })
        .toList();
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
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
                        List<Map> items = documents
                            .where((e) => e['producttype'].contains('Pesticide'))
                            .map((e) =>
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
                            Map thisItem = items[index];
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
                                      Image.network(
                                        '${thisItem['itemProductImage']}',
                                        fit: BoxFit.cover,
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
                                              Container(
                                                padding: EdgeInsets.only(left: 15.0),
                                                child: InkWell(
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
                                              Container(
                                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
                                                decoration: BoxDecoration(
                                                  color: hexStringToColor("2f6241"),
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                child: Text(
                                                  '${thisItem['itemProductType']}'.capitalize(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: IconButton(
                                                  icon: Icon(
                                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                                    color: Colors.green,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      isFavorite = !isFavorite;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                child: const Icon(
                                                  Icons.shopping_cart_outlined,
                                                  color: Colors.green,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  top: 35,
                                  right: 30,
                                  child: Container(
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
