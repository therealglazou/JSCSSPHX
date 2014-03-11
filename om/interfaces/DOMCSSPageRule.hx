package om.interfaces;

import om.interfaces.DOMCSSStyleDeclaration;

interface DOMCSSPageRule {

    /*
     *          attribute DOMString        selectorText;
     *                                       // raises(DOMException) on setting
     */
    var selectorText(default, set) : String;

    /*
     * readonly attribute nsIDOMCSSStyleDeclaration  style;
     */
    var style(default, null) : DOMCSSStyleDeclaration;
}