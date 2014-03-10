package om;

import om.interfaces.DOMCSSImportRule;
import om.interfaces.DOMMediaList;
import om.interfaces.DOMCSSStyleSheet;

class CSSImportRule extends CSSRule
                     implements DOMCSSImportRule {

    /*
     * from DOMCSSImportRule interface
     */
    public var href : String;
    public var media : DOMMediaList;
    public var styleSheet : DOMCSSStyleSheet;

    override function get_cssText() : String {
        var rv : String = "@import url(\"" + this.href + "\")";
        var m : String = this.media.mediaText;
        if ("" != m)
            rv += " " + m;
         rv += ";";
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
        this.href = "";
        this.media = new MediaList();
        this.styleSheet = null;
    }
}