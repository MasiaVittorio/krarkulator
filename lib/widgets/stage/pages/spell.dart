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
      margin: padding2Collapsed,
    ),
  );
}


class _CollapsedBody extends StatelessWidget {
  const _CollapsedBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => ExtraButtons(children: [
    SpellEditor(
      title: "Mana\ncost",
      content: (s) => "${s.manaCost}",
      tap: (s) => s.copyWith(manaCost: s.manaCost + 1),
      long: (s) => s.copyWith(manaCost: 0),
    ),
    SpellEditor(
      title: "Mana\nproduct",
      content: (s) => "${s.manaProduct}",
      tap: (s) => s.copyWith(manaProduct: s.manaProduct + 1),
      long: (s) => s.copyWith(manaProduct: 0),
    ),
    SpellEditor(
      tap: (s) => s.copyWith(treasuresProduct: s.treasuresProduct + 1), 
      long: (s) => s.copyWith(treasuresProduct: 0), 
      title: "Treasure\nProduct", 
      content: (s) => "${s.treasuresProduct}",
    ),
  ],margin: EdgeInsets.zero,);
}


class SpellExpanded extends StatelessWidget {

  const SpellExpanded({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = decorationBuilder(theme);
    final text = theme.brightness.contrast;

    return SubSection(
      [
        const Expanded(child: _CollapsedBody(),),
        Expanded(child: ExtraButtons(children: [
          SpellEditor(
            tap: (s) => s.copyWith(krarksProduced: s.krarksProduced + 1), 
            long: (s) => s.copyWith(krarksProduced: 0), 
            title: "Krark\ncopies", 
            content: (s) => "${s.krarksProduced}",
            image: decoration("assets/images/arts/Krark_the_Thumbless.jpg"),
            overrideTextColor: text,
          ),
          SpellEditor(
            tap: (s) => s.copyWith(thumbsProduced: s.thumbsProduced + 1), 
            long: (s) => s.copyWith(thumbsProduced: 0), 
            title: "Thumb\ncopies", 
            content: (s) => "${s.thumbsProduced}",
            image: decoration("assets/images/arts/Krarks_Thumb.jpg"),
            overrideTextColor: text,
          ),
          SpellEditor(
            tap: (s) => s.copyWith(veyransProduced: s.veyransProduced + 1), 
            long: (s) => s.copyWith(veyransProduced: 0), 
            title: "Veyran\ncopies", 
            content: (s) => "${s.veyransProduced}",
            image: decoration("assets/images/arts/Veyran_Voice_of_Duality.jpg"),
            overrideTextColor: text,
          ),
          SpellEditor(
            tap: (s) => s.copyWith(prodigiesProduced: s.prodigiesProduced + 1), 
            long: (s) => s.copyWith(prodigiesProduced: 0), 
            title: "Prodigy\ncopies", 
            content: (s) => "${s.prodigiesProduced}",
            image: decoration("assets/images/arts/Harmonic_Prodigy.jpg"),
            overrideTextColor: text,
          ),          
        ],margin: EdgeInsets.zero, separate: false),),
        Expanded(child: ExtraButtons(children: [
          SpellEditor(
            tap: (s) => s.copyWith(scoundrelProduced: s.scoundrelProduced + 1), 
            long: (s) => s.copyWith(scoundrelProduced: 0), 
            title: "Scoundrel\ncopies", 
            content: (s) => "${s.scoundrelProduced}",
            image: decoration("assets/images/arts/Tavern_Scoundrel.jpg"),
            overrideTextColor: text,
          ),
          SpellEditor(
            tap: (s) => s.copyWith(artistsProduced: s.artistsProduced + 1), 
            long: (s) => s.copyWith(artistsProduced: 0), 
            title: "Artist\ncopies", 
            content: (s) => "${s.artistsProduced}",
            image: decoration("assets/images/arts/Storm_Kiln_Artist.jpg"),
            overrideTextColor: text,
          ),
          SpellEditor(
            tap: (s) => s.copyWith(birgisProduced: s.birgisProduced + 1), 
            long: (s) => s.copyWith(birgisProduced: 0), 
            title: "Birgi\ncopies", 
            content: (s) => "${s.birgisProduced}",
            image: decoration("assets/images/arts/Birgi_God_of_Storytelling.jpg"),
            overrideTextColor: text,
          ),
          SpellEditor(
            tap: (s) => s.copyWith(bonusRounds: s.bonusRounds + 1), 
            long: (s) => s.copyWith(bonusRounds: 0), 
            title: "Bonus\nrounds", 
            content: (s) => "${s.bonusRounds}",
            image: decoration("assets/images/arts/Bonus_Round.jpg"),
            overrideTextColor: text,
          ),
        ],margin: EdgeInsets.zero, separate: false),),
      ], 
      mainAxisSize: MainAxisSize.max, 
      margin: padding2Expanded,
    );
  }
}
