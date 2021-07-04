// import 'sub_blocs/all.dart';
import 'dart:math';

import 'package:krarkulator/everything.dart';
import 'package:sid_bloc/sid_bloc.dart';

export 'sub_blocs/all.dart';

class Logic extends BlocBase {
  
  @override
  void dispose() {
    spell.dispose();
    zone.dispose();
    mana.dispose();
    storm.dispose();
    resolved.dispose();
    krarks.dispose();
    thumbs.dispose();
    veyrans.dispose();
    artists.dispose();
    scoundrels.dispose();
    triggers.dispose();
    automatic.dispose();
    maxCasts.dispose();
    onNextRefresh.clear();
  }

  /// throws a runtime error if the context has no logic
  static Logic of(BuildContext context) => BlocProvider.of<Logic>(context)!;

  final Map<String,Function> onNextRefresh = <String,Function>{};

  late Random rng;

  final BlocVar<Spell> spell = PersistentVar(
    initVal: Spell(0,0),
    key: "krarkulator logic blocVar spell",
    fromJson: (j) => Spell.fromJson(j as Map),
    toJson: (s) => s.toJson,
  );

  final BlocVar<Zone> zone = PersistentVar(
    initVal: Zone.hand,
    key: "krarkulator logic blocVar zone",
    toJson: (z) => z.name,
    fromJson: (j) => Zones.fromName(j as String),
  );


  final BlocVar<int> mana = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar mana",
  );

  final BlocVar<int> treasures = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar treasures",
  );

  final BlocVar<int> storm = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar storm",
  );

  final BlocVar<int> resolved = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar resolved",
  );


  final BlocVar<int> krarks = PersistentVar(
    initVal: 1,
    key: "krarkulator logic blocVar krarks",
  );
  final BlocVar<int> thumbs = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar thumbs",
  );
  final BlocVar<int> scoundrels = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar scoundrels",
  );
  final BlocVar<int> artists = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar artists",
  );
  final BlocVar<int> birgis = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar birgis",
  );
  final BlocVar<int> veyrans = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar veyrans",
  );

  final BlocVar<List<ThumbTrigger>> triggers = BlocVar([]);

  final BlocVar<bool> automatic = PersistentVar(
    initVal: false,
    key: "krarkulator logic blocVar automatic",
  );

  final BlocVar<int> maxCasts = PersistentVar(
    initVal: 100,
    key: "krarkulator logic blocVar maxCasts",
  );


  Logic() {
    rng = Random(DateTime.now().millisecondsSinceEpoch);
  }

  void onNextRefreshZone(){
    onNextRefresh["zone"] = zone.refresh;
  }
  void onNextRefreshTriggers(){
    onNextRefresh["triggers"] = triggers.refresh;
  }
  void onNextRefreshMana(){
    onNextRefresh["mana"] = mana.refresh;
  }
  void onNextRefreshTreasures(){
    onNextRefresh["treasures"] = treasures.refresh;
  }
  void onNextRefreshTotalStormCount(){
    onNextRefresh["totalStormCount"] = storm.refresh;
  }
  void onNextRefreshTotalResolved(){
    onNextRefresh["totalResolved"] = resolved.refresh;
  }

  /// Casts the spell and generates triggers
  void cast({required bool automatic}) {
    assert(canCast);

    triggers.value.clear();
    onNextRefreshTriggers();

    mana.value -= spell.value.manaCost; 
    onNextRefreshMana();

    ++storm.value;
    onNextRefreshTotalStormCount();

    zone.value = Zone.stack;
    onNextRefreshZone();

    final int n = howManyTriggers;

    if(birgis.value > 0){
      mana.value += birgis.value;
      onNextRefreshMana();
    }

    if(artists.value > 0){
      treasures.value += artists.value;
      onNextRefreshTreasures();
    }

    for(int i=0; i<n; i++){
      triggers.value.add(ThumbTrigger(thumbs.value, rng));
      onNextRefreshTriggers();
    }
    
    refreshIf(!automatic);
  }

  int get howManyTriggers => krarks.value * (1 + veyrans.value);

  void solveTrigger(Flip choice, {required bool automatic}){
    triggers.value.removeLast();
    onNextRefreshTriggers();
    if(choice == Flip.bounce){
      zone.value = Zone.hand;
      onNextRefreshZone();
      /// could already be bounced in hand from another trigger, but that does not
      /// change how the current trigger can still copy the latest known spell information
      /// and setting zone = hand more than one time has no effect
    } else {

      _solveSpell();

      if(artists.value > 0){
        treasures.value += artists.value;
        onNextRefreshTreasures();
      }
      if(scoundrels.value > 0){
        treasures.value += scoundrels.value * 2;
        onNextRefreshTreasures();
      }

      /// if this was the last trigger, and the spell was never bounced
      /// you should add one resolved spell (the orignal card) to the total 
      /// resolved count, and resolve that spell as well by producing the mana
      if(triggers.value.isEmpty && zone.value == Zone.stack){
        _solveSpell();
        zone.value = Zone.graveyard;
        onNextRefreshZone();
      }
    }


    refreshIf(!automatic);
  }

  void _solveSpell(){
    resolved.value++;
    onNextRefreshTotalResolved();
    /// resolve
    if(spell.value.chance == 1.0 || rng.nextDouble() < spell.value.chance){
      mana.value += spell.value.manaProduct;
      onNextRefreshMana();
    }
  }

  void reset(){
    this.mana.set(0);
    this.storm.set(0);
    this.resolved.set(0);
    this.zone.set(Zone.hand);
    this.spell.set(Spell(0,0));
    this.triggers.value.clear();
    this.triggers.refresh();
  }

  void refreshIf(bool v){
    if(v) refresh();
  }

  void refresh(){
    onNextRefresh.values.forEach((f) => f());
    onNextRefresh.clear();
  }


  void autoSolveTrigger(){
    ThumbTrigger trigger = triggers.value.last;
    Flip choice;
    if(zone.value == Zone.hand){ /// If already bounced, try to copy
      if(trigger.containsCopy){
        choice = Flip.copy;
      } else {
        choice = Flip.bounce;
      }
    } else { /// If still on the stack, try to bounce
      if(trigger.containsBounce){
        choice = Flip.bounce;
      } else {
        choice = Flip.copy;
      }
    }
    solveTrigger(choice, automatic: true);
  }

  void keepCasting({
    required int forUpTo,
  }){
    assert(forUpTo > 0);
    assert(forUpTo < 1000000000);

    int steps = 0;
    while(canCast && steps < forUpTo){
      ++steps;
      cast(automatic: true);
      final n = triggers.value.length;
      for(int i=0; i<n; ++i){
        autoSolveTrigger();
      }
    }

    refresh();
  }

  bool get canCast 
    => mana.value >= spell.value.manaCost 
    && zone.value == Zone.hand;


} 