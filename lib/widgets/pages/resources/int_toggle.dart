import 'package:krarkulator/everything.dart';


class IntToggle extends StatelessWidget {

  const IntToggle({
    required this.variable,
    required this.title,
    this.onlyReset = false,
    this.defaultVal = 0,
    Key? key ,
  }) : super(key: key);

  final BlocVar<int> variable;
  final String title;
  final bool onlyReset;
  final int defaultVal;

  @override
  Widget build(BuildContext context) {
    return variable.build((_, val) => ExtraButton(
      text: title,
      icon: null,
      customCircleColor: onlyReset ? null : Colors.transparent,
      customIcon: Text("$val"),
      onTap: onlyReset ? (){} : () => variable.set(val+1),
      onLongPress: () => variable.set(defaultVal),
    ));
  }
}