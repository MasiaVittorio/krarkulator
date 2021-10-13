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
    required StageData stage,
  }){
    assert(forHowManyFlips > 0);
    assert(forHowManyFlips < 1000000000);
    turnOnLogs();

    limit = 0;
    log("enter automatic cast");
    while(computeCanCast && limit < forHowManyFlips){
      cast(automatic: true);
      final n = triggers.value.length;
      for(int i=0; i<n; ++i){
        limit += triggers.value.last.flips.length;
        autoSolveTrigger();
      }
    }

    refresh();

    logsEnabled = false;
    stage.showAlert(
      LogsAlert(lines: <String>[
        if(deletedLogLines > 0)
          "DELETED LINES: $deletedLogLines",
        ...logs,
      ]),
      size: 450,
    );
  }

  void turnOnLogs(){
    logs.clear();
    deletedLogLines = 0;
    logsEnabled = true;
  }

}


class LogsAlert extends StatelessWidget {
  final List<String> lines;
  const LogsAlert({ 
    required this.lines,
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return HeaderedAlert("Logs", 
      alreadyScrollableChild: true,
      child: ListView.builder(
        itemCount: lines.length,
        itemBuilder: (_, i ) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(lines[lines.length - 1 - i]),
        ),
        scrollDirection: Axis.vertical,
        itemExtent: 20,
        reverse: true,
      ),
    );
  }
}