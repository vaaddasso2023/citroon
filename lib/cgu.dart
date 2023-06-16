import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CguPage extends StatefulWidget {
  const CguPage({Key? key}) : super(key: key);

  @override
  State<CguPage> createState() => _CguPageState();
}

class _CguPageState extends State<CguPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        title: const Text('Conditions d\'utilisation'),
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("f9f9f9"),
                hexStringToColor("e3f4d7"),
                hexStringToColor("f9f9f9")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
              )
          ),
          child:  Card(
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                text:  TextSpan(
                  text:
                  'CGU - Citroon\n\n'

                      'Les présentes Conditions Générales d\'Utilisation (CGU) régissent l\'utilisation de l\'application'
                      ' mobile Citroon, développée par l\'association VAADD. En utilisant Citroon, vous acceptez '
                      'les termes et conditions énoncés dans les présentes CGU. Veuillez les lire attentivement avant '
                      'd\'utiliser l\'application.\n\n'

                      '1. Acceptation des CGU En utilisant : \n\n'
                      'Citroon, vous reconnaissez avoir lu, compris et '
                      'accepté les présentes CGU dans leur intégralité. Si vous n\'acceptez pas ces conditions, '
                      'veuillez ne pas utiliser l\'application.\n\n'

                      '2. Utilisation de l\'Application :\n\n'
                  'a. Vous devez être âgé d\'au moins 18 ans ou avoir l\'autorisation d\'un parent ou tuteur légal '
                      'pour utiliser Citroon.\n'
                  'b. Vous êtes seul responsable de l\'exactitude et de la pertinence des informations que '
                      'vous fournissez lors de l\'utilisation de l\'application.\n'
                  'c. Vous acceptez de n\'utiliser Citroon que dans le respect des lois et réglementations en vigueur.\n'
                  'd. L\'utilisation de Citroon ne vous confère aucun droit de propriété intellectuelle sur '
                      'l\'application ou son contenu.\n\n'

                      '3. Fonctionnalités de Citroon :\n\n'
                  'a. Consultation et achat d\'intrants durables : Lors de l\'utilisation de la fonctionnalité '
                      'd\'achat d\'intrants durables, vous êtes responsable de la vérification des informations, '
                      'de la sélection des produits et de l\'exécution des transactions.\n'
                'b. Évaluation du potentiel des parcelles : Les recommandations fournies par la fonctionnalité '
                      'd\'évaluation des parcelles sont basées sur les informations que vous fournissez. Vous êtes '
                      'responsable de l\'interprétation et de l\'utilisation de ces recommandations.\n'
                'c. Boîte à outils numérique : Les ressources et liens fournis dans la boîte à outils sont à titre '
                      'informatif uniquement. Vous êtes responsable de l\'utilisation de ces ressources externes.\n'
                'd. Consultation de la météo agricole : Les prévisions météorologiques fournies sont basées sur '
                      'des sources fiables, mais elles peuvent ne pas être toujours exactes. Vous êtes responsable '
                      'de l\'interprétation et de l\'utilisation de ces informations.\n\n'

                  '4. Collecte des données personnelles : \n\n'
                'Lors de l\'utilisation de l\'application Citroon, nous pouvons collecter certaines informations personnelles '
                      'vous concernant, telles que votre nom, votre adresse e-mail, votre localisation géographique, '
                      'vos préférences et d\'autres données pertinentes. La collecte de ces données se fait dans le respect '
                      'des lois et réglementations applicables en matière de protection des données personnelles.\n\n'

                '5. Utilisation des données personnelles :\n\n'
                'Les données personnelles que nous collectons sont utilisées dans le but de vous fournir des services et '
                      'fonctionnalités personnalisés au sein de l\'application Citroon. Cela peut inclure l\'affichage de '
                      'recommandations adaptées à vos besoins agricoles, l\'envoi d\'informations pertinentes sur les intrants '
                      'durables, l\'amélioration de nos services et la communication avec vous concernant les mises à jour '
                      'de l\'application ou les offres spéciales.\n\n'

                  '6. Partage des données personnelles :\n\n'
                  'Nous ne vendons pas, ne louons pas et ne divulguons pas vos données personnelles à des tiers non autorisés, '
                      'sauf dans les cas suivants :\n'

                'a. Lorsque vous donnez votre consentement explicite pour le partage de vos données.\n'
                'b. Lorsque le partage est nécessaire pour fournir les services demandés par vous, tels que le traitement '
                      'des paiements lors de l\'achat d\'intrants durables.\n'
                'c. Lorsque la divulgation est requise par la loi, une procédure judiciaire ou toute autre demande gouvernementale.\n'
                'd. Lorsque nous estimons de bonne foi que la divulgation est nécessaire pour protéger nos droits, votre sécurité '
                      'ou celle d\'autrui, enquêter sur une fraude ou répondre à une situation d\'urgence.\n\n'
                '7. Sécurité des données personnelles :\n\n'
                  'Nous mettons en place des mesures de sécurité appropriées pour protéger vos données personnelles '
                      'contre tout accès, utilisation ou divulgation non autorisés. Cependant, veuillez noter qu\'aucune méthode '
                      'de transmission ou de stockage électronique n\'est totalement sécurisée, et nous ne pouvons garantir la '
                      'sécurité absolue de vos données.\n\n'

                '8. Conservation des données personnelles :\n\n'
                'Nous conservons vos données personnelles aussi longtemps que nécessaire pour atteindre les finalités pour '
                      'lesquelles elles ont été collectées, ainsi que pour respecter les obligations légales en vigueur.\n\n'

                  '9. Vos droits relatifs aux données personnelles :\n\n'
                  'Vous avez certains droits sur vos données personnelles, notamment le droit d\'accéder, de rectifier, '
                      'de supprimer, de limiter le traitement et de vous opposer à l\'utilisation de vos données personnelles. '
                      'Pour exercer ces droits, veuillez nous contacter à l\'adresse fournie dans l\'application.\n\n'

                '10. En utilisant l\'application Citroon, vous consentez à la collecte, à l\'utilisation et au traitement de vos '
                      'données personnelles conformément à la présente politique de confidentialité.\n\n'


                      '11. Limitation de responsabilité :\n\n'
                  'a. Citroon est fourni "tel quel" et sans garantie d\'aucune sorte, expresse ou implicite. L\'association '
                      'VAADD ne garantit pas l\'exactitude, la fiabilité ou l\'exhaustivité de l\'application.\n'
                'b. En aucun cas, l\'association VAADD ne pourra être tenue responsable des dommages directs, indirects, '
                      'spéciaux, consécutifs ou punitifs découlant de l\'utilisation ou de l\'incapacité d\'utiliser Citroon.\n\n'

                '12. Modification des CGU :\n\n'
                      ' L\'association VAADD se réserve le droit de modifier les présentes CGU à tout moment. '
                      'Les modifications prendront effet dès leur publication dans l\'application. '
                      'Il vous incombe de consulter régulièrement les CGU pour vous tenir informé des éventuelles modifications.\n\n'

                '13. Dispositions finales :\n\n'
                  'a. Si une disposition des présentes CGU est jugée invalide ou inapplicable, '
                      'les autres dispositions resteront pleinement en vigueur.\n'
                'b. Les présentes CGU sont régies par les lois en vigueur au Togo. Tout litige relatif à '
                      'l\'utilisation de Citroon sera soumis à la juridiction compétente du Togo.\n'
                'Pour toute question ou demande d\'assistance, veuillez nous contacter à l\'adresse fournie dans l\'application.\n\n'
                'Dernière mise à jour des CGU : 09/06/2023\n\n',

                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
