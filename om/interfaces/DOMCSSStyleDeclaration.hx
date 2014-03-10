package om.interfaces;

import om.interfaces.DOMCSSRule;

interface DOMCSSStyleDeclaration {

    /*
     *          attribute DOMString        cssText;
     */
    var cssText(get, set) : String;

    /*
     * DOMString          getPropertyValue(in DOMString propertyName);
     */
    function getPropertyValue(propertyName : String) : String;

    /*
     * nsIDOMCSSValue     getPropertyCSSValue(in DOMString propertyName);
     */
    // function getPropertyCSSValue(propertyName : String) : DOMCSSValue;

    /*
     * DOMString          removeProperty(in DOMString propertyName)
     *                                       raises(DOMException);
     */
    function removeProperty(propertyName : String) : String;

    /*
     * DOMString          getPropertyPriority(in DOMString propertyName);
     */
    function getPropertyPriority(propertyName : String) : String;

    /*
     * void               setProperty(in DOMString propertyName,
     *                                in DOMString value, 
     *                                [optional] in DOMString priority)
     *                                       raises(DOMException);
     */
    function setProperty(propertyName : String,
                         value : String,
                         ?priority : String = "") : Void;

    /*
     * readonly attribute unsigned long    length;
     */
    var length(get, null) : UInt;

    /*
     * DOMString          item(in unsigned long index);
     */
    function item(index : UInt) : String;

    /*
     * readonly attribute nsIDOMCSSRule    parentRule;
     */
    var parentRule : DOMCSSRule;
}
