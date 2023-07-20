import 'package:krarkulator/models/board.dart';

import 'spell.dart';

abstract class StackElement {

  const StackElement();

  String get type;
  Map<String,dynamic> get json => privateJson..["type"]=type;
  Map<String,dynamic> get privateJson;

}


class SpellOnTheStack extends StackElement {
  
  final Spell spell;
  
  final bool isCopy;
  bool get isPhysical => !isCopy;

  final int? uniqueSpellId;

  SpellOnTheStack(this.spell, {required this.isCopy, this.uniqueSpellId});

  static SpellOnTheStack physical(Spell spell, int id) 
      => SpellOnTheStack(spell, isCopy: false, uniqueSpellId: id);

  @override
  Map<String, dynamic> get privateJson => {
    ...spell.toJson,
    "isCopy": isCopy,
    "id": uniqueSpellId,
  };

  static SpellOnTheStack fromJson(Map<String,dynamic> json) 
      => SpellOnTheStack(
        Spell.fromJson(json), 
        isCopy: json["isCopy"],
        uniqueSpellId: json["id"],
      );
  
  @override
  String get type => t;

  static const t = "original spell"; 
}

class Trigger extends StackElement {

  static const vanillaKind = "vanilla";
  String get kindOfTrigger => vanillaKind;
  final BoardElement from;

  const Trigger(this.from);

  static const Trigger birgi = Trigger(BoardElement.birgi);
  static const Trigger artist = Trigger(BoardElement.artist);
  static TriggerWithSpell bonusRound(Spell spell) 
      => TriggerWithSpell(spell, BoardElement.bonusRound);
  static TriggerWithSpell krark(Spell spell, int id) 
      => TriggerWithSpell(spell, BoardElement.krark, uniqueSpellId: id);
  static const Trigger scoundrel = Trigger(BoardElement.scoundrel);

  @override
  Map<String, dynamic> get privateJson => {
    "from": from.name,
    "kind": kindOfTrigger,
  };

  static Trigger fromJson(Map<String,dynamic> json) {
    switch (json["kind"]) {
      case "vanilla":
        return Trigger(BoardElements.fromName(json["from"]));
      case "spell":
        return TriggerWithSpell.fromJson(json);
      default:
        return Trigger(BoardElements.fromName(json["from"]));
    }
  }

  @override
  String get type => t;

  static const t = "trigger";
}



class TriggerWithSpell extends Trigger {

  final Spell spell;
  final int? uniqueSpellId;

  static const kind = "spell";
  @override
  String get kindOfTrigger => kind;

  const TriggerWithSpell(this.spell, BoardElement from, {this.uniqueSpellId,}): 
    super(from);

  static TriggerWithSpell fromJson(Map<String,dynamic> json) 
      => TriggerWithSpell(
        Spell.fromJson(json["spell"]), 
        BoardElements.fromName(json["from"]),
        uniqueSpellId: json['id'],
      );

  @override
  Map<String, dynamic> get privateJson => {
    "spell": spell.toJson,
    "from": from.name,
    "kind": kindOfTrigger,
    'id': uniqueSpellId,
  };

}



class MtgStack {

  List<StackElement> stack;

  MtgStack(this.stack);


  void clear() => stack.clear();

  void removeLast() => stack.removeLast();
  void removeAt(int index) => stack.removeAt(index);

  void add(StackElement e) => stack.add(e);

  void addAll(Iterable<StackElement> l) => stack.addAll(l);

  void addMultiple(StackElement e, int n){
    for(int i=1; i<=n; i++) {
      stack.add(e);
    }
  }
  
  
  static StackElement? stackElementFromJson(Map<String,dynamic> json){
    switch (json["type"]) {
      case SpellOnTheStack.t:
        return SpellOnTheStack.fromJson(json);
      case Trigger.t:
        return Trigger.fromJson(json);
      default:
    }

    return null;
  }

  Map<String,dynamic> get json => {"stack": [
    for(final e in stack) e.json,
  ]};

  static MtgStack fromJson(Map<String,dynamic> json) => MtgStack([
    for(final e in json["stack"]) stackElementFromJson(e)!,
  ]);
}
