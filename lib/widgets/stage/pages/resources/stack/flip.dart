import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/resources/stack/generic.dart';

class ReplacementChild extends StatelessWidget {

  const ReplacementChild(this.replacement, { Key? key }) : super(key: key);

  final ReplacementEffect replacement;

  int get n => replacement.numberOfCoins;
  bool get canCopy => replacement.containsHeads;
  bool get canBounce => replacement.containsTails;
  bool get canBoth => replacement.mixed;
  bool get singleFlip => n == 1;

  @override
  Widget build(BuildContext context) {

    return CardUI(
      title: n==1 
        ? "Coin flip (${canCopy ? 'Heads': 'Tails'})" 
        : "$n coin flips (${canBoth ? 'mixed' : canCopy ? 'Only Heads' : 'Only Tails'})", 
      subTitle: n > 1 ? "Replacement Effect — Mid Resolution" : "Effect — Mid Resolution", 
      indexPlusOne: null, 
      outOf: null, 
      children: [
        if(n == 1) ListTile(
          title: Text("You flipped ${canCopy ? 'Heads' : 'Tails'}"),
          subtitle: Text(
            "(Tap to ${canCopy ? 'copy' : 'bounce'})",
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          onTap: () => Logic.of(context).solveFlipThenRefresh(canCopy),
          leading: Icon(ReplacementEffect.icon(canCopy)),
        ) else ...[
          if(canCopy) ResultTile(true, replacement: replacement),
          if(canBounce) ResultTile(false, replacement: replacement),
        ]
      ],
      image: Image.asset(
        singleFlip 
          ? "assets/images/arts/Tricksters_Talisman.jpg"
          : BoardElement.thumb.art,
        fit: BoxFit.cover,
        alignment: singleFlip
          ? const Alignment(0, -1)
          : BoardElement.thumb.alignment,
      ),
      artistCredit: singleFlip 
        ? "Sam White"
        : BoardElement.thumb.artist,
    );
  }


}

class ResultTile extends StatelessWidget {

  const ResultTile(this.result, {
    required this.replacement,
    Key? key,
  }) : super(key: key);

  final bool result;
  final ReplacementEffect replacement;

  bool get canCopy => replacement.containsHeads;
  bool get canBounce => replacement.containsTails;

  bool get isFull => replacement is FullReplacement;
  int get concordant => [
    for(final v in (replacement as FullReplacement).flips)
      if(v == result) 
        v,
  ].length;

  bool get active => result ? canCopy : canBounce;

  String get thisFlip => result ? 'Heads' : 'Tails';
  String get thisAction => result ? 'Copy' : 'Bounce';

  String get title {
    if(replacement is FullReplacement){
      final n = concordant;
      final plural = n > 1;
      return active 
        ? "$thisFlip came out $n time${plural ? 's' : ''}"
        : "$thisFlip never came out";
    } else {
      replacement as QuickReplacement;
      return active 
        ? "$thisFlip came out at least once"
        : "$thisFlip never came out"; 
    }
  }

  String get subTitle {
    if(active){
      return "(Tap to $thisAction the spell)";
    } else {
      return "(Can't pick this)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subTitle,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      leading: Icon(ReplacementEffect.icon(result)),
      onTap: active 
        ? () => Logic.of(context).solveFlipThenRefresh(result)
        : null,
    );
  }
}

