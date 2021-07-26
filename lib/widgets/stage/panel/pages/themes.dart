import 'package:krarkulator/data/widgets.dart';
import 'package:krarkulator/everything.dart';

class ThemePanel extends StatelessWidget {
  const ThemePanel({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, 
    children: const <Widget>[
      PanelTitle("Theme customization"),
      SubSection(<Widget>[
        SectionTitle("Colors"),
        StageSinglePrimaryColor(),
        StageAccentColor(),
      ]),

      KrWidgets.height10,
      KrWidgets.divider,

      SectionTitle("Brightness"),
      StageBrightnessToggle(),
    ],
  );
}