import 'package:krarkulator/everything.dart';


class SpellBody extends StatelessWidget {
  const SpellBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Stage.of(context)!.dimensionsController.dimensions
          .value.collapsedPanelSize / 2,
      ),
      child: const ExpandableList([
        ExpandableItem(
          expandedChild: ExpandedHand(), 
          collapsedChild: CollapsedHand(), 
          collapsedSize: 64,
        ),
        ExpandableItem(
          expandedChild: ExpandedGraveyard(), 
          collapsedChild: CollapsedGraveyard(), 
          collapsedSize: 64,
        ),
      ]),
    );
  }
}

class ExpandedGraveyard extends StatelessWidget {
  const ExpandedGraveyard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Spells in hand"),
        KrWidgets.height10,
        Expanded(child: logic.graveyard.build((_, grave) => grave.isEmpty 
          ? const GraveyardEmpty()
          : ListView(children: [
              for(int i=0; i<grave.length; ++i)
                GraveSpellTile(grave[i], graveIndex: i,),
            ],),
        ),),
      ],
    );
  }
}


class ExpandedHand extends StatelessWidget {

  const ExpandedHand({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Spells in hand"),
        KrWidgets.height10,
        Expanded(child: logic.hand.build((_, hand) => hand.isEmpty 
          ? const NewSpellButton()
          : ListView(children: [
              for(int i=0; i<hand.length; ++i)
                SpellTile(hand[i], handIndex: i,),
              KrWidgets.divider,
              const NewSpellTile(),
            ],),
        ),),
      ],
    );
  }
}

class SpellTile extends StatelessWidget {

  const SpellTile(this.spell, {
    required this.handIndex,
    Key? key,
  }) : super(key: key);

  final Spell spell;
  final int handIndex;

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    void _edit() => stage.showAlert(
      SpellEditor(
        initialSpell: spell,
        onConfirm: (newSpell) => logic.newSpellToHand(
          newSpell, 
          spell.name, 
          handIndex,
        ),
        alreadySavedSpells: {...logic.spellBook.value.keys},
      ),
      replace: true,
      size: SpellEditor.height,
    );

    void _alternatives() => stage.showAlert(
      AlternativesAlert(
        alternatives: [
          Alternative(
            title: "Edit", 
            icon: Icons.edit_outlined, 
            action: _edit,
          ),
          Alternative(
            title: "Move to graveyard", 
            icon: ManaIcons.flashback, 
            action: () => logic.moveSpellToGraveyard(handIndex),
            autoClose: true,
          ),
          Alternative(
            title: "Remove from hand", 
            icon: Icons.delete_forever_outlined, 
            action: () => logic.deleteFromHand(handIndex),
            color: KRColors.delete,
            autoClose: true,
          ),
        ], 
        label: "Spell: ${spell.name}",
      ),
      size: AlternativesAlert.heightCalc(3)
    );

    return SimpleTile(
      leading: logic.selectedSpellName.build((_, name) => Radio(
        value: spell.name, 
        groupValue: name, 
        onChanged: null,
      ),),
      title: Text(spell.name),
      trailing: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: spell.manaCost.costWidget(),
      ),
      expandTrailing: true,
      height: 64,
      onTap: () {
        if( logic.selectedSpellName.value == spell.name){
          _alternatives();
        } else {
          logic.selectedSpellName.set(spell.name);
        }
      },
      onLongPress: _alternatives,
    );
  }
}

class GraveSpellTile extends StatelessWidget {

  const GraveSpellTile(this.spell, { 
    required this.graveIndex, 
    Key? key,
  }) : super(key: key);

  final Spell spell;
  final int graveIndex;

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    return SimpleTile(
      leading: const Icon(ManaIcons.flashback),
      title: Text(spell.name),
      trailing: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: spell.manaCost.costWidget(),
      ),
      expandTrailing: true,
      height: 64,
      onTap: () => stage.showAlert(
        AlternativesAlert(
          alternatives: [
            Alternative(
              title: "Move to hand", 
              icon: McIcons.hand, 
              action: () => logic.moveSpellFromGraveTohand(graveIndex),
              autoClose: true,
            ),
            Alternative(
              title: "Remove from graveyard", 
              icon: Icons.delete_forever_outlined, 
              action: () => logic.deleteFromGraveyard(graveIndex),
              color: KRColors.delete,
              autoClose: true,
            ),
          ], 
          label: "Spell: ${spell.name}",
        ),
        size: AlternativesAlert.heightCalc(2)
      ),
    );

  }
}

class GraveyardEmpty extends StatelessWidget {

  const GraveyardEmpty({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BiggestSquareBuilder(
          scale: 0.5,
          builder: (_, size) => Icon(
            ManaIcons.flashback,
            size: size,
            color: Theme.of(context).colorScheme.onBackground
                .withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 20,),
        const Text("Your graveyard is empty!", style: TextStyle(fontSize: 18),),
      ],
    ),);
  }
}

class NewSpellButton extends StatelessWidget {

  const NewSpellButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final logic = Logic.of(context);

    return InkWell(
      onTap: () => stage.showAlert(
        SpellEditor(
          onConfirm: (spell){
            logic.newSpellToHand(spell, null, null);
          },
          alreadySavedSpells: {...logic.spellBook.value.keys},
        ),
        size: SpellEditor.height,
      ),
      child: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BiggestSquareBuilder(
            scale: 0.6,
            builder: (_, size) => Icon(
              Icons.add_circle_outline,
              size: size,
              color: Theme.of(context).colorScheme.onBackground
                  .withOpacity(0.7),
            ),
          ),
          const Text("Add a spell to your hand", style: TextStyle(fontSize: 18),),
        ],
      ),),
    );
  }
}

class NewSpellTile extends StatelessWidget {

  const NewSpellTile({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final logic = Logic.of(context);

    return SimpleTile(
      height: 64,
      leading: const Icon(Icons.add),
      title: const Text("Add spell"),
      onTap: () => stage.showAlert(
        SpellEditor(
          onConfirm: (spell){
            logic.newSpellToHand(spell, null, null);
          },
          alreadySavedSpells: {...logic.spellBook.value.keys},
        ),
        size: SpellEditor.height,
      ),
    );
  }
}


class CollapsedHand extends StatelessWidget {

  const CollapsedHand({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);

    return SimpleTile(
      leading: const Icon(McIcons.hand), 
      title: logic.hand.build((_, hand) 
        => Text("${hand.isEmpty ? 'Zero' : hand.length} cards in hand")),
    );
  }
}

class CollapsedGraveyard extends StatelessWidget {

  const CollapsedGraveyard({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);

    return SimpleTile(
      leading: const Icon(ManaIcons.flashback), 
      title: logic.graveyard.build((_, grave) 
        => Text("${grave.isEmpty ? 'Zero' : grave.length} cards in graveyard")),
    );
  }
}

class SimpleTile extends StatelessWidget {

  const SimpleTile({ 
    required this.title,    
    this.leading, 
    this.trailing,
    this.height,
    this.onTap,
    this.onLongPress,
    this.expandTrailing = false,
    this.expandedTrailingAlignment = Alignment.centerRight,
    Key? key,
  }) : super(key: key);

  final Widget? leading;
  final Widget? trailing;
  final Widget title;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool expandTrailing;
  final Alignment expandedTrailingAlignment;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Padding(
      padding: EdgeInsets.only(
        left: leading == null ? 16 : 0,
        right: trailing == null ? 16 : 0,
      ),
      child: title,
    );
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(leading != null)
              BiggestSquareAtLeast(child: Center(child: leading,)),
            if(expandTrailing) titleWidget
            else Expanded(child: titleWidget),
            if(trailing != null)
              if(expandTrailing)
                Expanded(child: Align(
                  alignment: expandedTrailingAlignment,
                  child: trailing!,
                ),)
              else 
                BiggestSquareAtLeast(child: Center(child: trailing,)),
          ],
        ),
      ),
    );
  }
}

