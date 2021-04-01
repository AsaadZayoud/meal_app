import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/language_provider.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ThemeScreen extends StatelessWidget {
  final bool fromOnBoarding;
  const ThemeScreen({Key key, this.fromOnBoarding = false}) : super(key: key);
  static const routeName = './theme';
  @override
  Widget build(BuildContext context) {
    final lan = Provider.of<LanguageProvider>(context, listen: true);
    Widget buildRadioListTile(
      ThemeMode themeval,
      String txt,
      IconData icon,
      BuildContext ctx,
    ) {
      return RadioListTile(
        secondary: Icon(
          icon,
          color: Theme.of(ctx).buttonColor,
        ),
        value: themeval,
        groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
        onChanged: (newThemeVAl) =>
            Provider.of<ThemeProvider>(ctx, listen: false)
                .themeModeChange(newThemeVAl),
        title: Text(txt),
      );
    }

    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: fromOnBoarding
            ? AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
              )
            : AppBar(
                title: lan.getTexts('theme_appBar_title"'),
              ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                lan.getTexts('theme_screen_title'),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(lan.getTexts('theme_mode_title'),
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  buildRadioListTile(ThemeMode.system,
                      lan.getTexts('System_default_theme'), null, context),
                  buildRadioListTile(
                      ThemeMode.light,
                      lan.getTexts('light_theme'),
                      Icons.wb_sunny_rounded,
                      context),
                  buildRadioListTile(ThemeMode.dark, lan.getTexts('dark_theme'),
                      Icons.lightbulb, context),
                  buildListTile(context, 'primary'),
                  buildListTile(context, 'accent'),
                  SizedBox(height: fromOnBoarding ? 80 : 0),
                ],
              ),
            ),
          ],
        ),
        drawer: fromOnBoarding ? null : MainDrawer(),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, txt) {
    final lan = Provider.of<LanguageProvider>(context, listen: true);
    var primeryColor =
        Provider.of<ThemeProvider>(context, listen: true).primeryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    return ListTile(
      title: Text(
        lan.isEn
            ? "Change your $txt color"
            : "اختر لونك ${txt == 'primary' ? "الاساسي" : " الفرعي"} ",
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: CircleAvatar(
        backgroundColor: txt == "primary" ? primeryColor : accentColor,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                elevation: 4,
                titlePadding: const EdgeInsets.all(0.0),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: txt == "primary"
                        ? Provider.of<ThemeProvider>(context, listen: true)
                            .primeryColor
                        : Provider.of<ThemeProvider>(context, listen: true)
                            .accentColor,
                    onColorChanged: (newColor) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .onChange(newColor, txt == "primary" ? 1 : 2);
                    },
                    colorPickerWidth: 300.0,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    showLabel: false,
                  ),
                ),
              );
            });
      },
    );
  }
}
