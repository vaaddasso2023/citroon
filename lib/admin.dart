import 'dart:io';
import 'package:citroon/notifications.dart';
import 'package:citroon/parameter.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'addproduct.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 1;
  Color _selectedIconColor =  hexStringToColor("2f6241");
  String userId = FirebaseAuth.instance.currentUser!.uid;
  int unreadNotificationsCount = 0;

  List<DropdownMenuItem<String>> listproduit=[];
  final TextEditingController _controllerVendorName=TextEditingController();
  final TextEditingController _controllerOrganizationName=TextEditingController();
 /* final TextEditingController _controllerTelephone=TextEditingController();
  final TextEditingController _controllerProductName=TextEditingController();
  final TextEditingController _controllerProductDescription=TextEditingController();
  final TextEditingController _controllerProductPrice=TextEditingController(); */

  final CollectionReference _referenceIntrants = FirebaseFirestore.instance.collection('intrants');
  late Stream<QuerySnapshot> _streamIntrants;
  bool isEditing = false;
 // String? _documentId;
  String documentId = '';
  File? file;
  ImagePicker image = ImagePicker();
 // String? _selectedProduct;
  Map<String, dynamic> updatedData = {};
  List<Map<String, dynamic>> userDocuments = [];


  void produits()
  {
    listproduit.clear();
    listproduit.add(
      const DropdownMenuItem(
        value: 'Engrais',
        child: Text(
          'Engrais', style: TextStyle(
            color: Colors.black54
        ),
        ),
      ),
    );
    listproduit.add(
      const DropdownMenuItem(
        value: 'Semence',
        child: Text(
          'Semences', style: TextStyle(
            color: Colors.black54
        ),
        ),),
    );
    listproduit.add(
      const DropdownMenuItem(
        value: 'Herbicide',
        child: Text(
          'Herbicides', style: TextStyle(
            color: Colors.black54
        ),
        ),),
    );
    listproduit.add(
      const DropdownMenuItem(
        value: 'Pesticide',
        child: Text(
          'Pesticides', style: TextStyle(
            color: Colors.black54
        ),
        ),),
    );
    listproduit.add(
      const DropdownMenuItem(
        value: 'Provende',
        child: Text(
          'Provende', style: TextStyle(
            color: Colors.black54
        ),
        ),),
    );
    listproduit.add(
      const DropdownMenuItem(
        value: 'Machine',
        child: Text(
          'Machines', style: TextStyle(
            color: Colors.black54
        ),
        ),),
    );
  }

 // final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;
  late Uint8List imageFile;
  /* bool ? _isChecked = false;
  String? _nomVendeur ;
  String? _nomOrganisation ;
  String? _telephone ;
  String? _nomProduit ;
  String? _descriptionProduit;
  String? _price;
  String? _photoUrl; */
  String itemName = '';
  String itemOrganization = '';

  void loadUserDocuments() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('intrants')
        .where('userId', isEqualTo: userId)
        .get();

    List<DocumentSnapshot> documents = querySnapshot.docs;

    // Vider la liste existante
    userDocuments.clear();
    editableUserDocuments.clear();

    // Récupérer les données de chaque document
    for (DocumentSnapshot document in documents) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      userDocuments.add(data);
      editableUserDocuments.add(Map<String, dynamic>.from(data));
    }

    // Rafraîchir l'interface utilisateur pour afficher les données mises à jour
    setState(() {});
  }

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }
  List<Map<String, dynamic>> editableUserDocuments = [];
  void saveChanges() {
    // Parcourir les données modifiables et les enregistrer dans Firestore
    for (int i = 0; i < userDocuments.length; i++) {
      Map<String, dynamic> documentData = userDocuments[i];
      Map<String, dynamic> editableData = editableUserDocuments[i];

      if (editableData != documentData) {
        // Effectuer les modifications dans Firestore en utilisant documentId
        // et les données modifiées dans editableData
      }
    }

    setState(() {
      isEditing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserDocuments();
    _streamIntrants = _referenceIntrants.snapshots();
  }

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_3_rounded,),
      label: 'Utilisateur',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.input_outlined),
      label: 'Mes intrants',
    ),
    /*const BottomNavigationBarItem(
      icon: Icon(Icons.help_outline_outlined),
      label: 'Aide',
    ),*/
  ];

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const ParameterPage(),
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

  Future<List<DocumentSnapshot>> getDocumentsForCurrentUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('intrants')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs;
  }

  void updateDocument() async {
    // Vérifier si un ID de document est disponible
    if (documentId.isNotEmpty) {
      // Récupérer les nouvelles valeurs des champs de formulaire
      String newName = _controllerVendorName.text;
      String newOrganization = _controllerOrganizationName.text;
      // ... autres champs de formulaire mis à jour

      // Mettre à jour les données dans updatedData
      updatedData = {
        'name': newName,
        'organisation': newOrganization,
        // ... autres champs de données mis à jour
      };

      // Mettre à jour le document dans Firestore
      await FirebaseFirestore.instance
          .collection('intrants')
          .doc(documentId)
          .update(updatedData);

      // Reste du code après la mise à jour du document
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
      title: const Text('Paramètres'),
        elevation: 5,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_active_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>  NotificationsPage(),
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
                ),
                if (unreadNotificationsCount > 0)
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadNotificationsCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
       leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
         // Navigator.of(context).popUntil((route) => route.isFirst);
           Navigator.of(context).pop();
          },
        ),
      ),

      body: Stack(
        children: [
          ListView.builder(
            itemCount: userDocuments.isNotEmpty ? userDocuments.length : 1, // Vérifier si la liste n'est pas vide
            itemBuilder: (context, index) {
              if (userDocuments.isEmpty) {
                // Liste vide, afficher l'image
                return Container(
                    padding: const EdgeInsets.fromLTRB(80.0, 200.0, 80.0, 0.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          hexStringToColor("f9f9f9"),
                          hexStringToColor("e3f4d7"),
                          hexStringToColor("f9f9f9"),
                        ], begin: Alignment.topCenter, end: Alignment.bottomCenter
                        )
                    ),
                    child: Center(child: Image.asset('assets/images/zerop.png')));
              }

              // Map<String, dynamic> documentData = userDocuments[index];
              Map<String, dynamic> editableData = editableUserDocuments[index];

              // Extraire les champs éditables
              String itemName = editableData['name'];
              String itemOrganization = editableData['organisation'];
              int documentNumber = index + 1;
              void updateItemName(String value) {
                editableData['name'] = value;
              }
              void updateItemOrganization(String value) {
                editableData['organisation'] = value;
              }
              return Card(
                margin: const EdgeInsets.all(10.0),
                elevation: 3.0,
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                        decoration: BoxDecoration(
                          color: hexStringToColor("2f6241"),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Intrant n° $documentNumber',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nom du vendeur',
                        ),
                        initialValue: itemName,
                        enabled: isEditing,
                        onChanged: updateItemName,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Organisation',
                        ),
                        initialValue: itemOrganization,
                        enabled: isEditing,
                        onChanged: updateItemOrganization,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16, // Modifier la position verticale selon vos besoins
            left: 16, // Modifier la position horizontale selon vos besoins
            child: FloatingActionButton.extended(
              icon: const Icon(Icons.add_task_outlined),
              label: const Text('Ajouter'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const AddProductPage(),
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
              backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.grey;
                }
                return Colors.lightGreen;
              }),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        // backgroundColor: hexStringToColor("2f6241"),
        backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey;
          }
          return Colors.lightGreen;
        }),
        onPressed: isEditing ? saveChanges : startEditing,
        label: Text(isEditing ? 'Enregistrer' : 'Modifier'),
        icon: Icon(isEditing ? Icons.save : Icons.edit),
      ),

      // Navigation de bas de page
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        //backgroundColor:hexStringToColor("2f6241"),
        currentIndex: _selectedIndex,
        onTap: _onBottomNavigationItemTapped,
        items: _bottomNavigationBarItems,
        selectedItemColor: _selectedIconColor,
      ),
    );
  }
}
