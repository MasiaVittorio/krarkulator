import 'package:krarkulator/data/widgets.dart';
import 'package:krarkulator/everything.dart';

class KrCollapsed extends StatelessWidget {
  const KrCollapsed({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final error = TextStyle(color: Theme.of(context).colorScheme.error);
    final stage = Stage.of<KrPage,dynamic>(context)!;


    return logic.automatic.build((_, automatic)
    => logic.krarks.build((_, krarks) 
    => logic.zone.build((_, zone)
    => logic.mana.build((_, mana)
    => logic.treasures.build((_, treasures)
    => logic.spell.build((_, spell) 
    => logic.canCast.build((_, canCast){

      const Widget leading = Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Icon(ManaIcons.instant),
      );
      final Widget title = AnimatedText(canCast 
        ? ((automatic && krarks > 1) ? "Keep recasting" : "Cast once")
        : "Can't cast spell"
      ); 
      final Widget? subTitle = canCast 
        ? ((automatic && krarks > 1) 
          ? Text("Until no bounce or ${logic.maxFlips.value} actions")
          : null) 
        : (mana + treasures < spell.manaCost 
          ? Text("Missing mana", style: error,)
          : (!(zone == Zone.hand) 
            ? Text("Spell out of hand", style: error,)
            : null));
      final VoidCallback? action = canCast ? (){
        if(automatic && krarks > 1) 
          logic.keepCasting(forHowManyFlips: logic.maxFlips.value);
        else {
          logic.cast(automatic: false);
          stage.mainPagesController.goToPage(KrPage.triggers);
        }
      } : null;
      final Widget tile = Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        height: stage.dimensionsController.dimensions.value.collapsedPanelSize,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading,
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                AnimatedListed(
                  listed: subTitle != null,
                  child: subTitle ?? Container(),
                ),
              ],
            ),),
          ],
        ),
      );

      final Widget toggle = ExtraButtonToggle(
        iconOff: McIcons.gesture_tap,
        icon: Icons.repeat, 
        text: automatic ? "automatic" : "manual", 
        onChanged: (v){
          if(krarks <= 1) logic.automatic.setDistinct(false);
          else logic.automatic.setDistinct(v);
        },
        value: automatic,
      );

      return Row(children: [
        Expanded(child: InkResponse(
          onTap: action,
          child: tile,
        ),),
        if(krarks > 1) ...<Widget>[
          KrWidgets.verticalDivider,
          Container(
            alignment: Alignment.center,
            width: 100,
            child: toggle
          ),
        ],
      ],);
    }
    )))))));
  }
}