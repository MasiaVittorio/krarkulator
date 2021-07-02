import 'everything.dart';
import 'widgets/stage.dart';

void main() {
  runApp(Krarkulator());
}

class Krarkulator extends StatelessWidget {
  @override
  Widget build(BuildContext context) 
    => const MaterialApp(
      title: 'Krarkulator',
      home: const HomePage(),
    );
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Logic logic;

  @override
  void initState() {
    super.initState();
    logic = Logic();
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: logic,
      child: KrarkStage(),
    );
  }
}