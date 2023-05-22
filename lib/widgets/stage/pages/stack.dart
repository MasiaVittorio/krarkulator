import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/resources/snacks/last_action.dart';
import 'resources/all.dart';

class StackBody extends StatelessWidget {
  const StackBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    return logic.stack.build((_, val) {
      if(val.stack.isEmpty) return Container();
      return PagedStack(stack: [...val.stack]);
    });
  }
}


class PagedStack extends StatefulWidget {

  const PagedStack({
    required this.stack,
    Key? key,
  }): assert(stack.length > 0), super(key: key);

  final List<StackElement> stack;

  @override
  State<PagedStack> createState() => _PagedStackState();

}

class _PagedStackState extends State<PagedStack> {

  late PageController controller;
  late BlocVar<int> index;

  @override
  void initState() {
    super.initState();
    final i = widget.stack.length - 1;
    controller = PageController(initialPage: i);
    index = BlocVar(i);
  }

  @override
  void dispose() {
    controller.dispose();
    index.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PagedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if(index.value >= widget.stack.length){
      index.set(widget.stack.length -1);
    }
    if(controller.page!.round() >= widget.stack.length){
      controller.jumpToPage(widget.stack.length - 1);
    }

    if(widget.stack.length > oldWidget.stack.length){
      index.set(widget.stack.length -1);
      controller.jumpToPage(widget.stack.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          howManyLower,
          Expanded(child: body),
          howManyHigher,
          controls,
          SizedBox(
            height: Stage.of(context)!.dimensionsController
              .dimensions.value.collapsedPanelSize / 2,
          ),
        ].separateWith(KrWidgets.height10),
      ),
    );
  }

  int get n => widget.stack.length;
  // n = 3
  // i = 0: 0 lower / 2 higher
  // i = 1: 1 lower / 1 higher -> 
  // higher: n-i-1;

  // n = 1
  // i = 0: 0 lower / 1-0-1: 0 higher

  // n = 5
  // i = 3: 3 lower / 1 higher
  // i = 4: 4 lower (0,1,2,3) / 0 higher (5-4-1)

  Widget get howManyLower => ListTile(title: index.build((_, i) => AnimatedText(
    i == 0
      ? "This stack element will resolve last"
      : "$i stack elements lower than this one",
  ),),);
  Widget get howManyHigher => ListTile(title: index.build((_, i) => AnimatedText(
    i == n -1 
      ? "This stack element will resolve first"
      : "${n - i - 1} stack elements higher than this one",
  ),),);


  Widget get controls => index.build((context, i) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    return logic.replacement.build((_, flips) => flips == null
      ? Row(children: <Widget>[
        for(final child in [
          ListTile(
            title: const Text("Counter"),
            leading: KrWidgets.deleteIcon,
            onTap: () => logic.counterThenRefresh(index.value),
            onLongPress: () => stage.showAlert(
              const AdvancedCounterAlert(),
              size: AdvancedCounterAlert.height,
            ),
          ),
          if(i == n - 1) ListTile(
            title: const Text("Resolve"),
            leading: const Icon(Icons.check),
            onTap: () => solve(logic, stage),
            onLongPress: () => stage.showAlert(
              const AdvancedSolveAlert(),
              size: AdvancedSolveAlert.height,
            ),
          ) else ListTile(
            title: const Text("Go to top"),
            leading: const Icon(Icons.arrow_downward),
            onTap: (){
              controller.jumpToPage(widget.stack.length - 1);
              index.set(widget.stack.length - 1);
            },
          )
        ]) Expanded(child: SubSection([child],),),
      ].separateWith(KrWidgets.width10))
      : SubSection([ListTile(
        title: const Text("Thumb replacement effect"),
        leading: const Icon(Icons.warning_amber),
        onTap: (){
          if(controller.page?.round() == n - 1) return;
          controller.animateToPage(
            n -1, 
            duration: const Duration(milliseconds: 500), 
            curve: Curves.ease,
          );
          index.set(n - 1);
        },
      )])
    );
  });

  Widget get body => SubSection([
    Expanded(child: PageView.builder(
      itemCount: widget.stack.length,
      onPageChanged: index.set,
      itemBuilder: (_, i) => StackElementChild(
        widget.stack[i],
        index: i,
        outOf: widget.stack.length,
      ),
      scrollDirection: Axis.vertical,
      controller: controller,
    ),),
  ],);


  void solve(Logic logic, StageData stage){

    final element = logic.stack.value.stack.last;
    void show() => stage.showSnackBar(
      const LastAction(),
      pagePersistent: true,
      rightAligned: true,
    );

    switch (element.type) {
      case SpellOnTheStack.t:
        logic.solveSpell();
        break;
      case Trigger.t:
        element as Trigger;
        switch (element.from) {
          case BoardElement.artist:
            logic.solveArtistTrigger();
            logic.lastAction.set("+1 Treasure: now ${logic.treasures.value}");
            show();
            break;

          case BoardElement.birgi:
            logic.solveBirgiTrigger();
            logic.lastAction.set("+1 {R}: now ${logic.manaPool.value.pool[MtgColor.r]}");
            show();
            break;

          case BoardElement.bonusRound:
            final n = logic.solveBonusRoundTrigger();
            logic.lastAction.set("$n ${n>1 ? 'copies' : 'copy'} added to the stack");
            show();
            break;

          case BoardElement.scoundrel:
            logic.solveScoundrelTrigger();
            logic.lastAction.set("+2 Treasure: now ${logic.treasures.value}");
            show();
            break;

          case BoardElement.krark:
            logic.solveKrarkTrigger(full: true);
            break;
          default:
        }
        break;
    }

    logic.refreshUI();
  }


}


class AdvancedCounterAlert extends StatelessWidget {

  const AdvancedCounterAlert({ Key? key }) : super(key: key);

  static const double height = ConfirmAlert.height;

  @override
  Widget build(BuildContext context) {

    final logic = Logic.of(context);

    return ConfirmAlert(
      autoCloseAfterConfirm: true,
      confirmColor: KRColors.delete,
      warningText: "Counter ALL spells and abilities?",
      confirmIcon: Icons.delete_forever_outlined,
      confirmText: "Yes, clear the stack",
      cancelText: "No, go back",
      action: (){
        final physicalSpells = [
          for(final e in logic.stack.value.stack)
            if(e is SpellOnTheStack)
              if(e.isPhysical)
                e.spell.copyWith(),
        ];
        logic.graveyard.value.addAll(physicalSpells);
        logic.stack.value.clear();
        logic.graveyard.refresh();
        logic.stack.refresh();
      },
    );
  }
}


class AdvancedSolveAlert extends StatelessWidget {

  const AdvancedSolveAlert({ Key? key }) : super(key: key);

  static double get height => AlternativesAlert.heightCalc(2);

  @override
  Widget build(BuildContext context) {

    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    return AlternativesAlert(
      label: "Advanced stack resolution",
      alternatives: [
        Alternative(
          title: "Solve same kind of triggers", 
          icon: Icons.copy, 
          action: () {
            if(
              logic.stack.value.stack.last is TriggerWithSpell &&
              (logic.stack.value.stack.last as TriggerWithSpell).from 
                == BoardElement.krark && 
              logic.board.value.triggersFrom.krarks > 1
            ){
              stage.showAlert(
                AlternativesAlert(
                  label: "How to pick flips",
                  alternatives: [
                    Alternative(
                      title: "Start with a bounce", 
                      icon: Icons.restart_alt, 
                      action: () => logic.solveSameThenRefresh(true),
                      completelyAutoClose: true,
                    ),
                    Alternative(
                      title: "Copies all the way", 
                      icon: Icons.copy_all_rounded, 
                      action: () => logic.solveSameThenRefresh(false),
                      completelyAutoClose: true,
                    ),
                  ], 
                ),
                size: AlternativesAlert.heightCalc(2),
              );
            } else {
              logic.solveSameThenRefresh(false);
              stage.closePanelCompletely();
            }
          }
        ),
        Alternative(
          title: "Solve the whole stack", 
          icon: Icons.select_all_rounded, 
          action: () {
            if(logic.board.value.howMany.thumbs > 0){
              stage.showAlert(
                AlternativesAlert(
                  label: "How to pick flips",
                  alternatives: [
                    Alternative(
                      title: "Start with a bounce", 
                      icon: Icons.restart_alt, 
                      action: () => logic.solveAllThenRefresh(true),
                      completelyAutoClose: true,
                    ),
                    Alternative(
                      title: "Copies all the way", 
                      icon: Icons.copy_all_rounded, 
                      action: () => logic.solveAllThenRefresh(false),
                      completelyAutoClose: true,
                    ),
                  ], 
                ),
                size: AlternativesAlert.heightCalc(2),
              );
            } else {
              logic.solveAllThenRefresh(false);
              stage.closePanelCompletely();
            }
          }
        ),
      ], 
    );
  }
}




class StackElementChild extends StatelessWidget {

  const StackElementChild(this.element, {
    required this.index,
    required this.outOf,
    Key? key,
  }) : super(key: key);

  final StackElement element;
  final int index;
  final int outOf;

  @override
  Widget build(BuildContext context) {
    switch (element.runtimeType) {
      case Trigger:
        return StackWidgetTrigger(
          element as Trigger,
          index: index,
          outOf: outOf,
        );
      case TriggerWithSpell:
        return StackWidgetTriggerWithSpell(
          element as TriggerWithSpell,
          index: index,
          outOf: outOf,
        );
      case SpellOnTheStack:
        return StackWidgetSpell(
          element as SpellOnTheStack,
          index: index,
          outOf: outOf,
        );
      default:
    }
    assert(false);
    return Container();
  }

}

