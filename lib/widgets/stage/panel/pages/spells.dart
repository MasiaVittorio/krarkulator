import 'dart:convert';

import 'package:krarkulator/data/widgets.dart';
import 'package:krarkulator/everything.dart';

class SpellsPanel extends StatelessWidget {
  const SpellsPanel({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    return logic.spellBook.build((_, _book) 
      => logic.spell.build((_, _current){
        final jsonBook = <String,String>{
          for(final e in _book.entries)
            e.key: jsonEncode(e.value.toJson),
        };
        final currentJson = jsonEncode(_current.toJson);

        final saved = jsonBook.values.contains(currentJson);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PanelTitle("Saved Spells"),

            for(final e in jsonBook.entries)
              SpellTile(e.key, _book[e.key]!, e.value, currentJson),

            KrWidgets.divider,

            ListTile(
              leading: Icon(saved ? Icons.check : Icons.add),
              title: Text(saved ? "Current spell saved" : "Save current spell"),
              onTap: saved ? null : () => stage.showAlert(
                InsertAlert(
                  labelText: "Name the spell you're saving",
                  onConfirm: (name) => logic.spellBook.edit((book){
                    book[name] = _current;
                  }),
                ),
                size: InsertAlert.height,
              ),
            ),
          ],
        );
      },),
    );
  }
}

class SpellTile extends StatelessWidget {
  const SpellTile(
    this.name, 
    this.spell,
    this.spellJson, 
    this.currentJson, 
    {Key? key}
  ) : super(key: key);

  final String name;
  final Spell spell;
  final String spellJson;
  final String currentJson;

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of<KrPage,dynamic>(context)!;

    return RadioListTile(
      value: spellJson, 
      groupValue: currentJson, 
      onChanged: (_){
        logic.spell.set(spell);
        stage.closePanelCompletely();
        stage.mainPagesController.goToPage(KrPage.spell);
      },
      title: Text(name),
      secondary: IconButton(
        icon: KrWidgets.deleteIcon,
        onPressed: () => stage.showAlert(
          ConfirmAlert(
            action: (){
              logic.spellBook.value.remove(name);
              logic.spellBook.refresh();
            },
          ),
          size: ConfirmAlert.height,
        ),
      ),
    );
  }
}