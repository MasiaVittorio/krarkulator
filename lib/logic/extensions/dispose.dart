import 'package:krarkulator/everything.dart';

extension KrLogicDispose on Logic {

  void krDispose() {
    onNextRefresh.clear();
    /// Board
    krarks.dispose();
    thumbs.dispose();
    scoundrels.dispose();
    artists.dispose();
    birgis.dispose();
    veyrans.dispose();
    prodigies.dispose();
    bonusRounds.dispose();
    /// Spell
    spell.dispose();
    spellBook.dispose();
    /// Status
    zone.dispose();
    mana.dispose();
    treasures.dispose();
    storm.dispose();
    resolved.dispose();
    /// Triggers
    triggers.dispose();
    /// Other
    canCast.dispose();
    /// Settings
    automatic.dispose();
    maxActions.dispose();


  }

}
