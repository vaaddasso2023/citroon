import 'dart:typed_data';
import 'package:citroon/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'my_drawer_header.dart';
import 'login.dart';




class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  List<DropdownMenuItem<String>> listproduit=[];

  File? file;
  ImagePicker image = ImagePicker();
  String? def;
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
@override
Widget build(BuildContext context) {
  produits();
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.grey[400],
      title: const Text('Ajout de produit', style: TextStyle( fontSize: 18 , color: Colors.white,),),
    ),
    body: SingleChildScrollView (
      child: Container(
          margin: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // const Text("AJOUT DE PRODUIT", style: TextStyle( fontSize: 18 , color: Colors.black,),),
                const SizedBox(height: 16,),
                // Ajout de nom du vendeur
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom complet',
                    hintText: 'Votre nom et prénom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                   if (value == null || value.isEmpty){
                     return "Vous devez complèter le champ";
                   }
                   return null;
                  }
                ),
                // Ajout du nom de organisation
                const SizedBox(height: 12,),
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Organisation',
                      hintText: 'Nom de votre organisation',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Vous devez complèter le champ";
                      }
                      return null;
                    }
                ),
                // Ajout de numéro de téléphone
                const SizedBox(height: 12,),
                TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      hintText: 'Votre numéro de téléphone',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Vous devez complèter le champ";
                      }
                      return null;
                    }
                ),
                // Ajout de nom du produit
                const SizedBox(height: 12,),
                TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Nom du produit',
                      hintText: 'Le nom de votre produit',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Vous devez complèter le champ nom du produit";
                      }
                      return null;
                    }
                ),

                // Description du produit
                const SizedBox(height: 12,),
                TextFormField(
                    keyboardType: TextInputType.multiline,
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
                    // Faites quelque chose avec la valeur du texte ici
                  },
                ),

                // Ajout de nom du produit - début
                const SizedBox(height: 12,),

                // Liste déroulante

                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: DropdownButton(
                        value: def,
                          items: listproduit,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text(
                          'Type de produits', style: TextStyle(
                            color: Colors.grey
                        ),
                        ),
                        onChanged: (value) {
                        def=value!;
                        setState(() {

                        });
                        }
                      ),
                    ),
                ),
                const SizedBox(height: 12,),
                // Ajout de nom du produit - fin

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

                GestureDetector(
                  onTap: () async {

                    final image = await ImagePicker(

                    // ignore: deprecated_member_use
                    ).getImage(source: ImageSource.gallery);

                      if (image != null) {
                      final bytes = await image.readAsBytes();

                    setState(() {
                      imageFile = bytes;
                      imageAvailable = true;
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
                ),
                const SizedBox(height: 12,),

                // Précision sur la certification du produit
                Column(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      checkColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // Vous pouvez également personnaliser l'apparence de la
                      // checkbox avec les paramètres "activeColor",
                      // "checkColor", "fillColor", etc.
                    ),

                    const Text('Produit certifié ? cochez la case si oui'),
                  ],
                ),
                
                const SizedBox(height: 12,),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar (content: Text(
                                  "Envoi en cours ..."))
                          );
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      child: const Text("Envoyer")),

                ),
                const SizedBox(height: 12,),

                // Lien pour aller sur la page d'inscription et de connexion
                SizedBox(
                 child: InkWell(
                   onTap: (){
                     Navigator.pop(
                      context,
                       MaterialPageRoute(builder: (_) => const LoginPage()
                      ),
                     );
                   },
                   child: const Text('Pas encore de compte ? cliquez ici...'),
                  ),
               ),
              ],
            ),
          ),
      ),
    ),
  );
  }
}


 

  

