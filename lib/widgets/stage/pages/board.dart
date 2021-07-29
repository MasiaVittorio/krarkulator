import 'package:krarkulator/everything.dart';
import 'resources/all.dart';

class BoardCollapsed extends StatelessWidget {

  const BoardCollapsed({required this.width, Key? key }) : super(key: key);
  final double width;

  @override
  Widget build(context) {
    final logic = Logic.of(context);
    final theme = Theme.of(context);
    final decoration = decorationBuilder(theme);
    final text = theme.brightness.contrast;

    return BodyCollapsedElement(
      page: KrPage.board,
      title: "Board",
      width: width,
      child: SubSection(
        [Expanded(child: BlocVar.build6<int,int,int,int, int, int>(
          logic.birgis, logic.veyrans, logic.scoundrels, logic.prodigies, 
          logic.artists, logic.bonusRounds, 
          builder: (_, b , v, s, a, r, p) => ExtraButtons(children: [
          IntToggle(
            title: "Krarks",
            variable: logic.krarks,
            defaultVal: 1,
            image: decoration("assets/images/arts/Krark_the_Thumbless.jpg"),
            overrideTextColor: text,
          ),



          IntToggle(
            title: "Thumbs",
            variable: logic.thumbs,
            defaultVal: 0,
            image: decoration("assets/images/arts/Krarks_Thumb.jpg"),
            overrideTextColor: text,
          ),
          if(v! > 0) IntToggle(
            title: "Veyrans",
            variable: logic.veyrans,
            defaultVal: 0,
            noNeedToRebuild: true,
            image: decoration("assets/images/arts/Veyran_Voice_of_Duality.jpg"),
            overrideTextColor: text,
          )
          else if(a! > 0) IntToggle(
            title: "Artist",
            variable: logic.artists,
            defaultVal: 0,
            noNeedToRebuild: true,
            image: decoration("assets/images/arts/Storm_Kiln_Artist.jpg"),
            overrideTextColor: text,
          )
          else if(s! > 0) IntToggle(
            title: "Scoundrels",
            variable: logic.scoundrels,
            defaultVal: 0,
            noNeedToRebuild: true,
            image: decoration("assets/images/arts/Tavern_Scoundrel.jpg"),
            overrideTextColor: text,
          )
          else if(b! > 0) IntToggle(
            title: "Birgis",
            variable: logic.birgis,
            defaultVal: 0,
            noNeedToRebuild: true,
            image: decoration("assets/images/arts/Birgi_God_of_Storytelling.jpg"),
            overrideTextColor: text,
          )
          else if(r! > 0) IntToggle(
            title: "B. Rounds",
            variable: logic.bonusRounds,
            defaultVal: 0,
            noNeedToRebuild: true,
            image: decoration("assets/images/arts/Bonus_Round.jpg"),
            overrideTextColor: text,
          )
          else if(p! > 0) IntToggle(
            title: "Prodigies",
            variable: logic.prodigies,
            defaultVal: 0,
            noNeedToRebuild: true,
            image: decoration("assets/images/arts/Harmonic_Prodigy.jpg"),
            overrideTextColor: text,
          )
        ],margin: EdgeInsets.zero, separate: false,),),),],
        mainAxisSize: MainAxisSize.max,
        margin: padding1Collapsed,
      ),
    );
  }
  
}


class BoardExpanded extends StatelessWidget {
  const BoardExpanded({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final logic = Logic.of(context);
    final theme = Theme.of(context);
    final decoration = decorationBuilder(theme);
    final text = theme.brightness.contrast;

    // TODO: images

    return SubSection(
      [
        Expanded(child: ExtraButtons(children: [
          IntToggle(
            title: "Krarks",
            variable: logic.krarks,
            defaultVal: 1,
            image: decoration("assets/images/arts/Krark_the_Thumbless.jpg"),
            overrideTextColor: text,
          ),
          IntToggle(
            title: "Thumbs",
            variable: logic.thumbs,
            defaultVal: 0,
            image: decoration("assets/images/arts/Krarks_Thumb.jpg"),
            overrideTextColor: text,
          ),
        ],margin: EdgeInsets.zero, separate: false),),
        Expanded(child: ExtraButtons(children: [
          IntToggle(
            title: "Scoundrels",
            variable: logic.scoundrels,
            defaultVal: 0,
            image: decoration("assets/images/arts/Tavern_Scoundrel.jpg"),
            overrideTextColor: text,
          ),
          IntToggle(
            title: "Artists",
            variable: logic.artists,
            defaultVal: 0,
            image: decoration("assets/images/arts/Storm_Kiln_Artist.jpg"),
            overrideTextColor: text,
          ),
          IntToggle(
            title: "Birgis",
            variable: logic.birgis,
            defaultVal: 0,
            image: decoration("assets/images/arts/Birgi_God_of_Storytelling.jpg"),
            overrideTextColor: text,
          ),
        ],margin: EdgeInsets.zero, separate: false),),
        Expanded(child: ExtraButtons(children: [
          IntToggle(
            title: "Veyrans",
            variable: logic.veyrans,
            defaultVal: 0,
            image: decoration("assets/images/arts/Veyran_Voice_of_Duality.jpg"),
            overrideTextColor: text,
          ),
          IntToggle(
            title: "Prodigies",
            variable: logic.prodigies,
            defaultVal: 0,
            image: decoration("assets/images/arts/Harmonic_Prodigy.jpg"),
            overrideTextColor: text,
          ),
          IntToggle(
            title: "B. rounds",
            variable: logic.bonusRounds,
            defaultVal: 0,
            image: decoration("assets/images/arts/Bonus_Round.jpg"),
            overrideTextColor: text,
          ),
        ],margin: EdgeInsets.zero, separate: false,),),
      ],
      mainAxisSize: MainAxisSize.max, 
      margin: padding1Expanded,
    );
  }
}