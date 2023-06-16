import 'package:citroon/help.dart';
import 'package:citroon/utils/colors_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int _selectedIndex = 1;
  Color _selectedIconColor =  hexStringToColor("2f6241");
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

  @override
  void initState() {
    super.initState();
    configureFCM();
  }

  void configureFCM() {
    List<String> messages = [];

    // Demander la permission de recevoir des notifications (optionnel)
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Gérer les notifications lorsque l'application est en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message en premier plan: $message');
      // Traitez le message ici
      // Par exemple, mettez à jour l'état de votre page ou affichez une notification
      setState(() {
        messages.add(message.data['message']);
      });
    });

    // Gérer les notifications lorsque l'application est en arrière-plan ou terminée
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('L\'application a été ouverte à partir d\'une notification: $message');
      // Traitez le message ici
      // Par exemple, mettez à jour l'état de votre page ou affichez une notification
      setState(() {
        messages.add(message.data['message']);
      });
    });
  }

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => HelpPage(),
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
        case 1:
          _selectedIconColor = hexStringToColor("2f6241");
          break;
        default:
          _selectedIconColor = hexStringToColor("2f6241");
      }
    });
  }


  List<String> messages = [];
  TextEditingController _messageController = TextEditingController();
  void _sendMessage() {
    String message = _messageController.text;
    setState(() {
      messages.add(message);
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: Text('Contact'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("f9f9f9"),
              hexStringToColor("e3f4d7"),
              hexStringToColor("f9f9f9"),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter
            )
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(labelText: '',
                         // border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send),
                      iconSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ],
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
