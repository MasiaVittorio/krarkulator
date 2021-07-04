import 'package:krarkulator/everything.dart';


class BodyCollapsedElement extends StatelessWidget {
  const BodyCollapsedElement({ 
    required this.child,
    required this.title,
    required this.width,
    required this.page,
    Key? key,
  }): super(key: key);

  final Widget child;
  final String title;
  final double width;
  final KrPage page;


  @override
  Widget build(context) {
    final stage = Stage.of<KrPage,dynamic>(context)!;
    final VoidCallback callback = () => stage.mainPagesController.goToPage(page);
    final style = DefaultTextStyle.of(context).style;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: SidereusScrollPhysics(
        alwaysScrollable: true,
        bottomBounce: true,
        topBounce: true,
        bottomBounceCallback: callback,
        topBounceCallback: callback,
      ),
      child: Container(
        width: width,
        child: Row(children: [
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
              child: Text(
                title,
                style: TextStyle(
                  color: RightContrast(Theme.of(context)).onCanvas,
                  fontWeight: style.fontWeight!.increment,
                ),
              ),
            ),
          ),
          Expanded(child: child),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_right),
          ),
        ],),
      ),
    );
  }
  
}

