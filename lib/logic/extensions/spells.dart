import 'package:krarkulator/everything.dart';

extension SpellsLogic on Logic {

  void moveSpellToGraveyard(int handIndex){
    if(hand.value.length > handIndex && handIndex >=0){
      graveyard.value.add(hand.value.removeAt(handIndex));
      hand.refresh();
      graveyard.refresh();
    }
  }

  void moveSpellFromGraveTohand(int graveIndex){
    if(graveyard.value.length > graveIndex && graveIndex >=0){
      final newSpell = graveyard.value.removeAt(graveIndex);
      graveyard.refresh();
      newSpellToHand(newSpell, null, null);
    }
  }

  void deleteFromHand(int handIndex){
    if(hand.value.length > handIndex && handIndex >=0){
      hand.value.removeAt(handIndex);
      hand.refresh();
    }
  }

  void deleteFromGraveyard(int graveIndex){
    if(graveyard.value.length > graveIndex && graveIndex >=0){
      graveyard.value.removeAt(graveIndex);
      graveyard.refresh();
    }
  }

  void deleteFromSavedSpells(String name){
    spellBook.value.remove(name);
    spellBook.refresh();
  }

  void newSpellToSpellBook(Spell newSpell, String? oldName, {
    bool withoutRefresh = false,
  }){
    // if we edited the name of a spell remove the old name from spell book
    if(oldName != null) spellBook.value.remove(oldName);
    // add the new spell to spellbook
    spellBook.value[newSpell.name] = newSpell;
    if(!withoutRefresh) spellBook.refresh();
  }

  void newSpellToHand(Spell newSpell, String? oldName, int? handIndex, {
    bool withoutRefresh = false,
  }){
    newSpellToSpellBook(newSpell, oldName, withoutRefresh: withoutRefresh);

    // if we edited a spell from hand at an index remove that
    if(handIndex != null && hand.value.length > handIndex && handIndex >=0){
      hand.value.removeAt(handIndex);
    }

    // remove any spell with the new name
    hand.value.removeWhere((s) => s.name == newSpell.name);
    // or with the old name
    if(oldName != null) hand.value.removeWhere((s) => s.name == oldName);

    if(handIndex != null && hand.value.length > handIndex && handIndex >=0){
      // then if we edited a spell frmo hand at an index, insert the new one
      hand.value.insert(handIndex, newSpell);
    } else {
      // or just add it to the end
      hand.value.add(newSpell);
    }

    if(!withoutRefresh) hand.refresh();
  }


}