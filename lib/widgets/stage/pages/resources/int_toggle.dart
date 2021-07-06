import 'package:krarkulator/everything.dart';


class IntToggle extends StatelessWidget {

  const IntToggle({
    required this.variable,
    required this.title,
    this.onlyReset = false,
    this.defaultVal = 0,
    this.noNeedToRebuild = false,
    Key? key ,
  }) : super(key: key);

  final BlocVar<int> variable;
  final String title;
  final bool onlyReset;
  final int defaultVal;
  final bool noNeedToRebuild;

  @override
  Widget build(BuildContext context) => noNeedToRebuild
    ? fromVal(context, variable.value) 
    : variable.build(fromVal);

  Widget fromVal(BuildContext _, int val) => ExtraButton(
    text: title,
    icon: null,
    customCircleColor: onlyReset ? null : Colors.transparent,
    customIcon: Text("$val"),
    onTap: onlyReset ? (){} : () => variable.set(val+1),
    onLongPress: () => variable.set(defaultVal),
    twoLines: title.contains("\n"),
  );
}