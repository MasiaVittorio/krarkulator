import 'package:krarkulator/everything.dart';

extension KrLogicSolveSpell on Logic {

  void solveSpell(){
    log("resolve spell");

    resolved.value++;
    onNextRefreshTotalResolved();

    /// resolve
      
    if(spell.value.manaProduct != 0){
      mana.value += spell.value.manaProduct;
      onNextRefreshMana();
      log("  mana +${spell.value.manaProduct} = ${mana.value}");
    }
    if(spell.value.treasuresProduct > 0){
      treasures.value += spell.value.treasuresProduct;
      onNextRefreshTreasures();
      log("  treasures +${spell.value.treasuresProduct} = ${treasures.value}");
    }

    if(spell.value.krarksProduced > 0){
      krarks.value += spell.value.krarksProduced;
      onNextRefreshKrarks();
      log("  krarks +${spell.value.krarksProduced} = ${krarks.value}");
    }
    if(spell.value.thumbsProduced > 0){
      thumbs.value += spell.value.thumbsProduced;
      onNextRefreshThumbs();
      log("  thumbs +${spell.value.thumbsProduced} = ${thumbs.value}");
    }

    if(spell.value.veyransProduced > 0){
      veyrans.value += spell.value.veyransProduced;
      onNextRefreshVeyrans();
      log("  veyrans +${spell.value.veyransProduced} = ${veyrans.value}");
    }
    if(spell.value.prodigiesProduced > 0){
      prodigies.value += spell.value.prodigiesProduced;
      onNextRefreshProdigies();
      log("  prodigies +${spell.value.prodigiesProduced} = ${prodigies.value}");
    }

    if(spell.value.artistsProduced > 0){
      artists.value += spell.value.artistsProduced;
      onNextRefreshArtists();
      log("  artists +${spell.value.artistsProduced} = ${artists.value}");
    }
    if(spell.value.scoundrelProduced > 0){
      scoundrels.value += spell.value.scoundrelProduced;
      onNextRefreshScoundrels();
      log("  scoundrels +${spell.value.scoundrelProduced} = ${scoundrels.value}");
    }
    if(spell.value.birgisProduced > 0){
      birgis.value += spell.value.birgisProduced;
      onNextRefreshBirgis();
      log("  birgis +${spell.value.birgisProduced} = ${birgis.value}");
    }

    if(spell.value.bonusRounds > 0){
      bonusRounds.value += spell.value.bonusRounds;
      onNextRefreshBonusRounds();
      log("  bonus rounds +${spell.value.bonusRounds} = ${bonusRounds.value}");
    }
  }


}