package om.interfaces;

import om.interfaces.DOMMediaList;

interface DOMStyleSheet {
    /*
     * readonly attribute DOMString        type;
     */
    var type(default, null) : String;

    /*
     *          attribute boolean          disabled;
     */
    var disabled(default, set) : Bool;

    /*
     * readonly attribute nsIDOMNode       ownerNode;
     */
    // var ownerNode(default, null) : DOMNode;

    /*
     * readonly attribute nsIDOMStyleSheet parentStyleSheet;
     */
    var parentStyleSheet(default, null) : DOMStyleSheet;

    /*
     * readonly attribute DOMString        href;
     */
    var href(default, null) : String;

    /*
     * readonly attribute DOMString        title;
     */
    var title(default, null) : String;

    /*
     * readonly attribute nsIDOMMediaList  media;
     */
    var media(default, null) : DOMMediaList;
}