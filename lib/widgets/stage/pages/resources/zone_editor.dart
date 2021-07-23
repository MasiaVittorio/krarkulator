import 'package:krarkulator/everything.dart';


class ZoneEditor extends StatelessWidget {
  const ZoneEditor({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    
    return logic.zone.build((context, zone) => ExtraButton(
      icon: const <Zone, IconData>{
        Zone.hand: McIcons.hand_right,
        Zone.graveyard: ManaIcons.flashback,
        Zone.stack: McIcons.cards_outline,
      }[zone] ?? Icons.error,
      customCircleColor: Colors.transparent,
      text: (const <Zone, String>{
        Zone.hand: "Spell\nin hand",
        Zone.graveyard: "Spell\nin yard",
        Zone.stack: "On the\nstack",
      })[zone] ?? "error",
      twoLines: true,
      onTap: () => logic.zone.set((const {
        Zone.hand: Zone.stack,
        Zone.stack: Zone.graveyard,
        Zone.graveyard: Zone.hand,
      })[zone]!),
    ),);
  }
}