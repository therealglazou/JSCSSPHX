package om;

import om.interfaces.DOMCSSPrimitiveValue;
import om.interfaces.DOMCSSValue;
import om.interfaces.DOMException;

class CSSPrimitiveValue implements DOMCSSPrimitiveValue {

    /*
     * from DOMCSSValue interface
     */
    public var cssText(get, set) : String;
    public var cssValueType(default, null) : CSSValueType;

    /*
     * from DOMCSSPrimitiveValue interface
     */
    public var primitiveType(default, null) : PrimitiveType;
    
    /*
    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */

    public function get_cssText() : String {
        // TBD
        return "";
    }

    public function set_cssText(v : String) : String {
        // TBD
        throw NO_MODIFICATION_ALLOWED_ERR;
    }

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSPrimitiveValue
     */
    private var mUnit : String;
    private var mFloatValue : Float; 
    private var mString : String;

    public function setFloatValue(unit : String, floatValue : Float) : Void {
        if (CSS_UNIT != this.primitiveType
            && CSS_PERCENTAGE != this.primitiveType)
            throw INVALID_ACCESS_ERR;

        this.mUnit = unit;
        this.mFloatValue = floatValue;
    }

    public function getFloatValue() : Float {
        if (CSS_UNIT != this.primitiveType
            && CSS_PERCENTAGE != this.primitiveType)
            throw INVALID_ACCESS_ERR;

        return this.mFloatValue;
    }

    public function getFloatUnit() : String {
        if (CSS_UNIT != this.primitiveType
            && CSS_PERCENTAGE != this.primitiveType)
            throw INVALID_ACCESS_ERR;

        return this.mUnit;
    }

    public function getStringValue() : String {
        switch (this.primitiveType) {
            case CSS_STRING:
            case CSS_IDENT:
            case CSS_URI:
            case CSS_ATTR:
            case CSS_COUNTER:
            case CSS_VARIABLE:
                return this.mString;

            default:
                throw INVALID_ACCESS_ERR;
        }
        return ""; // never matches
    }

    public function setStringValue(stringValue : String) : Void {
        switch (this.primitiveType) {
            case CSS_STRING:
            case CSS_IDENT:
            case CSS_URI:
            case CSS_ATTR:
            case CSS_COUNTER:
            case CSS_VARIABLE:
                this.mString = stringValue;

            default:
                throw INVALID_ACCESS_ERR;
        }
    }

    public function new(aPrimitiveType : PrimitiveType) {
        this.primitiveType = aPrimitiveType;
        this.cssValueType = CSS_PRIMITIVE_VALUE;

        this.mUnit = "";
        this.mFloatValue = 0;
        this.mString = "";
    }
}
