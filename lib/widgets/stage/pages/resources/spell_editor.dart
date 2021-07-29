import 'package:krarkulator/everything.dart';


class SpellEditor extends StatelessWidget {
  const SpellEditor({
    required this.tap, 
    required this.long, 
    required this.title, 
    required this.content, 
    this.image,
    this.overrideTextColor,
    Key? key,
  }) : super(key: key);

  final Spell Function(Spell) tap; 
  final Spell Function(Spell) long;
  final String title; 
  final String Function(Spell) content; 
  final DecorationImage? image;
  final Color? overrideTextColor;

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);

    return logic.spell.build((context, spell) => ExtraButton(
      icon: null,
      customCircleColor: Colors.transparent,
      customIcon: Text(
        content(spell), 
        style: TextStyle(color: overrideTextColor),
      ),
      text: title,
      twoLines: title.contains("\n"),
      onTap: () => logic.spell.set(tap(spell)),
      onLongPress: () => logic.spell.set(long(spell)),
      image: image,
      overrideTextColor: overrideTextColor,
      borderRadius: image!=null ? BorderRadius.zero : null,
      expandVertically: image!=null ? true : false,
    ),);
  }
}
