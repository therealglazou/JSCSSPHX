package scanner;

enum TokenType {

  NULL_TYPE;

  WHITESPACE_TYPE;
  STRING_TYPE;
  COMMENT_TYPE;
  NUMBER_TYPE;
  IDENT_TYPE;
  FUNCTION_TYPE;
  ATRULE_TYPE;
  INCLUDES_TYPE;
  DASHMATCH_TYPE;
  BEGINSMATCH_TYPE;
  ENDSMATCH_TYPE;
  CONTAINSMATCH_TYPE;
  SYMBOL_TYPE;
  DIMENSION_TYPE;
  PERCENTAGE_TYPE;
  HEX_TYPE;
}

class JscsspToken {


    var type : TokenType;
    var value : Dynamic;
    var unit : String;

    public function new(aType : TokenType, aValue : Dynamic, aUnit: String) {
        this.type = aType;
    }
}
