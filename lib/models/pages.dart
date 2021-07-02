
enum KrPage {
  spell,
  status,
  triggers,
  board,
}

const _spell = "Spell";
const _status = "Status";
const _triggers = "Triggers";
const _board = "Board";

extension KrPageExt on KrPage {
  static const _names = <KrPage,String>{
    KrPage.spell: _spell,
    KrPage.status: _status,
    KrPage.triggers: _triggers,
    KrPage.board: _board,
  };

  String get name => _names[this]!;
}

class KrPages {
  static const _reverse = <String,KrPage>{
    _spell: KrPage.spell,
    _status: KrPage.status,
    _triggers: KrPage.triggers,
    _board: KrPage.board,
  };

  static KrPage? fromName(String name) => _reverse[name];
}

