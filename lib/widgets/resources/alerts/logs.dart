import 'package:krarkulator/everything.dart';


class LogsAlert extends StatelessWidget {

  const LogsAlert({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Logic.of(context).logs;
    return HeaderedAlert(
      "Log", 
      alreadyScrollableChild: true,
      canvasBackground: true,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0.5),
          child: Text(data[i], maxLines: 1,),
        ),
      ),
    );
  }
}