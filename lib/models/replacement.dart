
import 'dart:math';

import 'package:krarkulator/everything.dart';

abstract class ReplacementEffect {

  static const tailsIcon = McIcons.close_circle_outline;
  static const headsIcon = Icons.check_circle;
  static IconData icon(bool v) => v ? headsIcon : tailsIcon;

  final int numberOfCoins;

  ReplacementEffect(this.numberOfCoins);

  bool get containsHeads;
  bool get containsTails;
  bool get mixed => containsHeads && containsTails;

  bool contains(bool val);

  Map<String,dynamic> get json;

  static ReplacementEffect? fromJson(Map<String,dynamic> json){
    switch (json["type"]) {
      case "full":
        return FullReplacement.fromSaved([
          for(final a in (json["flips"] as List))
            a as bool,
        ], json["n"]);        
      case "quick":
        return QuickReplacement.fromSaved(json["got heads"], json["got tails"], json["n"]);
    }
    return null;
  }

}


class FullReplacement extends ReplacementEffect {

  late final List<bool> flips;

  FullReplacement(int numberOfCoins, Random rng): super(numberOfCoins) {
    flips = [
      for(int i=1; i<=numberOfCoins; ++i)
        rng.nextBool()
    ];
  }

  FullReplacement.fromSaved(this.flips, int n): super(n);

  @override
  Map<String, dynamic> get json => {
    "n": numberOfCoins,
    "flips": flips,
    "type": "full",
  };

  @override
  bool get containsHeads => flips.contains(true);

  @override
  bool get containsTails => flips.contains(false);

  @override
  bool contains(bool val) => flips.contains(val);

}

class QuickReplacement extends ReplacementEffect {

  late final bool _gotHeads;
  late final bool _gotTails;

  QuickReplacement(int numberOfCoins, Random rng): super(numberOfCoins) {
    bool _h = false;
    bool _t = false;
    for(int i=1; i<=numberOfCoins; ++i){
      if(rng.nextBool()){
        _h = true;
      } else {
        _t = true;
      }
      if(_h && _t){
        _gotHeads = true;
        _gotTails = true;
        return;
      }
    }
    _gotHeads = _h;
    _gotTails = _t;
  }

  QuickReplacement.fromSaved(this._gotHeads, this._gotTails, int n): super(n);

  @override
  Map<String, dynamic> get json => {
    "n": numberOfCoins,
    "got heads": _gotHeads,
    "got tails": _gotTails,
    "type": "quick",
  };

  @override
  bool get containsHeads => _gotHeads;

  @override
  bool get containsTails => _gotTails;

  @override
  bool contains(bool val) => val ? _gotHeads : _gotTails;

}
