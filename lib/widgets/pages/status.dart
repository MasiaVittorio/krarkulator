import 'package:krarkulator/everything.dart';
import 'resources/generic_collapsed.dart';

class StatusCollapsed extends StatelessWidget {

  const StatusCollapsed({required this.width, Key? key }) : super(key: key);
  final double width;

  @override
  Widget build(context) {
    return BodyCollapsedElement(
      page: KrPage.status,
      title: "Status",
      width: width,
      child: const SubSection(
        [Expanded(child: Center(child: Text("collapsed status"),),),], 
        mainAxisSize: MainAxisSize.max,
        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
      ),
    );
  }
  
}



class StatusExpanded extends StatelessWidget {
  const StatusExpanded({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SubSection([
      Expanded(child: Center(child: Text("status extended"),),),
    ], mainAxisSize: MainAxisSize.max, margin: const EdgeInsets.all(12),);
  }
}