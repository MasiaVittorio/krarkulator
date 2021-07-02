import 'package:krarkulator/everything.dart';
// import 'pages/all.dart';
import 'collapsed.dart';
import 'extended.dart';
import 'body.dart';

class KrarkStage extends StatelessWidget {
  const KrarkStage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stage<KrPage,dynamic>(
      body: const KrBody(), 
      collapsedPanel: const KrCollapsed(), 
      extendedPanel: const KrExtended(), 
      topBarContent: const StageTopBarContent(
        title: const StageTopBarTitle(
          panelTitle: "Settings",
        ),
      ),
      
      wholeScreen: true,

      storeKey: "krarkulator stage key unique",
      jsonToMainPage: (j) => KrPages.fromName(j)!,
      mainPageToJson: (p) => p.name as dynamic,

      mainPages: StagePagesData<KrPage>.nullable(
        defaultPage: KrPage.board,
        orderedPages: const [
          KrPage.board, KrPage.spell, KrPage.status, KrPage.triggers
        ],
        pagesData: const <KrPage,StagePage>{
          KrPage.board: StagePage(
            icon: Icons.favorite,
            name: "Board",
          ),
          KrPage.triggers: StagePage(
            icon: Icons.favorite,
            name: "Triggers",
          ),
          KrPage.spell: StagePage(
            icon: Icons.favorite,
            name: "Spell",
          ),
          KrPage.status: StagePage(
            icon: Icons.favorite,
            name: "Status",
          ),
        },
      ),

      stageTheme: StageThemeData.nullable(
        accentSelectedPage: true,
        pandaOpenedPanelNavBar: true,
        brightness: StageBrightnessData.nullable(
          brightness: Brightness.light,
          autoDark: false,
          autoDarkMode: AutoDarkMode.timeOfDay,
          darkStyle: DarkStyle.nightBlue,
        ),
        backgroundColors: StageColorsData.nullable(
          lightMainPrimary: const Color(0xFF2E3440),
          darkMainPrimaries: const <DarkStyle,Color>{
            DarkStyle.nightBlue: Color(0xFF222E3C),
            DarkStyle.dark: Color(0xFF1E1E1E),
            DarkStyle.nightBlack: Color(0xFF191919),
            DarkStyle.amoled: Color(0xFF151515),
          },
          lightAccent: const Color(0xFF88c0d0),
          darkAccents: const <DarkStyle,Color>{
            DarkStyle.nightBlue: Color(0xFF64FFDA),
            DarkStyle.dark: Color(0xFFECEFF1),
            DarkStyle.nightBlack: Color(0xFFCFD8DC),
            DarkStyle.amoled: Color(0xFFCFD8DC),
          },
        ),
      ),

    );
  }
}
