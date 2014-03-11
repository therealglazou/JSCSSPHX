package om;

import om.interfaces.DOMCSSUnknownRule;

class CSSUnknownRule extends CSSRule
                     implements DOMCSSUnknownRule {

    /*
     * from DOMCSSUnknownRule interface
     */
    public var data : String;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSUnknownRule
     */

    override function get_cssText() : String {
        return this.data;
    }

    override function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        // XXX what happens if parsing makes the rule valid again???
        return v;
    }
}