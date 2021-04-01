import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/language_provider.dart';

import '../screens/filters_screen.dart';
import '../screens/tabs_screen.dart';

import '../screens/theme_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(
      String title, IconData icon, Function tapHandler, BuildContext ctx) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Theme.of(ctx).buttonColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(ctx).textTheme.bodyText1.color,
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Drawer(
        elevation: 0,
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: Theme.of(context).accentColor,
              child: Text(
                lan.getTexts('drawer_name'),
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            buildListTile(lan.getTexts('drawer_item1'), Icons.restaurant, () {
              Navigator.of(context).pushReplacementNamed('/');
            }, context),
            buildListTile(lan.getTexts('drawer_item2'), Icons.settings, () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            }, context),
            buildListTile(lan.getTexts('drawer_item3'), Icons.color_lens, () {
              Navigator.of(context).pushNamed(ThemeScreen.routeName);
            }, context),
            Divider(
              height: 20,
              color: Colors.black54,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 20, right: 22),
              child: Text(
                lan.getTexts('drawer_switch_title'),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    lan.getTexts('drawer_switch_item2'),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Switch(
                    value: Provider.of<LanguageProvider>(context, listen: true)
                        .isEn,
                    onChanged: (newVal) {
                      Provider.of<LanguageProvider>(context, listen: false)
                          .changeLan(newVal);
                      Navigator.of(context)
                          .pushReplacementNamed(TabsScreen.routeName);
                      print(
                          Navigator.of(context).focusScopeNode.children.length);
                    },
                    inactiveTrackColor: Colors.white,
                  ),
                  Text(
                    lan.getTexts('drawer_switch_item1'),
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            ),
            Divider(
              height: 20,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }
}
