import 'package:citroon/admin.dart';
import 'package:citroon/login.dart';
import 'package:citroon/notifications.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:citroon/utils/separator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ParameterPage extends StatefulWidget {
  const ParameterPage({Key? key}) : super(key: key);

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  int _selectedIndex = 0;
  int unreadNotificationsCount = 0;
  Color _selectedIconColor =  hexStringToColor("2f6241");
  final user = FirebaseAuth.instance.currentUser;
  final defaultAvatar = 'assets/images/profile.png';

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_3_rounded,),
      label: 'Utilisateur',
    ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Paramètres'),
        elevation: 0,
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: double.maxFinite,
        padding: const EdgeInsets.only(bottom: 150.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("f9f9f9"),
              hexStringToColor("e3f4d7"),
              hexStringToColor("f9f9f9"),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            ClipOval(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(user?.photoURL ?? ''),
                  ),
                ),
                child: user?.photoURL == null
                    ? Image.asset(
                  defaultAvatar,
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.displayName ?? 'Votre Nom',
              style: const TextStyle(color: Colors.black54, fontSize: 20),
            ),
              const SizedBox(height: 8),
            Text(user?.email ?? 'Email',
              style: const TextStyle(color: Colors.black54, fontSize: 14,),
            ),
            const SizedBox(height: 22),
            Center(
              child: SeparatorLineWithText(
                text: 'ID',
                lineThickness: 1.0,
                textSize: 14.0,
                lineColor: Colors.grey,
                textColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Ferme la boîte de dialogue
                            },
                            child: const Text('Annuler',
                              style: TextStyle(color: Colors.green),),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              setState(() {
                                GoogleSignIn().signOut();
                                FirebaseAuth.instance.signOut();
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
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
                              });
                            },
                            child: const Text('Oui',
                            style: TextStyle(color: Colors.green),),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(5.0),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey;
                    }
                    return Colors.lightGreen;
                  }),
                ),
                child: const Text('Déconnexion'),
              ),
            ),
            SizedBox(height: 30.0,),
            SizedBox(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Action à effectuer lorsque le bouton est pressé
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(5.0),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey;
                    }
                    return Colors.lightGreen;
                  }),
                ),
                icon: Icon(Icons.share),
                label: Text('Partager l\'application'),
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
