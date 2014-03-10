package om.interfaces;

import om.interfaces.DOMMediaList;
import om.interfaces.DOMCSSStyleSheet;

interface DOMCSSMediaRule {

    /*
     * readonly attribute stylesheets::MediaList  media;
     */
    var media(default, null) : DOMMediaList;

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

    /*
     * void               deleteRule(in unsigned long index)
     *                                       raises(DOMException);
     */
    function deleteRule(index : UInt) : Void;
}
