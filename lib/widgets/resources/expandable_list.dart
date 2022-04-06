import 'package:flutter/material.dart';
import 'package:sid_ui/sid_ui.dart';

class ExpandableItem {
  final Widget expandedChild;
  final Widget collapsedChild;

  final double collapsedSize;

  const ExpandableItem({
    required this.expandedChild,
    required this.collapsedChild,
    required this.collapsedSize,
  });
}


class ExpandableList extends StatefulWidget {

  const ExpandableList(this.items, {
    this.initialIndex = 0,
    Key? key,
  }): super(key: key);

  final List<ExpandableItem> items;
  final int initialIndex;

  @override
  State<ExpandableList> createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {

  late int index;

  @override
  void initState() {
    super.initState();
    assert(widget.initialIndex >=0); 
    assert(widget.initialIndex < widget.items.length || widget.items.isEmpty);
    index = widget.initialIndex;
  }

  static const padding = 12.0;

  @override
  Widget build(BuildContext context) {
    if(widget.items.isEmpty) return Container();

    final items = widget.items;

    return LayoutBuilder(builder: (_, BoxConstraints constraints){
      final h = constraints.maxHeight;
      final minSpaces = [
        for(int i=0; i<items.length; ++i)
          items[i].collapsedSize + padding + (i==0 ? padding : 0),
      ];

      final occupied = minSpaces.reduce((v, e) => v+e);

      final maxSpaces = [
        for(int i=0; i<items.length; ++i)
          h - occupied + minSpaces[i],
      ];

      const totalFlex = 100000000;

      final minFlexes = [
        for(int i=0; i<items.length; i++)
          ((minSpaces[i] / h) * totalFlex).round(),
      ];

      final maxFlexes = [
        for(int i=0; i<items.length; i++)
          ((maxSpaces[i] / h) * totalFlex).round(),
      ];


      return ConstrainedBox(
        constraints: constraints,
        child: AnimatedExpandeds(
          children: [
            for(int i=0; i < items.length; ++i)
              EasyCrossFade(
                collapsed: items[i].collapsedChild, 
                extended: items[i].expandedChild, 
                showFirst: index != i, 
                collapsedSize: minSpaces[i], 
                extendedSize: maxSpaces[i],
                onTapCollapsed: () => setState(() {
                  index = i;
                }),
                // better calculate size with paddings
                extendedPadding: i == 0 
                  ? const EdgeInsets.all(padding) 
                  : const EdgeInsets.only(
                    left: padding, right: padding, bottom: padding,
                  ),
                collapsedPadding: i == 0 
                  ? const EdgeInsets.symmetric(vertical: padding) 
                  : const EdgeInsets.only(
                    bottom: padding,
                  ),
              ),
          ], 
          flexesCollapsed: minFlexes, 
          flexesExpanded: maxFlexes, 
          index: index,
        ),
      );
    });
  }
}


class EasyCrossFade extends StatelessWidget {

  const EasyCrossFade({
    required this.collapsed,
    required this.extended,
    required this.showFirst,
    required this.collapsedSize,
    required this.extendedSize,
    required this.extendedPadding,
    required this.onTapCollapsed,
    required this.collapsedPadding,
    Key? key,
  }) : super(key: key);

  final Widget collapsed;
  final Widget extended;
  final bool showFirst;
  final double collapsedSize; 
  final double extendedSize;
  final EdgeInsets extendedPadding;
  final EdgeInsets collapsedPadding;
  final VoidCallback onTapCollapsed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: showFirst ? collapsedPadding : extendedPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(showFirst ? 0.0 : 10.0),
        color: showFirst 
          ? theme.canvasColor 
          : theme.scaffoldBackgroundColor.withOpacity(0.8),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox.expand(
          child: Stack(children: [
            Positioned(
              top: 0, right: 0, left: 0,
              height: collapsedSize 
                  - collapsedPadding.top 
                  - collapsedPadding.bottom,
              child: IgnorePointer(
                ignoring: !showFirst,
                child: InkWell(
                  onTap: showFirst ? onTapCollapsed : null,
                  child: AnimatedOpacity(
                    opacity: showFirst ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: collapsed,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0, right: 0, left: 0,
              height: extendedSize
                  - extendedPadding.top
                  - extendedPadding.bottom,
              child: IgnorePointer(
                ignoring: showFirst,
                child: AnimatedOpacity(
                  opacity: !showFirst ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: extended,
                ),
              ),
            ),
          ],),
        ),
      ),
    );
      
  }
}


class AnimatedExpandeds extends StatelessWidget {

  const AnimatedExpandeds({
    required this.children,
    required this.flexesCollapsed,
    required this.flexesExpanded,
    required this.index,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;
  final List<int> flexesCollapsed;
  final List<int> flexesExpanded;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedDouble(
      value: index.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      builder: (_, value) => Column(children: [
        for(int i=0; i<children.length; i++)
          Expanded(
            flex: (value - i).abs().clamp(0, 1).mapToRange(
              flexesExpanded[i].toDouble(), 
              flexesCollapsed[i].toDouble(),
            ).round(),
            child: children[i],
          ),
      ],),
    );
  }
}


