import 'package:krarkulator/everything.dart';

extension KrLogicSolveSpell on Logic {

  void solveSpell(){

    resolved.value++;
    onNextRefreshTotalResolved();

    /// resolve
    if(spell.value.chance == 1.0 || rng.nextDouble() < spell.value.chance){
      
      if(spell.value.manaProduct != 0){
        mana.value += spell.value.manaProduct;
        onNextRefreshMana();
      }
      if(spell.value.artistsProduced > 0){
        artists.value += spell.value.artistsProduced;
        onNextRefreshArtists();
      }
      if(spell.value.krarksProduced > 0){
        krarks.value += spell.value.krarksProduced;
        onNextRefreshKrarks();
      }
      if(spell.value.scoundrelProduced > 0){
        scoundrels.value += spell.value.scoundrelProduced;
        onNextRefreshScoundrels();
      }
      if(spell.value.treasuresProduct > 0){
        treasures.value += spell.value.treasuresProduct;
        onNextRefreshTreasures();
      }
      if(spell.value.veyransProduced > 0){
        veyrans.value += spell.value.veyransProduced;
        onNextRefreshVeyrans();
      }
      if(spell.value.thumbsProduced > 0){
        thumbs.value += spell.value.thumbsProduced;
        onNextRefreshThumbs();
      }
      if(spell.value.birgisProduced > 0){
        birgis.value += spell.value.birgisProduced;
        onNextRefreshBirgis();
      }
      if(spell.value.bonusRounds > 0){
        bonusRounds.value += spell.value.bonusRounds;
        onNextRefreshBonusRounds();
      }
    }
  }


}