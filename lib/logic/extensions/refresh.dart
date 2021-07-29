import 'package:krarkulator/everything.dart';

extension KrLogicRefresh on Logic {

  ///===== Refreshes ===============================================
  void onNextRefreshZone(){
    onNextRefresh["zone"] = zone.refresh;
  }
  void onNextRefreshTriggers(){
    onNextRefresh["triggers"] = triggers.refresh;
  }
  void onNextRefreshMana(){
    onNextRefresh["mana"] = mana.refresh;
  }
  void onNextRefreshTreasures(){
    onNextRefresh["treasures"] = treasures.refresh;
  }
  void onNextRefreshTotalStormCount(){
    onNextRefresh["totalStormCount"] = storm.refresh;
  }
  void onNextRefreshTotalResolved(){
    onNextRefresh["totalResolved"] = resolved.refresh;
  }
  void onNextRefreshArtists(){
    onNextRefresh["artists"] = artists.refresh;
  }
  void onNextRefreshScoundrels(){
    onNextRefresh["scoundrels"] = scoundrels.refresh;
  }
  void onNextRefreshVeyrans(){
    onNextRefresh["veyrans"] = veyrans.refresh;
  }
  void onNextRefreshThumbs(){
    onNextRefresh["thumbs"] = thumbs.refresh;
  }
  void onNextRefreshBirgis(){
    onNextRefresh["birgis"] = birgis.refresh;
  }
  void onNextRefreshBonusRounds(){
    onNextRefresh["bonusRounds"] = bonusRounds.refresh;
  }
  void onNextRefreshKrarks(){
    onNextRefresh["krarks"] = krarks.refresh;
  }

  void refreshIf(bool v){
    if(v) refresh();
  }
  void refresh(){
    onNextRefresh.values.forEach((f) => f());
    onNextRefresh.clear();
  }


}
