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
  Widget build(context) => Row(children: [
    rotatedTitle(Theme.of(context)),
    Expanded(child: child),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(Icons.keyboard_arrow_right),
    ),
  ],);
  
  Widget rotatedTitle(ThemeData theme) => RotatedBox(
    quarterTurns: 3,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
      child: Text(
        title,
        style: TextStyle(
          color: RightContrast(theme).onCanvas,
          fontWeight: theme.textTheme.bodyText2!.fontWeight!.increment,
        ),
      ),
    ),
  );

}

