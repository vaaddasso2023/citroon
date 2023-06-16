import 'package:citroon/utils/colors_utils.dart';
import 'package:citroon/utils/our_themes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'conts/images.dart';
import 'conts/strings.dart';
import 'models/current_weather_model.dart';
import 'models/hourly_weather_model.dart';
import 'utils/main_controller.dart';
import 'utils/separator.dart';

class MeteoPage extends StatefulWidget {
  const MeteoPage({Key? key}) : super(key: key);

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  int _selectedIndex = 0;
  Color _selectedIconColor =  hexStringToColor("2f6241");

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.help_outline_outlined,),
      label: 'Aide',
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
    initializeDateFormatting('fr', null);
    var date = DateFormat.yMMMMd('fr_FR').format(DateTime.now());
    var theme = Theme.of(context);
    var controller = Get.put(MainController());

    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: hexStringToColor("2f6241"),
          title: const Text ("Météo agricole"),// date.text.color(Colors.white).make(),
          elevation: 0.0,
          actions: [

          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("f9f9f9"),
                hexStringToColor("e3f4d7"),
                hexStringToColor("f9f9f9")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
              )),
          child: Obx(
                () => controller.isloaded.value == true
                ? Container(
                    padding: const EdgeInsets.all(12),
                    child: FutureBuilder(
                        future: controller.currentWeatherData,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            CurrentWeatherData data = snapshot.data;
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "${data.name}"
                                      .text
                                      //.uppercase
                                     // .fontFamily("poppins_bold")
                                      .size(24)
                                      .letterSpacing(3)
                                      .color(hexStringToColor("2f6241"))
                                      .make(),
                                  Center(
                                    child: SeparatorLineWithText(
                                      text: date,
                                      lineThickness: 1.0,
                                      textSize: 16.0,
                                      lineColor: Colors.grey,
                                      textColor: hexStringToColor("2f6241"),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        "assets/weather/${data.weather![0].icon}.png",
                                        width: 80,
                                        height: 80,
                                      ),
                                      RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                          text: "${data.main!.temp}$degree",
                                          style: TextStyle(
                                            color: theme.primaryColor,
                                            fontSize: 64,
                                            fontFamily: "poppins",
                                          )
                                              ),
                                      TextSpan(
                                          text: " ${data.weather![0].main}",
                                          style: TextStyle(
                                            color: theme.primaryColor,
                                            letterSpacing: 3,
                                            fontSize: 14,
                                            fontFamily: "poppins",
                                          )),
                                           ],
                                        )),
                                  ],
                                ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                            onPressed: null,
                                            icon: Icon(Icons.expand_less_rounded, color: theme.iconTheme.color),
                                            label: "${data.main!.tempMax}$degree".text.color(theme.iconTheme.color).make()),
                                        TextButton.icon(
                                            onPressed: null,
                                            icon: Icon(Icons.expand_more_rounded, color: theme.iconTheme.color),
                                            label: "${data.main!.tempMin}$degree".text.color(theme.iconTheme.color).make())
                                      ],
                                    ),

                                  10.heightBox,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: List.generate(3, (index) {
                                      var iconsList = [clouds, humidity, windspeed];
                                      var values = [
                                        "${data.clouds!.all}",
                                        "${data.main!.humidity}",
                                        "${data.wind!.speed} km/h"
                                      ];
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Image.asset(
                                              iconsList[index],
                                              width: 60,
                                              height: 60,
                                            ).box.gray200.padding(const EdgeInsets.all(8)).roundedSM.make(),
                                          ),
                                          10.heightBox,
                                          values[index].text.gray900.make(),
                                        ],
                                      );

                                    }),
                                  ),
                                  10.heightBox,
                                  const Divider(),
                                  10.heightBox,
                                  FutureBuilder(
                                    future: controller.hourlyWeatherData,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        HourlyWeatherData hourlyData = snapshot.data;

                                        return SizedBox(
                                          height: 160,
                                          child: ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: hourlyData.list!.length > 6 ? 6 : hourlyData.list!.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              var time = DateFormat.jm('fr_FR').format(DateTime.fromMillisecondsSinceEpoch(
                                                  hourlyData.list![index].dt!.toInt() * 1000));
                                                return Container(
                                                  padding: const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(right: 4),
                                                  decoration: BoxDecoration(
                                                    color: Vx.gray200,
                                                    borderRadius: BorderRadius.circular(12),
                                                   /* boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 3,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],*/
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      time.text.make(),
                                                      Image.asset(
                                                        "assets/weather/${hourlyData.list![index].weather![0].icon}.png",
                                                        width: 80,
                                                      ),
                                                      15.heightBox,
                                                      "${hourlyData.list![index].main!.temp}$degree".text.make(),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                    10.heightBox,
                                    const Divider(),
                                    10.heightBox,
                                  Center(
                                    child: SeparatorLineWithText(
                                      text: 'La semaine prochaine',
                                      lineThickness: 1.0,
                                      textSize: 16.0,
                                      lineColor: Colors.grey,
                                      textColor: hexStringToColor("2f6241"),
                                    ),
                                  ),
                                  10.heightBox,
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 7,
                                  itemBuilder: (BuildContext context, int index) {
                                   var day = DateFormat.EEEE('fr_FR').format(DateTime.now().add(Duration(days: index + 1)));
                                   day = capitalizeFirstLetter(day);
                                    return Card(
                                      elevation: 1.0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: day.text.semiBold.color(theme.primaryColor).make()),
                                            Expanded(
                                              child: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Image.asset("assets/weather/50n.png", width: 40),
                                                  label: "26$degree".text.size(16).color(theme.primaryColor).make()),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                text: "37$degree /",
                                                style: TextStyle(
                                                  color: theme.primaryColor,
                                                  fontFamily: "poppins",
                                                  fontSize: 16,
                                                )),
                                            TextSpan(
                                                text: " 26$degree",
                                                style: TextStyle(
                                                  color: theme.iconTheme.color,
                                                  fontFamily: "poppins",
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                            ),
                          );
                        } else {
                          return const Center(
                               child: CircularProgressIndicator(
                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                               ),
                    );
                  }
                },
              ),
            )
                : const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
            ),
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
String capitalizeFirstLetter(String text) {
  return text.substring(0, 1).toUpperCase() + text.substring(1);
}