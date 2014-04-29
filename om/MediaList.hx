/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is JSCSSP code.
 *
 * The Initial Developer of the Original Code is
* Disruptive Innovations SAS
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Daniel Glazman <d.glazman@partner.samsung.com>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either of the GNU General Public License Version 2 or later (the "GPL"),
 * or the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

package om;

import om.interfaces.DOMMediaList;
import om.interfaces.DOMException;

class MediaList implements DOMMediaList {

    /*
     * from DOMMediaList interface
     */
    public var mediaText(get, set) : String;
    public var length(get, null) : UInt;

    private var mMediaArray : Array<String>;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/stylesheets.html#StyleSheets-MediaList
     */
    private function get_mediaText() : String {
        return mMediaArray.join(", ");
    }

    private function set_mediaText(v : String) : String {
        // TBD : validate v and throw SYNTAX_ERR if invalid
        var rv = v.split(",");
        mMediaArray = [];
        for (i in 0...rv.length) {
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
