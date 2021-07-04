
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

  const Spell(this.manaCost, this.manaProduct, {
    this.chance = 1.0,
    this.veyransProduced = 0,
    this.artistsProduced = 0,
    this.krarksProduced = 0,
    this.scoundrelProduced = 0,
    this.treasuresProduct = 0,
  });

  static Spell fromJson(Map json) => Spell(
    json['manaCost'], json['manaProduct'],
    chance: json["chance"],
    artistsProduced: json["artistsProduced"],
    krarksProduced:  json["krarksProduced"],
    scoundrelProduced: json["scoundrelProduced"],
    veyransProduced:  json["veyransProduced"],
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
  };
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