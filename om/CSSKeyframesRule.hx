package om;

import om.interfaces.DOMCSSKeyframesRule;
import om.interfaces.DOMCSSKeyframeRule;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSRuleList;

class CSSKeyframesRule extends CSSRule
                       implements DOMCSSKeyframesRule {

    /*
     * from DOMCSSKeyframesRule interface
     */

    public var name : String;
    public var cssRules : DOMCSSRuleList;

    /*
     * http://dev.w3.org/csswg/css-animations/#CSSKeyframesRule-interface
     */

    public function appendRule(rule: String) : Void {
        // TBD when parsing is done...
    }

    public function deleteRule(key: String) : Void {
        for (i in 0...this.cssRules.length) {
            var rule = cast(this.cssRules.item(i), CSSKeyframeRule);
            if (rule.keyText == key) {
                cast(this.cssRules, CSSRuleList)._deleteRule(i);
                return;
            }
        }
    }

    public function findRule(key : String) : DOMCSSKeyframeRule {
        for (i in 0...this.cssRules.length) {
            var rule = cast(this.cssRules.item(i), CSSKeyframeRule);
            if (rule.keyText == key) {
                return rule;
            }
        }
        return null;
    }

    override function get_cssText() : String {
        var rv ="@keyframes " + this.name + " { ";
        for (i in 0...this.cssRules.length - 1)
            rv += this.cssRules.item(i).cssText;
        return rv;
    }

    override function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    /*
     * CONSTRUCTOR
     */
    public function new() {
        super();
        this.cssRules = new CSSRuleList();
    }
}
