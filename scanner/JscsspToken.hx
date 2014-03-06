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
        type = aType;
        value = aValue;
        unit = aUnit;
    }

    private function _isOfType(aType : TokenType, aValue : String) : Bool
    {
        return (type == aType && ("" == aValue || value.toLowerCase() == aValue));
    }

    public function isWhiteSpace(w : String) : Bool {
    	return _isOfType(WHITESPACE_TYPE, w);
    }

    function isString() : Bool
    {
        return _isOfType(STRING_TYPE, "");
    }

    function isComment() : Bool
    {
        return _isOfType(COMMENT_TYPE, "");
    }

    function isNumber(n) : Bool
    {
        return _isOfType(NUMBER_TYPE, n);
    }

    function isIdent(i) : Bool
    {
        return _isOfType(IDENT_TYPE, i);
    }

    function isFunction(f) : Bool
    {
        return _isOfType(FUNCTION_TYPE, f);
    }

    function isAtRule(a) : Bool
    {
        return _isOfType(ATRULE_TYPE, a);
    }

    function isIncludes() : Bool
    {
        return _isOfType(INCLUDES_TYPE, "");
    }

    function isDashmatch() : Bool
    {
        return _isOfType(DASHMATCH_TYPE, "");
    }

    function isBeginsmatch() : Bool
    {
        return _isOfType(BEGINSMATCH_TYPE, "");
    }

    function isEndsmatch() : Bool
    {
        return _isOfType(ENDSMATCH_TYPE, "");
    }

    function isContainsmatch() : Bool
    {
        return _isOfType(CONTAINSMATCH_TYPE, "");
    }

    function isSymbol(c) : Bool
    {
        return _isOfType(SYMBOL_TYPE, c);
    }

    function isDimension() : Bool
    {
        return _isOfType(DIMENSION_TYPE, "");
    }

    function isPercentage() : Bool
    {
        return _isOfType(PERCENTAGE_TYPE, "");
    }

    function isHex() : Bool
    {
        return _isOfType(HEX_TYPE, "");
    }

    function isDimensionOfUnit(aUnit) : Bool
    {
        return (isDimension() && unit == aUnit);
    }

    function isLength() : Bool
    {
        return (isPercentage() ||
                isDimensionOfUnit("cm") ||
                isDimensionOfUnit("mm") ||
                isDimensionOfUnit("in") ||
                isDimensionOfUnit("pc") ||
                isDimensionOfUnit("px") ||
                isDimensionOfUnit("em") ||
                isDimensionOfUnit("ex") ||
                isDimensionOfUnit("pt"));
    }

    function isAngle() : Bool
    {
        return (isDimensionOfUnit("deg") ||
                isDimensionOfUnit("rad") ||
                isDimensionOfUnit("grad"));
    }
}
