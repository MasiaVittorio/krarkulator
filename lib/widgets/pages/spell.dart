import 'package:krarkulator/everything.dart';
import 'resources/all.dart';

class SpellCollapsed extends StatelessWidget {

  const SpellCollapsed({required this.width, Key? key }) : super(key: key);
  final double width;

  @override
  Widget build(context) => BodyCollapsedElement(
    page: KrPage.spell,
    title: "Spell",
    width: width,
    child: const SubSection(
      [Expanded(child: _CollapsedBody(),),],
      mainAxisSize: MainAxisSize.max,
      margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
      
    ),
  );
  
}

class _CollapsedBody extends StatelessWidget {
  const _CollapsedBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);

    return ExtraButtons(children: [
      _SpellEditor(
        title: "Mana\ncost",
        content: (s) => "${s.manaCost}",
        tap: (s) => s.copyWith(manaCost: s.manaCost + 1),
        long: (s) => s.copyWith(manaCost: 0),
      ),
      _SpellEditor(
        title: "Mana\nproduct",
        content: (s) => "${s.manaProduct}",
        tap: (s) => s.copyWith(manaProduct: s.manaProduct + 1),
        long: (s) => s.copyWith(manaProduct: 0),
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
  );
  }
}


class _SpellEditor extends StatelessWidget {
  const _SpellEditor({
    required this.tap, 
    required this.long, 
    required this.title, 
    required this.content, 
    Key? key,
  }) : super(key: key);

  final Spell Function(Spell) tap; 
  final Spell Function(Spell) long;
  final String title; 
  final String Function(Spell) content; 

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);

    return logic.spell.build((context, spell) => ExtraButton(
      icon: null,
      customCircleColor: Colors.transparent,
      customIcon: Text(content(spell)),
      text: title,
      twoLines: title.contains("\n"),
      onTap: () => logic.spell.set(tap(spell)),
      onLongPress: () => logic.spell.set(long(spell)),
    ),);
  }
}



class SpellExpanded extends StatelessWidget {
  const SpellExpanded({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubSection([
      const Expanded(child: _CollapsedBody(),),
      Expanded(child: ExtraButtons(children: [
        _SpellEditor(
          tap: (s) => s.copyWith(treasuresProduct: s.treasuresProduct + 1), 
          long: (s) => s.copyWith(treasuresProduct: 0), 
          title: "Treasure\nProduct", 
          content: (s) => "${s.treasuresProduct}",
        ),
        _SpellEditor(
          tap: (s) => s.copyWith(krarksProduced: s.krarksProduced + 1), 
          long: (s) => s.copyWith(krarksProduced: 0), 
          title: "Krark\ncopies", 
          content: (s) => "${s.krarksProduced}",
        ),
        _SpellEditor(
          tap: (s) => s.copyWith(veyransProduced: s.veyransProduced + 1), 
          long: (s) => s.copyWith(veyransProduced: 0), 
          title: "Veyran\ncopies", 
          content: (s) => "${s.veyransProduced}",
        ),
      ]),),
      Expanded(child: ExtraButtons(children: [
        _SpellEditor(
          tap: (s) => s.copyWith(scoundrelProduced: s.scoundrelProduced + 1), 
          long: (s) => s.copyWith(scoundrelProduced: 0), 
          title: "Scoundrel\ncopies", 
          content: (s) => "${s.scoundrelProduced}",
        ),
        _SpellEditor(
          tap: (s) => s.copyWith(artistsProduced: s.artistsProduced + 1), 
          long: (s) => s.copyWith(artistsProduced: 0), 
          title: "Artist\ncopies", 
          content: (s) => "${s.artistsProduced}",
        ),
        _SpellEditor(
          tap: (s) => s.copyWith(birgisProduced: s.birgisProduced + 1), 
          long: (s) => s.copyWith(birgisProduced: 0), 
          title: "Birgi\ncopies", 
          content: (s) => "${s.birgisProduced}",
        ),
      ]),),
    ], mainAxisSize: MainAxisSize.max, margin: const EdgeInsets.all(12),);
  }
}