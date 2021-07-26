import 'package:krarkulator/data/widgets.dart';
import 'package:krarkulator/everything.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel ({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PanelTitle("Info"),
        SubSection([
          ListTile(
            title: Text("Licenses & legal info"),
          ),
          ListTile(
            title: Text("Developer"),
          ),
          ListTile(
            title: Text("CounterSpell"),
          ),
        ]),

        KrWidgets.height10,

        SubSection([
          ListTile(
            title: Text("Key engine cards"),
          ),
        ]),

        KrWidgets.height10,

        // TODO: this page

        ExtraButtons(children: [
          ExtraButton(
            onTap: (){},
            icon: McIcons.discord,
            text: "Discord",
          ),
          ExtraButton(
            onTap: (){},
            icon: McIcons.telegram,
            text: "Telegram",
          ),
          ExtraButton(
            onTap: (){},
            icon: McIcons.gmail,
            text: "E-mail",
          ),
        ]),

        KrWidgets.height10,

        Text(
          '"Double or Nothing."',
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}