package om.interfaces;

import om.interfaces.DOMCSSRule;

interface DOMCSSRuleList {

    /*
     * readonly attribute unsigned long    length;
     */
    var length(get, null) : UInt;

    /*
     * CSSRule            item(in unsigned long index);
     */
    function item(index : UInt) : DOMCSSRule;
}
