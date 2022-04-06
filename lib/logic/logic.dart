import 'dart:math';

import 'package:krarkulator/everything.dart';

export 'extensions/all.dart';

class Logic extends BlocBase {
  /// throws a runtime error if the context has no logic
  static Logic of(BuildContext context) => BlocProvider.of<Logic>(context)!;

  late Random rng;
  int currentLoopActions = 0;

  final List<String> logs = [];

  final BlocVar<String> lastAction = BlocVar("");

  final PersistentVar<int> uniqueSpellId = PersistentVar(
    initVal: 0, 
    key: "kr_logic uniqueSpellId",
  );

  final PersistentVar<Board> board = PersistentVar(
    initVal: Board({}), 
    key: "kr_logic board",
    toJson: (b) => b.json,
    fromJson: (j) => Board.fromJson(j),
  );


  final PersistentVar<Map<MtgColor?, bool>> favColors = PersistentVar(
    initVal: {MtgColor.u: true, MtgColor.r: true}, 
    key: "kr_logic favColors",
    toJson: (m) => <String,dynamic>{
      for(final c in MtgColor.values)
        c.name: m[c],
      "null": m[null],
    },
    fromJson: (j) => <MtgColor?, bool>{
      for(final c in MtgColor.values) 
        c: j[c.name] ?? (c == MtgColor.r || c == MtgColor.u),
      null: j["null"] ?? false,
    },
  );  

  final PersistentVar<ManaPool> manaPool = PersistentVar(
    initVal: ManaPool(), 
    key: "kr_logic manaPool",
    toJson: (p) => p.toJson,
    fromJson: (json) => ManaPool.fromJson(json),
  );  
  
  final PersistentVar<int> treasures 
    = PersistentVar(initVal: 0, key: "kr_logic treasures");

  final PersistentVar<MtgStack> stack = PersistentVar(
    initVal: MtgStack([]), 
    key: "kr_logic stack",
    toJson: (v) => v.json,
    fromJson: (json) => MtgStack.fromJson(json),
  );
  

  final PersistentVar<int> storm
      = PersistentVar(initVal: 0, key: "kr_logic storm");

  final PersistentVar<Map<String,int>> resolvedCount = PersistentVar(
    initVal: {}, 
    fromJson: (j) => <String,int>{
      for(final e in (j as Map).entries)
        e.key as String: e.value as int,
    },
    toJson: (m) => m,
    key: "kr_logic resolvedCount",
  );

  final PersistentVar<int> copiedCount 
      = PersistentVar(initVal: 0, key: "kr_logic copiedCount");


  final PersistentVar<String?> selectedSpellName
      = PersistentVar(initVal: null, key: "kr_logic selectedSpellName");
  
  final PersistentVar<List<Spell>> hand = PersistentVar(
    initVal: [], 
    key: "kr_logic hand",
    toJson: (l) => [for(final e in l) e.toJson],
    fromJson: (json) => [for(final j in json) Spell.fromJson(j)],
  );
  
  final PersistentVar<List<Spell>> graveyard = PersistentVar(
    initVal: [], 
    key: "kr_logic graveyard",
    toJson: (l) => [for(final e in l) e.toJson],
    fromJson: (json) => [for(final j in json) Spell.fromJson(j)],
  );


  final PersistentVar<ReplacementEffect?> replacement = PersistentVar(
    initVal: null, 
    key: "kr_logic replacement",
    toJson: (v) => v?.json,
    fromJson: (json) => json == null ? null : ReplacementEffect.fromJson(json)!,
  );


  final PersistentVar<int> maxNumberOfActions 
      = PersistentVar(initVal: 500, key: "kr_logic maxNumberOfActions");

  
  final PersistentVar<Map<String,Spell>> spellBook = PersistentVar(
    initVal: {
      Spell.riteName: Spell.riteOfFlame,
      Spell.twinName: Spell.twinflameKrark,
      Spell.brainName: Spell.brainFreeze,
      Spell.kindredName: Spell.kindredCharge,
      Spell.desperateName: Spell.desperateRitual,
      Spell.heatName: Spell.heatShimmer,
    }, 
    key: "kr_logic spellBook",
    toJson: (m) => <String,Map<String,dynamic>>{
      for(final e in m.entries)
        e.key: e.value.toJson,
    },
    fromJson: (json) => {
      for(final e in (json as Map).entries)
        e.key: Spell.fromJson(e.value)
    },
  );

  Logic(){
    rng = Random(DateTime.now().millisecondsSinceEpoch);
  }
  
  @override
  void dispose() {

    logs.clear();
    lastAction.dispose();

    uniqueSpellId.dispose();

    board.dispose();

    favColors.dispose();
    manaPool.dispose();
    treasures.dispose();

    stack.dispose();

    storm.dispose();
    resolvedCount.dispose();
    copiedCount.dispose();
    
    selectedSpellName.dispose();
    hand.dispose();
    graveyard.dispose();

    replacement.dispose();

    maxNumberOfActions.dispose();

    spellBook.dispose();
  }

  void refreshUI(){
    board.refresh();
    graveyard.refresh();
    manaPool.refresh();
    hand.refresh();
    replacement.refresh();
    resolvedCount.refresh();
    copiedCount.refreshDistinct();
    selectedSpellName.refreshDistinct();
    stack.refresh();
    storm.refreshDistinct();
    treasures.refreshDistinct();
    // this.uniqueSpellId .refresh();
  }

}