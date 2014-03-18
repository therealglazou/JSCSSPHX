package om;

import om.interfaces.DOMCSSPrimitiveValue;
import om.interfaces.DOMCSSValue;
import om.interfaces.DOMCSSColorValue;
import om.interfaces.DOMException;

class CSSColorValue implements DOMCSSColorValue {

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
     * from DOMCSSColorValue interface
     */
    public var top(default, null)    : DOMCSSPrimitiveValue;
    public var right(default, null)  : DOMCSSPrimitiveValue;
    public var bottom(default, null) : DOMCSSPrimitiveValue;
    public var left(default, null)   : DOMCSSPrimitiveValue;
    
    /*
    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */

    public function get_cssText() : String {
        return "rect(" + this.top.cssText + ", " +
                         this.right.cssText + ", " +
                         this.bottom.cssText + ", " +
                         this.left.cssText + ")";
    }

    public function set_cssText(v : String) : String {
        // TBD
        throw NO_MODIFICATION_ALLOWED_ERR;
    }

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSPrimitiveValue
     */

    public function setFloatValue(unit : String, floatValue : Float) : Void {
        throw INVALID_ACCESS_ERR;
    }

    public function getFloatValue() : Float {
        throw INVALID_ACCESS_ERR;
    }

    public function getFloatUnit() : String {
        throw INVALID_ACCESS_ERR;
    }

    public function getStringValue() : String {
        throw INVALID_ACCESS_ERR;
    }

    public function setStringValue(stringValue : String) : Void {
        throw INVALID_ACCESS_ERR;
    }

    public function new() {
        this.primitiveType = CSS_RECT;
        this.cssValueType = CSS_PRIMITIVE_VALUE;
    }
}
