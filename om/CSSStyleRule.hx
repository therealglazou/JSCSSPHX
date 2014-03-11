package om;

import om.CSSStyleDeclaration;
import om.interfaces.DOMCSSStyleRule;
import om.interfaces.DOMCSSStyleDeclaration;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSStyleSheet;

class CSSStyleRule extends CSSRule
                   implements DOMCSSStyleRule {

    /* from DOMCSSStyleRule interface
     * 
     */
    public var selectorText(default, set) : String;
    public var style(default, null) : DOMCSSStyleDeclaration;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSStyleRule
     */

    private function set_selectorText(v : String) {
        /// TBD when selector parsing is done
        this.selectorText = v;
        return v;
    }

    override function get_cssText() : String {
        return this.selectorText + " { "
               + this.style.cssText + " }";
    }

    override function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    /*
     * CONSTRUCTOR
     */
    public function new(aSelectorText : String,
                        aType : DOMCSSRuleType,
                        aSheet: DOMCSSStyleSheet,
                        aRule : DOMCSSRule) {
        super(aType, aSheet, aRule);
        this.selectorText = aSelectorText;
        this.style = new CSSStyleDeclaration();
    }
}
