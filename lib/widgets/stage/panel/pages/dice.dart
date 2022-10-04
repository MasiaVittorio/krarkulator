import 'dart:math';

import 'package:krarkulator/everything.dart';


class RandomPanel extends StatefulWidget {

  const RandomPanel({
    Key? key,
  }): super(key: key);

  @override
  State<RandomPanel> createState() => _RandomPanelState();
}

enum _Type {
  coin,
  d6,
  d20,
}

class _RandomPanelState extends State<RandomPanel> with SingleTickerProviderStateMixin { 

  //================================
  // State
  int? result;
  _Type type = _Type.coin;
  late AnimationController controller;
  final Random random = Random(DateTime.now().millisecondsSinceEpoch);

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      vsync: this,
      value: 1.0,
      upperBound: 10.0,
      lowerBound: 0.0,
    );
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  //================================
  // Logic

  /// animates the roll
  void bounce() => controller
    .animateTo(
      0.7, 
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 250),
    )
    .then((_){
      controller.animateTo(
        1.0, 
        curve: Curves.easeInBack.flipped,
        duration: const Duration(milliseconds: 250),
      );
    });

  /// extracts a new random number
  void roll(){
    setState((){
      if(type == _Type.coin){
        result = random.nextInt(2);
        //0 = tails / 1 = heads
      } else if (type == _Type.d6){
        result = random.nextInt(6) + 1;
      } else if(type == _Type.d20){
        result = random.nextInt(20) + 1;
      }
    });
    bounce();
  }


  //================================
  // UI
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return Column(children: <Widget>[
      const PanelTitle("Dice rolls"),

      // Roll result, tap to roll a new one
      Expanded(child: SubSection(<Widget>[
        Expanded(child: Center(
          child: ScaleTransition(
            scale: controller,
            child: Text(
              result == null ? "-" : 
                type == _Type.coin 
                  ? (result == 0 ? "Tails" : "Heads")
                  : "$result", 
              style: theme.textTheme.headline4,
            ),
          ),
        ),),
      ], onTap: roll,),),

      // Select the desired dice (d6, d10, d20)
      RadioSliderOf<_Type>(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        // ignore: unnecessary_this
        onSelect: (t) => this.setState((){
          type = t;
          result = null;
        }),
        selectedItem: type,
        items: const <_Type,RadioSliderItem>{
          _Type.coin : RadioSliderItem(
            icon: Icon(Icons.check_circle),
            title: Text("coin"),
          ),
          _Type.d6 : RadioSliderItem(
            icon: Icon(McIcons.dice_6),
            title: Text("d6"),
          ),
          _Type.d20 : RadioSliderItem(
            icon: Icon(McIcons.dice_d20),
            title: Text("d20"),
          ),
        }
      ),

    ].separateWith(const SizedBox(height: 15,), alsoLast: true),);
  }

}