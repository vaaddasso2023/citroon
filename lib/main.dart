
//import 'firebase_options.dart';
import 'package:citroon/addproduct.dart';
import 'package:citroon/engrais.dart';
import 'package:citroon/herbicides.dart';
import 'package:citroon/info.dart';
import 'package:citroon/pesticides.dart';
import 'package:citroon/semences.dart';
import 'package:citroon/login.dart';
import 'package:citroon/touslesproduits.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'my_drawer_header.dart';
import 'utils/user_model.dart';


Future main() async {
await WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class FirstLoad extends StatelessWidget {
  const FirstLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo here
            Image.asset(
              'assets/images/logo.png',
              height: 120,
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.touslesproduits;

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.touslesproduits) {
      container = AllproductPage();
    } else if (currentPage == DrawerSections.engrais) {
      container = FertilizerPage();
    } else if (currentPage == DrawerSections.semences) {
      container = SeedPage();
    } else if (currentPage == DrawerSections.herbicides) {
      container = HerbicidesPage();
    } else if (currentPage == DrawerSections.pesticides) {
      container = PesticidesPage();
    } else if (currentPage == DrawerSections.addproduct) {
      container = AddProductPage();
    } else if (currentPage == DrawerSections.signup) {
      container = LoginPage();
    } else if (currentPage == DrawerSections.info) {
      container = InfoPage();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('CITROON'),
        actions: [
          IconButton(onPressed: () async {
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();

                }, icon: Icon(Icons.login_outlined))
        ],
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
             child: Column(
                children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget MyDrawerList(){
    return Container(
      padding: EdgeInsets.only(
        top:15,
      ),
      child: Column(
        //Show the list of menu drawer
        children: [
          menuItem(1, "Tous les produits", Icons.dashboard_outlined,
            currentPage == DrawerSections.touslesproduits ? true: false),
          menuItem(2, "Engrais", Icons.compost_outlined,
              currentPage == DrawerSections.engrais ? true: false),
          menuItem(3, "Semences", Icons.spa_outlined,
              currentPage == DrawerSections.semences ? true: false),
          menuItem(4, "Herbicides", Icons.macro_off_outlined,
              currentPage == DrawerSections.herbicides ? true: false),
          menuItem(5, "Pesticides", Icons.pest_control_outlined,
              currentPage == DrawerSections.pesticides ? true: false),
          SizedBox(height: 100), // espace de 160 pixels entre les deux paragraphes
          menuItem(6, "Ajouter un produit", Icons.add,
              currentPage == DrawerSections.addproduct ? true: false),
          SizedBox(height: 5), // espace de 5 pixels entre les deux paragraphes
          menuItem (7, "Connexion", Icons.login_outlined,
              currentPage == DrawerSections.signup ? true: false),
          SizedBox(height: 5), // espace de 5 pixels entre les deux paragraphes
          menuItem(8, "Info", Icons.report_outlined,
              currentPage == DrawerSections.info ? true: false),

        ],
      ),
    );

  }
  Widget menuItem(int id, String title, IconData icon, bool selected){
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState(() {
            if (id==1){
              currentPage = DrawerSections.touslesproduits;
            } else if (id==2) {
              currentPage = DrawerSections.engrais;
            } else if (id==3){
              currentPage = DrawerSections.semences;
            } else if (id==4){
              currentPage = DrawerSections.herbicides;
            } else if (id==5){
              currentPage = DrawerSections.pesticides;
            } else if (id==6){
              currentPage = DrawerSections.addproduct;
            }else if (id==7){
              currentPage = DrawerSections.signup;
            }else if (id==8){
              currentPage = DrawerSections.info;
            }
          });
        },

        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
              icon,
            size: 20,
            color: Colors.black,
          ),
              ),
              Expanded(
                flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
enum DrawerSections{
  touslesproduits,
  pesticides,
  engrais,
  semences,
  herbicides,
  addproduct,
  signup,
  info,
}