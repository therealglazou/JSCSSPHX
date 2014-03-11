package om;

import om.interfaces.DOMCSSCharsetRule;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSStyleSheet;

class CSSCharsetRule extends CSSRule
                     implements DOMCSSCharsetRule {

    /*
     * from DOMCSSCharsetRule interface
     */
    public var encoding(default, set) : String;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSCharsetRule
     */

    private function set_encoding(v : String) : String {
        // TBD check against valid encodings
        this.encoding = v;
        return v;
    }

    override function get_cssText() : String {
        return "@charset \"" + this.encoding + "\";";
    }

    override function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    /*
     * CONSTRUCTOR
     */

    public function new(aEncoding : String,
                        aType : DOMCSSRuleType,
                        aSheet: DOMCSSStyleSheet,
                        aRule : DOMCSSRule) {
        super(aType, aSheet, aRule);
        this.encoding = aEncoding;
    }
}