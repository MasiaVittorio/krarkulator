import 'package:krarkulator/everything.dart';
import 'pages/all.dart';

class KrBody extends StatelessWidget {

  const KrBody({ Key? key }) : super(key: key);

  static const int n = 4;
  // TODO: if too small, scrollable

  @override
  Widget build(BuildContext context){

    final stage = Stage.of<KrPage,dynamic>(context)!;

    final dimensions = stage.dimensionsController.dimensions.value;
    final bottomPadding = dimensions.collapsedPanelSize / 2;
    
    return LayoutBuilder(builder: (_, constraints){

      final space = constraints.maxHeight - bottomPadding;
      final little = space / (n+1);
      final big = little * 2;
      final littleExpanded = little*3;
      final width = constraints.maxWidth;

      return Material(
        child: ConstrainedBox(
          constraints: constraints,
          child: Stack(children: [Positioned(
            top: 0, left: 0, right: 0,
            bottom: null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LittleChild(
                  page: KrPage.board, 
                  width: width,
                  collapsedHeigth: little, 
                  expandedHeigth: littleExpanded, 
                  collapsedChild: BoardCollapsed(width: width,),
                  expandedChild: const BoardExpanded(),
                ),
                LittleChild(
                  page: KrPage.spell, 
                  width: width,
                  collapsedHeigth: little, 
                  expandedHeigth: littleExpanded, 
                  collapsedChild: SpellCollapsed(width: width,),
                  expandedChild: const SpellExpanded(),
                ),
                LittleChild(
                  page: KrPage.status, 
                  width: width,
                  collapsedHeigth: little, 
                  expandedHeigth: littleExpanded, 
                  collapsedChild: StatusCollapsed(width: width,),
                  expandedChild: const StatusExpanded(),
                ),
                
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: big,
                    maxWidth: width,
                  ),
                  child: const TriggersView(),
                ),
              ],
            ),
          )]),
        ),
      );
    });
  }
}


class LittleChild extends StatelessWidget {

  const LittleChild({ 
    required this.page,
    required this.width,
    required this.collapsedHeigth,
    required this.expandedHeigth,
    required this.collapsedChild,
    required this.expandedChild,
    Key? key, 
  }): super(key: key);

  final KrPage page;
  final double width;
  final double collapsedHeigth;
  final double expandedHeigth;
  final Widget collapsedChild;
  final Widget expandedChild;

  BoxConstraints constraints(double height) => BoxConstraints(
    maxWidth: width,
    maxHeight: height,
  );

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of<KrPage,dynamic>(context)!;
    final VoidCallback callback = () => stage.mainPagesController.goToPage(page);
    final physics = SidereusScrollPhysics(
      alwaysScrollable: true,
      bottomBounce: true,
      topBounce: true,
      bottomBounceCallback: callback,
      topBounceCallback: callback,
    );

    final collapsedBoxed = ConstrainedBox(
      constraints: constraints(collapsedHeigth),
      child: collapsedChild,
    );
    final expandedBoxed = ConstrainedBox(
      constraints: constraints(expandedHeigth),
      child: expandedChild,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: physics,
      child: Container(
        width: width,
        child: StageBuild.offMainPage<KrPage>((_, p) => AnimatedDouble(
          value: p == page ? expandedHeigth : collapsedHeigth,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          builder: (_, val) {

            final expandedOpacity = val.mapToRange(0.0, 1.0, 
              fromMin: collapsedHeigth, fromMax: expandedHeigth,
            );
            final collapsedOpacity = 1 - expandedOpacity;

            return ConstrainedBox(
              constraints: constraints(val),
              child: Stack(children: [
                
                Positioned(
                  top: 0, left: 0, right: 0, height: collapsedHeigth,
                  child: IgnorePointer(
                    ignoring: val != collapsedHeigth,
                    child: Opacity(
                      opacity: collapsedOpacity,
                      child: collapsedBoxed,
                    ),
                  ),
                ),

                Positioned(
                  top: 0, left: 0, right: 0, height: expandedHeigth,
                  child: IgnorePointer(
                    ignoring: val != expandedHeigth,
                    child: Opacity(
                      opacity: expandedOpacity,
                      child: expandedBoxed,
                    ),
                  ),
                ),

              ],),
            );
          },
        )),
      ),
    );
  }
}



