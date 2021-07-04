import 'package:krarkulator/everything.dart';
import 'resources/generic_collapsed.dart';

class SpellCollapsed extends StatelessWidget {

  const SpellCollapsed({required this.width, Key? key }) : super(key: key);
  final double width;

  @override
  Widget build(context) {
    return BodyCollapsedElement(
      page: KrPage.spell,
      title: "Spell",
      width: width,
      child: const SubSection(
        [Expanded(child: Center(child: Text("collapsed spell"),),),], 
        mainAxisSize: MainAxisSize.max,
        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
      ),
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