import 'dart:async';
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late Stream<QuerySnapshot> _stream;
  final _reference = FirebaseFirestore.instance.collection('intrants');
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _stream = _reference.snapshots();
  }

  List<Map> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List<Map> listItems = listDocs
        .map((e) => {'itemProductName': e['productname'],
        'itemProductDescription': e['description'],
        'itemProductPrice': e['price'],
        'itemProductImage': e['photo'],
        })
        .toList();
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
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
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            padding: EdgeInsets.only(right: 25.0),
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
                }).toList();
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = items[index];
                    return Card(
                      elevation: 3.0,
                      margin: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 60.0),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Image.network(
                                '${thisItem['itemProductImage']}',
                                fit: BoxFit.cover,
                              ),
                                const SizedBox(height: 5),
                                Text('${thisItem['itemProductName']}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${thisItem['itemProductDescription']}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
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
                    );

                  },
                );
                }
                      return const Center(child: CircularProgressIndicator());
                  }
              )
            ),

          ],
        ),
      ),
    );
  }
}