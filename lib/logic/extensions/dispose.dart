import 'package:krarkulator/everything.dart';

extension KrLogicDispose on Logic {

  void krDispose() {
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

}
