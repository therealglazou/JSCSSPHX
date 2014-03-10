package om;

import om.interfaces.DOMStyleSheet;
import om.interfaces.DOMCSSStyleSheet;
import om.interfaces.DOMMediaList;
import om.interfaces.DOMCSSRule;

import om.MediaList;

class StyleSheet implements DOMStyleSheet
                 implements DOMCSSStyleSheet {

    /*
     * from DOMStyleSheet interface
     */

    public var type(default, null) : String;
    public var disabled(default, set) : Bool;
    // public var ownerNode(default, null) : DOMNode;
    public var parentStyleSheet(default, null) : DOMStyleSheet;
    public var href(default, null) : String;
    public var title(default, null) : String;
    public var media(default, null) : DOMMediaList;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/stylesheets.html#StyleSheets-StyleSheet
     */

    private function set_disabled(v: Bool) : Bool {
        this.disabled = v;
        return v;
    }

    /*
     * from DOMCSSStyleSheet interface
     */
    public var ownerRule(default, null) : DOMCSSRule;

    public function insertRule(rule: String, index: UInt) : UInt {
        /// TBD
        return 0;
    }

    /*
     * CONSTRUCTOR
     */
    public function new() {
        this.type = "text/css";
        this.disabled = false;
        this.parentStyleSheet = null;
        this.href = "";
        this.title = "";
        this.media = new MediaList();
    }
}
