package om.interfaces;

import om.interfaces.DOMCSSStyleDeclaration;

interface DOMCSSFontFaceRule {

    /*
     * readonly attribute nsIDOMCSSStyleDeclaration  style;
     */
    var style(default, null) : DOMCSSStyleDeclaration;
}
