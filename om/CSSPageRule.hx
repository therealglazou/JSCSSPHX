package om;

import om.CSSStyleDeclaration;
import om.interfaces.DOMCSSPageRule;
import om.interfaces.DOMCSSStyleDeclaration;

class CSSPageRule extends CSSRule
                  implements DOMCSSPageRule {

    /* from DOMCSSPageRule interface
     * 
     */
    public var selectorText(default, set) : String;
    public var style(default, null) : DOMCSSStyleDeclaration;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSPageRule
     */

    private function set_selectorText(v : String) {
        /// TBD when selector parsing is done
        this.selectorText = v;
        return v;
    }

    override function get_cssText() : String {
        return "@page " + this.selectorText + " { "
               + this.style.cssText + " }";
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
        this.selectorText = "";
        this.style = new CSSStyleDeclaration();
    }
}