package om.interfaces;

interface DOMCSSNamespaceRule {

    /*
     * [TreatNullAs=EmptyString] attribute DOMString namespaceURI;
     */
    var namespaceURI : String;

    /*
     * [TreatNullAs=EmptyString] attribute DOMString prefix;
     */
    var prefix : String;
}
