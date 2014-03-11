package om.interfaces;

import om.interfaces.DOMCSSStyleDeclaration;

interface DOMCSSKeyframeRule {

    /*
     *          attribute DOMString           keyText;
     */
    var keyText : String;

    /*
     * readonly attribute CSSStyleDeclaration style;
     */
    var style(default, null) : DOMCSSStyleDeclaration;
}
