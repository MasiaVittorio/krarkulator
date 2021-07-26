
/// Mana burst spells cost X and give Y
class Spell {
  final int manaCost;
  final int manaProduct;
  final int treasuresProduct;
  
  final double chance; ///spells that not always resolve 
  
  final int krarksProduced; // if -1 -> double 
  final int veyransProduced; // if -1 -> double 
  final int scoundrelProduced; // if -1 -> double 
  final int artistsProduced; // if -1 -> double
  final int thumbsProduced; // if -1 -> double
  final int birgisProduced;
  final int bonusRounds;

  const Spell(this.manaCost, this.manaProduct, {
    this.chance = 1.0,
    this.veyransProduced = 0,
    this.artistsProduced = 0,
    this.krarksProduced = 0,
    this.scoundrelProduced = 0,
    this.treasuresProduct = 0,
    this.thumbsProduced = 0,
    this.birgisProduced = 0,
    this.bonusRounds = 0,
  });

  static Spell fromJson(Map json) => Spell(
    json['manaCost'] ?? 0, json['manaProduct'] ?? 0,
    chance: json["chance"] ?? 1.0,
    artistsProduced: json["artistsProduced"] ?? 0,
    krarksProduced:  json["krarksProduced"] ?? 0,
    scoundrelProduced: json["scoundrelProduced"] ?? 0,
    veyransProduced:  json["veyransProduced"] ?? 0,
    thumbsProduced: json["thumbsProduced"] ?? 0,
    birgisProduced: json["birgisProduced"] ?? 0,
    bonusRounds: json["bonusRounds"] ?? 0,
  ); 

  Map<String,dynamic> get toJson => {
    "artistsProduced": this.artistsProduced,
    "chance": this.chance,
    "krarksProduced": this.krarksProduced,
    "manaCost": this.manaCost,
    "manaProduct": this.manaProduct,
    "scoundrelProduced": this.scoundrelProduced,
    "veyransProduced": this.veyransProduced,
    "treasuresProduct": this.treasuresProduct,
    "thumbsProduced": this.thumbsProduced,
    "birgisProduced": this.birgisProduced,
    "bonusRounds": this.bonusRounds,
  };

  Spell copyWith({
    int? manaCost, 
    int? manaProduct, 
    double? chance,
    int? veyransProduced,
    int? artistsProduced,
    int? krarksProduced,
    int? scoundrelProduced,
    int? treasuresProduct,
    int? thumbsProduced,
    int? birgisProduced,
    int? bonusRounds,
  }) => Spell(
    manaCost ?? this.manaCost,
    manaProduct ?? this.manaProduct,
    chance: chance ?? this.chance,
    veyransProduced: veyransProduced ?? this.veyransProduced,
    krarksProduced: krarksProduced ?? this.krarksProduced,
    artistsProduced: artistsProduced ?? this.artistsProduced,
    scoundrelProduced: scoundrelProduced ?? this.scoundrelProduced,
    treasuresProduct: treasuresProduct ?? this.treasuresProduct,
    thumbsProduced: thumbsProduced ?? this.thumbsProduced,
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