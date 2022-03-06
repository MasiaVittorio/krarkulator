import 'package:krarkulator/everything.dart';

extension KrLogicEngine on Logic {
  /// Casts the spell and generates triggers
  void cast({required bool automatic}) {
    assert(computeCanCast);
    log("casting spell");

    triggers.value.clear(); // clear triggers
    onNextRefreshTriggers();

    _paySpellManaCost();

    ++storm.value; // Uptick storm count
    onNextRefreshTotalStormCount();

    zone.value = Zone.stack; // put spell on the stack
    onNextRefreshZone();
    log("spell zone: stack");

    _triggerBirgi();

    _triggerStormKilnArtist();

    final int n = computeHowManyKrarkTriggers(
      krarks.value,
      veyrans.value,
      prodigies.value,
    );
    if (n > 0)
      _triggerKrark(n);
    else {
      solveSpell(false); // In case of zero krarks the spell has to just resolve
      zone.value = Zone.graveyard;
    }

    _triggerBonusRound();

    refreshUIIf(!automatic);
  }

  void _paySpellManaCost() {
    final int oldMana = mana.value;
    mana.value -= spell.value.manaCost;
    onNextRefreshMana();
    if (mana.value < 0) {
      final int oldTreasures = treasures.value;
      final int treasuresToSpend = 0 - mana.value;
      mana.value = 0;
      treasures.value -= treasuresToSpend;
      onNextRefreshTreasures();
      log("after paying cost, treasures: $oldTreasures - $treasuresToSpend = ${treasures.value}");
    }
    final manaSpent = oldMana - mana.value;
    log("after paying cost, mana: $oldMana - $manaSpent = ${mana.value}");
  }

  int get howManyBirgiTriggers => birgis.value * (1 + veyrans.value);
  void _triggerBirgi() {
    if (birgis.value > 0) {
      final n = howManyBirgiTriggers;

      final oldMana = mana.value;

      /// Veyran (not harmonic prodigy!) increases the mana generated by birgi!
      mana.value += n;
      log("  birgi, mana: $oldMana + $n = ${mana.value}");
      onNextRefreshMana();
    }
  }

  int get howManyArtistsTriggers =>
      artists.value * (1 + veyrans.value + prodigies.value);
  void _triggerStormKilnArtist() {
    if (artists.value > 0) {
      final n = howManyArtistsTriggers;

      final oldTreasures = treasures.value;

      /// veyrans (as well as armonic prodigies) double the amount
      /// of treasures that the storm kiln artist makes!
      treasures.value += n;
      log("  artist, treasures: $oldTreasures +$n = ${treasures.value}");
      onNextRefreshTreasures();
    }
  }

  void _triggerKrark(int n) {
    log("  krark: triggers +$n");
    for (int i = 0; i < n; i++) {
      // TODO: thumbs value should be looked up upon resolution of the single
      // trigger, not upon putting the trigger on the stack
      triggers.value.add(ThumbTrigger(thumbs.value, rng));
      onNextRefreshTriggers();
    }
  }

  void _triggerBonusRound() {
    if (bonusRounds.value > 0) {
      final int n = bonusRounds.value + 0;
      log("  bonus round: copies +$n");
      for (int i = 1; i <= n; ++i) {
        ++limit;
        _triggerStormKilnArtist();
        solveSpell(true);
      }
    }
  }

  void solveKrarkTrigger(Flip choice, {required bool automatic}) {
    log("trigger #${triggers.value.length}: ${choice == Flip.bounce ? 'tails' : 'head'}");
    triggers.value.removeLast();
    onNextRefreshTriggers();

    if (choice == Flip.bounce) {
      zone.value = Zone.hand;
      log("  spell zone: hand");
      onNextRefreshZone();

      /// could already be bounced in hand from another trigger, but that does not
      /// change how the current trigger can still copy the latest known spell information
      /// and setting zone = hand more than one time has no effect
    } else {
      /// Copy

      _triggerStormKilnArtist();

      _triggerScoundrel();

      solveSpell(true);

      /// if this was the last trigger, and the spell was never bounced
      /// you should add one resolved spell (the orignal card) to the total
      /// resolved count, and resolve that spell as well by producing the mana
      if (triggers.value.isEmpty && zone.value == Zone.stack) {
        log("no bounce: resolve original spell");
        solveSpell(false);
        zone.value = Zone.graveyard;
        log("spell zone: graveyard");
        onNextRefreshZone();
      }
    }

    refreshUIIf(!automatic);
  }

  void _triggerScoundrel() {
    if (scoundrels.value > 0) {
      final n = scoundrels.value * 2;
      treasures.value += n;
      onNextRefreshTreasures();
      log("  scoundrel: treasures +$n = ${treasures.value}");
    }
  }
}
