
import 'dart:math';

class ThumbTrigger {
  
  List<Flip> flips;

  ThumbTrigger(int howManyThumbs, Random rng): flips = [
    for(int i=0; i<pow(2,howManyThumbs); ++i)
      rng.nextBool() ? Flip.copy : Flip.bounce,
  ];

  bool get containsCopy => this.flips.contains(Flip.copy);
  bool get containsBounce => this.flips.contains(Flip.bounce);

}

enum Flip {bounce, copy}
