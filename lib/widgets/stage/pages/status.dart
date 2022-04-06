import 'package:auto_size_text/auto_size_text.dart';
import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/resources/alerts/resolved_count.dart';


class StatusBody extends StatelessWidget {
  const StatusBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      const ManaPoolWidget(),
      const SubSection([
        StormCountWidget(),
        CopiedCount(),
      ]),
      const ResolvedWidget(),
    ].separateWith(KrWidgets.height10, alsoFirstAndLast: true),);
  }
}


class ManaPoolWidget extends StatelessWidget {

  const ManaPoolWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);

    return BlocVar.build2(logic.manaPool, logic.favColors, builder: (
      _, ManaPool pool, Map<MtgColor?, bool> favColors,
    ){
      List<MtgColor?> useful = [];
      for(final e in pool.pool.entries){
        if(e.value > 0 || (favColors[e.key] ?? false)) {
          useful.add(e.key);
        }
      }
      

      final children = [
        for(final a in useful)
          ColorShower(a, value: pool.pool[a] ?? 0,),
        logic.treasures.build((_, val) => Treasures(value: val)),
      ];
      
      return SubSection([
        const SectionTitle("Mana Pool & treasures"),
        KrWidgets.height10,
        for(final part in children.part(children.length == 4 ? 2 : 3))
          ...[
            Row(children: <Widget>[
              for(final child in part ?? <Widget>[])
                Expanded(child: child),
            ].separateWith(KrWidgets.width10, alsoFirstAndLast: true),),
            KrWidgets.height10,
          ],
        const EditTile(),
      ],);
    });
  }
}

class EditTile extends StatelessWidget {

  const EditTile({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    return ListTile(
      title: const Text(
        "Edit which colors appear here", 
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      leading: const Icon(Icons.edit_outlined),
      visualDensity: VisualDensity.compact,
      onTap: () => stage.showAlert(
        const ManaPoolEditor(),
        size: 320,
      ),
    );
  }
}

class ColorShower extends StatelessWidget {

  const ColorShower(this.color, {
    required this.value, 
    this.dontOpen = false,
    Key? key,
  }): super(key: key);

  final MtgColor? color;
  final int value;
  final bool dontOpen;

  static const double height = 64;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;

    return SizedBox(
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: color.color,
        child: InkWell(
          onTap: dontOpen ? null : () => stage.showAlert(
            ManaEditor(color),
            size: 370,
          ),
          child: Row(children: [
            BiggestSquareAtLeast(child: Icon(color.icon, color: Colors.black,)),
            Expanded(child: AutoSizeText(
              value.toString(),
              minFontSize: 14,
              maxFontSize: 40,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),),
          ],),
        ),
      ),
    );
  }
}


class Treasures extends StatelessWidget {

  const Treasures({
    required this.value, 
    Key? key,
  }): super(key: key);

  final int value;

  static const double height = 64;
  static const color = Color(0xFFC6AA64);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;

    return SizedBox(
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: color,
        child: InkWell(
          onTap: () => stage.showAlert(
            const TreasuresEditor(),
            size: TreasuresEditor.height,
          ),
          child: Row(children: [
            const BiggestSquareAtLeast(child: Icon(McIcons.treasure_chest, color: Colors.black,)),
            Expanded(child: AutoSizeText(
              value.toString(),
              minFontSize: 14,
              maxFontSize: 40,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),),
          ],),
        ),
      ),
    );
  }
}




class StormCountWidget extends StatelessWidget {

  const StormCountWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;
    
    return logic.storm.build((_, int v) => ListTile(
      title: const Text("Storm Count"),
      leading: const Icon(ManaIcons.instant),
      trailing: Text("$v", style: const TextStyle(fontSize: 20),),
      onTap: () => stage.showAlert(
        const StormCountEditor(),
        size: StormCountEditor.height,
      ),
    ),);
  }
}


class CopiedCount extends StatelessWidget {

  const CopiedCount({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;
    
    return logic.copiedCount.build((_, int v) => ListTile(
      title: const Text("Copied Count"),
      leading: const Icon(Icons.copy),
      trailing: Text("$v", style: const TextStyle(fontSize: 20),),
      onTap: () => stage.showAlert(
        const CopiedCountEditor(),
        size: CopiedCountEditor.height,
      ),
    ),);
  }
}



class ResolvedWidget extends StatelessWidget {

  const ResolvedWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: const Text("Total Resolved Spells"),
      trailing: logic.resolvedCount.build((_, map) => Text(
        map.isEmpty ? "0" : map.values.reduce((v, e) => v+e).toString(), 
        style: const TextStyle(fontSize: 20),
      ),),
      leading: const Icon(Icons.check),
      onTap: () => stage.showAlert(
        const ResolvedCountAlert(),
        size: 450,
      ),
    );
  }
}

