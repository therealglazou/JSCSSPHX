package om;

import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSStyleSheet;

class CSSRule implements DOMCSSRule {

    /*
     * from DOMCSSRule interface
     */
    public var type(default, null) : DOMCSSRuleType;
    public var cssText(get, set) : String;
    public var parentStyleSheet(default, null) : DOMCSSStyleSheet;
    public var parentRule(default, null) : DOMCSSRule;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSRule
     */

    private function get_cssText() : String {
        // TBD when om and seralization is done
        return "";
    }

    private function set_cssText(v : String) : String {
        // TBD when parsing is done
        return v;
    }

    /*
     * CONSTRUCTOR
     */

    public function new() {
        this.type = DOMCSSRuleType.UNKNOWN_RULE;
        this.parentStyleSheet = null;
        this.parentRule = null;
   }
}
