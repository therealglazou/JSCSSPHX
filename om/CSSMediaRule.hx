package om;

import om.interfaces.DOMCSSMediaRule;
import om.interfaces.DOMMediaList;
import om.interfaces.DOMCSSRule;

import om.MediaList;

class CSSMediaRule extends CSSRule
                   implements DOMCSSMediaRule {

    /*
     * from DOMCSSMediaRule interface
     */

    public var media(default, null) : DOMMediaList;
    // var cssRules(default, null) : DOMCSSRuleList;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSMediaRule
     */

    public function insertRule(rule: String, index: UInt) : UInt {
        /// TBD
        return 0;
    }

    public function deleteRule(index: UInt) : Void {
        /// TBD
    }

    override function get_cssText() : String {
        var rv : String = "@media ";
        var m : String = this.media.mediaText;
        if ("" == m)
            rv += "all";
        else
            rv += " " + m;
        rv += " {";
        // TBD browse cssRules
        rv += " }";
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
        this.media = new MediaList();
    }
}
