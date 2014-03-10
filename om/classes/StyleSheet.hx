package om.classes;

import om.interfaces.DOMStyleSheet;
import om.interfaces.DOMCSSStyleSheet;
import om.interfaces.DOMMediaList;
import om.classes.MediaList;

class StyleSheet implements DOMStyleSheet
                 implements DOMCSSStyleSheet {

    /*
     * from DOMStyleSheet interface
     */

    public var type(get, null) : String;
    public var disabled(get, set) : Bool;
    // public var ownerNode(default, null) : DOMNode;
    public var parentStyleSheet(get, null) : DOMStyleSheet;
    public var href(get, null) : String;
    public var title(get, null) : String;
    public var media(get, null) : DOMMediaList;

    private var mType : String;
    private var mDisabled : Bool;
    private var mParentStyleSheet : DOMStyleSheet;
    private var mHref : String;
    private var mTitle : String;
    private var mMediaList : DOMMediaList;

    private inline function get_type() : String {
        return mType;
    }

    private inline function get_disabled() : Bool {
        return mDisabled;
    }

    private function set_disabled(v: Bool) : Bool {
        mDisabled = v;
        return v;
    }

    private inline function get_parentStyleSheet() : DOMStyleSheet {
        return mParentStyleSheet;
    }

    private inline function get_href() : String {
        return mHref;
    }

    private inline function get_title() : String {
        return mTitle;
    }

    private inline function get_media() : DOMMediaList {
        return mMediaList;
    }

    /*
     * from DOMCSSStyleSheet interface
     */
    public function insertRule(rule: String, index: UInt) : UInt {
        /// TBD
        return 0;
    }

    /*
     * CONSTRUCTOR
     */
    public function new() {
        mType = "text/css";
        mDisabled = false;
        mParentStyleSheet = null;
        mHref = "";
        mTitle = "";
        mMediaList = new MediaList();
    }
}
