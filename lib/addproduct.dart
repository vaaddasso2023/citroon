import 'dart:core';
import 'dart:typed_data';
import 'package:citroon/parameter.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'admin.dart';
import 'package:path/path.dart' as path;



class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isUploading = false;
  List<DropdownMenuItem<String>> listproduit=[];
  int _selectedIndex = 0;
  Color _selectedIconColor =  hexStringToColor("2f6241");
  final TextEditingController _controllerVendorName=TextEditingController();
  final TextEditingController _controllerOrganizationName=TextEditingController();
  final TextEditingController _controllerTelephone=TextEditingController();
  final TextEditingController _controllerProductName=TextEditingController();
  final TextEditingController _controllerProductDescription=TextEditingController();
  final TextEditingController _controllerProductPrice=TextEditingController();
  final CollectionReference _referenceIntrants = FirebaseFirestore.instance.collection('intrants');
  late Stream<QuerySnapshot> _streamIntrants;

  PlatformFile? _selectedFile;
  File? file;
  ImagePicker image = ImagePicker();
  String? _selectedProduct;
  bool _isUploading = false;

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.keyboard_option_key_outlined,),
      label: 'Option',
    ),
    /*const BottomNavigationBarItem(
      icon: Icon(Icons.keyboard_option_key_outlined,),
      label: 'Mes intrants',
    ),*/
    const BottomNavigationBarItem(
      icon: Icon(Icons.input_outlined),
      label: 'Mes intrants',
    ),
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
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AdminPage(),
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
        default:
          _selectedIconColor = hexStringToColor("2f6241");
      }
    });
  }

  void produits()
  {
  listproduit.clear();
  listproduit.add(
      const DropdownMenuItem(
        value: 'engrais',
          child: Text(
            'Engrais', style: TextStyle(
              color: Colors.black54
          ),
          ),
      ),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'semence',
      child: Text(
        'Semences', style: TextStyle(
          color: Colors.black54
      ),
      ),),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'herbicide',
      child: Text(
        'Herbicides', style: TextStyle(
          color: Colors.black54
      ),
      ),),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'pesticide',
      child: Text(
        'Pesticides', style: TextStyle(
          color: Colors.black54
      ),
      ),),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'provende',
      child: Text(
        'Provende', style: TextStyle(
          color: Colors.black54
      ),
      ),),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'machine',
      child: Text(
        'Machines', style: TextStyle(
          color: Colors.black54
      ),
      ),),
  );
}



final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;
  bool pdfAvailable = false;
  late Uint8List imageFile;
  bool ? _isChecked = false;
  String? _nomVendeur ;
  String? _nomOrganisation ;
  String? _telephone ;
  String? _nomProduit ;
  String? _descriptionProduit;
  String? _price;
  String? _photoUrl;
  String? _pdfUrl;
  late List<int> _pdfBytes;
  //late  pdfFile;
  //File pdfFile = File("Uint8List");
  File? pdfFile;

  @override
  void initState() {
    super.initState();
   _streamIntrants = _referenceIntrants.snapshots();

  }
  @override
  Widget build(BuildContext context) {
    produits();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Ajouter un intrant'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _streamIntrants,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
            return Center(
                child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
              );
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
            }
            return SingleChildScrollView(
              child: Container(
                  margin: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        // Ajout de nom du vendeur
                        TextFormField(
                          controller: _controllerVendorName,
                          keyboardType: TextInputType.text,
                          initialValue: _nomVendeur,
                          decoration: const InputDecoration(
                            labelText: 'Nom complet',
                            hintText: 'Votre nom et prénom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vous devez compléter le champ";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _nomVendeur = value;
                          },
                        ),
                        // Ajout du nom de organisation
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: _controllerOrganizationName,
                          keyboardType: TextInputType.text,
                          initialValue: _nomOrganisation,
                          decoration: const InputDecoration(
                            labelText: 'Organisation',
                            hintText: 'Nom de votre organisation',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vous devez compléter le champ";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _nomOrganisation = value;
                          },
                        ),
                        // Ajout de numéro de téléphone
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: _controllerTelephone,
                          keyboardType: TextInputType.phone,
                          initialValue: _telephone,
                          decoration: const InputDecoration(
                            labelText: 'Téléphone',
                            hintText: 'Votre numéro de téléphone',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vous devez compléter le champ";
                            }
                            return null;
                            },
                            onSaved: (value) {
                              _telephone = value;
                            },
                          ),
                          // Ajout de nom du produit
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _controllerProductName,
                            keyboardType: TextInputType.text,
                            initialValue: _nomProduit,
                            decoration: const InputDecoration(
                            labelText: 'Nom de l\'intrant',
                            hintText: 'Le nom de votre produit',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vous devez compléter le champ nom du produit";
                            }
                            return null;
                          },
                            onSaved: (value) {
                              _nomProduit = value;
                            },
                        ),
                        // Description du produit
                        const SizedBox(height: 12,),
                            TextFormField(
                              controller: _controllerProductDescription,
                            keyboardType: TextInputType.multiline,
                              initialValue: _descriptionProduit,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'Décrivez en 10 mots votre produit',
                              border: OutlineInputBorder(),
                            ),
                          validator: (value) {
                            if (value == null || value.isEmpty){
                              return "Vous devez completer le champ nom du produit";
                            }
                            if (value.split(' ').length > 15) {
                              return 'La saisie doit être limitée à 15 mots';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _descriptionProduit = value;
                          },
                        ),
                        const SizedBox(height: 12,),
                          // Prix du produit
                          TextFormField(
                            controller: _controllerProductPrice,
                            keyboardType: TextInputType.number,
                            initialValue: _price,
                            decoration: const InputDecoration(
                              labelText: 'Prix',
                              hintText: 'Combien coûte le produit',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vous devez compléter le champ";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _price = value;
                              });

                            },
                          ),
                          // Ajout de nom du produit

                        // type de produit - début
                        const SizedBox(height: 12,),
                      // Liste déroulante
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: DropdownButton(
                                  value: _selectedProduct,
                                  items: listproduit,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Text(
                                    'Type d\'intrants', style: TextStyle(
                                      color: Colors.grey
                                  ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedProduct = value;
                                      state.didChange(value);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          onSaved: (value) {
                            _selectedProduct = value;
                          },
                        ),

                        const SizedBox(height: 12,),
                        // Type produit - fin
                        // Ajouter l'image du produit
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                    image: imageAvailable && imageFile != null
                                        ? DecorationImage(
                                      image: MemoryImage(imageFile),
                                      fit: BoxFit.cover,
                                    )
                                        : const DecorationImage(
                                      image: AssetImage(""),
                                    ),
                                  ),
                                  height: 80,
                                  width: 250,
                                  child: Stack(
                                    children: [
                                      !imageAvailable || imageFile == null
                                          ? const Center(
                                              child: Icon(Icons.photo, size: 40),
                                            )
                                          : const SizedBox(),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                    color: Colors.grey,
                                      size: 40,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      !imageAvailable || imageFile == null;
                                      imageAvailable = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),


                        const SizedBox(height: 12,),
                        Form(
                          child: GestureDetector(
                            onTap: () async {
                              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                final bytes = await image.readAsBytes();
                                setState(() {
                                  imageFile = bytes;
                                  imageAvailable = true;
                                });
                                final Reference storageReference = FirebaseStorage.instance
                                    .ref()
                                    .child('product_images')
                                    .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
                                // set a flag to indicate that the upload is in progress
                                setState(() {
                                  isUploading = true;
                                });
                                try {
                                  final UploadTask uploadTask = storageReference.putData(bytes);
                                  await uploadTask.whenComplete(() async {
                                    final url = await storageReference.getDownloadURL();
                                    setState(() {
                                      _photoUrl = url;
                                    });
                                  });
                                } catch (e) {
                                  // handle error and show error message to user
                                  setState(() {
                                    imageFile = Uint8List(0); // empty array of bytes
                                    imageAvailable = false;
                                    _photoUrl = null;
                                  });
                                }
                                setState(() {
                                  // reset the flag to indicate that the upload is complete
                                  isUploading = false;
                                });
                              }
                            },
                            child: Container(

                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 40,
                              child: Center(

                                child: isUploading
                                    ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                )
                                    : const Text("Choisir la photo du produit"),
                              ),
                            ),
                          ),
                        ),


                        const SizedBox(height: 12,),
                          // Précision sur la certification du produit
                        FormField(
                          initialValue: '',
                          onSaved: (value) {
                            _isChecked = value == 'true';
                          },
                          builder: (FormFieldState<String> state) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  checkColor: Colors.white,
                                  onChanged: (value) {
                                    _isChecked = value!;
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                const Text('Intrant certifié / homologué ?'),
                              ],
                            );
                          },
                        ),

                          // Ajout de fiche technique de l'intrant
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 80,
                                  width: 250,
                                  child: Stack(
                                    children: [
                                      pdfFile != null
                                          ? PDFView(
                                        filePath: pdfFile!.path, // Laisser vide pour charger à partir du fichier local
                                       // path: path.basename(pdfFile!.path), // Obtenir le nom du fichier à partir du chemin
                                        enableSwipe: true,
                                        swipeHorizontal: true,
                                        autoSpacing: false,
                                        pageFling: false,
                                        onRender: (pages) {
                                          print("Nombre de pages : $pages");
                                        },
                                        onError: (error) {
                                          print("Erreur lors du chargement du PDF : $error");
                                        },
                                      )
                                          : const Center(
                                            child: Icon(Icons.picture_as_pdf_outlined, size: 40),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pdfFile = null; // Réinitialiser la variable pdfFile à null
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Form(
                          child: GestureDetector(
                            onTap: () async {
                              final FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              );
                              if (result != null) {
                                final file = File(result.files.single.path!);
                                if (file.existsSync()) {
                                  final bytes = await file.readAsBytes();
                                  setState(() {
                                    pdfFile = file;
                                  });
                                  // ... le reste de votre code pour l'upload vers Firebase Storage
                                }
                                // ...
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 40,
                              child: Center(
                                child: isUploading
                                    ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                )
                                    : const Text("Choisir la fiche technique du produit"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25,),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()){
                                      String itemName=_controllerVendorName.text;
                                      String itemOrganization = _controllerOrganizationName.text;
                                      String itemTelephone = _controllerTelephone.text;
                                      String itemProductName = _controllerProductName.text;
                                      String itemProductDescription = _controllerProductDescription.text;
                                      String itemProductPrice = _controllerProductPrice.text;


                                      // Map with the input data
                                      String userId = FirebaseAuth.instance.currentUser!.uid;
                                      Map<String, dynamic> dataTosave={
                                        'name': itemName,
                                        'organisation': itemOrganization,
                                        'telephone': itemTelephone,
                                        'productname': itemProductName,
                                        'price': itemProductPrice,
                                        'description': itemProductDescription,
                                        'isChecked': _isChecked! ? true : false,
                                        'producttype': _selectedProduct,
                                        'photo' : _photoUrl,
                                        'userId': userId,
                                      };

                                      const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                        ),
                                      );
                                      // Add the data to the database
                                    await FirebaseFirestore.instance.collection('intrants').add(dataTosave)
                                    .catchError((error) => print('Erreur lors de l\'ajout de la donnée: $error'));
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            content: const Text('Félicitations ! Vos données sont envoyées. Elles seront validées avant affichage sur la plateforme.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Center(
                                                  child: Text('Fermer',
                                                    style: TextStyle(color: Colors.white),),

                                                ),
                                                onPressed: () {
                                                  if (!context.mounted) return;
                                                  Navigator.pushReplacement(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (context, animation, secondaryAnimation) => const AdminPage(),
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
                                                style: ButtonStyle(
                                                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                    )
                                                  ),
                                                    elevation: MaterialStateProperty.all<double>(1.0),
                                                    backgroundColor: MaterialStateProperty.resolveWith((
                                                        states) {
                                                      if (states.contains(MaterialState.pressed)) {
                                                        return Colors.green;
                                                      }
                                                      return Colors.green;
                                                    })
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(5.0),
                              backgroundColor: MaterialStateProperty.resolveWith((
                                  states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.grey;
                                }
                                return Colors.lightGreen;
                              })
                            ),

                              child: const Text("Envoyer",
                                  style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              )),

                        ),
                        const SizedBox(height: 12,),
                  ],
                ),
              ),
          ),
        );
      }
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




 

  

