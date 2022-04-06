import 'package:flutter/material.dart';
import 'package:krarkulator/data/widgets.dart';
import 'package:krarkulator/logic/logic.dart';
import 'package:krarkulator/models/board.dart';
import 'package:krarkulator/widgets/resources/alerts/board_element_editor.dart';
import 'package:stage/stage.dart';

class BoardBody extends StatelessWidget {
  const BoardBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const data = [
      [BoardElement.krark, BoardElement.thumb],
      [BoardElement.scoundrel, BoardElement.artist],
      [BoardElement.birgi],
      [BoardElement.veyran, BoardElement.prodigy],
      [BoardElement.bonusRound, BoardElement.staff],
    ];

    final stage = Stage.of(context)!;
    final bottom = stage.dimensionsController
        .dimensions.value.collapsedPanelSize / 2;
    
    final minHeight = data.length * (BoardElementTile.size + 10) + 10 + bottom;

    return LayoutBuilder(builder: (_, c){
      if(minHeight > c.maxHeight) {
        return ListView.builder(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: bottom,
          ),
          itemBuilder: (_, int i) => Container(
            height: BoardElementTile.size,
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(children: <Widget>[
              for(final e in data[i])
                Expanded(child: BoardElementTile(e)),
            ].separateWith(KrWidgets.width10),),
          ),
          itemCount: data.length,
          itemExtent: BoardElementTile.size,
        ); 
      } else {
        return Column(children: [
          for(final r in data)
            Expanded(child: Row(children: <Widget>[
              for(final e in r)
                Expanded(child: BoardElementTile(e)),
            ].separateWith(KrWidgets.width10, alsoFirstAndLast: true),)),
          SizedBox(height: bottom,),
        ].separateWith(KrWidgets.height10, alsoFirst: true),);
      }
    },);
  }
}



class BoardElementTile extends StatelessWidget {

  static const size = 120.0;

  const BoardElementTile(this.element, { Key? key }) : super(key: key);

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
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [

        Positioned.fill(child: image(bkg, stage, logic, hardBkg, text, border)),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 20,
          child: label(theme, border)
        ),

        Positioned.fill(child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => stage.showAlert(
              BoardElementEditor(element), 
              size: 500, 
            ),
            child: const SizedBox.expand(),
          ),
        ),),
      ],),
    );
  }

  Widget label(ThemeData theme, Border border) => Container(
    height: 20,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(radius),
      ),
      border: border,
      color: SubSection.getColor(theme).withOpacity(0.8),
    ),
    child: Center(child: Text(
      element.plural,
      style: TextStyle(color: theme.colorScheme.onBackground),
    ),),
  );

  Widget image(Color bkg, StageData stage, Logic logic, Color hardBkg, Color text, Border border) => Container(
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
    child: SizedBox.expand(child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        content(logic, hardBkg, text, border),
        KrWidgets.height15,
      ],
    ),),
  );

  Widget content(Logic logic, Color hardBkg, Color text, Border border) =>  Row(
    children: [
      const Spacer(),
      Container(
        constraints: const BoxConstraints(
          minHeight: textPadding * 2 + fontSize,
          maxHeight: textPadding * 2 + fontSize,
          minWidth: textPadding * 2 + fontSize,
        ),
        decoration: BoxDecoration(
          color: hardBkg.withOpacity(0.6),
          borderRadius: BorderRadius.circular(5000),
          border: border,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 1, left: 8, right: 8),
        child: logic.board.build((_, board) => Text(
          board.howMany.element(element).toString(),
          maxLines: 1,
          style: TextStyle(
            color: text, 
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        )),
      ),
      const Spacer(),
    ],
  );

  static const textPadding = 8;

  static const fontSize = 20.0;

}
