import 'package:krarkulator/everything.dart';


class ManaPoolEditor extends StatelessWidget {

  const ManaPoolEditor({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      Expanded(child: Center(child: ColorSelector())),
      KrWidgets.height10,
      SubSection([
        ListTile(title: Text("As long as there's mana of a color, it will show up on the mana pool even if disabled"),),
      ],),
      KrWidgets.height10,
    ],);
  }
}

class ColorSelector extends StatelessWidget {

  const ColorSelector({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      child: logic.favColors.build((_, map) => Stack(children: [
          Positioned.fill(child: CircularLayout([
            for(final color in MtgColor.values)
              ColouredIconToggle(
                color: color.color, 
                icon: color.icon, 
                value: map[color] ?? false, 
                onChanged: (v){
                  logic.favColors.value[color] = v;
                  logic.favColors.refresh();
                }
              ),
          ]),),
          Center(child: ColouredIconToggle(
            // ignore: unnecessary_cast
            color: (null as MtgColor?).color, 
            // ignore: unnecessary_cast
            icon: (null as MtgColor?).icon, 
            value: map[null] ?? false, 
            onChanged: (v){
              logic.favColors.value[null] = v;
              logic.favColors.refresh();
            }
          ),),
        ],
      )),
    );
  }
}

class ColouredIconToggle extends StatelessWidget {

  const ColouredIconToggle({
    required this.color,
    required this.icon,

    required this.value,
    required this.onChanged,

    this.duration = const Duration(milliseconds: 300),
    this.size = 60,
    Key? key,
  }) : super(key: key);

  final Color color;
  final IconData icon;

  final bool value;
  final void Function(bool) onChanged;

  final Duration duration;

  final double size;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Material(
      animationDuration: duration,
      borderRadius: BorderRadius.circular(50),
      elevation: value ? 8 : 0,
      child: AnimatedContainer(
        duration: duration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color: value ? color : theme.scaffoldBackgroundColor,
          border: Border.all(
            width: value ? 0 : 1, 
            color: theme.colorScheme.onBackground
              .withOpacity(value ? 0.0 : 0.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          borderRadius: BorderRadius.circular(size),
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onChanged(!value),
            child: Container(
              height: size,
              width: size,
              alignment: Alignment.center,
              child: Icon(
                icon, 
                color: value ? color.contrast : theme.brightness.contrast,
              ),
            ),
          ),
        ),
      ),
    );
  }
}