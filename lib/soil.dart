import 'package:citroon/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class SoilPage extends StatefulWidget {
     const SoilPage({Key? key}) : super(key: key);

  @override
  State<SoilPage> createState() => _SoilPageState();
}

class _SoilPageState extends State<SoilPage> {
  final _mapController = MapController(initPosition: GeoPoint(latitude: 6.5239665, longitude: 1.0523915));
  int _selectedIndex = 0;
  Color _selectedIconColor = hexStringToColor("2f6241");

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.design_services_outlined,),
      label: 'Evaluer',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_on_outlined),
      label: 'Notification',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.contact_emergency_outlined),
      label: 'Contact',
    ),
  ];

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _selectedIconColor = hexStringToColor("2f6241");
          break;
        case 1:
          _selectedIconColor = hexStringToColor("2f6241");
          break;
        case 2:
          _selectedIconColor = hexStringToColor("2f6241");
          break;
        default:
          _selectedIconColor = hexStringToColor("2f6241");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: hexStringToColor("2f6241"),
        elevation: 0,
        title: const Text('Mon Sol'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
            OSMFlutter(
              controller: _mapController,
              mapIsLoading: const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
              initZoom: 12,
              minZoomLevel: 6,
              maxZoomLevel: 19,
              stepZoom: 1.0,
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.red,
                      size: 56,
                    ),
                  )
              ),
            ),
          Positioned(
            bottom: 16, // Modifier la position verticale selon vos besoins
            left: 16, // Modifier la position horizontale selon vos besoins
            child: FloatingActionButton.extended(
              icon: const Icon(Icons.design_services_outlined),
              label: const Text('Evaluer mon sol'),
              onPressed: () {
                // Action à effectuer lors du clic sur le deuxième FAB
              },
              backgroundColor: Colors.red,
               // Modifier la couleur selon vos besoins
            ),
          ),
          ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: () async {
          await _mapController.currentLocation();
        },
        backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey;
          }
          return Colors.lightGreen;
        }),
      ),


      /*bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavigationItemTapped,
        items: _bottomNavigationBarItems,
        selectedItemColor: _selectedIconColor,
      ),*/
    );
  }
}
