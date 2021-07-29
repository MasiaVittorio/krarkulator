import 'package:krarkulator/everything.dart';
// TODO: make the trigger display a bit more fancy??


class TriggersView extends StatelessWidget {
  const TriggersView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);


    return logic.triggers.build((context, triggers) => Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
      child: Row(children: <Widget>[
        if(triggers.isNotEmpty) Expanded(flex: 6, child: SubSection(((){
          final ThumbTrigger trigger = triggers.last;
          final flips = trigger.flips;
          final howManyFlips = flips.length;
          final int copies = ([
            for(final f in flips) 
              if(f == Flip.copy) "",
          ]).length;
          final int bounces = howManyFlips - copies;
          final String description = howManyFlips > 0 
            ? "($howManyFlips flips)" : "(regular flip)";

          return <Widget>[
            SectionTitle("Trigger #${triggers.length} $description"),
            if(howManyFlips > 1) ExtraButtons(
              margin: EdgeInsets.zero,
              children: <Widget>[
                ExtraButton(
                  customCircleColor: Colors.transparent,
                  icon: null,
                  customIcon: Text("$copies"),
                  onTap: copies > 0 
                    ? () => logic.solveKrarkTrigger(Flip.copy, automatic: false) 
                    : null,
                  text: "Heads\n(copy)",
                  twoLines: true,
                ), 
                ExtraButton(
                  customCircleColor: Colors.transparent,
                  icon: null,
                  customIcon: Text("$bounces"),
                  onTap: bounces > 0 
                    ? () => logic.solveKrarkTrigger(Flip.bounce, automatic: false) 
                    : null,
                  text: "Tails\n(bounce)",
                  twoLines: true,
                ), 
              ],
            )
            else ExtraButtons(
              margin: EdgeInsets.zero,
              children: <Widget>[
                ExtraButton(
                  icon: copies > 0 ? Icons.check : Icons.close,
                  onTap: null,
                  text: copies > 0 ? "Heads\n(copy)" : "Tails\n(bounce)",
                  twoLines: true,
                ),
                ExtraButton(
                  customCircleColor: Colors.transparent,
                  icon: Icons.keyboard_arrow_right,
                  onTap: () => logic.solveKrarkTrigger(flips.first, automatic: false),
                  text: "Ok\n(${triggers.length > 1 ? "next" : "finish"})",
                  twoLines: true,
                ),
              ],
            ),
          ];
        }())),),

        if(triggers.isNotEmpty) Expanded(flex: 2, child: ExtraButton(
          onTap: null,
          text: "Triggers\nleft",
          twoLines: true,
          icon: null,
          customIcon: Text("${triggers.length - 1}"),
        )),
        
        if(triggers.isEmpty) const Expanded(child: SubSection([
          ListTile(title: Text("No trigger left"),),
        ]),),
      ],),
    ));
  }
}
