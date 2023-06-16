import 'package:card_loading/card_loading.dart';
import 'package:citroon/chat.dart';
import 'package:citroon/engrais.dart';
import 'package:citroon/herbicides.dart';
import 'package:citroon/info.dart';
import 'package:citroon/notifications.dart';
import 'package:citroon/parameter.dart';
import 'package:citroon/pesticides.dart';
import 'package:citroon/provende.dart';
import 'package:citroon/semences.dart';
import 'package:citroon/login.dart';
import 'package:citroon/soil.dart';
import 'package:citroon/tools.dart';
import 'package:citroon/touslesproduits.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:citroon/utils/main_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:async';
import 'cgu.dart';
import 'conts/strings.dart';
import 'firebase_options.dart';
import 'help.dart';
import 'machinerie.dart';
import 'meteo.dart';
import 'models/current_weather_model.dart';
import 'my_drawer_header.dart';
import 'utils/user_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("HandLing a background message with id  ${message.messageId}");
}
  void _firebaseMessagingForegroundHandler(RemoteMessage message){
    print("Got message whilst in the forground");
    print("Message data: ${message.data}");
    if (message.notification != null){
      print("Message also contain a notification : ${message.notification}");
    }
  }

Future main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  handleDynamicLinks();
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

  final String constant = "Le token est : ";
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('$fcmToken $constant');
  runApp( MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool? isLoggedIn;
  MyApp({this.isLoggedIn}) ;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: IntroSlider(), //isLoggedIn! ? const HomePage() : const LoginPage(),
    );
  }
}

Future<void> handleDynamicLinks() async {
  // Gérez le lien initial si l'application a été ouverte par un lien dynamique
  final PendingDynamicLinkData? data =
  await FirebaseDynamicLinks.instance.getInitialLink();

  _handleLinkData(data);
  // Gérez les liens dynamiques entrants lorsque l'application est déjà ouverte
  FirebaseDynamicLinks.instance.onLink;
}

void _handleLinkData(PendingDynamicLinkData? data) {
  final Uri? deepLink = data?.link;

  if (deepLink != null) {
    // Gérez le lien dynamique ici en fonction de l'URL deepLink
    // Vous pouvez extraire les paramètres de l'URL et effectuer les actions requises
    print('Lien dynamique reçu : $deepLink');
  }
}

class IntroSlider extends StatefulWidget {
  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  @override
  void initState() {
    super.initState();
    // Délai de 1 seconde avant de naviguer vers la page principale
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
          transitionDuration: Duration(milliseconds: 1300), // Augmentez la durée de l'animation
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
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexStringToColor("2f6241"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logoappbar.png",
            width: 150.0,
            height: 150.0,
          ),
        ],
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  Widget build(BuildContext context) {
    final isLoggedIn = true; // Remplacez cette variable par votre propre logique d'état de connexion

    return isLoggedIn ? HomePage() : LoginPage();
  }

}


class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  bool isConnected = false;
  bool isLoading = true;
  var currentPage = DrawerSections.parameter;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool showIntroSlider = true;
  int unreadNotificationsCount = 0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // Récupérer une référence à la collection "messages" dans Firestore
  final CollectionReference messagesRef =
  FirebaseFirestore.instance.collection('messages');

  // Enregistrer un message dans Firestore
  Future<void> enregistrerMessage(String message) {
    return messagesRef.add({
      'contenu': message,
      'date': DateTime.now(),
    });
  }

  Future<void> setupInteractMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      _handleMessageTerminated(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenBackground);
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.body}');
      // Traitez le message et affichez la notification dans votre interface utilisateur
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from terminated state: ${message.notification?.body}');
      // Traitez le message lorsqu'il est ouvert à partir de l'état d'application terminée
    });
  }

  @override
  void initState() {
    super.initState();
    setupInteractMessage();
    _firebaseMessaging.requestPermission();
    _configureFirebaseMessaging();
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

void _handleMessageOpen(RemoteMessage message){
    if (message.data['type'] == 'chat') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>  ContactPage(),
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
    } else {
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
    }
}

  void _handleMessageTerminated(RemoteMessage message){
    print('Message from app that was terminated');
    _handleMessageOpen(message);
  }

  void _handleMessageOpenBackground(RemoteMessage message){
    print('Message from app that was in background');
    _handleMessageOpen(message);
  }

  void handleLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        transitionDuration: Duration(milliseconds: 300), // Augmentez la durée de l'animation
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
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      isLoading = false;
    });

    initializeDateFormatting('fr', null);
    var date = DateFormat.yMMMMd('fr_FR').format(DateTime.now());
    //var theme = Theme.of(context);
    var controller = Get.put(MainController());

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(
          color: hexStringToColor("2f6241"),
        ),
        title: const SizedBox(
          height: 35.0,
          child: Image(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined),
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
      ),


        body: WillPopScope(
          onWillPop: () async {
            // Affiche la fenêtre de confirmation
            bool shouldClose = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Fermer l\'application'),
                content: Text('Êtes-vous sûr de vouloir quitter l\'application ?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Non'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Oui'),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            );
            // Retourne la valeur correspondant à la décision de fermer l'application
            return shouldClose ?? false;
          },
          child: Container(
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
                Obx(
                      () => controller.isloaded.value == true
                      ? Card(
                        elevation: 1.0,
                        shape: const RoundedRectangleBorder(
                          //borderRadius: BorderRadius.circular(30.0),

                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                hexStringToColor("87ceeb"),
                                hexStringToColor("ffffff"),
                                hexStringToColor("e3f4d7")
                              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
                              )
                          ),
                          child: FutureBuilder(
                          future: controller.currentWeatherData,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData){
                              CurrentWeatherData data = snapshot.data;
                              return Row(
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
                                                children: [
                                                  "${data.name}"
                                                  .text
                                                   //.uppercase
                                                  .fontFamily("poppins_bold")
                                                  .size(18)
                                                  .letterSpacing(3)
                                                  .color(Colors.blueGrey)
                                                  .make(),
                                             ],
                                            )
                                          //  : CircularProgressIndicator(),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
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
                                            Image.asset(
                                            "assets/weather/${data.weather![0].icon}.png",
                                            width: 40,
                                            height: 40,
                                             ),
                                            Container(
                                                padding: EdgeInsets.only(left: 55.0),
                                              child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "${data.main!.temp}$degree",
                                                    style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 18,
                                                      //fontFamily: "poppins",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "\n${data.weather![0].main}",
                                                    style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      //letterSpacing: 3,
                                                      fontSize: 12,
                                                     // fontFamily: "poppins",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          // Ajoutez ici le code pour afficher la météo du jour suivant
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            else {
                              return const Center(
                                child: SizedBox(
                                  width: 40,  // Modifier la largeur du cercle
                                  height: 40,  // Modifier la hauteur du cercle
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,  // Modifier l'épaisseur de la ligne du cercle
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  ),
                                ),
                              );
                            }
                          }
                    ),
                        ),
                  )
                      : const Center(
                        child: SizedBox(
                          width: 40,  // Modifier la largeur du cercle
                          height: 40,  // Modifier la hauteur du cercle
                          child: CircularProgressIndicator(
                            strokeWidth: 1,  // Modifier l'épaisseur de la ligne du cercle
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                      ),


                ),

                const SizedBox(height: 20.0),
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
                              transitionDuration: Duration(milliseconds: 200), // Augmentez la durée de l'animation
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
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child:
                          isLoading
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
                                      size: 25,
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
                          isLoading
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
                                  size: 25,
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
                          isLoading
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
                                  size: 25,
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
                          isLoading
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
                                  size: 25,
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
                          isLoading
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
                                  size: 25,
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
                          isLoading
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
                                  size: 25,
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
                          isLoading
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
                                  size: 25,
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
                                      'Outillage',
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

                      // Météo agricole

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const MeteoPage(),
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
                          isLoading
                              ? const CardLoading(
                            height: 100,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            margin: EdgeInsets.only(bottom: 0),
                          )
                              : Stack(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                child: Icon(Icons.cloudy_snowing,
                                  size: 25,
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
                                      'Météo',
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
                      // Informations ou à propos
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const SoilPage(),
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
                          isLoading
                              ? const CardLoading(
                            height: 100,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            margin: EdgeInsets.only(bottom: 0),
                          )
                              : Stack(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                child: Icon(Icons.landscape_outlined,
                                  size: 25,
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
                                      'Mon Sol',
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
                      // Aide
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const ToolsPage(),
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
                          isLoading
                              ? const CardLoading(
                            height: 100,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            margin: EdgeInsets.only(bottom: 0),
                          )
                              : Stack(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                child: Icon(Icons.dataset_linked_outlined,
                                  size: 25,
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
                                      'Outils',
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
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(height: 25),
          menuItem(1, "Paramètre", Icons.settings_suggest_outlined, currentPage == DrawerSections.parameter),

          menuItem(2, "A propos", Icons.business_outlined, currentPage == DrawerSections.info),
          const SizedBox(height: 5),
          menuItem(3, "Aide", Icons.help_outline_outlined, currentPage == DrawerSections.help),
          const SizedBox(height: 5),
          menuItem(4, "C G U", Icons.report_outlined, currentPage == DrawerSections.cgu),
          const SizedBox(height: 150),
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
              break;
              case 3:
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
              case 4:
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
  parameter, info, help, cgu,
}


