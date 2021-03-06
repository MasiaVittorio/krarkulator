import 'package:krarkulator/everything.dart';
import 'stage/panel/collapsed.dart';
import 'stage/panel/extended.dart';
import 'stage/body.dart';
import 'stage/reset.dart';

class KrarkStage extends StatelessWidget {
  const KrarkStage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stage<KrPage,PanelPage>(
    body: const KrBody(), 
    collapsedPanel: const KrCollapsed(), 
    extendedPanel: const KrExtended(), 
    topBarContent: const StageTopBarContent(
      title: StageTopBarTitle(
        panelTitle: "Krarkulator",
      ),
      secondary: ResetButton(),
    ),
    
    wholeScreen: true,

    storeKey: "krarkulator stage key unique",
    jsonToPanelPage: (j) => PanelPages.fromName(j)!,
    panelPageToJson: (p) => p.name,

    panelPages: const StagePagesData<PanelPage>.nullable(
      defaultPage: PanelPage.spells,
      orderedPages: [
        PanelPage.dice, PanelPage.spells, PanelPage.themes, PanelPage.info,
      ],
      pagesData: <PanelPage,StagePage>{
        PanelPage.spells: StagePage(
          icon: McIcons.cards,
          unselectedIcon: McIcons.cards_outline,
          name: "Spells",
        ),
        PanelPage.dice: StagePage(
          icon: McIcons.dice_3_outline,
          name: "Random",
        ),
        PanelPage.themes: StagePage(
          icon: McIcons.palette,
          unselectedIcon: McIcons.palette_outline,
          name: "Themes",
        ),
        PanelPage.info: StagePage(
          icon: Icons.info,
          unselectedIcon: Icons.info_outline,
          name: "Info",
        ),
      },
    ),

    jsonToMainPage: (j) => KrPages.fromName(j)!,
    mainPageToJson: (p) => p.name,
    mainPages: const StagePagesData<KrPage>.nullable(
      defaultPage: KrPage.board,
      orderedPages: [
        KrPage.board, KrPage.spell, KrPage.status, KrPage.triggers
      ],
      pagesData: <KrPage,StagePage>{
        KrPage.board: StagePage(
          icon: ManaIcons.creature,
          name: "Board",
          longName: "Board & Effects",
        ),
        KrPage.triggers: StagePage(
          icon: McIcons.cards,
          unselectedIcon: McIcons.cards_outline,
          name: "Stack",
        ),
        KrPage.spell: StagePage(
          icon: ManaIcons.sorcery,
          name: "Spell",
          longName: "Spells",
        ),
        KrPage.status: StagePage(
          icon: ManaIcons.c,
          name: "Status",
          longName: "Resources & Info",
        ),
      },
    ),

    stageTheme: StageThemeData.nullable(
      accentSelectedPage: true,
      pandaOpenedPanelNavBar: true,
      brightness: const StageBrightnessData.nullable(
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
