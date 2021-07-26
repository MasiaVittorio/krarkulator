
enum PanelPage {
  spells,
  dice,
  themes,
  info,
}

const _spells = "Spells";
const _dice = "Dice";
const _themes = "Themes";
const _info = "Info";

extension PanelPageExt on PanelPage {
  static const _names = <PanelPage,String>{
    PanelPage.spells: _spells,
    PanelPage.themes: _themes,
    PanelPage.dice: _dice,
    PanelPage.info: _info,
  };

  String get name => _names[this]!;
}

class PanelPages {
  static const _reverse = <String,PanelPage>{
    _spells: PanelPage.spells,
    _dice: PanelPage.dice,
    _themes: PanelPage.themes,
    _info: PanelPage.info,
  };

  static PanelPage? fromName(String name) => _reverse[name];
}

