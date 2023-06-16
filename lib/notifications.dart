import 'package:citroon/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<RemoteMessage?> initialMessage;
  int unreadNotificationsCount = 0;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    setupInteractMessage();
  }

  Future<void> initializeFirebase() async {
     // Firebase.initializeApp();
    initialMessage = FirebaseMessaging.instance.getInitialMessage();
  }

  void _handleMessageOpen(RemoteMessage message) {
    if (message.data['type'] == 'notifications') {
      // Traiter le message de notification
    }
  }

  Future<void> setupInteractMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenBackground);
  }

  void _handleMessageOpenBackground(RemoteMessage message) {
    _handleMessageOpen(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<RemoteMessage?>(
        future: initialMessage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final message = snapshot.data!;
            final data = message.data;

            if (data.isEmpty) {
              return const Center(
                  child: Text(
                      'pas de notifications')
              );
            }

            final notifications = data;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Card(
                  elevation: 1.0,
                  child: ListTile(
                    title: Text('${message}'),
                   // Ajoutez d'autres widgets ici pour afficher plus de détails sur chaque notification
                  ),
                );
              },
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          return const Center(
              child: Text(
                  'pas de notifications')
          );
        },
      ),
    );
  }
}
