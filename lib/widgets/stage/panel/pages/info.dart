import 'package:krarkulator/data/widgets.dart';
import 'package:krarkulator/everything.dart';
import 'dart:math';

class InfoPanel extends StatelessWidget {
  
  const InfoPanel ({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final query = MediaQuery.of(context);
      
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PanelTitle("Info"),
        SubSection([
          ExtraButtons(children: [
            ExtraButton(
              icon: McIcons.text_box_check_outline,
              text: "Licenses",
              onTap: () => stage.showAlert(
                const LicensesAlert(), 
                size: 450,
              ),
              customCircleColor: Colors.transparent,
            ),
            // MAYBE: something about the developer??
            ExtraButton(
              icon: KrIcons.counterSpell,
              text: "CounterSpell",
              onTap: KRActions.reviewCounterSpell,
              customCircleColor: Colors.transparent,
            ),
          ],),
        ]),

        KrWidgets.height10,

        SubSection([
          ListTile(
            leading: Icon(McIcons.cards_outline),
            title: Text("Key engine cards"),
            onTap: () => stage.showAlert(
              KeyCardsAlert(query.size.width),
              size: 414,
            ),
          ),
        ]),

        KrWidgets.height10,

        SubSection([
          ListTile(
            // TODO: check this icon
            leading: Icon(McIcons.youtube),
            title: Text("Video tutorial"),
            onTap: KRActions.openVideoTutorial,
          ),
        ]),

        KrWidgets.height10,

        ExtraButtons(children: [
          ExtraButton(
            onTap: KRActions.openDiscordInvite,
            icon: McIcons.discord,
            text: "Discord",
          ),
          ExtraButton(
            onTap: KRActions.chatWithMe,
            icon: McIcons.telegram,
            text: "Telegram",
          ),
          ExtraButton(
            onTap: KRActions.mailMe,
            icon: McIcons.gmail,
            text: "E-mail",
          ),
        ]),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            Random(DateTime.now().millisecondsSinceEpoch).nextBool()
              ? '"Double or Nothing."'
              : "I suck at playing Krark, but I'm good at coding.\nWhich means...\nI'm actually really good at playing Krark.",
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}