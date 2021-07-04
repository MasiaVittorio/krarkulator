import 'package:krarkulator/everything.dart';
import 'resources/all.dart';

class BoardCollapsed extends StatelessWidget {

  const BoardCollapsed({required this.width, Key? key }) : super(key: key);
  final double width;

  @override
  Widget build(context) {
    final logic = Logic.of(context);

    return BodyCollapsedElement(
      page: KrPage.board,
      title: "Board",
      width: width,
      child: SubSection(
        [Expanded(child: ExtraButtons(children: [
          IntToggle(
            title: "Krarks",
            variable: logic.krarks,
            defaultVal: 1,
          ),
          IntToggle(
            title: "Thumbs",
            variable: logic.thumbs,
            defaultVal: 0,
          ),
        ],),),],
        mainAxisSize: MainAxisSize.max,
        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        
      ),
    );
  }
  
}


class BoardExpanded extends StatelessWidget {
  const BoardExpanded({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final logic = Logic.of(context);

    return SubSection(
      [
        Expanded(child: ExtraButtons(children: [
          IntToggle(
            title: "Krarks",
            variable: logic.krarks,
            defaultVal: 1,
          ),
          IntToggle(
            title: "Thumbs",
            variable: logic.thumbs,
            defaultVal: 0,
          ),
        ],),),
        Expanded(child: ExtraButtons(children: [
          IntToggle(
            title: "Scoundrels",
            variable: logic.scoundrels,
            defaultVal: 0,
          ),
          IntToggle(
            title: "Artists",
            variable: logic.artists,
            defaultVal: 0,
          ),
        ],),),
        Expanded(child: ExtraButtons(children: [
          IntToggle(
            title: "Veyrans",
            variable: logic.veyrans,
            defaultVal: 0,
          ),
        ],),),
      ],
      mainAxisSize: MainAxisSize.max, 
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
    );
  }
}