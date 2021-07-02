import 'package:krarkulator/everything.dart';


class SpellCollapsed extends StatelessWidget {

  const SpellCollapsed({required this.width, Key? key }) : super(key: key);
  final double width;

  @override
  Widget build(context) {
    final stage = Stage.of<KrPage,dynamic>(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: SidereusScrollPhysics(
        alwaysScrollable: true,
        bottomBounce: true,
        topBounce: true,
        bottomBounceCallback: () => stage.mainPagesController.goToPage(KrPage.spell),
        topBounceCallback: () => stage.mainPagesController.goToPage(KrPage.spell),
      ),
      child: SubSection([
        Expanded(child: Container(alignment: Alignment.center, width: width - 24, child: Text("spell collapsed"),),),
      ], mainAxisSize: MainAxisSize.max, margin: const EdgeInsets.all(12),),
    );
  }
  
}


class SpellExpanded extends StatelessWidget {
  const SpellExpanded({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SubSection([
      Expanded(child: Center(child: Text("spell extended"),),),
    ], mainAxisSize: MainAxisSize.max, margin: const EdgeInsets.all(12),);
  }
}