import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/resources/stack/flip.dart';
import 'package:krarkulator/widgets/stage/pages/resources/stack/generic.dart';

class StackWidgetTriggerWithSpell extends StatelessWidget {

  const StackWidgetTriggerWithSpell(this.triggerWithSpell, {
    required this.index,
    required this.outOf,
    Key? key,
  }): super(key: key);

  final TriggerWithSpell triggerWithSpell;

  final int index;
  final int outOf;

  BoardElement get from => triggerWithSpell.from;
  Spell get spell => triggerWithSpell.spell;

  String get title {
    switch (from) {
      case BoardElement.krark:
        return "Krark the Thumbless";
      case BoardElement.bonusRound:
        return "Bonus Round";
      case BoardElement.artist:
      case BoardElement.birgi:
      case BoardElement.prodigy:
      case BoardElement.scoundrel:
      case BoardElement.staff:
      case BoardElement.thumb:
      case BoardElement.veyran:
        return "error: trigger with spell shouldn't be from anything other than krark or bonus round";
    }
  }

  String get link => '(Linked to spell: "${spell.name}")';

  String get description {
    switch (from) {
      case BoardElement.krark:
        return "Flip a coin, then you either bounce the original spell (if it's still on the stack), or copy it (even if the original is not on the stack anymore)";
      case BoardElement.bonusRound:
        return "Put a copy of the spell on the stack (even if the original spell is not on the stack anymore)";
      case BoardElement.artist:
      case BoardElement.birgi:
      case BoardElement.prodigy:
      case BoardElement.scoundrel:
      case BoardElement.staff:
      case BoardElement.thumb:
      case BoardElement.veyran:
        return "error: trigger with spell shouldn't be from anything other than krark or bonus round";
    }
  }

  String get typeline {
    switch (from) {
      case BoardElement.krark:
        return "Triggered ability";
      case BoardElement.bonusRound:
        return "Delayed triggered ability";
      case BoardElement.artist:
      case BoardElement.birgi:
      case BoardElement.prodigy:
      case BoardElement.scoundrel:
      case BoardElement.staff:
      case BoardElement.thumb:
      case BoardElement.veyran:
        return "error: trigger with spell shouldn't be from anything other than krark or bonus round";
    }
  }

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    
    if(from == BoardElement.krark && index == outOf - 1){
      return logic.replacement.build((_, flips) => flips == null 
        ? thisTrigger
        : ReplacementChild(flips),
      );
    }

    return thisTrigger;

  }

  Widget get thisTrigger => CardUI(
    title: title, 
    subTitle: typeline, 
    indexPlusOne: index + 1, 
    outOf: outOf,
    image: Image.asset(
      from.art,
      alignment: from.alignment,
      fit: BoxFit.cover,
    ),
    artistCredit: from.artist, 
    children: [
      Text(link, style: const TextStyle(fontStyle: FontStyle.italic),),
      const SizedBox(height: 4,),
      Text(description),
    ],
  );

}

