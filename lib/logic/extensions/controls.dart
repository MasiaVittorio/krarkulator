// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:krarkulator/everything.dart';

extension KrControls on Logic {

  Spell? _getSelectedSpellFromHand(String _name, List<Spell> _hand){
    for(final s in _hand){
      if(s.name == _name) return s;
    }
    return null;
  }

  bool _isSelectedSpellInGraveyard(String _name, List<Spell> _graveyard){
    for(final s in _graveyard)
      if(s.name == _name) return true;
    return false;
  }

  /// string if the spell cannot be cast, spell if it can
  Object getSpellOrMessage({
    required ManaPool pool,
    required String? spellName,
    required int treasures,
    required List<Spell> hand,
    required List<Spell> graveyard,
  }){

    if(spellName == null) return const CastError(
      ErrorType.spellNotSelected, 
      "Select a spell from your hand!",
    );

    Spell? spell = _getSelectedSpellFromHand(spellName, hand);

    if(spell == null){
      if(_isSelectedSpellInGraveyard(spellName, graveyard)) {
        return CastError(
          ErrorType.spellInGraveyard, 
          '"$spellName" is in the graveyard!',
        );
      }
      return CastError(
        ErrorType.spellOutOfHand ,
        '"$spellName" out of hand!',
      );
    }

    int debt = pool.debtIfWouldTryToPay(spell.manaCost);

    if(debt > treasures) {
      return const CastError(
        ErrorType.insufficientManaOrTreasures, 
        "Insufficient mana / treasures!",
      );
    }

    return spell;
  }

  void solveError(CastError error, StageData stage){
    switch (error.type) {
      case ErrorType.insufficientManaOrTreasures:
        stage.mainPagesController.goToPage(KrPage.status);
        break;
      case ErrorType.spellInGraveyard:
        stage.mainPagesController.goToPage(KrPage.spell);
        break;
      case ErrorType.spellNotSelected:
        stage.mainPagesController.goToPage(KrPage.spell);
        break;
      case ErrorType.spellOutOfHand:
        stage.mainPagesController.goToPage(KrPage.spell);
        break;
    }
  }

  void tryToCast(Spell spell){
    int debt = manaPool.value.debtIfWouldTryToPay(spell.manaCost);

    if(debt <= treasures.value){
      manaPool.value.pay(spell.manaCost);
      treasures.value -= debt;
      castPrivate(spell);
    }
  }

  void refreshAfterCast(){
    storm.refresh();
    manaPool.refresh();
    treasures.refreshDistinct();
    hand.refresh();
    stack.refresh();
    copiedCount.refresh();
  }

  void counterThenRefresh(int index){
    if(index < stack.value.stack.length && index > 0){
      counterAt(index);
      stack.refresh();
      graveyard.refresh();
    }
  }

  void tryToCastAndRefresh(Spell spell){
    int debt = manaPool.value.debtIfWouldTryToPay(spell.manaCost);

    if(debt <= treasures.value){
      manaPool.value.pay(spell.manaCost);
      treasures.value -= debt;
      castPrivate(spell);
      refreshAfterCast();
    }

  }

  // safe method, just renaming it to make it obvious
  void tryToCopyASpell(Spell spell, {int nTimes = 1}) 
    => copyASpell(spell, nTimes: nTimes); 

  void solveFlipThenRefresh(bool copy){
    solveFlip(copy);
    if(!copy) hand.refresh();
    stack.refresh();
    copiedCount.refresh();
    replacement.refresh();
  }

  void solveSameThenRefresh(bool startWithBounce){
    solveSamePrivate(startWithBounce);
    refreshUI();
  }

  void solveAllThenRefresh(bool startWithBounce){
    solveAllPrivate(startWithBounce);
    refreshUI();
  }


}