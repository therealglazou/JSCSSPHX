package om.interfaces;

import om.interfaces.DOMMediaList;

interface DOMStyleSheet {
    /*
     * readonly attribute DOMString        type;
     */
    var type(get, null) : String;

    /*
     *          attribute boolean          disabled;
     */
    var disabled(get, set) : Bool;

    /*
     * readonly attribute nsIDOMNode       ownerNode;
     */
    // var ownerNode(default, null) : DOMNode;

    /*
     * readonly attribute nsIDOMStyleSheet parentStyleSheet;
     */
    var parentStyleSheet(get, null) : DOMStyleSheet;

    /*
     * readonly attribute DOMString        href;
     */
    var href(get, null) : String;

    /*
     * readonly attribute DOMString        title;
     */
    var title(get, null) : String;

    /*
     * readonly attribute nsIDOMMediaList  media;
     */
    var media(get, null) : DOMMediaList;
}