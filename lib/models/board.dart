
// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:krarkulator/everything.dart';

enum BoardElement {
  krark,
  thumb,
  scoundrel,
  artist,
  birgi,
  veyran,
  prodigy,
  bonusRound,
  staff,
}

class BoardElements {
  static BoardElement fromName(String name) 
    => BoardElement.values.firstWhere((e) => name == e.name);
}


extension BoardElementNames on BoardElement {
  static const Map<BoardElement, String> _plurals = {
    BoardElement.artist: "Artists",
    BoardElement.birgi: "Birgis",
    BoardElement.bonusRound: "B. Rounds",
    BoardElement.krark: "Krarks",
    BoardElement.prodigy: "Prodigies",
    BoardElement.scoundrel: "Scoundrels",
    BoardElement.thumb: "Thumbs",
    BoardElement.veyran: "Veyrans",
    BoardElement.staff: "Staffs",
  };

  String get plural => _plurals[this]!;

  String get longName {
    switch (this) {
      case BoardElement.artist:
        return "Storm Kilnk Aritst";
      case BoardElement.birgi:
        return "Birgi, God of Storytelling";
      case BoardElement.bonusRound:
        return "Bonus Round";
      case BoardElement.krark:
        return "Krark, the Thumbless";
      case BoardElement.prodigy:
        return "Harmonic Prodigy";
      case BoardElement.scoundrel:
        return "Tavern Scoundrel";
      case BoardElement.thumb:
        return "Krark's Thumb";
      case BoardElement.veyran:
        return "Veyran, Voice of Duality";
      case BoardElement.staff:
        return "Twinning Staff";
    }
  }

  static const Map<BoardElement, String> _singulars = {
    BoardElement.artist: "Artist",
    BoardElement.birgi: "Birgi",
    BoardElement.bonusRound: "B. Round",
    BoardElement.krark: "Krark",
    BoardElement.prodigy: "Prodigy",
    BoardElement.scoundrel: "Scoundrel",
    BoardElement.thumb: "Thumb",
    BoardElement.veyran: "Veyran",
    BoardElement.staff: "Staff",
  };

  String get singular => _singulars[this]!;

  String get art {
    switch (this) {
      case BoardElement.artist:
        return "assets/images/arts/Storm_Kiln_Artist.jpg";
      case BoardElement.birgi:
        return "assets/images/arts/Birgi_God_of_Storytelling.jpg";
      case BoardElement.bonusRound:
        return "assets/images/arts/Bonus_Round.jpg";
      case BoardElement.krark:
        return "assets/images/arts/Krark_the_Thumbless.jpg";
      case BoardElement.prodigy:
        return "assets/images/arts/Harmonic_Prodigy.jpg";
      case BoardElement.scoundrel:
        return "assets/images/arts/Tavern_Scoundrel.jpg";
      case BoardElement.staff:
        return "assets/images/arts/Twinning_Staff.jpg";
      case BoardElement.thumb:
        return "assets/images/arts/Krarks_Thumb.jpg";
      case BoardElement.veyran:
        return "assets/images/arts/Veyran_Voice_of_Duality.jpg";
    }
  }

  String get fullImage {
    switch (this) {
      case BoardElement.artist:
        return "assets/images/cards/Storm_Kiln_Artist.jpg";
      case BoardElement.birgi:
        return "assets/images/cards/Birgi_God_of_Storytelling.jpg";
      case BoardElement.bonusRound:
        return "assets/images/cards/Bonus_Round.jpg";
      case BoardElement.krark:
        return "assets/images/cards/Krark_the_Thumbless.jpg";
      case BoardElement.prodigy:
        return "assets/images/cards/Harmonic_Prodigy.jpg";
      case BoardElement.scoundrel:
        return "assets/images/cards/Tavern_Scoundrel.jpg";
      case BoardElement.staff:
        return "assets/images/cards/Twinning_Staff.jpg";
      case BoardElement.thumb:
        return "assets/images/cards/Krarks_Thumb.jpg";
      case BoardElement.veyran:
        return "assets/images/cards/Veyran_Voice_of_Duality.jpg";
    }
  }

  String? get quote {
    switch (this) {
      case BoardElement.artist:
        return "A captured elemental makes for a potent, albeit unstable, power source.";
      case BoardElement.krark:
        return "“Double or nothing.”";
      case BoardElement.prodigy:
        return "Each note strikes with deadly precision.";
      case BoardElement.scoundrel:
        return "“No refunds. I cheated you fair and square.”";
      case BoardElement.birgi:
        return "“This is a tale to make all Kaldheim tremble…”";
      case BoardElement.bonusRound:
        return "When the twin-spell bonus round begins, the crowd rises to its feet in anticipation of incredible combinations.";
      case BoardElement.thumb:
        return "“I can think of one goblin it ain’t so lucky for.” —Slobad, goblin tinkerer";
      default:
        return null;      
    }
  }

  String get artist {
    switch (this) {
      case BoardElement.artist:
        return "Manuel Castañón";
      case BoardElement.birgi:
        return "Eric Deschamps";
      case BoardElement.bonusRound:
        return "Lake Hurwitz";
      case BoardElement.krark:
        return "Mathias Kollros";
      case BoardElement.prodigy:
        return "Paul Scott Canavan";
      case BoardElement.scoundrel:
        return "Cynthia Sheppard";
      case BoardElement.staff:
        return "Mike Bierek";
      case BoardElement.thumb:
        return "Ron Spencer";
      case BoardElement.veyran:
        return "Mathias Kollros";
    }
  }

  Alignment get alignment {
    switch (this) {
      case BoardElement.artist:
        return const Alignment(0,-0.5);
      case BoardElement.birgi:
        return const Alignment(0,-0.5);
      case BoardElement.bonusRound:
        return const Alignment(0,-0.6);
      case BoardElement.krark:
        return const Alignment(0,-0.5);
      case BoardElement.prodigy:
        return const Alignment(0,-0.4);
      case BoardElement.scoundrel:
        return const Alignment(0,-0.5);
      case BoardElement.staff:
        return const Alignment(0,-0.3);
      case BoardElement.thumb:
        return const Alignment(0,0.3);
      case BoardElement.veyran:
        return const Alignment(0,-0.3);
    }
  }
}

class Board {

  /// means a chance of 1 / 2^(2^n - 1) of failure: less than 10^-300 for n=10
  static const insaneNumberOfThumbs = 10; 
  static const insaneNumberOfAnything = 10000; // ten thousands 

  Map<BoardElement, int> board;
  late _HowMany howMany;
  late _Trigger triggersFrom;

  Board(this.board){
    howMany = _HowMany(this);
    triggersFrom = _Trigger(this);
  }

  void reset() {
    for(final e in BoardElement.values) {
      board[e] = 0;
    }
  }

  static Board get emptyBoard => Board({
    for(final e in BoardElement.values)
      e: 0,
  });

  Map<String,dynamic> get json => {
    for(final e in board.keys)
      e.name: board[e],
  };

  static Board fromJson(Map<String,dynamic> json) => Board({
    for(final String k in json.keys)
      BoardElements.fromName(k): json[k],
  });

  void solveSpell(Spell spell){
    for(final e in spell.boardProduct.entries){
      if(e.value > 0) {
        board[e.key] = howMany.element(e.key) + e.value;
      } else if(e.value == -1) {
        board[e.key] = howMany.element(e.key) * 2;
      }

      if((board[e.key] ?? 0) > insaneNumberOfAnything) board[e.key] = insaneNumberOfAnything;
    }
    if((board[BoardElement.thumb] ?? 0) > insaneNumberOfThumbs){
      board[BoardElement.thumb] = insaneNumberOfThumbs;
    }
  }

}


class _HowMany {
  final Board board;

  _HowMany(this.board);

  int element(BoardElement e) => board.board[e] ?? 0;

  int get artists => element(BoardElement.artist);
  int get birgis => element(BoardElement.birgi);
  int get bonusRounds => element(BoardElement.bonusRound);
  int get krarks => element(BoardElement.krark);
  int get prodigies => element(BoardElement.prodigy);
  int get scoundrels => element(BoardElement.scoundrel);
  int get thumbs => min(element(BoardElement.thumb), Board.insaneNumberOfThumbs);
  int get veyrans => element(BoardElement.veyran);
  int get staffs => element(BoardElement.staff);
}

class _Trigger {
  final Board board;

  _Trigger(this.board);


  // when casting or copying
  int get artists => board.howMany.artists * (1 + board.howMany.veyrans + board.howMany.prodigies);

  // when casting
  int get birgis => board.howMany.birgis * (1 + board.howMany.veyrans);
  
  // when casting
  int get bonusRounds => board.howMany.bonusRounds;

  // when casting
  int get krarks => board.howMany.krarks * (1 + board.howMany.veyrans + board.howMany.prodigies);

  // when winning a coin flip
  int get scoundrels => board.howMany.scoundrels;
}
