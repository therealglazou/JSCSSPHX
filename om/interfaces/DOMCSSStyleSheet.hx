package om.interfaces;

interface DOMCSSStyleSheet {

    /*
     * readonly attribute nsIDOMCSSRule     ownerRule;
     */
    // var ownerRule(default, null) : DOMCSSRule;

    /*
     * readonly attribute nsIDOMCSSRuleList cssRules;
     */
    // var cssRules(default, null) : DOMCSSRuleList;

    /*
     * unsigned long      insertRule(in DOMString rule,
     *                               in unsigned long index)
     *                                       raises(DOMException);
     */
    function insertRule(rule: String, index: UInt) : UInt;
}