import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/all.dart';
import 'package:krarkulator/widgets/stage/pages/resources/stack/generic.dart';


class StackWidgetSpell extends StatelessWidget {

  const StackWidgetSpell(this.spellOnTheStack, {
    required this.index,
    required this.outOf,
    Key? key,
  }) : super(key: key);

  final SpellOnTheStack spellOnTheStack;

  final int index;
  final int outOf;

  Spell get spell => spellOnTheStack.spell;
  bool get isPhysical => spellOnTheStack.isPhysical;
  bool get isCopy => spellOnTheStack.isCopy;

  @override
  Widget build(BuildContext context) {
    return CardUI(
      title: spell.name, 
      subTitle: isPhysical ? 'Original Spell' : "Spell Copy", 
      indexPlusOne: index + 1, 
      outOf: outOf, 
      children: <Widget>[
        if(spell.producesMana)
          SimpleTile(
            title: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text("Add: "),
            ),
            expandTrailing: true,
            expandedTrailingAlignment: Alignment.centerLeft,
            trailing: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: spell.manaProduct.costWidget(),
            ),
          ),
        if(spell.treasuresProduct == 1)
          const ListTile(
            title: Text("Create one treasure"),
            leading: Icon(McIcons.treasure_chest),
          ) 
        else if(spell.treasuresProduct > 1)
          ListTile(
            title: Text("Create ${spell.treasuresProduct} treasures"),
            leading: const Icon(McIcons.treasure_chest),
          ),
        if(spell.producesBoard) ...[
          const SectionTitle("Other products"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for(final e in spell.boardProduct.keys)
                  if((spell.boardProduct[e] ?? 0) != 0)
                    BoardElementShower(e, val: spell.boardProduct[e]!)
              ].separateWith(KrWidgets.width10, alsoFirstAndLast: true),
            ),
          ),
        ],
      ].separateWith(KrWidgets.height5,),
    );

  }

}


class BoardElementShower extends StatelessWidget {

  static const double height = 56;

  const BoardElementShower(this.element, {
    required this.val,
    Key? key,
  }) : super(key: key);

  final BoardElement element;
  final int val;

  bool get fixedNumber => val >= 0;

  bool get doubling => val == -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(64),
        image: DecorationImage(
          image: AssetImage(element.art),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            theme.canvasColor.withOpacity(0.5), 
            BlendMode.srcOver,
          ),
        )
      ),
      alignment: Alignment.center,
      child: IconButton(
        onPressed: null, 
        icon: Text(
          doubling ? "x2" : "+$val",
          style: TextStyle(color: theme.brightness.contrast),
        ),
      ),
    );
  }


}

class ManaCostShower extends StatelessWidget {

  const ManaCostShower(this.cost, {
    required this.title,
    this.right = true,
    Key? key,
  }) : super(key: key);

  final String title;

  final bool right;

  final Map<MtgColor?, int> cost;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        SectionTitle(title),
        SizedBox(
          height: 50,
          child: Center(child: cost.hasSomething 
            ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: right,
                child: cost.costWidget(
                  size: 30,
                ),
              ),
            )
            : const Text(
              "Empty", 
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
    );
  }

  static const double addH = 42;
}