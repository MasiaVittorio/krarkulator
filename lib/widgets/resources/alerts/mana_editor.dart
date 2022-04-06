import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/status.dart';

class ManaEditor extends StatelessWidget {

  const ManaEditor(this.color, { Key? key }) : super(key: key);

  final MtgColor? color; 

  String get quote {
    switch (color) {
      case MtgColor.w:
        return "White is the color of organization, law, and morality. It seeks peace through order.";
      case MtgColor.u:
        return "Blue is the color of logic, depth, and progress. It seeks perfection through knowledge.";
      case MtgColor.b:
        return "Black is the color of death, amorality, and individualism. It seeks satisfaction through ruthlessness.";
      case MtgColor.r:
        return "Red is the color of impulse, emotion, and chaos. Red seeks freedom through action.";
      case MtgColor.g:
        return "Green is the color of nature, instinct, and harmony. Green seeks growth through acceptance.";
      case null:
        return "Detached from all other colors and philosophies, colorless cards tend to be unique, artificial, and unknowable.";
    }
  }

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;
    final logic = Logic.of(context);

    return Column(children: <Widget>[
      SectionTitle("${color.label} Mana pool"),
      KrWidgets.height10,
      logic.manaPool.build((_, mana) => buttons(mana.pool[color] ?? 0),),
      KrWidgets.height10,
      insertTile(logic, stage),
      KrWidgets.divider,
      logic.manaPool.build(
        (_, mana) => doubleTile(mana.pool[color] ?? 0, logic),
      ),
      KrWidgets.divider,
      logic.manaPool.build(
        (_, mana) => resetTile(mana.pool[color] ?? 0, logic),
      ),
      KrWidgets.height10,
      Expanded(child: quoteWidget),
      KrWidgets.height10,
    ],);
  }

  Widget get quoteWidget => SubSection(
    [Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: AutoSizeText(
        quote,
        textAlign: TextAlign.center,
        minFontSize: 14,
        maxFontSize: 20,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    )], 
    overrideColor: color.color.withOpacity(0.3),
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
  ); 

  Widget insertTile(Logic logic, StageData stage) => ListTile(
    leading: const Icon(Icons.edit_outlined),
    title: const Text("Insert manually"),
    onTap: () => _edit(stage, logic, color),
  );
 
  Widget doubleTile(int val, Logic logic) => ListTile(
    title: const Text("Double"),
    leading: const Icon(McIcons.chevron_double_up),
    onTap: val == 0 ? null : (){
      logic.manaPool.value.pool[color] = val * 2;
      logic.manaPool.refresh();
    },
    enabled: val > 0,
  );

  Widget resetTile(int val, Logic logic) => ListTile(
    title: const Text("Reset to zero"),
    leading: const Icon(Icons.restart_alt),
    onTap: val == 0 ? null : (){
      logic.manaPool.value.pool[color] = 0;
      logic.manaPool.refresh();
    },
    enabled: val > 0,
  );

  Widget buttons(int val) => Row(children: <Widget>[

    Expanded(
      flex: 2,
      child: Row(children: <Widget>[
        if(val > 1)
          ...[
            Expanded(child: _Button(color, value: - min(5, val))),
            Expanded(child: _Button(color, value: -1)),
          ]
        else Expanded(child: _Button(color, value: -1, disabled: val == 0,)),
      ].separateWith(KrWidgets.width10),),
    ),

    Expanded(flex: 1, child: _Shower(color, value: val)),

    Expanded(
      flex: 2,
      child: Row(children: <Widget>[
        for(final plus in [1,5])
          Expanded(child: _Button(color, value: plus,)),
      ].separateWith(KrWidgets.width10),),
    ),

  ].separateWith(KrWidgets.width10, alsoFirstAndLast: true),);
}

void _edit(StageData stage, Logic logic, MtgColor? color) => stage.showAlert(
  InsertAlert(
    inputType: const TextInputType.numberWithOptions(
      signed: false,
      decimal: false,
    ),
    labelText: "Insert ${color.label} mana pool value",
    checkErrors: (val){
      if(int.tryParse(val) == null) return "Insert a valid number";
      if(int.parse(val) < 0) return "Insert a POSITIVE number!";
      return null;
    },
    onConfirm: (val){
      logic.manaPool.value.pool[color] = int.parse(val);
      logic.manaPool.refresh();
    },
  ),
  size: InsertAlert.height
);

class _Shower extends StatelessWidget {

  const _Shower(this.color, {
    required this.value,
    Key? key,
  }) : super(key: key);

  final MtgColor? color;
  final int value;
  static const height = ColorShower.height;

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;
    final logic = Logic.of(context);

    return SizedBox(
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: color.color,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _edit(stage, logic, color),
          child: Stack(children: [
            Positioned.fill(child: BiggestSquareBuilder(
              scale: 0.8,
              builder: (_, size) => Icon(
                color.icon, 
                color: Colors.white.withOpacity(0.4),
                size: size,
              ),
            ),),
            Positioned.fill(child: Center(
              child: AutoSizeText(
                value.toString(),
                maxLines: 1,
                minFontSize: 8,
                maxFontSize: 50,
                stepGranularity: 0.5,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),),
          ],),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {

  const _Button(this.color, {
    required this.value, 
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  final MtgColor? color;
  final int value;
  final bool disabled;

  static const height = ColorShower.height;

  @override
  Widget build(BuildContext context) {

    final logic = Logic.of(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: SubSection.getColor(Theme.of(context)),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: disabled ? null : (){
            logic.manaPool.value.pool[color] 
              = (logic.manaPool.value.pool[color] ?? 0) + value;
            logic.manaPool.refresh();
          },
          child: Row(children: [
            Expanded(child: Center(
              child: Text(
                (value > 0 ? "+": "") + value.toString(),
                maxLines: 1,
                style: TextStyle(
                  color: theme.brightness.contrast.withOpacity(
                    disabled ? 0.5 : 1.0,
                  ),
                  fontSize: 14,
                ),
              ),
            ),),
          ],),
        ),
      ),
    );
  }
}

