import 'package:krarkulator/everything.dart';
import 'resources/all.dart';

class SpellCollapsed extends StatelessWidget {

  const SpellCollapsed({required this.width, Key? key }) : super(key: key);
  final double width;

  @override
  Widget build(context) {
    final logic = Logic.of(context);

    return BodyCollapsedElement(
      page: KrPage.spell,
      title: "Spell",
      width: width,
      child: SubSection(
        [Expanded(child: logic.spell.build((context, spell) 
          => ExtraButtons(children: [
            ExtraButton(
              icon: null,
              customCircleColor: Colors.transparent,
              customIcon: Text("${spell.manaCost}"),
              text: "Mana\ncost",
              twoLines: true,
              onTap: () => logic.spell.set(spell.copyWith(
                manaCost: spell.manaCost + 1,                
              )),
              onLongPress: () => logic.spell.set(spell.copyWith(
                manaCost: 0,                
              )),
            ),
            ExtraButton(
              icon: null,
              customCircleColor: Colors.transparent,
              customIcon: Text("${spell.manaProduct}"),
              text: "Mana\nproduct",
              twoLines: true,
              onTap: () => logic.spell.set(spell.copyWith(
                manaProduct: spell.manaProduct + 1,                
              )),
              onLongPress: () => logic.spell.set(spell.copyWith(
                manaProduct: 0,                
              )),
            ),
            logic.zone.build((context, zone) => ExtraButton(
              icon: const <Zone, IconData>{
                Zone.hand: McIcons.cards_outline,
                Zone.graveyard: ManaIcons.flashback,
                Zone.stack: ManaIcons.instant,
              }[zone] ?? Icons.error,
              customCircleColor: Colors.transparent,
              text: (const <Zone, String>{
                Zone.hand: "Now\nin hand",
                Zone.graveyard: "Now\nin yard",
                Zone.stack: "On the\nstack",
              })[zone] ?? "error",
              twoLines: true,
              onTap: () => logic.zone.set((const {
                Zone.hand: Zone.stack,
                Zone.stack: Zone.graveyard,
                Zone.graveyard: Zone.hand,
              })[zone]!),
            ),),
          ],
        ),),),],
        mainAxisSize: MainAxisSize.max,
        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        
      ),
    );
  }
  
}


class SpellExpanded extends StatelessWidget {
  const SpellExpanded({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SubSection([
      Expanded(child: Center(child: Text("spell extended"),),),
    ], mainAxisSize: MainAxisSize.max, margin: const EdgeInsets.all(12),);
  }
}