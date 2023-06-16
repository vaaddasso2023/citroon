import 'dart:convert';

import 'package:citroon/touslesproduits.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Favorite> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<List<Favorite>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriteStrings = prefs.getStringList('favorites');

    if (favoriteStrings != null) {
      List<Favorite> favorites = favoriteStrings.map((favoriteString) => Favorite.fromJson(jsonDecode(favoriteString))).toList();
      return favorites;
    } else {
      return [];
    }
  }


  Future<void> loadFavorites() async {
    List<Favorite> loadedFavorites = await getFavorites();
    setState(() {
      favorites = loadedFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          Favorite favorite = favorites[index];
          // Afficher les détails du favori (nom, description, etc.)
          return ListTile(
            title: Text(favorite.productName),
            subtitle: Text(favorite.productDescription),
            // Autres détails du favori...
          );
        },
      ),
    );
  }
}
