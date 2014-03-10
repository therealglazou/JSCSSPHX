package om;

import om.CSSStyleDeclaration;
import om.interfaces.DOMCSSStyleRule;
import om.interfaces.DOMCSSStyleDeclaration;

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

    /*
     * CONSTRUCTOR
     */
    public function new() {
        super();
        this.selectorText = "";
        this.style = new CSSStyleDeclaration();
    }
}
