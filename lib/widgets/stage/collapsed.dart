import 'package:krarkulator/everything.dart';

class KrCollapsed extends StatelessWidget {
  const KrCollapsed({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final error = TextStyle(color: Theme.of(context).colorScheme.error);

    return logic.automatic.build((_, automatic)
    => logic.krarks.build((_, krarks) 
    => logic.zone.build((_, zone)
    => logic.mana.build((_, mana)
    => logic.spell.build((_, spell) 
    => logic.canCast.build((_, canCast){

      const Widget leading = Padding(
        padding: EdgeInsets.all(8),
        child: Icon(ManaIcons.instant),
      );
      final Widget title = AnimatedText(canCast 
        ? ((automatic && krarks > 1) ? "Keep recasting" : "Cast once")
        : "Can't cast spell"
      ); 
      final Widget? subTitle = canCast 
        ? ((automatic && krarks > 1) 
          ? Text("Until no bounce or ${logic.maxCasts.value} casts")
          : null) 
        : (mana < spell.manaCost 
          ? Text("Missing mana", style: error,)
          : (!(zone == Zone.hand) 
            ? Text("Spell out of hand", style: error,)
            : null));
      final VoidCallback? action = canCast ? (
          (automatic && krarks > 1) 
            ? () => logic.keepCasting(forUpTo: logic.maxCasts.value)
            : () => logic.cast(automatic: false)
        ) : null;
      final Widget tile = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if(subTitle != null) subTitle,
            ],
          ),),
        ],
      );

      final Widget toggle = ExtraButtonToggle(
        iconOff: McIcons.gesture_tap,
        icon: Icons.repeat, 
        text: automatic ? "automatic" : "manual", 
        onChanged: (v){
          if(krarks > 1) return;
          logic.automatic.set(v);
        },
        value: automatic,
      );

      return Row(children: [
        Expanded(child: InkResponse(
          onTap: action,
          child: tile,
        ),),
        toggle,
      ],);
    }
    ))))));
  }
}