import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  // int _selectedIndex = 0;
  Color _selectedIconColor =  hexStringToColor("2f6241");

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: SizedBox.shrink(),
      label: 'Citroon - V 1.0.0 ',
    ),
    const BottomNavigationBarItem(
      label: '',
      icon: SizedBox.shrink(),// Utilisez SizedBox.shrink() pour supprimer l'icône
    ),
  ];


  void _onBottomNavigationItemTapped(int index) {
    setState(() {
    //  _selectedIndex = index;
      switch (index) {
        default:
          _selectedIconColor = hexStringToColor("2f6241");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('A propos'),
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("f9f9f9"),
                hexStringToColor("e3f4d7"),
                hexStringToColor("f9f9f9")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
              )
          ),
          child:  Card(
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                  text:  TextSpan(
                    text:
                        'CITROON\n\n'
                    'Citroon est un outil digital innovant développé par l\'association VAADD | Veille & Actions Axées sur le '
                    'Développement Durable, '
                     'et dédié à l\'agriculture durable et à la promotion des intrants certifiés et '
                    'homologués. Notre application mobile vise à stimuler la productivité agricole, '
                    'à favoriser l\'autosuffisance alimentaire et à réduire l\'impact des changements '
                    'climatiques au Togo et en Afrique. '
                    'Fondée sur les principes de durabilité et de responsabilité environnementale, '
                    'Citroon met à votre disposition quatre grandes fonctionnalités essentielles pour les '
                    'agriculteurs et les acteurs du secteur agricole :\n\n'

                    '1. Consultation et achat d\'intrants durables : Accédez à une vaste gamme d\'intrants '
                    'agricoles durables, certifiés et homologués, spécifiquement sélectionnés pour améliorer '
                    'les pratiques agricoles et optimiser les rendements. Grâce à notre application conviviale, '
                    'vous pouvez facilement parcourir les produits disponibles, obtenir des informations détaillées '
                    'et effectuer vos achats en quelques clics.\n\n'

                    '2. Évaluation du potentiel des parcelles : Déterminez la fertilité de vos parcelles agricoles '
                    'et identifiez les éléments nécessaires à leur amélioration. Notre fonctionnalité d\'évaluation du '
                    'potentiel des parcelles vous permet d\'obtenir des recommandations personnalisées pour optimiser '
                    'les rendements, en prenant en compte les caractéristiques spécifiques de votre exploitation.\n\n'

                    '3. Boîte à outils numérique : Accédez à une collection de ressources et de liens vers d\'autres '
                    'solutions numériques pertinentes liées à l\'agriculture. Que vous recherchiez des guides pratiques, '
                    'des formations en ligne, des communautés d\'agriculteurs ou des informations sur les bonnes pratiques '
                    'agricoles, notre boîte à outils vous permettra de trouver rapidement les informations dont vous avez besoin.\n\n'

                    '4. Consultation de la météo agricole : Restez informé des conditions météorologiques spécifiques à '
                    'votre région. Notre fonctionnalité de consultation de la météo agricole vous fournit des prévisions précises '
                    'et actualisées, vous permettant ainsi de planifier vos activités agricoles de manière plus efficace et '
                    'd`\'anticiper les éventuels défis climatiques.\n\n'

                    'Chez VAADD, nous nous engageons à soutenir les agriculteurs et les acteurs du secteur agricole '
                    'dans leur transition vers des pratiques durables et résilientes. En utilisant notre application mobile, '
                    'vous contribuez activement à la construction d\'un avenir agricole plus durable, tout en renforçant la '
                    'sécurité alimentaire et en préservant notre environnement pour les générations futures.\n\n'
                    ''
                    'Rejoignez-nous dès aujourd\'hui et ensemble, cultivons un avenir meilleur pour l\'agriculture en Afrique et au-delà !\n\n'

                    'Email : vaaddasso@gmail.com\n',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[800],
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        // backgroundColor: ,
       // currentIndex: _selectedIndex,
        onTap: _onBottomNavigationItemTapped,
        items: _bottomNavigationBarItems,
        selectedItemColor: _selectedIconColor,
      ),
    );
  }
}