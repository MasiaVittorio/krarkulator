
import 'dart:math';

class ThumbTrigger {
  
  List<Flip> flips;

  ThumbTrigger(int howManyThumbs, Random rng): flips = [
    for(int i=0; i<pow(2,howManyThumbs); ++i)
      (rng.nextInt(2) == 0) ? Flip.copy : Flip.bounce,
      /// nextInt(2) gives either 0 or 1, so this flips a coin
  ];

  bool get containsCopy => this.flips.contains(Flip.copy);
  bool get containsBounce => this.flips.contains(Flip.bounce);

}

enum Flip {bounce, copy}
