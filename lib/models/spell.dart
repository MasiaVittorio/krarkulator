
/// Mana burst spells cost X and give Y
class Spell {
  final int manaCost;
  final int manaProduct;
  final int treasuresProduct;
  
  // final double chance; ///spells that not always resolve 
  
  final int krarksProduced; 
  final int thumbsProduced; 

  final int veyransProduced;  
  final int prodigiesProduced;

  final int scoundrelProduced; 
  final int artistsProduced;
  final int birgisProduced;

  final int bonusRounds;

  const Spell(this.manaCost, this.manaProduct, {
    // this.chance = 1.0,
    this.treasuresProduct = 0,

    this.krarksProduced = 0,
    this.thumbsProduced = 0,

    this.veyransProduced = 0,
    this.prodigiesProduced = 0,

    this.artistsProduced = 0,
    this.scoundrelProduced = 0,
    this.birgisProduced = 0,

    this.bonusRounds = 0,
  });

  static Spell fromJson(Map json) => Spell(
    json['manaCost'] ?? 0, json['manaProduct'] ?? 0,
    treasuresProduct: json["treasuresProduct"] ?? 0,
    // chance: json["chance"] ?? 1.0,

    krarksProduced:  json["krarksProduced"] ?? 0,
    thumbsProduced: json["thumbsProduced"] ?? 0,

    veyransProduced:  json["veyransProduced"] ?? 0,
    prodigiesProduced: json["prodigiesProduced"],

    artistsProduced: json["artistsProduced"] ?? 0,
    scoundrelProduced: json["scoundrelProduced"] ?? 0,
    birgisProduced: json["birgisProduced"] ?? 0,

    bonusRounds: json["bonusRounds"] ?? 0,
  ); 

  Map<String,dynamic> get toJson => {
    "manaCost": this.manaCost,
    "manaProduct": this.manaProduct,
    "treasuresProduct": this.treasuresProduct,
    // "chance": this.chance,

    "krarksProduced": this.krarksProduced,
    "thumbsProduced": this.thumbsProduced,

    "veyransProduced": this.veyransProduced,
    "prodigiesProduced": this.prodigiesProduced,

    "artistsProduced": this.artistsProduced,
    "scoundrelProduced": this.scoundrelProduced,
    "birgisProduced": this.birgisProduced,

    "bonusRounds": this.bonusRounds,
  };

  Spell copyWith({
    int? manaCost, 
    int? manaProduct, 
    int? veyransProduced,
    int? artistsProduced,
    int? krarksProduced,
    int? scoundrelProduced,
    int? treasuresProduct,
    int? thumbsProduced,
    int? birgisProduced,
    int? bonusRounds,
    int? prodigiesProduced,
  }) => Spell(
    manaCost ?? this.manaCost,
    manaProduct ?? this.manaProduct,
    treasuresProduct: treasuresProduct ?? this.treasuresProduct,
    // chance: chance ?? this.chance,
    krarksProduced: krarksProduced ?? this.krarksProduced,
    thumbsProduced: thumbsProduced ?? this.thumbsProduced,

    veyransProduced: veyransProduced ?? this.veyransProduced,
    prodigiesProduced: prodigiesProduced ?? this.prodigiesProduced,

    artistsProduced: artistsProduced ?? this.artistsProduced,
    scoundrelProduced: scoundrelProduced ?? this.scoundrelProduced,
    birgisProduced: birgisProduced ?? this.birgisProduced,

    bonusRounds: bonusRounds ?? this.bonusRounds,
  );
}



enum Zone {
  hand,
  graveyard,
  stack,
}

extension ZoneExt on Zone {
  static const _map = {
    Zone.hand: "hand",
    Zone.graveyard: "graveyard",
    Zone.stack: "stack",
  };

  String get name => _map[this]!;
}

class Zones {
  static const _map = {
    "graveyard": Zone.graveyard,
    "hand": Zone.hand,
    "stack": Zone.stack,
  };

  static Zone fromName(String name) => _map[name]!;
}