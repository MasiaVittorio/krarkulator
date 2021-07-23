import 'package:krarkulator/everything.dart';
// TODO: absolutely the triggers


class TriggersView extends StatelessWidget {
  const TriggersView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SubSection([
      Expanded(child: Center(child: Text("big")),),
    ], mainAxisSize: MainAxisSize.max, margin: const EdgeInsets.all(12),);
  }
}
