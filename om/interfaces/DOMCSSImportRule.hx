package om.interfaces;

import om.interfaces.DOMMediaList;
import om.interfaces.DOMCSSStyleSheet;

interface DOMCSSImportRule {

    /*
     * readonly attribute DOMString        href;
     */
    public var href : String;

    /*
     * readonly attribute stylesheets::MediaList  media;
     */
    public var media : DOMMediaList;

    /*
     * readonly attribute CSSStyleSheet    styleSheet;
     */
    public var styleSheet : DOMCSSStyleSheet;
}
