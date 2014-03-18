package om.interfaces;

import om.interfaces.DOMCSSValue;

enum PrimitiveType {
    CSS_UNKNOWN;

    CSS_NUMBER;

    CSS_PERCENTAGE;
    CSS_UNIT;
    CSS_STRING;
    CSS_URI;
    CSS_IDENT;
    CSS_ATTR;
    CSS_COUNTER;
    CSS_RECT;
    CSS_RGBCOLOR;

    CSS_CALC;
    CSS_GRADIENT;

    CSS_VARIABLE;
}

interface DOMCSSPrimitiveValue extends DOMCSSValue {

    /*
     * readonly attribute unsigned short   primitiveType;
     */
    var primitiveType(default, null) : PrimitiveType;

    /*
     * MODIFIED FROM
     * void               setFloatValue(in unsigned short unitType, 
     *                                  in float floatValue)
     *                                       raises(DOMException);
     */
    function setFloatValue(unit : String, floatValue : Float) : Void;

    /*
     * MODIFIED FROM
     * float              getFloatValue(in unsigned short unitType)
     *                                       raises(DOMException);
     */
    function getFloatValue() : Float;

    /*
     * NEW
     * DOMString          getFloatUnit()
     *                                       raises(DOMException);
     */
    function getFloatUnit() : String;

    /*
     * void               setStringValue(in unsigned short stringType,
     *                                   in DOMString stringValue)
     *                                       raises(DOMException);    
     */
    function setStringValue(stringValue : String) : Void;

    /* MODIFIED FROM
     * DOMString          getStringValue()
     *                                       raises(DOMException);    
     */
    function getStringValue() : String;

}
