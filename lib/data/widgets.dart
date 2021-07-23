import 'package:flutter/material.dart';


class KrWidgets {
  static const Widget VerticalDivider = _VerticalDivider();
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