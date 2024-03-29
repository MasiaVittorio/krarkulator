import 'package:krarkulator/everything.dart';


class LicensesAlert extends StatelessWidget {
  const LicensesAlert({Key? key}) : super(key: key);

  static showText(StageData stage, String text, String title)=> stage.showAlert(
    HeaderedAlert('"$title" Package', 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(text),
      ), 
    ), 
    size: 400.0
  );

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;

    return HeaderedAlert(
      "Licenses & source code", 

      bottom: ListTile(
        title: const Text("View source code"),
        leading: const Icon(McIcons.github),
        trailing: const FlutterLogo(size: 30),
        onTap: () => stage.showAlert(const ConfirmAlert(
          warningText: "You'll be redirected to your browser on Krarkulator's  github page",
          twoLinesWarning: true,
          action: KRActions.githubPage,
          confirmIcon: Icons.exit_to_app,
          cancelColor: KRColors.delete,
        ), size: ConfirmAlert.twoLinesheight),
      ),

      child: Column(children: <Widget>[
        
        const Section([
          SectionTitle("Disclaimer"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Text(CSLicenses.wizardFanContentPolicy),
          ),
        ]),
        
        const Section([
          SectionTitle("Images"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Text(CSLicenses.scryfallImagePolicy),
          ),
        ]),

        const Section(<Widget>[
          SectionTitle("Icons"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Text(CSLicenses.iconsLicenses),
          ),
        ]),


        Section([
          const SectionTitle("Flutter Packages"),
          ListTile(
            title: const Text('cached_network_image'),
            subtitle: const Text('Used under: MIT License'),
            onTap: () => showText(stage, CSLicenses.mit, "cached_network_image"),
          ),
          // ListTile(
          //   title: const Text('division'),
          //   subtitle: const Text('Used under: MIT License'),
          //   onTap: () => showText(stage, CSLicenses.mit, "division"),
          // ),
          // ListTile(
          //   title: const Text('flutter_reorderable_list'),
          //   subtitle: const Text('Used under: BSD License'),
          //   onTap: () => showText(stage, CSLicenses.bsd, "flutter_reorderable_list"),
          // ),
          // ListTile(
          //   title: const Text('hive'),
          //   subtitle: const Text('Used under: Apache 2.0 License'),
          //   onTap: () => showText(stage, CSLicenses.apache2, "hive"),
          // ),
          // ListTile(
          //   title: const Text('http'),
          //   subtitle: const Text('Used under: BSD License'),
          //   onTap: () => showText(stage, CSLicenses.bsd, "http"),
          // ),
          // ListTile(
          //   title: const Text('in_app_purchase'),
          //   subtitle: const Text('Used under: BSD License'),
          //   onTap: () => showText(stage, CSLicenses.bsd, "in_app_purchase"),
          // ),
          ListTile(
            title: const Text('path_provider'),
            subtitle: const Text('Used under: BSD License'),
            onTap: () => showText(stage, CSLicenses.bsd, "path_provider"),
          ),
          ListTile(
            title: const Text('rxdart'),
            subtitle: const Text('Used under: Apache 2.0 License'),
            onTap: () => showText(stage, CSLicenses.apache2, "rxdart"),
          ),
          // ListTile(
          //   title: const Text('screen'),
          //   subtitle: const Text('Used under: MIT License'),
          //   onTap: () => showText(stage, CSLicenses.mit, "screen"),
          // ),
          ListTile(
            title: const Text('sqflite'),
            subtitle: const Text('Used under: MIT License'),
            onTap: () => showText(stage, CSLicenses.mit, "sqflite"),
          ),
          ListTile(
            title: const Text('url_launcher'),
            subtitle: const Text('Used under: BSD License'),
            onTap: () => showText(stage, CSLicenses.bsd, "url_launcher"),
          ),
          // ListTile(
          //   title: const Text('vibrate'),
          //   subtitle: const Text('Used under: MIT License'),
          //   onTap: () => showText(stage, CSLicenses.mit, "vibrate"),
          // ),
        ]),
      ],),
    );
  }
}


