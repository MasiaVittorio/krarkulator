import 'package:krarkulator/everything.dart';

class LastAction extends StatelessWidget {

  const LastAction({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    return StageSnackBar(
      title: logic.lastAction.build((_, val) => Text(val)),
    );
  }
}