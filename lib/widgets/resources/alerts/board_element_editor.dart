import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/all.dart';


class BoardElementEditor extends StatelessWidget {

  const BoardElementEditor(this.element, { Key? key }) : super(key: key);

  final BoardElement element;



  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;
    final logic = Logic.of(context);

    return Column(children: <Widget>[
      SectionTitle("How many ${element.plural}"),
      KrWidgets.height10,
      logic.board.build((_, board) => buttons(board.board[element] ?? 0),),
      KrWidgets.height10,
      insertTile(logic, stage),
      KrWidgets.divider,
      logic.board.build(
        (_, board) => doubleTile(board.board[element] ?? 0, logic),
      ),
      KrWidgets.divider,
      logic.board.build(
        (_, board) => resetTile(board.board[element] ?? 0, logic),
      ),
      KrWidgets.height10,
      Expanded(child: quoteWidget),
      KrWidgets.height10,
    ],);
  }

  Widget get quoteWidget => _BottomImage(element); 

  Widget insertTile(Logic logic, StageData stage) => ListTile(
    leading: const Icon(Icons.edit_outlined),
    title: const Text("Insert manually"),
    onTap: () => _edit(stage, logic, element),
  );
 
  Widget doubleTile(int val, Logic logic) => ListTile(
    title: const Text("Double"),
    leading: const Icon(McIcons.chevron_double_up),
    onTap: val == 0 ? null : (){
      logic.board.value.board[element] = val * 2;
      logic.board.refresh();
    },
    enabled: val > 0,
  );

  Widget resetTile(int val, Logic logic) => ListTile(
    title: const Text("Reset to zero"),
    leading: const Icon(Icons.restart_alt),
    onTap: val == 0 ? null : (){
      logic.board.value.board[element] = 0;
      logic.board.refresh();
    },
    enabled: val > 0,
  );

  Widget buttons(int val) => Row(children: <Widget>[

    Expanded(
      flex: 2,
      child: Row(children: <Widget>[
        if(val > 1)
          ...[
            Expanded(child: _Button(element, value: - min(5, val))),
            Expanded(child: _Button(element, value: -1)),
          ]
        else Expanded(child: _Button(element, value: -1, disabled: val == 0,)),
      ].separateWith(KrWidgets.width10),),
    ),

    Expanded(flex: 1, child: _Shower(element, value: val)),

    Expanded(
      flex: 2,
      child: Row(children: <Widget>[
        for(final plus in [1,5])
          Expanded(child: _Button(element, value: plus,)),
      ].separateWith(KrWidgets.width10),),
    ),

  ].separateWith(KrWidgets.width10, alsoFirstAndLast: true),);
}

void _edit(StageData stage, Logic logic, BoardElement element) => stage.showAlert(
  InsertAlert(
    inputType: const TextInputType.numberWithOptions(
      signed: false,
      decimal: false,
    ),
    labelText: "Insert ${element.plural} number",
    checkErrors: (val){
      if(int.tryParse(val) == null) return "Insert a valid number";
      if(int.parse(val) < 0) return "Insert a POSITIVE number!";
      return null;
    },
    onConfirm: (val){
      logic.board.value.board[element] = int.parse(val);
      logic.board.refresh();
    },
  ),
  size: InsertAlert.height
);

class _Shower extends StatelessWidget {

  const _Shower(this.element, {
    required this.value,
    Key? key,
  }) : super(key: key);

  final BoardElement element;
  final int value;
  static const height = ColorShower.height;

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;
    final logic = Logic.of(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.secondary,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _edit(stage, logic, element),
          child: Center(
            child: AutoSizeText(
              value.toString(),
              maxLines: 1,
              minFontSize: 8,
              maxFontSize: 50,
              stepGranularity: 0.5,
              style: TextStyle(
                color: theme.colorScheme.secondary.contrast,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {

  const _Button(this.element, {
    required this.value, 
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  final BoardElement element;
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
            logic.board.value.board[element] 
              = (logic.board.value.board[element] ?? 0) + value;
            logic.board.refresh();
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



class _BottomImage extends StatelessWidget {

  const _BottomImage(this.element, { Key? key }) : super(key: key);

  final BoardElement element;

  static const radius = 12.0;


  @override
  Widget build(BuildContext context) {

    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    final theme = Theme.of(context);
    final bkg = theme.canvasColor;
    final hardBkg = theme.brightness.opposite.contrast;
    final text = theme.brightness.contrast;
    final borderColor = theme.colorScheme.onBackground.withOpacity(0.15);
    final border = Border.all(color: borderColor, width: 1.3);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [

        Positioned.fill(child: image(
          context, bkg, stage, 
          logic, hardBkg, text, border,
        )),

        if(element.quote != null)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: label(theme, border)
        ),
        
      ],),
    );
  }

  Widget label(ThemeData theme, Border border) => Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(radius),
      ),
      border: border,
      color: SubSection.getColor(theme).withOpacity(0.8),
    ),
    padding: const EdgeInsets.all(8),
    child: Text(
      element.quote!,
      textAlign: TextAlign.center,
      style: TextStyle(color: theme.colorScheme.onBackground),
    ),
  );

  Widget image(
    BuildContext context,
    Color bkg, 
    StageData stage, 
    Logic logic, 
    Color hardBkg, 
    Color text, 
    Border border
  ) => GestureDetector(
    onTap: () => stage.showAlert(
      ImageAlert(AssetImage(element.fullImage)),
      size: (
        MediaQuery.of(context).size.width - 
        stage.dimensionsController.dimensions.value
          .panelHorizontalPaddingOpened*2
      ) / ImageAlert.mtgAspectRatio,
    ),
    child: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(element.art),
          fit: BoxFit.cover,
          alignment: element.alignment,
          colorFilter: ColorFilter.mode(
            bkg.withOpacity(0.18), 
            BlendMode.srcOver,
          ),
        ),
      ),
      child: const SizedBox.expand(),
    ),
  );

}
