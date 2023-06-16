import 'package:flutter/material.dart';

class ProductLink extends StatelessWidget {
  final String link;
  final String productName;
  final String productImage;

  ProductLink({required this.link, required this.productName, required this.productImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Gérer le tap sur le lien
      },
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Image.network(
                productImage,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            TextSpan(
              text: productName,
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




