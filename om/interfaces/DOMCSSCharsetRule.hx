package om.interfaces;

interface DOMCSSCharsetRule {

    /*
     * attribute DOMString        encoding;
     *                              // raises(DOMException) on setting
     */
    var encoding(default, set) : String;
}
