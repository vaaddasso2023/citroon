import 'package:citroon/addproduct.dart';
import 'package:citroon/login.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:citroon/utils/separator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


enum MenuType {
  Notification,
  Contact,
  Home,
}

Map<MenuType, IconData> menuIcons = {
  MenuType.Notification: Icons.notifications,
  MenuType.Contact: Icons.contact_mail,
  MenuType.Home: Icons.home,
};


class ParameterPage extends StatefulWidget {
  const ParameterPage({Key? key}) : super(key: key);

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  MenuType _selectedMenu = MenuType.Home;

  @override
  final user = FirebaseAuth.instance.currentUser;
  final defaultAvatar = 'assets/images/profile.png';

  void _onMenuSelected(MenuType menuType) {
    setState(() {
      _selectedMenu = menuType;
    });
  }


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
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),

      body:  Container(
        color: Colors.white,
         // width: double.infinity,
         height: double.maxFinite,
         padding: const EdgeInsets.only(bottom:150.0),
          child:  Column(
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
                style: const TextStyle(color: Colors.black54, fontSize:20),
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
                      setState(() {
                          GoogleSignIn().signOut();
                          FirebaseAuth.instance.signOut();
                          //isConnected = true;
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
                    child: const Text('Déconnexion'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  )
              ),

            ],
      ),

    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
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

        label: const Text('Ajouter un intrant'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
