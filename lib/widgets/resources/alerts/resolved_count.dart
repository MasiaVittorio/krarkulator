import 'package:krarkulator/everything.dart';


class ResolvedCountAlert extends StatelessWidget {

  const ResolvedCountAlert({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final logic = Logic.of(context);

    return logic.resolvedCount.build((_, map) => HeaderedAlert(
      "Resolved Count", 
      bottom: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SubSection([
          ListTile(
            leading: const Icon(Icons.clear_all),
            title: const Text("Clear all"),
            onTap: (){
              logic.resolvedCount.value.clear();
              logic.resolvedCount.refresh();
            },
          ),
        ]),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(final e in map.entries)
            ListTile(
              title: Text(e.key),
              trailing: Text(
                e.value.toString(),
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: (){
                  logic.resolvedCount.value.remove(e.key);
                  logic.resolvedCount.refresh();
                },
              ),
            ),
        ],
      )));
  }
}