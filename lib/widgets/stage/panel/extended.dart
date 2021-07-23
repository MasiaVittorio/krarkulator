import 'package:krarkulator/everything.dart';
import 'pages/all.dart';

class KrExtended extends StatelessWidget {
  const KrExtended({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StageExtendedPanel<PanelPage>(
      canvasBackground: true,
      children: const {
        PanelPage.dice: RandomPanel(),
        PanelPage.spells: SizedBox(),
        PanelPage.themes: SizedBox(),
      }
    );
  }
}