// import 'package:krarkulator/data/widgets.dart';
import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/all.dart';

class KrCollapsed extends StatelessWidget {
  const KrCollapsed({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final logic = Logic.of(context);
    final stage = Stage.of<KrPage,dynamic>(context)!;

    return logic.graveyard.build((_, graveyard) => 
      logic.hand.build((_, hand) => 
      logic.treasures.build((_, treasures) => 
      logic.manaPool.build((_, pool) => 
      logic.selectedSpellName.build((_, spellName){

        final object = logic.getSpellOrMessage(
          pool: pool, 
          spellName: spellName, 
          treasures: treasures, 
          hand: hand, 
          graveyard: graveyard,
        );

        late final CastError? error; 
        late final Spell? spell;
        if(object is CastError){
          error = object;
          spell = null;
        } else if(object is Spell){
          spell = object;
          error = null;
        } else {
          assert(false); // unreachable
        }

        if(error != null){
          return SimpleTile(
            title: Text(
              error.message, 
              style: TextStyle(color: errorColor), 
            ),
            leading: Icon(Icons.warning_amber_rounded, color: errorColor,),
            onTap: () => logic.solveError(error!, stage),
          );
        } else if(spell != null){
          return SimpleTile(
            title: Text(
              'Cast "${spell.name}"', 
            ),
            leading: const Icon(ManaIcons.instant),
            onTap: () {
              final canLoop = logic.board.value.triggersFrom.krarks > 1;
              if(!canLoop) {
                logic.tryToCastAndRefresh(spell!);
              } else {
                final n = logic.maxNumberOfActions.value; 
                stage.showAlert(
                  AlternativesAlert(
                    alternatives: [
                      Alternative(
                        title: "Auto-loop casts", 
                        icon: Icons.refresh_rounded, 
                        action: (){
                          final s = logic.startLoop();
                          logic.refreshUI();
                          stage.closePanelCompletely();
                          stage.showSnackBar(StageSnackBar(
                            title: Text(s),
                            secondary: IconButton(
                              icon: const Text("log"),
                              onPressed: () => stage.showAlert(
                                const LogsAlert(), 
                                size: 500,
                              ),
                            ),
                          ));
                        },
                      ),
                      Alternative(
                        title: "Cast once", 
                        icon: ManaIcons.instant,
                        action: () => logic.tryToCastAndRefresh(spell!),
                        autoClose: true,
                      ),
                    ], 
                    label: "You can loop casts until no bounce or $n actions",
                    twoLinesLabel: true,
                  ),
                  size: AlternativesAlert.twoLinesheightCalc(2),
                );
              }
            },
          );
        } else {
          assert(false);
          return Container();
        }
      },)))),
    );

  }
}