// import 'sub_blocs/all.dart';
import 'dart:math';

import 'package:krarkulator/everything.dart';
import 'package:sid_bloc/sid_bloc.dart';

export 'sub_blocs/all.dart';


class Logic extends BlocBase {
  
  /// throws a runtime error if the context has no logic
  static Logic of(BuildContext context) => BlocProvider.of<Logic>(context)!;

  final Map<String,Function> onNextRefresh = <String,Function>{};

  late Random rng;

  ///==== Board ==============================================
  ///
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
  final BlocVar<int> bonusRounds = PersistentVar(
    initVal: 0,
    key: "krarkulator logic blocVar bonusRounds",
  );


  ///==== Spell ==============================================
  final BlocVar<Spell> spell = PersistentVar(
    initVal: Spell(0,0),
    key: "krarkulator logic blocVar spell",
    fromJson: (j) => Spell.fromJson(j as Map),
    toJson: (s) => s.toJson,
  );
  final BlocVar<Map<String,Spell>> spellBook = PersistentVar(
    initVal: <String,Spell>{},
    key: "krarkulator logic blocVar spellBook",
    fromJson: (j) => {for(final e in (j as Map).entries) 
      e.key: Spell.fromJson(e.value)
    },
    toJson: (m) => {for(final e in m.entries) e.key: e.value.toJson},
  );


  ///==== Status ==============================================
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


  ///===== Triggers ===============================================
  final BlocVar<List<ThumbTrigger>> triggers = BlocVar([]);


  ///===== Settings ===============================================
  final BlocVar<bool> automatic = PersistentVar(
    initVal: false,
    key: "krarkulator logic blocVar automatic",
  );

  final BlocVar<int> maxFlips = PersistentVar(
    initVal: 100,
    key: "krarkulator logic blocVar maxFlips"
  );


  late BlocVar<bool> canCast;

  @override
  void dispose() {
    /// Board
    krarks.dispose();
    thumbs.dispose();
    scoundrels.dispose();
    artists.dispose();
    birgis.dispose();
    veyrans.dispose();
    bonusRounds.dispose();
    /// Spell
    spell.dispose();
    /// Status
    zone.dispose();
    mana.dispose();
    treasures.dispose();
    storm.dispose();
    resolved.dispose();
    /// Triggers
    triggers.dispose();
    /// Settings
    automatic.dispose();
    maxFlips.dispose();

    canCast.dispose();

    onNextRefresh.clear();
  }

  ///===== Constructor ===============================================
  Logic() {
    rng = Random(DateTime.now().millisecondsSinceEpoch);
    canCast = BlocVar.fromCorrelateLatest3<bool,int,Spell,Zone>(
      mana, spell, zone,
      map: (m,s,z) => _computeCanCast,
    );
  }
  bool get _computeCanCast => mana.value + treasures.value >= spell.value.manaCost 
    && zone.value == Zone.hand;


  ///===== Refreshes ===============================================
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
  void onNextRefreshArtists(){
    onNextRefresh["artists"] = artists.refresh;
  }
  void onNextRefreshScoundrels(){
    onNextRefresh["scoundrels"] = scoundrels.refresh;
  }
  void onNextRefreshVeyrans(){
    onNextRefresh["veyrans"] = veyrans.refresh;
  }
  void onNextRefreshThumbs(){
    onNextRefresh["thumbs"] = thumbs.refresh;
  }
  void onNextRefreshBirgis(){
    onNextRefresh["birgis"] = birgis.refresh;
  }
  void onNextRefreshBonusRounds(){
    onNextRefresh["bonusRounds"] = bonusRounds.refresh;
  }
  void onNextRefreshKrarks(){
    onNextRefresh["krarks"] = krarks.refresh;
  }

  void refreshIf(bool v){
    if(v) refresh();
  }
  void refresh(){
    onNextRefresh.values.forEach((f) => f());
    onNextRefresh.clear();
  }


  ///===== Methods ===============================================

  /// Casts the spell and generates triggers
  void cast({required bool automatic}) {
    assert(_computeCanCast);

    triggers.value.clear();
    onNextRefreshTriggers();

    mana.value -= spell.value.manaCost; 
    if(mana.value < 0){
      final int treasuresToSpend = 0 - mana.value;
      mana.value = 0;
      treasures.value -= treasuresToSpend;
      onNextRefreshTreasures();
    }
    onNextRefreshMana();

    ++storm.value;
    onNextRefreshTotalStormCount();

    if(birgis.value > 0){
      mana.value += birgis.value;
      onNextRefreshMana();
    }

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
    
    if(bonusRounds.value > 0){
      final int n = bonusRounds.value + 0;
      for(int i=1; i<=n; ++i){
        _solveSpell();
      }
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
        treasures.value += artists.value 
          * (1 + veyrans.value.clamp(0, double.infinity).toInt());
          /// veyrans (as well as armonic prodigies) double the amount 
          /// of treasures that the storm kiln artist makes!
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
      
      if(spell.value.manaProduct != 0){
        mana.value += spell.value.manaProduct;
        onNextRefreshMana();
      }
      if(spell.value.artistsProduced > 0){
        artists.value += spell.value.artistsProduced;
        onNextRefreshArtists();
      }
      if(spell.value.krarksProduced > 0){
        krarks.value += spell.value.krarksProduced;
        onNextRefreshKrarks();
      }
      if(spell.value.scoundrelProduced > 0){
        scoundrels.value += spell.value.scoundrelProduced;
        onNextRefreshScoundrels();
      }
      if(spell.value.treasuresProduct > 0){
        treasures.value += spell.value.treasuresProduct;
        onNextRefreshTreasures();
      }
      if(spell.value.veyransProduced > 0){
        veyrans.value += spell.value.veyransProduced;
        onNextRefreshVeyrans();
      }
      if(spell.value.thumbsProduced > 0){
        thumbs.value += spell.value.thumbsProduced;
        onNextRefreshThumbs();
      }
      if(spell.value.birgisProduced > 0){
        birgis.value += spell.value.birgisProduced;
        onNextRefreshBirgis();
      }
      if(spell.value.bonusRounds > 0){
        bonusRounds.value += spell.value.bonusRounds;
        onNextRefreshBonusRounds();
      }
    }
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
    required int forHowManyFlips,
  }){
    assert(forHowManyFlips > 0);
    assert(forHowManyFlips < 1000000000);

    int flips = 0;
    while(_computeCanCast && flips < forHowManyFlips){
      cast(automatic: true);
      final n = triggers.value.length;
      for(int i=0; i<n; ++i){
        flips += triggers.value.last.flips.length;
        autoSolveTrigger();
      }
    }

    refresh();
  }



  void reset(){
    /// Board
    krarks.set(1);
    thumbs.set(0);
    artists.set(0);
    birgis.set(0);
    scoundrels.set(0);
    veyrans.set(0);
    bonusRounds.set(0);
    /// Status
    zone.set(Zone.hand);
    treasures.set(0);
    mana.set(0);
    storm.set(0);
    resolved.set(0);
    /// Spell
    spell.set(Spell(0,0));
    /// Triggers
    triggers.value.clear();
    triggers.refresh();
    automatic.set(false);
  }

} 