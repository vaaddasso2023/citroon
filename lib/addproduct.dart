import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'login.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  List<DropdownMenuItem<String>> listproduit=[];

  TextEditingController _controllerVendorName=TextEditingController();
  TextEditingController _controllerOrganizationName=TextEditingController();
  TextEditingController _controllerTelephone=TextEditingController();
  TextEditingController _controllerProductName=TextEditingController();
  TextEditingController _controllerProductDescription=TextEditingController();
  TextEditingController _controllerProductPrice=TextEditingController();

  CollectionReference _referenceIntrants = FirebaseFirestore.instance.collection('intrants');
  late Stream<QuerySnapshot> _streamIntrants;

  File? file;
  ImagePicker image = ImagePicker();
  String? _selectedProduct;
  void produits()
  {
  listproduit.clear();
  listproduit.add(
      const DropdownMenuItem(
        value: 'engrais',
          child: Text(
            'Engrais', style: TextStyle(
              color: Colors.grey
          ),
          ),),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'semences',
      child: Text(
        'Semences', style: TextStyle(
          color: Colors.grey
      ),
      ),),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'herbicides',
      child: Text(
        'Herbicides', style: TextStyle(
          color: Colors.grey
      ),
      ),),
  );
  listproduit.add(
    const DropdownMenuItem(
      value: 'pesticides',
      child: Text(
        'Pesticides', style: TextStyle(
          color: Colors.grey
      ),
      ),),
  );
}



final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;
  late Uint8List imageFile;
  bool ? _isChecked = false;
  String? _nomVendeur ;
  String? _nomOrganisation ;
  String? _telephone ;
  String? _nomProduit ;
  String? _descriptionProduit;
  String? _price;
  String? _photoUrl;

 @override
  void initState() {
    super.initState();
   _streamIntrants = _referenceIntrants.snapshots();

  }
  @override
  Widget build(BuildContext context) {
    produits();
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _streamIntrants,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
            return Center(
                child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
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
                            labelText: 'Nom du produit',
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
                                    'Type de produits', style: TextStyle(
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
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                           image: const DecorationImage(
                           image: AssetImage("assets/images/icone_photo.png"),

                               ),
                              ),
                              height: 120,
                              width: 120,
                              child: imageAvailable ? Image.memory(
                                  imageFile) : const SizedBox(
                              ),
                            ),
                          const SizedBox(height: 12,),
                        FormField<String>(
                          key: const Key('photo-form-field'),
                          onSaved: (value) {
                            _photoUrl = value;
                            // Save the _photoUrl to Firestore
                          },
                          builder: (FormFieldState<String> field) {
                            return GestureDetector(
                              onTap: () async {
                                final image = await ImagePicker().getImage(source: ImageSource.gallery);
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
                                  final UploadTask uploadTask = storageReference.putData(bytes);
                                  await uploadTask.whenComplete(() async {
                                    final url = await storageReference.getDownloadURL();
                                    setState(() {
                                      _photoUrl = url;
                                    });
                                    // Call the onSave function to save the _photoUrl to Firestore
                                    field.didChange(_photoUrl);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 40,
                                child: const Center(
                                  child: Text("Choisir la photo du produit"),
                                ),
                              ),
                            );
                          },
                        ),
                          const SizedBox(height: 12,),
                          // Précision sur la certification du produit
                        FormField(
                          initialValue: '',
                          onSaved: (value) {
                            _isChecked = value == 'true';
                          },
                          builder: (FormFieldState<String> state) {
                            return Column(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  checkColor: Colors.green,
                                  onChanged: (value) {
                                    _isChecked = value!;
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                const Text('Produit certifié ? cochez la case si oui'),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 12,),

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
                                      };

                                      Center(
                                        child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                                        ),
                                      );
                                      // Add the data to the database
                                    await FirebaseFirestore.instance.collection('intrants').add(dataTosave);
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            content: Text('Félicitations ! Vos données sont envoyées. Elles seront validées avant affichage sur la plateforme.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Center(
                                                  child: Text('Fermer',
                                                    style: TextStyle(color: Colors.white),),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
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
  );
  }
}




 

  

