import 'package:krarkulator/everything.dart';

extension KrLogicLoops on Logic {
  
  void autoSolveTrigger(){
    ThumbTrigger trigger = triggers.value.last;
    Flip choice;
    if(zone.value == Zone.hand){ /// If already bounced, try to copy
      if(trigger.containsCopy){
        choice = Flip.copy;
      } else {
        choice = Flip.bounce;
      }
    } else { /// If still on the stack, try to bounce
      if(trigger.containsBounce){
        choice = Flip.bounce;
      } else {
        choice = Flip.copy;
      }
    }
    solveKrarkTrigger(choice, automatic: true);
  }

  void keepCasting({
    required int forHowManyFlips,
  }){
    assert(forHowManyFlips > 0);
    assert(forHowManyFlips < 1000000000);

    limit = 0;
    while(computeCanCast && limit < forHowManyFlips){
      cast(automatic: true);
      final n = triggers.value.length;
      for(int i=0; i<n; ++i){
        limit += triggers.value.last.flips.length;
        autoSolveTrigger();
      }
    }

    refresh();
  }

}