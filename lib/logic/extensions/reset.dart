import 'dart:math';

import '../logic.dart';

extension KrReset on Logic {
  void reset(){
    board.value.reset();
    graveyard.value.clear();
    hand.value.clear();
    manaPool.value.empty();
    replacement.value = null;
    resolvedCount.value = {};
    rng = Random(DateTime.now().millisecondsSinceEpoch);
    selectedSpellName.value = null;
    stack.value.clear();
    storm.value = 0;
    copiedCount.value = 0;
    treasures.value = 0;

    refreshUI();
  }
}