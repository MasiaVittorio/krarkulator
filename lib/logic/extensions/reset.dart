import 'package:krarkulator/everything.dart';

extension KrLogicReset on Logic {
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