import 'package:citroon/admin.dart';
import 'package:citroon/login.dart';
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
  Color _selectedIconColor =  hexStringToColor("2f6241");
  final user = FirebaseAuth.instance.currentUser;
  final defaultAvatar = 'assets/images/profile.png';

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings_suggest_outlined,),
      label: 'Paramètre',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_on_outlined),
      label: 'Notification',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.admin_panel_settings_outlined),
      label: 'Admin',
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

            Navigator.push(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        height: double.maxFinite,
        padding: const EdgeInsets.only(bottom: 150.0),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('Déconnexion'),
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
}
