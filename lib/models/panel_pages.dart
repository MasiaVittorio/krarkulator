
enum PanelPage {
  spells,
  dice,
  themes,
}

const _spells = "Spells";
const _dice = "Dice";
const _themes = "Themes";

extension PanelPageExt on PanelPage {
  static const _names = <PanelPage,String>{
    PanelPage.spells: _spells,
    PanelPage.themes: _themes,
    PanelPage.dice: _dice,
  };

  String get name => _names[this]!;
}

class PanelPages {
  static const _reverse = <String,PanelPage>{
    _spells: PanelPage.spells,
    _dice: PanelPage.dice,
    _themes: PanelPage.themes,
  };

  static PanelPage? fromName(String name) => _reverse[name];
}

