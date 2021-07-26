import 'package:flutter/material.dart';


class KrWidgets {
  static const Widget verticalDivider = _VerticalDivider();
  
  static const Widget height3 = SizedBox(height: 3, width: 0,);
  static const Widget height5 = SizedBox(height: 5, width: 0,);
  static const Widget height7 = SizedBox(height: 7, width: 0,);
  static const Widget height10 = SizedBox(height: 10, width: 0,);
  static const Widget height15 = SizedBox(height: 15, width: 0,);
  static const Widget height20 = SizedBox(height: 20, width: 0,);
  static const Widget width5 = SizedBox(width: 5, height: 0,);
  static const Widget width10 = SizedBox(width: 10, height: 0,);
  static const Widget width15 = SizedBox(width: 15, height: 0,);
  static const Widget width20 = SizedBox(width: 20, height: 0,);

  static const Widget deleteIcon = Icon(
    Icons.delete_forever, 
    color: Color(0xFFE45356),
  );

  static const Widget divider = const Padding(
    padding: const EdgeInsets.symmetric(horizontal:16.0),
    child: const Divider(height: 2.0,),
  );

}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: 1.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}