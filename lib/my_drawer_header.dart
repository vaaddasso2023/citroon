import 'package:citroon/addproduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'main.dart';


class MyHeaderDrawer extends StatefulWidget {


  const MyHeaderDrawer({Key? key});

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();

}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final defaultAvatar = 'assets/images/profile.png';
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top:20.0),
      child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
           children: [
             SizedBox(height: 15),
             CircleAvatar(
               radius: 40,
               backgroundImage: NetworkImage(user?.photoURL ?? ''),
                 child: user?.photoURL == null
                     ? Image.asset(defaultAvatar)
                     : null,
             ),
             SizedBox(height: 8),

             Text(
               user?.displayName ?? 'Votre Nom',
               style: TextStyle(color: Colors.white, fontSize:20),
             ),
             SizedBox(height: 8),

             Text(user?.email ?? 'Email',
               style: TextStyle(color: Colors.grey[200], fontSize: 14,),
             ),
           ],


      ),

    );

  }

}


