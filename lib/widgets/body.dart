import 'package:krarkulator/everything.dart';
import 'pages/all.dart';

class KrBody extends StatelessWidget {

  const KrBody({ Key? key }) : super(key: key);

  static const int n = 4;

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

  @override
  Widget build(BuildContext context) {

    final collapsedBoxed = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: collapsedHeigth,
        maxWidth: width,
      ),
      child: collapsedChild,
    );
    final expandedBoxed = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: expandedHeigth,
        maxWidth: width,
      ),
      child: expandedChild,
    );

    return StageBuild.offMainPage<KrPage>((_, p) {

      final isExpanded = (p == page);
      final isCollapsed = !isExpanded;

      return AnimatedDouble(
        value: isExpanded ? expandedHeigth : collapsedHeigth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        builder: (_, val) {

          final expandedOpacity = val.mapToRange(0.0, 1.0, 
            fromMin: collapsedHeigth, fromMax: expandedHeigth,
          );
          final collapsedOpacity = 1 - expandedOpacity;

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: val,
            ),
            child: Stack(children: [
              
              Positioned(
                top: 0, left: 0, right: 0, bottom: null,
                child: IgnorePointer(
                  ignoring: isExpanded,
                  child: Opacity(
                    opacity: collapsedOpacity,
                    child: collapsedBoxed,
                  ),
                ),
              ),

              Positioned(
                top: 0, left: 0, right: 0, bottom: null,
                child: IgnorePointer(
                  ignoring: isCollapsed,
                  child: Opacity(
                    opacity: expandedOpacity,
                    child: expandedBoxed,
                  ),
                ),
              ),

            ],),
          );
        },
      );
    });
  }
}



