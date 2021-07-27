import 'package:krarkulator/everything.dart';

class ImageAlert extends StatelessWidget {

  final ImageProvider image;

  static const mtgAspectRatio = 63/88;

  const ImageAlert(this.image);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: Stage.of(context)!.panelController.panelScrollPhysics(),
      child: AspectRatio(
        aspectRatio: mtgAspectRatio,
        child: Container(
          color: Colors.black,
          child: Image(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}