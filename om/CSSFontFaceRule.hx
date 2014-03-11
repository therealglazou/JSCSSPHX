package om;

import om.CSSStyleDeclaration;
import om.interfaces.DOMCSSFontFaceRule;
import om.interfaces.DOMCSSStyleDeclaration;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSStyleSheet;

class CSSFontFaceRule extends CSSRule
                   implements DOMCSSFontFaceRule {

    /* from DOMCSSFontFaceRule interface
     * 
     */

    public var style(default, null) : DOMCSSStyleDeclaration;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSFontFaceRule
     */

    override function get_cssText() : String {
        return "@font-face { "
               + this.style.cssText + " }";
    }

    override function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    /*
     * CONSTRUCTOR
     */
    public function new(aType : DOMCSSRuleType,
                        aSheet: DOMCSSStyleSheet,
                        aRule : DOMCSSRule) {
        super(aType, aSheet, aRule);
        this.style = new CSSStyleDeclaration();
    }
}
