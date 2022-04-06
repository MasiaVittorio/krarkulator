import 'package:krarkulator/everything.dart';
import 'pages/all.dart';

class KrExtended extends StatelessWidget {
  const KrExtended({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const StageExtendedPanel<PanelPage>(
      canvasBackground: true,
      children: {
        PanelPage.dice: RandomPanel(),
        PanelPage.spells: SpellsPanel(),
        PanelPage.themes: ThemePanel(),
        PanelPage.info: InfoPanel(),
      }
    );
  }
}
