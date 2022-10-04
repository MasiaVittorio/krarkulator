import 'package:krarkulator/everything.dart';
import 'pages/all.dart';

class KrBody extends StatelessWidget {

  const KrBody({ Key? key }) : super(key: key);

  static const int n = 4;

  @override
  Widget build(BuildContext context){
    
    return StageBody<KrPage>(
      customBackground: (theme) => theme.canvasColor,
      children: {
        KrPage.board: BoardBody(),
        KrPage.spell: SpellBody(),
        KrPage.status: StatusBody(),
        KrPage.triggers: StackBody(),
      },
    );
    
  }
}

