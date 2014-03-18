package om;

import om.interfaces.DOMCSSValueList;
import om.interfaces.DOMCSSValue;
import om.interfaces.DOMException;

class CSSValueList implements DOMCSSValueList {

    /*
     * from DOMCSSValue interface
     */
    public var cssText(get, set) : String;
    public var cssValueType(default, null) : CSSValueType;

    /*
     * from DOMCSSValueList interface
     */
    public var commaSeparated(default, null) : Bool;
    public var length(get, null) : UInt;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */

    public function get_cssText() : String {
        return this.mValueArray
                   .map(function(n) {return n.cssText; } )
                   .join(", ");
    }

    public function set_cssText(v : String) : String {
        // TBD
        throw NO_MODIFICATION_ALLOWED_ERR;
    }

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValueList
     */
    private var mValueArray : Array<DOMCSSValue>;

    private function get_length() : UInt {
        return this.mValueArray.length;
    }

    public function item(index : UInt) : DOMCSSValue {
        if (index >= this.mValueArray.length)
            return null;
        return this.mValueArray[index];
    }

    /*
     * CONSTRUCTOR
     */
    public function new(aCommaSeparated : Bool) {
        this.commaSeparated = aCommaSeparated;
        this.cssValueType = CSS_VALUE_LIST;
        this.mValueArray = [];
    }
}
