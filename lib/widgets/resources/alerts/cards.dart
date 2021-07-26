import 'package:krarkulator/everything.dart';

class KeyCardsAlert extends StatelessWidget {

  const KeyCardsAlert(this.screenWidth, {Key? key}) : super(key: key);

  final double screenWidth;

  static const _dir = "assets/images/";
  static const _dirCards = _dir + "cards/";
  static const _dirArts = _dir + "arts/";
  static const cards = <String,ImageProvider>{
    "Birgi, God of Storytelling": AssetImage(_dirCards + "Birgi_God_of_Storytelling.jpg"),
    "Bonus Round": AssetImage(_dirCards + "Bonus_Round.jpg"),
    "Harmonic Prodigy": AssetImage(_dirCards + "Harmonic_Prodigy.jpg"),
    "Krark, the Thumbless": AssetImage(_dirCards + "Krark_the_Thumbless.jpg"),
    "Krark's Thumb": AssetImage(_dirCards + "Krarks_Thumb.jpg"),
    "Sakashima of a Thousand Faces": AssetImage(_dirCards + "Sakashima_of_a_Thousand_Faces.jpg"),
    "Storm Kiln Artist": AssetImage(_dirCards + "Storm_Kiln_Artist.jpg"),
    "Tavern Scoundrel": AssetImage(_dirCards + "Tavern_Scoundrel.jpg"),
    "Veyran, Voice of Duality": AssetImage(_dirCards + "Veyran_Voice_of_Duality.jpg"),
  };
  static const arts = <String,ImageProvider>{
    "Birgi, God of Storytelling": AssetImage(_dirArts + "Birgi_God_of_Storytelling.jpg"),
    "Bonus Round": AssetImage(_dirArts + "Bonus_Round.jpg"),
    "Harmonic Prodigy": AssetImage(_dirArts + "Harmonic_Prodigy.jpg"),
    "Krark, the Thumbless": AssetImage(_dirArts + "Krark_the_Thumbless.jpg"),
    "Krark's Thumb": AssetImage(_dirArts + "Krarks_Thumb.jpg"),
    "Sakashima of a Thousand Faces": AssetImage(_dirArts + "Sakashima_of_a_Thousand_Faces.jpg"),
    "Storm Kiln Artist": AssetImage(_dirArts + "Storm_Kiln_Artist.jpg"),
    "Tavern Scoundrel": AssetImage(_dirArts + "Tavern_Scoundrel.jpg"),
    "Veyran, Voice of Duality": AssetImage(_dirArts + "Veyran_Voice_of_Duality.jpg"),
  }; 
  static const subtitles = <String,String>{
    "Harmonic Prodigy": "Equivalent to veyran",
  };


  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    

    return HeaderedAlert("Key mentioned cards", child: stage
      .dimensionsController.dimensions.build((_, dim) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(final e in cards.entries)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: arts[e.key],
              ),
              title: Text(e.key),
              subtitle: subtitles[e.key] != null ? Text(subtitles[e.key]!) : null,
              onTap: () => stage.showAlert(
                ImageAlert(e.value),
                size: (screenWidth - dim.panelHorizontalPaddingOpened*2)
                  / ImageAlert.mtgAspectRatio,
              ),
            ),
        ],
      )),
    );
  }
}