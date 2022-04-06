enum ErrorType {
  spellNotSelected,
  spellInGraveyard,
  spellOutOfHand,
  insufficientManaOrTreasures,
}

class CastError {
  final ErrorType type;
  final String message;
  const CastError(this.type, this.message); 
}