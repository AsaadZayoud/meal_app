import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/language_provider.dart';

import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';

class FiltersScreen extends StatefulWidget {
  final bool fromOnBoarding;
  FiltersScreen({Key key, this.fromOnBoarding = false}) : super(key: key);
  static const routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function updateValue,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onChanged: updateValue,
      inactiveTrackColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    final Map<String, bool> currentFilters =
        Provider.of<MealProvider>(context, listen: true).filters;
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        drawer: widget.fromOnBoarding ? null : MainDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              title: widget.fromOnBoarding
                  ? null
                  : Text(lan.getTexts('filters_appBar_title')),
              backgroundColor: widget.fromOnBoarding
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
              elevation: widget.fromOnBoarding ? 0 : 5,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      lan.getTexts('filters_screen_title'),
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildSwitchListTile(
                    lan.getTexts('Gluten-free'),
                    lan.getTexts('Gluten-free-sub'),
                    currentFilters['gluten'],
                    (newValue) {
                      setState(
                        () {
                          currentFilters['gluten'] = newValue;
                        },
                      );

                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    },
                  ),
                  _buildSwitchListTile(
                    lan.getTexts('Lactose-free'),
                    lan.getTexts('Lactose-free_sub'),
                    currentFilters['lactose'],
                    (newValue) {
                      setState(
                        () {
                          currentFilters['lactose'] = newValue;
                        },
                      );
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    },
                  ),
                  _buildSwitchListTile(
                    lan.getTexts('Vegetarian'),
                    lan.getTexts('Vegetarian-sub'),
                    currentFilters['vegetarian'],
                    (newValue) {
                      setState(
                        () {
                          currentFilters['vegetarian'] = newValue;
                        },
                      );
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    },
                  ),
                  _buildSwitchListTile(
                    lan.getTexts('Vegan'),
                    lan.getTexts('Vegan-sub'),
                    currentFilters['vegan'],
                    (newValue) {
                      setState(
                        () {
                          currentFilters['vegan'] = newValue;
                        },
                      );
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
