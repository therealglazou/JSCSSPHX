package om.interfaces;

interface DOMMediaList {

    /*
     *          attribute DOMString        mediaText;
     *                                       // raises(DOMException) on setting
     */
    var mediaText(get, set) : String;

    /*
     * readonly attribute unsigned long    length;
     */
    var length(get, null) : UInt;

    /*
     * DOMString          item(in unsigned long index);
     */
    function item(index : UInt) : String;

    /*
     * void               deleteMedium(in DOMString oldMedium)
     *                                       raises(DOMException);
     */
    function deleteMedium(oldMedium : String) : Void;

    /*
     * void               appendMedium(in DOMString newMedium)
     *                                       raises(DOMException);
     */
    function appendMedium(newMedium : String) : Void;
}