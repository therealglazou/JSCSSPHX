package om;

import om.CSSStyleDeclaration;
import om.interfaces.DOMCSSKeyframeRule;
import om.interfaces.DOMCSSStyleDeclaration;

class CSSKeyframeRule extends CSSRule
                   implements DOMCSSKeyframeRule {

    /* from DOMCSSStyleRule interface
     * 
     */
    public var keyText : String;
    public var style(default, null) : DOMCSSStyleDeclaration;

    /*
     * http://dev.w3.org/csswg/css-animations/#CSSKeyframeRule-interface
     */

    override function get_cssText() : String {
        return this.keyText + " { "
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
        this.keyText = "";
        this.style = new CSSStyleDeclaration();
    }
}
