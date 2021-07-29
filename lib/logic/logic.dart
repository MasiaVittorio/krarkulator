// import 'sub_blocs/all.dart';
import 'dart:math';

import 'package:krarkulator/everything.dart';
import 'package:sid_bloc/sid_bloc.dart';
import 'extensions/all.dart';
export 'extensions/all.dart';

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
    initVal: <String,Spell>{
      "Rite of Flame": Spell(1,2),
      "Desperate Ritual": Spell(2,3),
      "Bonus Round": Spell(3,0,bonusRounds: 1),
      "Twinflame (Krark)": Spell(2,0,krarksProduced: 1),
      "Heat Shimmer (Krark)": Spell(3,0,krarksProduced: 1),
    },
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
  int limit = 0;

  final BlocVar<int> maxFlips = PersistentVar(
    initVal: 100,
    key: "krarkulator logic blocVar maxFlips"
  );


  late BlocVar<bool> canCast;

  @override
  void dispose() => krDispose();

  ///===== Constructor ===============================================
  Logic() {
    rng = Random(DateTime.now().millisecondsSinceEpoch);
    canCast = BlocVar.fromCorrelateLatest4<bool,int,int,Spell,Zone>(
      mana, treasures, spell, zone,
      map: (m,t,s,z) => computeCanCast,
    );
  }

  bool get computeCanCast => mana.value + treasures.value >= spell.value.manaCost 
    && zone.value == Zone.hand;





} 