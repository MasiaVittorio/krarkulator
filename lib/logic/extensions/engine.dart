import 'package:krarkulator/everything.dart';

extension KrLogicEngine on Logic {

  /// Casts the spell and generates triggers
  void cast({required bool automatic}) {
    assert(computeCanCast);

    triggers.value.clear(); // clear triggers
    onNextRefreshTriggers();

    _paySpellManaCost();

    ++storm.value; // Uptick storm count
    onNextRefreshTotalStormCount();

    zone.value = Zone.stack; // put spell on the stack
    onNextRefreshZone();


    _triggerBirgi();

    _triggerStormKilnArtist();

    _triggerKrark();
    
    _triggerBonusRound();

    refreshIf(!automatic);
  }

  void _paySpellManaCost(){
    mana.value -= spell.value.manaCost;
    onNextRefreshMana();
    if(mana.value < 0){
      final int treasuresToSpend = 0 - mana.value;
      mana.value = 0;
      treasures.value -= treasuresToSpend;
      onNextRefreshTreasures();
    }
  }

  void _triggerBirgi(){
    if(birgis.value > 0){
      mana.value += birgis.value;
      onNextRefreshMana();
    } //TODO: veyran should multiply this while prodigy would not, fuck
  }

  void _triggerStormKilnArtist(){
    if(artists.value > 0){
      treasures.value += artists.value 
        * (1 + veyrans.value.clamp(0, double.infinity).toInt());
        /// veyrans (as well as armonic prodigies) double the amount 
        /// of treasures that the storm kiln artist makes!
      onNextRefreshTreasures();
    }
  }

  int get howManyTriggers => krarks.value * (1 + veyrans.value);
  void _triggerKrark(){
    final int n = howManyTriggers;
    for(int i=0; i<n; i++){
      triggers.value.add(ThumbTrigger(thumbs.value, rng));
      onNextRefreshTriggers();
    }
  }

  void _triggerBonusRound(){
    if(bonusRounds.value > 0){
      final int n = bonusRounds.value + 0;
      for(int i=1; i<=n; ++i){
        ++limit;
        solveSpell();
        _triggerStormKilnArtist();
      }
    }
  }

  void solveKrarkTrigger(Flip choice, {required bool automatic}){

    triggers.value.removeLast();
    onNextRefreshTriggers();

    if(choice == Flip.bounce){
      zone.value = Zone.hand;
      onNextRefreshZone();
      /// could already be bounced in hand from another trigger, but that does not
      /// change how the current trigger can still copy the latest known spell information
      /// and setting zone = hand more than one time has no effect
    } else { /// Copy

      solveSpell();

      _triggerStormKilnArtist();

      if(scoundrels.value > 0){
        treasures.value += scoundrels.value * 2;
        onNextRefreshTreasures();
      }

      /// if this was the last trigger, and the spell was never bounced
      /// you should add one resolved spell (the orignal card) to the total 
      /// resolved count, and resolve that spell as well by producing the mana
      if(triggers.value.isEmpty && zone.value == Zone.stack){
        solveSpell();
        zone.value = Zone.graveyard;
        onNextRefreshZone();
      }
    }

    refreshIf(!automatic);
  }


}
