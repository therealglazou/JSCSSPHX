package om;

import om.interfaces.DOMCSSNamespaceRule;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSStyleSheet;

class CSSNamespaceRule extends CSSRule
                       implements DOMCSSNamespaceRule {

    /*
     * from DOMCSSNamespaceRule interface
     */

    public var namespaceURI : String;
    public var prefix : String;

    /*
     * http://dev.w3.org/csswg/cssom/#the-cssnamespacerule-interface
     */

    override function get_cssText() : String {
        var rv ="@namespace ";
        if (this.prefix != "")
            rv += this.prefix + " ";
        rv += this.namespaceURI + ";";
        return rv;
    }

    override function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    /*
     * CONSTRUCTOR
     */
    public function new(aURI : String,
                        aPrefix : String,
                        aType : DOMCSSRuleType,
                        aSheet: DOMCSSStyleSheet,
                        aRule : DOMCSSRule) {
        super(aType, aSheet, aRule);
        this.namespaceURI = aURI;
        this.prefix = aPrefix;
    }
}