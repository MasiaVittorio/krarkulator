import 'package:krarkulator/everything.dart';


class SpellEditor extends StatelessWidget {
  const SpellEditor({
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
