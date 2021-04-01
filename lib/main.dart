import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/meal_provider.dart';
import 'package:flutter_complete_guide/screens/theme_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/tabs_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/filters_screen.dart';
import './screens/categories_screen.dart';
import './screens/on_boarding_screen.dart';

import 'package:provider/provider.dart';
import './providers/meal_provider.dart';
import './providers/theme_provider.dart';
import './screens/theme_screen.dart';
import './providers/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool setbigen = prefs.getBool('watched') ?? false;
  Widget homeScreen = setbigen ? TabsScreen() : OnBoardingScreen();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MealProvider>(
        create: (context) => MealProvider(),
      ),
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider<LanguageProvider>(
        create: (context) => LanguageProvider(),
      ),
    ],
    child: MyApp(homeScreen),
  ));
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;
  MyApp(this.homeScreen);
  static MaterialColor primeryColor;
  static MaterialColor accentColor;
  static ThemeMode tm;

  @override
  Widget build(BuildContext context) {
    primeryColor =
        Provider.of<ThemeProvider>(context, listen: true).primeryColor;
    accentColor = Provider.of<ThemeProvider>(context, listen: true).accentColor;
    tm = Provider.of<ThemeProvider>(context, listen: true).tm;
    Provider.of<MealProvider>(context, listen: false).setData();
    Provider.of<ThemeProvider>(context, listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context, listen: false).getThemeColors();
    final lan = Provider.of<LanguageProvider>(context);
    lan.getLan();

    return MaterialApp(
      title: lan.getTexts('drawer_name'),
      themeMode: tm,
      theme: ThemeData(
          primarySwatch: primeryColor,
          accentColor: accentColor,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(color: Colors.black),
              bodyText2: TextStyle(
                color: Color.fromRGBO(100, 200, 200, 1),
              ),
              headline6: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              )),
          buttonColor: Colors.black87,
          cardColor: Colors.white,
          shadowColor: Colors.black54),

      darkTheme: ThemeData(
          primarySwatch: primeryColor,
          accentColor: accentColor,
          canvasColor: Color.fromRGBO(14, 22, 53, 1),
          fontFamily: 'Raleway',
          unselectedWidgetColor: Colors.white70,
          bottomAppBarColor: Colors.white,
          textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: TextStyle(color: Colors.white),
              bodyText2: TextStyle(
                color: Color.fromRGBO(100, 200, 200, 1),
              ),
              headline6: TextStyle(
                color: Colors.white60,
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              )),
          buttonColor: Colors.white70,
          cardColor: Color.fromRGBO(35, 34, 39, 1),
          shadowColor: Colors.white60),
      // home: CategoriesScreen(),
      initialRoute: '/', // default is '/'
      routes: {
        '/': (ctx) => homeScreen,
        TabsScreen.routeName: (ctx) => TabsScreen(),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
        FiltersScreen.routeName: (ctx) => FiltersScreen(),
        ThemeScreen.routeName: (ctx) => ThemeScreen(),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
        // if (settings.name == '/meal-detail') {
        //   return ...;
        // } else if (settings.name == '/something-else') {
        //   return ...;
        // }
        // return MaterialPageRoute(builder: (ctx) => CategoriesScreen(),);
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
    );
  }
}
