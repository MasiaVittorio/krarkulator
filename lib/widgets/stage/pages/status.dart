import 'package:krarkulator/everything.dart';
import 'package:krarkulator/widgets/stage/pages/resources/all.dart';

class StatusCollapsed extends StatelessWidget {
  const StatusCollapsed({required this.width, Key? key}) : super(key: key);
  final double width;

  @override
  Widget build(context) => BodyCollapsedElement(
        page: KrPage.status,
        title: "Status",
        width: width,
        child: const SubSection(
          [
            Expanded(
              child: _CollapsedBody(),
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          margin: padding3Collapsed,
        ),
      );
  // MAYBE: highlight mana if can't cast for missing mana and so on

}

class _CollapsedBody extends StatelessWidget {
  const _CollapsedBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    return ExtraButtons(
      children: [
        IntToggle(variable: logic.mana, title: "Mana\npool"),
        IntToggle(variable: logic.treasures, title: "Treasures"),
        const ZoneEditor(),
      ],
      margin: EdgeInsets.zero,
    );
  }
}

class StatusExpanded extends StatelessWidget {
  const StatusExpanded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    return SubSection(
      [
        Expanded(child: _CollapsedBody()),
        ExtraButtons(children: [
          IntToggle(variable: logic.storm, title: "Storm"),
          IntToggle(variable: logic.resolved, title: "Resolved"),
        ]),
      ],
      margin: padding3Expanded,
      mainAxisSize: MainAxisSize.max,
    );
  }
}
