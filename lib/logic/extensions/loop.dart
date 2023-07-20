import 'dart:convert';

import 'package:krarkulator/models/board.dart';
import 'package:krarkulator/models/stack.dart';

import '../logic.dart';
import 'package:krarkulator/models/spell.dart';

extension KrLoops on Logic {

  String startLoop(){
    
    logs.clear();
    bool couldCast = true;
    currentLoopActions = 0;

    do {
      ++currentLoopActions;

      Object tryResult = getSpellOrMessage(
        pool: manaPool.value, 
        spellName: selectedSpellName.value ?? '', 
        treasures: treasures.value, 
        hand: hand.value, 
        graveyard: graveyard.value,
      );

      bool triedToBounceThisCast = false;
  
      if(tryResult is Spell){
        tryToCast(tryResult);
      } else {
        couldCast = false;
      }
      
      // surely the stack is empty if we are at the start of this do while, and
      // the tryResult wasn't a spell to cast, so this while won't fire if we 
      // didn't cast the spell 
      while(
        stack.value.stack.isNotEmpty && 
        currentLoopActions < maxNumberOfActions.value
      ){
        ++currentLoopActions;
        triedToBounceThisCast = _autoSolveTop(triedToBounceThisCast);
      }

    } while (couldCast && currentLoopActions < maxNumberOfActions.value);

    if(couldCast) {
      return "${maxNumberOfActions.value} actions reached";
    } else {
      return "Couldn't cast again";
    }
  }

  bool _autoSolveTop(bool alreadyTriedToBounce){
    final element = stack.value.stack.last;

    bool triedToBounceThisTime = false;

    switch (element.type) {
      case SpellOnTheStack.t:
        solveSpell();
        break;
      case Trigger.t:
        element as Trigger;
        switch (element.from) {
          case BoardElement.artist:
            solveArtistTrigger();
            break;

          case BoardElement.birgi:
            solveBirgiTrigger();
            break;

          case BoardElement.bonusRound:
            solveBonusRoundTrigger();
            break;

          case BoardElement.scoundrel:
            solveScoundrelTrigger();
            break;

          case BoardElement.krark:
            element as TriggerWithSpell;

            solveKrarkTrigger(full: false);

            final flips = replacement.value!;

            if(flips.numberOfCoins == 1){
              
              // if only one flip was done, no choice to be done
              solveFlip(flips.containsHeads);

            } else { 
              
              // more flips, let's see if we can choose
              final bool possibleToCopy = flips.containsHeads;
              final bool possibleToBounce = flips.containsTails;

              if(possibleToBounce && possibleToCopy){
                // if you can choose, you want to bounce at least one first 
                // time, then always copy
                if(alreadyTriedToBounce){
                  solveFlip(true); // copy
                } else {
                  triedToBounceThisTime = true;
                  solveFlip(false); // bounce
                }
              } else {
                // if we can't choose, this is the choice
                solveFlip(possibleToCopy);
              }

            }
            break;
          default:
        }
        break;
    }

    return alreadyTriedToBounce || triedToBounceThisTime;
  }

  void solveSamePrivate(bool startWithBounce){
    final element = stack.value.stack.last;
    final start = jsonEncode(element.json);
    
    bool triedToBounceThisCast = startWithBounce ? false : true;
    while(
      stack.value.stack.isNotEmpty && 
      jsonEncode(stack.value.stack.last.json) == start
    ){
      triedToBounceThisCast = _autoSolveTop(triedToBounceThisCast);
    }
  }

  void solveAllPrivate(bool startWithBounce){
    bool triedToBounceThisCast = startWithBounce ? false : true;
    while(stack.value.stack.isNotEmpty){
      triedToBounceThisCast = _autoSolveTop(triedToBounceThisCast);
    }
  }

  void log(String string){
    if(logs.length < 200){
      logs.add(string);
    } else {
      logs.removeAt(100);
      logs.removeAt(100);
      logs.insert(100, "[...]");
      logs.add(string);
    }
  }

}