import 'board.dart';
import 'mana.dart';

/// Mana burst spells cost X and give Y
class Spell {

  final bool storm;

  final String name;
  final Map<MtgColor?, int> manaCost;
  final Map<MtgColor?, int> manaProduct;
  final int treasuresProduct;

  // -1 => double
  final Map<BoardElement,int> boardProduct;

  bool get producesMana {
    for(final v in manaProduct.values)
      if(v > 0) return true;
    return false;
  }

  bool get producesBoard {
    for(final v in boardProduct.values)
      if(v != 0) return true;
    return false;
  }

  const Spell(
    this.name,
    this.manaCost,
    this.manaProduct, {
    this.treasuresProduct = 0,
    this.boardProduct = const {},
    this.storm = false,
  });


  static Spell fromJson(Map<String,dynamic> json) => Spell(
    json["name"],
    <MtgColor?,int>{
      for(final c in MtgColor.values)
        c: json["manaCost"][c.name] ?? 0,
      null: json["manaCost"][null] ?? 0,
    },
    <MtgColor?,int>{
      for(final c in MtgColor.values)
        c: json['manaProduct'][c.name] ?? 0,
      null: json['manaProduct'][null] ?? 0,
    },
    treasuresProduct: json["treasuresProduct"] ?? 0,
    boardProduct: <BoardElement,int>{
      for(final e in (json["board_product"] as Map).entries)
        BoardElements.fromName(e.key) : e.value,
    },
    storm: json["storm"] ?? false,
  );

  static const _clrless = "colorless";

  Map<String, dynamic> get toJson => {
    "name": name,
    "manaCost": <String,int>{
      for (final c in MtgColor.values)
        c.name: manaCost[c] ?? 0,
      _clrless: manaCost[null] ?? 0,
    },
    "manaProduct": <String,int>{
      for (final c in MtgColor.values)
        c.name: manaProduct[c] ?? 0,
      _clrless: manaProduct[null] ?? 0,
    },
    "treasuresProduct": treasuresProduct,
    "board_product": <String,int>{
      for(final e in boardProduct.entries)
        e.key.name: e.value,
    },
    "storm": storm,
  };

  Spell copyWith({
    String? name,
    Map<MtgColor?, int>? manaCost,
    Map<MtgColor?, int>? manaProduct,
    int? treasuresProduct,
    Map<BoardElement,int>? boardProduct,
    bool? storm,
  }) =>
      Spell(
        name ?? this.name,
        manaCost ?? this.manaCost,
        manaProduct ?? this.manaProduct,
        treasuresProduct: treasuresProduct ?? this.treasuresProduct,
        boardProduct: boardProduct ?? this.boardProduct,
        storm: storm ?? this.storm,
      );

  static const String riteName = "Rite of Flame"; 
  static const riteOfFlame = Spell(
    riteName,
    {MtgColor.r: 1},
    {MtgColor.r: 2},
  );

  static const String desperateName = "Desperate Ritual"; 
  static const desperateRitual = Spell(
    desperateName,
    {MtgColor.r: 2},
    {MtgColor.r: 3},
  );

  static const String brainName = "Brain Freeze"; 
  static const brainFreeze = Spell(
    brainName,
    {MtgColor.u: 2},
    {},
    storm: true,
  );

  static const String twinName = "Twinflame (krark)"; 
  static const twinflameKrark = Spell(
    twinName,
    {MtgColor.r: 2},
    {},
    boardProduct: {BoardElement.krark: 1},
  );

  static const String heatName = "Heat Shimmer (krark)"; 
  static const heatShimmer = Spell(
    heatName,
    {MtgColor.r: 3},
    {},
    boardProduct: {BoardElement.krark: 1},
  );

  static const String kindredName = "Kindred Charge (wizards)"; 
  static const kindredCharge = Spell(
    kindredName,
    {MtgColor.r: 6},
    {},
    boardProduct: {
      BoardElement.krark: -1,
      BoardElement.veyran: -1,
      BoardElement.prodigy: -1,
    },
  );

}

