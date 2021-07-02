
/// Mana burst spells cost X and give Y
class Spell {
  final int cost;
  final int product;
  
  final double chance; ///spells that not always resolve 
  
  const Spell(this.cost, this.product, this.chance);
}



enum Zone {
  hand,
  graveyard,
  stack,
}