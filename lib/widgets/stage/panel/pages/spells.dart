import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/all.dart';

class SpellsPanel extends StatelessWidget {
  const SpellsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    return SingleChildScrollView(
      physics: stage.panelController.panelScrollPhysics(),
      child: logic.spellBook.build((_, book) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const PanelTitle("Saved Spells"),
          for (final spell in book.values) SpellTile(spell),
          KrWidgets.divider,
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("New spell"),
            onTap: () => stage.showAlert(
              SpellEditor(
                  onConfirm: (ns) => logic.newSpellToSpellBook(ns, null)),
              size: SpellEditor.height,
            ),
          ),
        ],
      ),),
    );
  }
}

class SpellTile extends StatelessWidget {
  const SpellTile(
    this.spell, {
    Key? key,
  }) : super(key: key);

  final Spell spell;

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
              null,
            ),
            alreadySavedSpells: {...logic.spellBook.value.keys},
          ),
          replace: true,
          size: SpellEditor.height,
        );

    return SimpleTile(
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
        logic.newSpellToHand(spell, null, null);
        stage.closePanelCompletely();
        stage.mainPagesController.goToPage(KrPage.spell);
        logic.selectedSpellName.set(spell.name);
      },
      onLongPress: () => stage.showAlert(
          AlternativesAlert(
            alternatives: [
              Alternative(
                title: "Edit",
                icon: Icons.edit_outlined,
                action: _edit,
              ),
              Alternative(
                title: "Delete",
                icon: Icons.delete_forever_outlined,
                action: () => logic.deleteFromSavedSpells(spell.name),
                color: KRColors.delete,
                autoClose: true,
              ),
            ],
            label: "Saved spell: ${spell.name}",
          ),
          size: AlternativesAlert.heightCalc(2)),
    );
  }
}
