package om;

import om.interfaces.DOMCSSValue;
import om.interfaces.DOMException;

class CSSValue implements DOMCSSValue {

    /*
     * from DOMCSSValue interface
     */
    public var cssText(get, set) : String;
    public var cssValueType(default, null) : CSSValueType;

    /*
    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */

    public function get_cssText() : String {
        switch (this.cssValueType) {
            case CSS_INHERIT:
                return "inherit";
            case CSS_INITIAL:
                return "initial";
            case CSS_PRIMITIVE_VALUE:
                return cast(this, CSSPrimitiveValue).cssText;
            case CSS_VALUE_LIST:
                return cast(this, CSSValueList).cssText;
            default:
                return ""; // should never happen
        }
    }

    public function set_cssText(v : String) : String {
        throw NO_MODIFICATION_ALLOWED_ERR;
    }

    public function new(aType : CSSValueType) {
        this.cssValueType = aType;
    }
}
