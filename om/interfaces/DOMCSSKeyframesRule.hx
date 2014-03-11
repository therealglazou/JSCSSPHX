package om.interfaces;

import om.interfaces.DOMCSSRuleList;
import om.interfaces.DOMCSSKeyframeRule;

interface DOMCSSKeyframesRule {

    /*
     *          attribute DOMString   name;
     */
    var name : String;

    /*
     * readonly attribute CSSRuleList cssRules;
     */
    var cssRules : DOMCSSRuleList;

    /*
     * void            appendRule(in DOMString rule);
     */
    function appendRule(rule : String) : Void;

    /*
     * void            deleteRule(in DOMString key);
     */
    function deleteRule(key : String) : Void;

    /*
     * CSSKeyframeRule findRule(in DOMString key);
     */
    function findRule(key : String) : DOMCSSKeyframeRule;
}
