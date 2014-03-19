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
 * The Original Code is JSCSSPHX code.
 *
 * The Initial Developer of the Original Code is
 * Samsung Electronics Co. Ltd
 * Portions created by the Initial Developer are Copyright (C) 2014
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

import om.interfaces.DOMCSSValue;
import om.interfaces.DOMException;

class CSSValue implements DOMCSSValue {

    /*
     * from DOMCSSValue interface
     */
    public var cssText(get, set) : String;
    public var type(default, null) : CSSValueType;
    public var commaSeparated : Bool;
    public var length(get, null) : UInt;

    /*
    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */
    private var mString : String;
    private var mFloat  : Float;
    private var mValueArray : Array<CSSValue>;
    
    private function get_length() : UInt {
        if (CSS_VALUE_LIST != this.type)
            throw INVALID_ACCESS_ERR;
        return this.mValueArray.length;
    }

    public function get_cssText() : String {
        switch (this.type) {
            case CSS_SYMBOL, CSS_STRING, CSS_IDENT:
                return this.mString;
            case CSS_URI:
                return "url(\"" + this.mString + "\")";
            case CSS_UNIT:
                return Std.string(this.mFloat) + this.mString;
            case CSS_NUMBER:
                return Std.string(this.mFloat) + this.mString;
            case CSS_VALUE_LIST:
                var rv =  this.mValueArray
                           .map(function(n) {return n.cssText; } )
                           .join((this.commaSeparated ? ", " : " "));
                if ("" != this.mString)
                  rv = this.mString + "(" + rv + ")";
                return rv;
            default:
                return ""; // should never happen
        }
    }

    public function set_cssText(v : String) : String {
        // TBD
        return "";
    }

    public function item(index : UInt) : CSSValue {
        if (CSS_VALUE_LIST != this.type)
            throw INVALID_ACCESS_ERR;
        if (index >= this.length)
            return null;
        return this.mValueArray[index];
    }

    public function getFloatValue() : Float {
        if (CSS_UNIT != this.type && CSS_NUMBER != this.type)
            throw INVALID_ACCESS_ERR;
        return this.mFloat;
    }

    public function setFloatValue(floatValue : Float) : Void {
        if (CSS_UNIT != this.type && CSS_NUMBER != this.type)
            throw INVALID_ACCESS_ERR;
        this.mFloat = floatValue;
    }

    public function getStringValue() : String {
        if (CSS_UNIT == this.type || CSS_NUMBER == this.type)
            throw INVALID_ACCESS_ERR;
        return this.mString;
    }

    public function setStringValue(stringValue : String) : Void{
        if (CSS_UNIT == this.type || CSS_NUMBER == this.type)
            throw INVALID_ACCESS_ERR;
        this.mString = stringValue;
    }

    /*
     * CONSTRUCTOR
     */
    public function new() {
        this.type = CSS_NUMBER;
        this.mString = "";
        this.mFloat = 0;
        this.mValueArray = [];
    }
}
