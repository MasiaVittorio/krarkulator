import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/resources/stack/generic.dart';

class StackWidgetTrigger extends StatelessWidget {

  const StackWidgetTrigger(this.trigger, {
    required this.index,
    required this.outOf,
    Key? key,
  }) : super(key: key);

  final Trigger trigger;
  
  final int index;
  final int outOf;

  Widget get content {
    switch (trigger.from) {
      case BoardElement.artist:
      case BoardElement.scoundrel:
        return const ListTile(
          title: Text("Create a treasure"),
          leading: Icon(McIcons.treasure_chest),
        );
      case BoardElement.birgi:
        // should not go on the stack, mana ability
      case BoardElement.bonusRound:
      case BoardElement.krark:
        // handled by trigger with spell
      case BoardElement.prodigy:
      case BoardElement.veyran:
        // replacement handled automatically, +1/+1 not handled
      case BoardElement.thumb:
      case BoardElement.staff:
        // replacement handled automatically
      default:
    }
    return const Text("Error, this trigger should come from either artist or scoundrel");
  }

  @override
  Widget build(BuildContext context) {
    // final logic = Logic.of(context);


    // final _resolve = logic.solveSpell();
    // final _counter = logic.counter();

    return CardUI(
      title: trigger.from.longName, 
      subTitle: "Triggered Ability", 
      indexPlusOne: index + 1, 
      outOf: outOf,
      image: Image.asset(
        trigger.from.art,
        alignment: trigger.from.alignment,
        fit: BoxFit.cover,
      ),
      artistCredit: trigger.from.artist, 
      children: [content],
    );
  }
}