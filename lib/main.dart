import 'package:card_loading/card_loading.dart';
import 'package:citroon/engrais.dart';
import 'package:citroon/herbicides.dart';
import 'package:citroon/info.dart';
import 'package:citroon/parameter.dart';
import 'package:citroon/pesticides.dart';
import 'package:citroon/provende.dart';
import 'package:citroon/semences.dart';
import 'package:citroon/login.dart';
import 'package:citroon/touslesproduits.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'cgu.dart';
import 'firebase_options.dart';
import 'help.dart';
import 'machinerie.dart';
import 'my_drawer_header.dart';
import 'utils/user_model.dart';




Future main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool? isLoggedIn;
  MyApp({this.isLoggedIn}) ;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  isLoggedIn! ? const HomePage() : const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  bool isConnected = false;
  bool isLoading = true;
  var currentPage = DrawerSections.parameter;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });

  }


  void handleLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
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
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      isLoading = false;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        centerTitle: true,
        title: const SizedBox(
          height: 35.0,
          child: Image(
            image: AssetImage('assets/images/logoappbar.png'),
          ),
        ),
      ),

        body: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
              hexStringToColor("f9f9f9"),
              hexStringToColor("e3f4d7"),
              hexStringToColor("f9f9f9")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
            )
          ),
          child: Column(
            children: [
            Card(
                color: hexStringToColor("2f6241"),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                //borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(23.0),
                    child: isLoading
                      ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                    : Stack(
                        children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                        ),
                       // Ajoutez ici le code pour afficher la météo du jour suivant
                       // _weather != null
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                            Text(
                            'Météo à afficher',
                            style: TextStyle(fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                             ),
                          ],
                        )
                          //  : CircularProgressIndicator(),
                      ],
                    ),
                  ),

                ),

                Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(23.0),
                      child: isLoading
                          ? const CardLoading(
                        height: 100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                      )
                          : Stack(
                             children: const [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                            ),
                            // Ajoutez ici le code pour afficher la météo du jour suivant
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            ),

            const SizedBox(height: 15.0),
            Expanded(
              child: ResponsiveGridList (
                minItemWidth: 120,
                horizontalGridMargin: 0,
                verticalGridMargin: 0,
                children: [
                  // Tous intants
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const AllproductPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                              children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                child: Icon(Icons.all_out_outlined,
                                  size: 30,
                                  color: Colors.green,
                              ),
                             ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 0,
                                top: 10,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Tout',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Herbicides
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const HerbicidesPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                                 children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                child: Icon(Icons.macro_off_outlined,
                                  size: 30,
                                  color: Colors.black45,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 0,
                                top: 10,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                    'Herbicides',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                              // Pesticides
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const PesticidesPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.pest_control_outlined,
                                size: 30,
                                color: Colors.black45,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 0,
                              top: 10,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Pesticides',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                    // Semences
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const SeedPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.spa_outlined,
                                size: 30,
                                color: Colors.green,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 0,
                              top: 10,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Semences',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                    // Engrais
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const FertilizerPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.compost_outlined,
                                size: 30,
                                color: Colors.green,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 0,
                              top: 10,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Engrais',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                          // Provende
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const FeedPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.pets_outlined,
                                size: 30,
                                color: Colors.green,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 0,
                              top: 10,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Provende',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                  // Machines agricoles
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const MachinePage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                                 children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                child: Icon(Icons.agriculture_outlined,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 0,
                                top: 10,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Machinerie',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                  // Informations ou à propos
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const InfoPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                                children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                child: Icon(Icons.business_outlined,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 0,
                                top: 10,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'A propos',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                  // Aide
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const HelpPage(),
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
                    child: Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child:
                      SizedBox(
                        width: 110.0,
                        child: isLoading
                            ? const CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          margin: EdgeInsets.only(bottom: 0),
                        )
                            : Stack(
                               children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                              child: Icon(Icons.help_outline_outlined,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 0,
                              top: 10,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Aide',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: const SizedBox(
                width: double.maxFinite,
                child: Center(
                  child: Text(
                    'On affichera plutôt nos partenaires ici.',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              height: 170.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /*IconButton(
                    icon: const Icon(Icons.arrow_circle_left_rounded),
                    color: Colors.lightGreen,
                    onPressed: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),*/
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      children: [
                        Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: const AspectRatio(
                                aspectRatio: 16/10,
                                child: Image(
                                  image: AssetImage('assets/images/herbicide.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: double.infinity, // prend toute la largeur disponible
                            height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: const AspectRatio(
                                aspectRatio: 16/10, // ajustez le ratio en fonction de votre image
                                child: Image(
                                  image: AssetImage('assets/images/pesticide.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                          Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SizedBox(
                              width: double.infinity, // prend toute la largeur disponible
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: const AspectRatio(
                                  aspectRatio: 16/10, // ajustez le ratio en fonction de votre image
                                  child: Image(
                                    image: AssetImage('assets/images/engrais.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),


                GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const SeedPage(),
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

                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SizedBox(
                              width: double.infinity, // prend toute la largeur disponible
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: const AspectRatio(
                                  aspectRatio: 16/10, // ajustez le ratio en fonction de votre image
                                  child: Image(
                                    image: AssetImage('assets/images/semence.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                    ),
                  ),
                  /*IconButton(
                    icon: const Icon(Icons.arrow_circle_right_rounded),
                    color: Colors.lightGreen,
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: Column(
           children: [
           const MyHeaderDrawer(),
           MyDrawerList(),
         ],
          ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(height: 25),
          menuItem(1, "Paramètre", Icons.settings_suggest_outlined, currentPage == DrawerSections.parameter),
          menuItem(2, "Aide", Icons.help_outline_outlined, currentPage == DrawerSections.help),
          const SizedBox(height: 5),
          menuItem(3, "C G U", Icons.report_outlined, currentPage == DrawerSections.cgu),
          const SizedBox(height: 250),
          SizedBox(
            child: Image.asset('assets/images/logo.png', height: 40.0),
          )
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected, [String? page]){
    return Material(
      // color: selected ? Colors.white : Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState(() {
            switch (id){
              case 1:
              Navigator.push(
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
              break;
              case 2:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const HelpPage(),
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
              break;
              case 3:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const CguPage(),
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
              break;
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
                size: 35,
                color: hexStringToColor("2f6241"),
                ),
              ),
              Expanded(
                flex: 2,
                  child: Text(
                    title,
                      style: const TextStyle(
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
  parameter, help, cgu,
}
/*IconData getWeatherIcon(String weatherMain) {
  switch (weatherMain) {
    case 'Thunderstorm':
      return Icons.flash_on;
    case 'Drizzle':
    case 'Rain':
      return Icons.opacity;
    case 'Snow':
      return Icons.ac_unit;
    case 'Mist':
    case 'Smoke':
    case 'Haze':
    case 'Dust':
    case 'Fog':
    case 'Sand':
    case 'Ash':
    case 'Squall':
    case 'Tornado':
      return Icons.blur_on;
    case 'Clear':
      return Icons.wb_sunny;
    case 'Clouds':
      return Icons.cloud;
    default:
      return Icons.help_outline;
  }
}*/

