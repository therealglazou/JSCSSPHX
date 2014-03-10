package om.classes;

import om.interfaces.DOMMediaList;
import om.interfaces.DOMException;

class MediaList implements DOMMediaList {

    /*
     * from DOMMediaList interface
     */
    public var mediaText(get, set) : String;
    public var length(get, null) : UInt;

    private var mMediaArray : Array<String>;

    private function get_mediaText() : String {
        return mMediaArray.join(", ");
    }

    private function set_mediaText(v : String) : String {
        var rv = v.split(",");
        mMediaArray = [];
        for (i in 0...rv.length - 1) {
            rv[i] = StringTools.trim(rv[i]);
            if (0 == i || rv[i] != rv[i-1])
                mMediaArray.push(rv[i]);
        }
        return v;
    }

    private inline function get_length() : UInt {
        return mMediaArray.length;
    }

    public function item(index : UInt) : String {
        if (index < mMediaArray.length)
            return mMediaArray[index];
        return null;
    }

    public function deleteMedium(oldMedium : String) : Void {
        var index = mMediaArray.indexOf(oldMedium);
        if (-1 != index) {
            mMediaArray.splice(index, 1);
            return;
        }
        throw DOMException.NOT_FOUND_ERR;
    }

    public function appendMedium(newMedium : String) : Void {
        // TBD : validate newMedium and throw INVALID_CHARACTER_ERR if invalid
        var index = mMediaArray.indexOf(newMedium);
        if (-1 != index) {
            mMediaArray.splice(index, 1);
        }
        mMediaArray.push(newMedium);
    }

    /*
     * CONSTRUCTOR
     */
    public function new() {
        
    }
}
