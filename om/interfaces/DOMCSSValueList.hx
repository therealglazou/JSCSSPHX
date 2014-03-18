package om.interfaces;

import om.interfaces.DOMCSSValue;

interface DOMCSSValueList extends DOMCSSValue {

    /*
     * ADDED
     * readonly attribute boolean commaSeparated;
     */
    var commaSeparated(default, null) : Bool;

    /*
     * readonly attribute unsigned long    length;
     */
    var length(get, null) : UInt;

    /*
     * CSSValue           item(in unsigned long index);
     */
    function item(index : UInt) : DOMCSSValue;
}
