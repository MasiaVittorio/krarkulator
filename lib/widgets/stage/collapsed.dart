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
    => logic.canCast.build((_, canCast) 
      => ListTile(
        leading: const Icon(ManaIcons.instant),
        title: AnimatedText(canCast ? "Cast spell" : "Can't cast spell"),
        subtitle: canCast ? null : 
          mana < spell.manaCost ? Text("Missing mana", style: error,)
          : !(zone == Zone.hand) ? Text("Spell out of hand", style: error,)
          : null,
        onTap: canCast ? (
          (automatic && krarks > 1) 
            ? () => logic.keepCasting(forUpTo: logic.maxCasts.value)
            : () => logic.cast(automatic: false)
        ) : null,
      )
    ))))));
  }
}