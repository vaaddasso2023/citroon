import 'package:citroon/touslesproduits.dart';
import 'package:citroon/utils/separator.dart';
import 'package:citroon/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'registration.dart';
import 'services/google_sign_in.dart';
import 'utils/colors_utils.dart';


class LoginPage extends StatefulWidget {
  const LoginPage ({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

// editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;


  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Entrer votre Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Email invalide");
          }
          return null;
        },

        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Mot de passe obligatoire");
          }
          if (!regex.hasMatch(value)) {
            return ("Entrer un pass valide (Min. 6 caractères)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Mot de passe",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            bool isConnected = await checkInternetConnectivity();
            if (isConnected){
            signIn(emailController.text, passwordController.text);

            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    content: Text('Veuillez vous connecter à internet d\'abord !'),
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


          child: Text(
            "Se connecter",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )

      ),
    );

    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("f9f9f9"),
                hexStringToColor("e3f4d7"),
                hexStringToColor("f9f9f9")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
              )),
          child: Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 35), // Espacement entre les enfants
                Form(
                  key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: 100,
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                              width: 130,
                            )),
                        SizedBox(height: 45),
                        emailField,
                        SizedBox(height: 25),
                        passwordField,
                        SizedBox(height: 35),
                        loginButton,
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Pas de compte ? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => RegistrationPage(),
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
                                child: Text(
                                  "S'enregistrer",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                              ),
                            )
                          ],
                        ),
                     ],
                   ),
                ),
                SizedBox(height: 30),

                // Séparateur

                Center(
                    child: SeparatorLineWithText(
                      text: 'Ou se connecter avec Google',
                      lineThickness: 1.0,
                      textSize: 14.0,
                      lineColor: Colors.grey,
                      textColor: Colors.grey,
                    ),
                    ),
                SizedBox(height: 30),
                                          // Connexion avec GMAIL
                ElevatedButton(
                  onPressed: () async {
                    bool isConnected = await checkInternetConnectivity();
                    if (isConnected){
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      );
                   await signInWithGoogle(signInWithGoogle(context));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            content: Text('Veuillez vous connecter à internet d\'abord !'),
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
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
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

                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google.png",
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Se connecter",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

// login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        Fluttertoast.showToast(msg: "Connecté avec succès !");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AllproductPage()));
      } on FirebaseAuthException catch (error) {
        String errorMessage;
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Adresse email incorrecte.";
            break;
          case "wrong-password":
            errorMessage = "Mauvais mot de passe.";
            break;
          case "user-not-found":
            errorMessage = "L'utilisateur avec cet email n'existe pas.";
            break;
          case "user-disabled":
            errorMessage = "L'utilisateur avec cet email a été désactivé.";
            break;
          case "too-many-requests":
            errorMessage = "Trop de requêtes.";
            break;
          case "operation-not-allowed":
            errorMessage =
            "La connexion avec l'email et le mot de passe n'est pas activée.";
            break;
          default:
            errorMessage = "Une erreur non définie s'est produite.";
        }
        Fluttertoast.showToast(
            msg: errorMessage,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
        );
        print(error.code);
      }
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }

}
