import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/status.dart';

class TreasuresEditor extends StatelessWidget {

  static const double height = 290;
  const TreasuresEditor({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;
    final logic = Logic.of(context);

    return Column(children: <Widget>[
      const SectionTitle("Treasures"),
      KrWidgets.height10,
      logic.treasures.build((_, val) => buttons(val),),
      KrWidgets.height10,
      insertTile(logic, stage),
      KrWidgets.divider,
      logic.treasures.build((_, val) => doubleTile(val, logic),),
      KrWidgets.divider,
      logic.treasures.build((_, val) => resetTile(val, logic),),
      KrWidgets.height10,
    ],);
  }

  Widget insertTile(Logic logic, StageData stage) => ListTile(
    leading: const Icon(Icons.edit_outlined),
    title: const Text("Insert manually"),
    onTap: () => _edit(stage, logic),
  );
 
  Widget doubleTile(int val, Logic logic) => ListTile(
    title: const Text("Double"),
    leading: const Icon(McIcons.chevron_double_up),
    onTap: val == 0 ? null : () => logic.treasures.set(val * 2),
    enabled: val > 0,
  );

  Widget resetTile(int val, Logic logic) => ListTile(
    title: const Text("Reset to zero"),
    leading: const Icon(Icons.restart_alt),
    onTap: val == 0 ? null : () => logic.treasures.set(0),
    enabled: val > 0,
  );

  Widget buttons(int val) => Row(children: <Widget>[

    Expanded(
      flex: 2,
      child: Row(children: <Widget>[
        if(val > 1)
          ...[
            Expanded(child: _Button(value: - min(5, val))),
            const Expanded(child: _Button(value: -1)),
          ]
        else Expanded(child: _Button(value: -1, disabled: val == 0,)),
      ].separateWith(KrWidgets.width10),),
    ),

    Expanded(flex: 1, child: _Shower(value: val)),

    Expanded(
      flex: 2,
      child: Row(children: <Widget>[
        for(final plus in [1,5])
          Expanded(child: _Button(value: plus,)),
      ].separateWith(KrWidgets.width10),),
    ),

  ].separateWith(KrWidgets.width10, alsoFirstAndLast: true),);
}

void _edit(StageData stage, Logic logic) => stage.showAlert(
  InsertAlert(
    inputType: const TextInputType.numberWithOptions(
      signed: false,
      decimal: false,
    ),
    labelText: "Insert treasures value",
    checkErrors: (val){
      if(int.tryParse(val) == null) return "Insert a valid number";
      if(int.parse(val) < 0) return "Insert a POSITIVE number!";
      return null;
    },
    onConfirm: (val) => logic.treasures.set(int.parse(val)),
  ),
  size: InsertAlert.height
);

class _Shower extends StatelessWidget {

  const _Shower({
    required this.value,
    Key? key,
  }) : super(key: key);

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
        color: Treasures.color,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _edit(stage, logic),
          child: Stack(children: [
            Positioned.fill(child: BiggestSquareBuilder(
              scale: 0.8,
              builder: (_, size) => Icon(
                McIcons.treasure_chest, 
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

  const _Button({
    required this.value, 
    this.disabled = false,
    Key? key,
  }) : super(key: key);

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
            logic.treasures.value += value;
            logic.treasures.refresh();
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

