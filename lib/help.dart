import 'package:citroon/chat.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int _selectedIndex = 0;
  Color _selectedIconColor =  hexStringToColor("2f6241");
  List<Item> _data = generateItems(); // Utilisez la nouvelle liste générée

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.question_mark_outlined,),
      label: 'FAQ',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.question_answer_outlined),
      label: 'Contact',
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
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ContactPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Aide'),
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("f9f9f9"),
              hexStringToColor("e3f4d7"),
              hexStringToColor("f9f9f9"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              // Ajoutez les propriétés souhaitées pour votre conteneur en haut
              // par exemple, vous pouvez définir la hauteur, le padding, etc.
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:  Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                         SizedBox(
                          child: Text(
                            "Rejoignez notre canal Telegram, notre groupe "
                                "Whatsapp et abonnez-vous à notre chaîne Youtube.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        SizedBox(height: 25.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: InkWell(
                                onTap: () {
                                  // Action à effectuer lorsque l'image est cliquée
                                  launchUrl('https://t.me/votre_compte' as Uri);
                                },
                                child: Image.asset(
                                  'assets/icons/telegram.png',
                                  width: 24, // Modifier la largeur selon vos besoins
                                  height: 24, // Modifier la hauteur selon vos besoins
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: InkWell(
                                onTap: () {
                                  // Action à effectuer lorsque l'image est cliquée
                                  launchUrl('https://t.me/votre_compte' as Uri);
                                },
                                child: Image.asset(
                                  'assets/icons/whatsap.png',
                                  width: 24, // Modifier la largeur selon vos besoins
                                  height: 24, // Modifier la hauteur selon vos besoins
                                ),
                              ),
                            ),
                            SizedBox(
                              child: InkWell(
                                onTap: () async {
                                  String url = 'https://t.me/vaadd'; // Replace with your desired URL
                                  if (await canLaunch(url)) {
                                  await launch(Uri.parse(url).toString());
                                  } else {
                                  throw 'Could not launch $url';
                                  }
                                },
                                child: Image.asset(
                                  'assets/icons/youtube.png',
                                  width: 24, // Modifier la largeur selon vos besoins
                                  height: 24, // Modifier la hauteur selon vos besoins
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildPanel(),
                ),
              ),
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

  Widget _buildPanel() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ExpansionPanelList(
        elevation: 3,
        expandedHeaderPadding: const EdgeInsets.all(5.0),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = !isExpanded;
          });
        },
        children: _data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  title: Text(
                    item.question,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  item.answer,
                  style: const TextStyle(
                    fontSize: 14.0,

                  ),
                ),
              ),
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}
class Item {
  Item({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  String question;
  String answer;
  bool isExpanded;
}

List<Item> generateItems() {
  return [
    Item(
      question: 'Q1 : Qui peut ajouter un intrant sur Citroon ?',
      answer: 'R1 : Vous pouvez ajouter un intrant dans la base de Citroon, '
          'du moment où vous disposez de tous les droits pour le faire, qu\'il s\'agisse d\'une'
          'entité morale ou physique. Vous devez également disposer d\'une clé administrateur.',
    ),
    Item(
      question: 'Q2 : Mon intrant n\'est ni certifié ni homologué. Peux-je l\'ajouter au Citroon ?',
      answer: 'R2 : Citroon est une plateforme dont l\'une des vocations est de faire la promotion '
          'des intrants durables, certifiés ou homologués. Toutefois, si vous avez un intrant durable qui'
          'n\'est ni certifié ni homologué, vous pouvez l\'ajouter au Citroon. Il sera affiché avec la mention NON Certifié.',
    ),
    Item(
      question: 'Q3 : Où pourrais-je trouver une clé administrateur  afin d\'ajouter un intrant ? ',
      answer: 'R3 : Pour récupérer une Passe Admin, envoyez nous un message via l\'onglet Contact.',
    ),
    Item(
      question: 'Q4 : Je suis un simple utilisateur de Citroon. Pourrais-je me faire livrer après achat ? '
          'Combien de temps cela peut prendre ?',
      answer: 'R4 : Vous avez la possibilité de vous faire livrer un intrant sur toute l\'étendu du territoire du Togo.'
          'Le délai de réception est en fonction de votre lieu de résidence. En moyenne, vous recevrez votre intrant en moins de 72h.',
    ),
    Item(
      question: 'Q5 : L\'évaluateur *Mon Sol* est-il payant ? '
          'Quel est son dégré d\'exactitude ou de précision ?',
      answer: 'R5 : *Mon Sol* se base sur des données relevées en 2021 par les institutions étatiques Spécialisées. '
          'Ces données sont donc suceptibles d\'évoluer.'
          'L\'évaluation, les analyses et les pistes de corrections proposées par *Mon Sol* sont à cet effet à titre indicatifs'
          'Pour plus de précision et de ressources, consulter notre Boîte à Outils.',
    ),
    Item(
      question: 'Q6 : L\'évaluateur *Mon Sol* peut-il fonctionner dans mon pays ? ',
      answer: 'R6 : Pour le moment *Mon Sol* se base sur des données relevées au Togo et ne peut évaluer aucune '
          'parcelle en dehors de cette limite territoriale. ',
    ),
    // Ajoutez les autres questions et réponses ici
  ];
}

