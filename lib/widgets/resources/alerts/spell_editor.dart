import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/all.dart';


class SpellEditor extends StatefulWidget {

  static const double height = 700;
  
  const SpellEditor({
    required this.onConfirm, 
    this.initialSpell,
    this.alreadySavedSpells = const {},
    Key? key,
  }) : super(key: key);

  final void Function(Spell) onConfirm;
  final Spell? initialSpell;
  final Set<String> alreadySavedSpells;

  @override
  State<SpellEditor> createState() => _SpellEditorState();
}

class _SpellEditorState extends State<SpellEditor> {

  late TextEditingController nameCtrlr;
  late Map<MtgColor?,int> manaCost;
  late Map<MtgColor?,int> manaProduct;
  late int treasuresProduct;
  late Map<BoardElement,int> boardProduct;
  late bool storm;

  @override
  void initState() {
    super.initState();
    nameCtrlr = TextEditingController(
      text: widget.initialSpell?.name,
    );
    nameCtrlr.addListener(() => setState(() {}));
    manaCost = {...(widget.initialSpell?.manaCost ?? {})};
    manaProduct = {...(widget.initialSpell?.manaProduct ?? {})};
    treasuresProduct = widget.initialSpell?.treasuresProduct ?? 0;
    boardProduct = {...(widget.initialSpell?.boardProduct ?? {})};
    storm = widget.initialSpell?.storm ?? false;
  }

  @override
  void dispose() {
    manaCost.clear();
    manaProduct.clear();
    boardProduct.clear();
    nameCtrlr.dispose();
    super.dispose();
  }

  Spell? get spell => nameCtrlr.text.isEmpty 
    ? null
    : Spell(
      nameCtrlr.text,
      {...manaCost},
      {...manaProduct},
      boardProduct: {...boardProduct},
      treasuresProduct: treasuresProduct,
      storm: storm,
    );
  
  bool get wouldOverride 
    => nameCtrlr.text.isNotEmpty 
    && widget.alreadySavedSpells.contains(nameCtrlr.text);
  
  bool get wouldSave 
    => nameCtrlr.text.isNotEmpty 
    && !widget.alreadySavedSpells.contains(nameCtrlr.text);

  bool get someElementMissing {
    for(final e in BoardElement.values)
      if(!boardProduct.containsKey(e))
        return true;
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      wouldOverride 
        ? "Edit spell" 
        : "New spell", 
      customBackground: (theme) => theme.canvasColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          manaCostEditor,
          KrWidgets.height5,
          stormEditor,
          KrWidgets.height5,
          manaProductEditor,
          KrWidgets.height5,
          treasures,
          KrWidgets.height5,
          SubSection([
            const SectionTitle("Other products"),
            ...board,
            if(boardProduct.isNotEmpty && someElementMissing) KrWidgets.divider,
            if(someElementMissing) newBoardElement,
          ]),
          KrWidgets.height15,
        ],
      ),
      bottom: bottom,
    );
  }

  Widget get bottom => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
          const SectionTitle("Spell name"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              textAlign: TextAlign.center,
              controller: nameCtrlr,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(inherit:true, fontSize: 18.0),
              decoration: const InputDecoration(
                hintText: "Type a name here",
              ),
            ),
          ),
          KrWidgets.height10,
          SubSection([
            ListTile(
              leading: const Icon(Icons.check),
              title: Text(
                wouldOverride ? "Update" : wouldSave ? "Save" : "Insert a name",
                style: TextStyle(
                  color: wouldOverride || wouldSave ? null : KRColors.delete,
                ),
              ),
              onTap: wouldOverride || wouldSave 
                ? (){
                  widget.onConfirm(spell!);
                  Stage.of(context)!.closePanel();
                }
                : null,
              enabled: wouldOverride || wouldSave,
            ),
          ]),
      ],
    ),
  );

  Widget get newBoardElement => SizedBox(
    height: 58,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      children: <Widget>[
        for(final e in BoardElement.values)
          if(!boardProduct.keys.contains(e))
            BoardElementChip(e, onTap: () => setState(() {
              boardProduct[e] = 1;      
            }))
      ].separateWith(KrWidgets.width10),
    ),
  );

  Widget get nameEditor => Container();

  Widget get treasures => ListTile(
    title: Text("Treasures: $treasuresProduct"),
    trailing: IconButton(
      onPressed: () => setState(() {
        treasuresProduct = 0;
      }), 
      icon: const Icon(Icons.restart_alt_outlined),
    ),
    leading: const Icon(McIcons.treasure_chest),
    onTap: () => setState(() {
      treasuresProduct++;
    }),
    onLongPress: () => setState(() {
      treasuresProduct = 0;
    }),
  );

  List<Widget> get board => [
    for(final e in boardProduct.keys)
      BoardElementEditor(
        e, 
        val: boardProduct[e]!, 
        onNewVal: (newVal) => setState(() {
          boardProduct[e] = newVal;
        }), 
        onRemove: () => setState(() {
          boardProduct.remove(e);
        }),
      ),
  ]; 

  Widget get stormEditor => SwitchListTile(
    title: const Text("Storm"),
    secondary: const Icon(ManaIcons.instant),
    value: storm, 
    onChanged: (v) => setState(() {
      storm = v;
    }),
  );

  Widget get manaCostEditor => ManaCostEditor(
    manaCost, 
    title: "Mana Cost", 
    onAdd: (c, v) => setState(() {
      manaCost[c] = (manaCost[c] ?? 0) + v;
    }),
  );

  Widget get manaProductEditor => ManaCostEditor(
    manaProduct, 
    title: "Mana Product", 
    right: false,
    onAdd: (c, v) => setState(() {
      manaProduct[c] = (manaProduct[c] ?? 0) + v;
    }),
  );

}

class BoardElementChip extends StatelessWidget {

  const BoardElementChip(this.element, {
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final BoardElement element;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5000),
            border: Border.all(
              color: theme.brightness.contrast.withOpacity(0.4),
              width: 1,
            ),
            color: theme.canvasColor,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "+${element.name}",
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class BoardElementEditor extends StatelessWidget {

  static const double height = 56;

  const BoardElementEditor(this.element, {
    required this.val,
    required this.onNewVal,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  final BoardElement element;
  final int val;
  final void Function(int) onNewVal;
  final VoidCallback onRemove;

  bool get fixedNumber => val >= 0;

  bool get doubling => val == -1;

  void toggleMode(){
    if(fixedNumber){
      onNewVal(-1);
    } else {
      onNewVal(1);
    }
  }

  void plus(){
    assert(fixedNumber);
    onNewVal(val + 1);
  }
  void minus(){
    assert(fixedNumber);
    onNewVal(val - 1);
  }
  void reset(){
    assert(fixedNumber);
    onNewVal(0);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTile(
      height: 64,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: modeToggle(Theme.of(context)),
      ),
      title: Text(
        doubling 
          ? "Double ${element.plural}"
          : val != 1 
            ? "$val ${element.plural} copies" 
            : "$val ${element.singular} copy", 
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: remove,
      ),
      onTap: doubling ? null : plus,
      onLongPress: doubling ? null : reset,
    );
  }

  Widget get remove => IconButton(
    onPressed: onRemove, 
    icon: KrWidgets.deleteIcon,
  );


  Widget modeToggle(ThemeData theme) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(64),
      image: DecorationImage(
        image: AssetImage(element.art),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          theme.canvasColor.withOpacity(0.5), 
          BlendMode.srcOver,
        ),
      )
    ),
    child: IconButton(
      onPressed: toggleMode, 
      icon: Text(
        doubling ? "x2" : "#",
        style: TextStyle(color: theme.brightness.contrast),
      ),
    ),
  );

}

class ManaCostEditor extends StatelessWidget {

  const ManaCostEditor(this.cost, {
    required this.title,
    required this.onAdd,
    this.right = true,
    Key? key,
  }) : super(key: key);

  final String title;

  final bool right;

  final Map<MtgColor?, int> cost;

  final void Function(MtgColor?, int) onAdd;

  @override
  Widget build(BuildContext context) {
    return SubSection([
      SectionTitle(title),
      SizedBox(
        height: 50,
        child: Center(child: cost.hasSomething 
          ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: right,
              child: cost.costWidget(
                size: 30,
                onTap: (c) => onAdd(c, -1),
              ),
            ),
          )
          : const Text(
            "Empty", 
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      KrWidgets.divider,
      SizedBox(
        height: addH,
        child: Row(children: [
          for(final c in [
            MtgColor.w, MtgColor.u, MtgColor.b,
            MtgColor.r, MtgColor.g, null,
          ])
            Expanded(child: InkWell(
              onTap: () => onAdd(c, 1),
              child: Container(
                width: double.infinity,
                height: addH,
                alignment: Alignment.center,
                child: Icon(c.icon, size: 20,),
              ),
            ),),
        ],),
      ),
    ]);
  }

  static const double addH = 42;
}