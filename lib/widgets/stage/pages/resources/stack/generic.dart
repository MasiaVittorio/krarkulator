import 'package:krarkulator/everything.dart';

class CardUI extends StatelessWidget {

  const CardUI({
    required this.title,
    required this.subTitle,
    required this.indexPlusOne,
    required this.outOf,
    required this.children,
    this.artistCredit,
    this.image,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final int? indexPlusOne;
  final int? outOf;
  final List<Widget> children;
  final Image? image;
  final String? artistCredit;

  static const p = 12.0;
  static const pp = 20.0;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final bkg = SubSection.getColor(theme);
    final rounded = BoxDecoration(
      color: bkg, 
      border: Border.all(color: theme.colorScheme.onBackground),
      borderRadius: BorderRadius.circular(8) ,
    );

    return LayoutBuilder(builder: (_, c) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: p, left: p, right: p),
          child: name(rounded),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: pp),
            child: art(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: p),
          child: typeline(rounded),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: c.maxHeight * (image == null ? 0.50 : 0.35),
          ),
          child: textBox(),
        ),
        if((indexPlusOne != null && outOf != null) || artistCredit != null)
          Padding(
            padding: const EdgeInsets.all(p),
            child: Row(children: [
              if(artistCredit != null)
                ...[
                  const Icon(ManaIcons.artist_nib, size: 18,),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      artistCredit!, 
                      style: const TextStyle(fontSize: 13),
                    ),
                  )
                ],
              const Spacer(),
              if((indexPlusOne != null && outOf != null))
                ptBox(rounded),
            ],),
          ),
      ],
    ),);
  }

  Widget name(BoxDecoration decoration) => Container(
    decoration: decoration,
    height: 36,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Text(title),
  );

  Widget art() => image ?? const SizedBox.expand();

  Widget typeline(BoxDecoration decoration) => Container(
    decoration: decoration,
    height: 36,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Text(subTitle),
  );

  Widget textBox() => Container(
    alignment: Alignment.centerLeft,
    child: SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),),
  );

  Widget ptBox(BoxDecoration decoration) => Container(
    decoration: decoration,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Text("$indexPlusOne / $outOf"),
  );

}
