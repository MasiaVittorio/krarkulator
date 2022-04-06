import 'dart:math';

import 'package:krarkulator/models/board.dart';
import 'package:krarkulator/models/mana.dart';
import 'package:krarkulator/models/replacement.dart';

import '../logic.dart';
import 'package:krarkulator/models/spell.dart';
import 'package:krarkulator/models/stack.dart';

extension KrEngine on Logic {

  /// this method doesn't pay the mana cost, from outside use tryToCast instead!
  void castPrivate(Spell spell){

    hand.value.removeWhere((s) => spell.name == s.name);
    if(uniqueSpellId.value > 100000000){
      uniqueSpellId.value = 0;
    } else {
      uniqueSpellId.value++;
    }
    final int id = uniqueSpellId.value + 0;
    // ALWAYS THE FIRST ELEMENT ON THE BOTTOM OF THE STACK 
    stack.value.add(SpellOnTheStack.physical(spell, id));

    this.log("CAST SPELL ${spell.name}");

    storm.value++;

    // triggers on cast
    int nt = board.value.triggersFrom.krarks;
    stack.value.addMultiple(
      Trigger.krark(spell, id), // best to order them on the bottom, 
      nt, // so you get treasures / mana first
    );
    if(nt > 0) this.log("  (krark triggers: $nt)");

    nt = board.value.triggersFrom.artists;
    stack.value.addMultiple(
      Trigger.artist, // solve these before copying or bouncing
      nt, // so you have the mana to react 
    );
    if(nt > 0) this.log("  (artist triggers: $nt)");

    nt = board.value.triggersFrom.bonusRounds;
    stack.value.addMultiple(
      Trigger.bonusRound(spell), // best to order them near the top
      nt, // so you get the copies right away
    );
    if(nt > 0) this.log("  (bonus round triggers: $nt)");

    nt = board.value.triggersFrom.birgis;
    stack.value.addMultiple(
      Trigger.birgi, // best to order them on the absolute top as they can't 
      nt, // answer a triggered mana ability
    );
    if(nt > 0) this.log("  (birgi triggers: $nt)");

    while(
      stack.value.stack.isNotEmpty && 
      stack.value.stack.last is Trigger &&
      (stack.value.stack.last as Trigger).from == BoardElement.birgi
    ){
      solveBirgiTrigger();
      // mana abilities can't be responded to
    }

    if(spell.storm && storm.value > 1){
      this.log("  spell had storm");
      copyASpell(spell.copyWith(), nTimes: storm.value - 1);
    }

  }

  void counterAt(int index){
    final element = stack.value.stack[index];
    if(element is SpellOnTheStack) graveyard.value.add(element.spell);
    stack.value.removeAt(index);
  }

  void solveBirgiTrigger(){
    final element = stack.value.stack.last;
    assert(element.runtimeType == Trigger);
    assert((element as Trigger).from == BoardElement.birgi);

    manaPool.value.add({MtgColor.r: 1});
    this.log("solve birgi trigger: +1 red = ${manaPool.value.pool[MtgColor.r]}");

    stack.value.removeLast();
  }
  
  int solveBonusRoundTrigger(){
    final element = stack.value.stack.last;
    assert(element.runtimeType == TriggerWithSpell);
    assert((element as TriggerWithSpell).from == BoardElement.bonusRound);

    final Spell copiedSpell = (element as TriggerWithSpell).spell.copyWith();

    stack.value.removeLast();
    this.log("solve bonus round trigger");

    return copyASpell(copiedSpell);
  }

  int copyASpell(Spell copiedSpell, {int nTimes = 1}){

    int n = nTimes + board.value.howMany.staffs;
    stack.value.addMultiple(
      SpellOnTheStack(copiedSpell, isCopy: true),
      n,
    );

    if(n > nTimes){
      this.log("Copy a spell $n times ($nTimes + ${n - nTimes} staffs)");
    } else {
      this.log("Copy a spell $n times");
    }

    // triggers on copy
    final int at = board.value.triggersFrom.artists * n;
    stack.value.addMultiple(
      Trigger.artist, 
      at,
    );
    if(at > 0){
      this.log("  (trigger artists $at times)");
    }

    copiedCount.value += n;
    return n;
  }

  void solveSpell(){
    final element = stack.value.stack.last;
    assert(element.runtimeType == SpellOnTheStack);

    final Spell spell = (element as SpellOnTheStack).spell;
    this.log("solve spell ${element.isPhysical ? '(original)' : '(copy)'}");

    board.value.solveSpell(spell);
    manaPool.value.add(spell.manaProduct);
    treasures.value += spell.treasuresProduct;
    
    if(element.isCopy == false){
      // original spell, add to graveyard
      graveyard.value.add(spell);
    }

    resolvedCount.value[spell.name] 
      = (resolvedCount.value[spell.name] ?? 0) + 1; 

    stack.value.removeLast();
  }

  void solveArtistTrigger(){
    final element = stack.value.stack.last;
    assert(element.runtimeType == Trigger);
    assert((element as Trigger).from == BoardElement.artist);

    treasures.value += 1;
    this.log("solve artist trigger: +1 treasure = ${treasures.value}");

    stack.value.removeLast();
  }

  void solveKrarkTrigger({required bool full}){
    final element = stack.value.stack.last;
    assert(element.runtimeType == TriggerWithSpell);
    assert((element as TriggerWithSpell).from == BoardElement.krark);

    int n = pow(2, board.value.howMany.thumbs) as int;

    if(!full || n > 50){
      replacement.value = QuickReplacement(n, rng);
      if(n > 1){
        this.log("thumb replacement: ${replacement.value!.mixed ? 'mixed' : replacement.value!.containsHeads ? 'all heads' : 'all tails'}");
      }
    } else {
      replacement.value = FullReplacement(n, rng);
    }
  }

  void solveFlip(bool copy){
    final element = stack.value.stack.last;
    element as TriggerWithSpell;
    assert(element.from == BoardElement.krark);
    
    assert(replacement.value != null);
    assert(replacement.value!.contains(copy));


    if(copy){
      
      // copy, remove this trigger and add a new copy of the spell
      final copiedSpell = element.spell.copyWith(); 
      stack.value.removeLast();
      this.log("solve krark trigger with heads: copy spell");
      final st = board.value.triggersFrom.scoundrels;
      if(st > 0) this.log("  (trigger scoundrel $st times)");
      copyASpell(copiedSpell);

      // trigger scoundrel
      stack.value.addMultiple(
        Trigger.scoundrel, 
        st,
      );

    } else {

      // bounce, if the spell was still there
      final int originalSpellIndex = stack.value.stack.indexWhere((e) 
        =>  e.runtimeType == SpellOnTheStack &&
            (e as SpellOnTheStack).isPhysical &&
            e.spell.name == element.spell.name &&
            e.uniqueSpellId == element.uniqueSpellId,
      );

      if(originalSpellIndex == -1){
        // spell wasn't there anymore, probably already bounced
        this.log("solve krark trigger with tails: spell already out of stack");
      } else {
        final toBeRemoved = stack.value.stack[originalSpellIndex];
        toBeRemoved as SpellOnTheStack;
        final copiedSpell = toBeRemoved.spell.copyWith();
        stack.value.stack.removeAt(originalSpellIndex);
        newSpellToHand(copiedSpell, null, null, withoutRefresh: true);
        this.log("solve krark trigger with tails: bounce spell");
      }
      stack.value.removeLast();

    }

    replacement.value = null;

  }

  void solveScoundrelTrigger(){
    final element = stack.value.stack.last;
    assert(element.runtimeType == Trigger);
    assert((element as Trigger).from == BoardElement.scoundrel);

    treasures.value += 2;

    stack.value.removeLast();
    this.log("solve scoundrel trigger: +2 treasures = ${treasures.value}");
  }

}