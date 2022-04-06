import 'package:krarkulator/everything.dart';


class ResetButton extends StatelessWidget {
  const ResetButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Logic.of(context);
    final stage = Stage.of(context)!;

    return stage.panelController.isMostlyOpened.build((_, opened) => AnimatedOpacity(
      opacity: opened ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.ease,
      child: IgnorePointer(
        ignoring: opened,
        child: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => stage.showAlert(
            ConfirmAlert(
              warningText: "Reset all values?",
              action: logic.reset,
              confirmIcon: Icons.refresh,
            ),
            size: ConfirmAlert.height
          ),
        ),
      ),
    ),);
  }
}