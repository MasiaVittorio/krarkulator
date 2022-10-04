import 'everything.dart';
import 'widgets/stage.dart';

void main() {
  runApp(const Krarkulator());
}

class Krarkulator extends StatelessWidget {

  const Krarkulator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
    => const MaterialApp(
      title: 'Krarkulator',
      home: HomePage(),
    );
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
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
      child: const KrarkStage(),
    );
  }
}