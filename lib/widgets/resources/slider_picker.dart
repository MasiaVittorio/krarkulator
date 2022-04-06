// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/rendering.dart';
import 'package:krarkulator/everything.dart';

class SliderPicker extends StatelessWidget {

  final List<Widget> children;
  final void Function(int) onSelected;
  final int selectedIndex;
  final double itemExtent;
  final ScrollController intScrollController;
  final int visibleItems;
  final double width;

  SliderPicker({
    required this.children,
    required this.onSelected,
    required this.selectedIndex,
    this.itemExtent = 56.0,
    this.visibleItems = 3,
    this.width = 150,
    Key? key
  }): intScrollController = ScrollController(
        initialScrollOffset: selectedIndex * itemExtent,
      ), 
      super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    TextStyle defaultStyle = themeData.textTheme.bodyText2!;
    TextStyle selectedStyle = themeData.textTheme.headline5!.copyWith(
      color: RightContrast(themeData).onCanvas,
    );

    var listItemCount = children.length + 2;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        
        if (intScrollController.position.activity is HoldScrollActivity) {
          animateToIndex(selectedIndex);
        }
      },
      child: NotificationListener(
        child: SizedBox(
          height: itemExtent * visibleItems,
          width: width,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: intScrollController,
            itemExtent: itemExtent,
            itemCount: listItemCount,
            // cacheExtent: _calculateCacheExtent(listItemCount),
            itemBuilder: (BuildContext context, int index) {
              final int value = _intValueFromIndex(index);

              //define special style for selected (middle) element
              final TextStyle itemStyle = value == selectedIndex
                ? selectedStyle
                : defaultStyle;

              bool isExtra = index == 0 || index == listItemCount - 1;

              return isExtra
                ? Container() //empty first and last element
                : Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => animateToIndex(value),
                    child: DefaultTextStyle.merge(
                        style: itemStyle,
                        child:Center(
                          child: children[value],
                        )
                      ),
                  ),
                );
            },
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  int _intValueFromIndex(int index) {
    index--;
    index %= children.length;
    return index;
  }

  /// Used to animate integer number picker to new selected index
  void animateToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(value,
      duration: const Duration(milliseconds: 250), curve: Curves.easeInOut
    );
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
    Notification notification,
    ScrollController scrollController,
  ) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement = (
        notification.metrics.pixels / itemExtent
      ).round();

      intIndexOfMiddleElement = intIndexOfMiddleElement.clamp(0, children.length - 1);

      // int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement + 1);
      // intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intIndexOfMiddleElement != selectedIndex) {
        onSelected(intIndexOfMiddleElement);
      }
    }
    return true;
  }
}