import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/language_provider.dart';

import '../dummy_data.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildContainer(Widget child, ctx) {
    bool islandscape = MediaQuery.of(ctx).orientation == Orientation.landscape;
    var dw = MediaQuery.of(ctx).size.width;
    var dh = MediaQuery.of(ctx).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(ctx).cardColor,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      height: islandscape ? dh * 0.5 : dh * 0.25,
      width: islandscape ? (dw * 0.5 - 30) : dw,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    var accentColor = Theme.of(context).accentColor;
    List<String> liststeps = lan.getTexts('steps-$mealId') as List<String>;
    var stips = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('# ${(index + 1)}'),
            ),
            title: Text(
              liststeps[index],
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Divider()
        ],
      ),
      itemCount: liststeps.length,
    );
    List<String> listingradeans =
        lan.getTexts('ingredients-$mealId') as List<String>;
    var ingradeans = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Card(
        color: accentColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Text(
            listingradeans[index],
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
      itemCount: listingradeans.length,
    );
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(lan.getTexts('meal-${selectedMeal.id}')),
                background: Hero(
                  tag: mealId,
                  child: InteractiveViewer(
                    child: FadeInImage(
                      image: NetworkImage(
                        selectedMeal.imageUrl,
                      ),
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/placeholder.png'),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (islandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            buildSectionTitle(
                                context, lan.getTexts('Ingredients')),
                            buildContainer(ingradeans, context),
                          ],
                        ),
                        Column(
                          children: [
                            buildSectionTitle(context, lan.getTexts('Steps')),
                            buildContainer(stips, context),
                          ],
                        )
                      ],
                    ),
                  if (!islandscape)
                    buildSectionTitle(context, lan.getTexts('Ingredients')),
                  if (!islandscape) buildContainer(ingradeans, context),
                  if (!islandscape)
                    buildSectionTitle(context, lan.getTexts('Steps')),
                  if (!islandscape) buildContainer(stips, context),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Provider.of<MealProvider>(context, listen: true)
                    .isFavorite(mealId)
                ? Icons.star
                : Icons.star_border),
            onPressed: () => Provider.of<MealProvider>(context, listen: false)
                .toggleFavorite(mealId)),
      ),
    );
  }
}
