import 'package:krarkulator/everything.dart';

class ThemePanel extends StatelessWidget {
  const ThemePanel({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    return SingleChildScrollView(
      physics: stage.panelController.panelScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
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
      )
    );
  }
}