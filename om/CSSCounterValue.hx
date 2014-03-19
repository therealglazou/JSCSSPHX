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

import om.interfaces.DOMCSSPrimitiveValue;
import om.interfaces.DOMCSSValue;
import om.interfaces.DOMCSSCounterValue;
import om.interfaces.DOMException;

class CSSCounterValue implements DOMCSSCounterValue {

    /*
     * from DOMCSSValue interface
     */
    public var cssText(get, set) : String;
    public var cssValueType(default, null) : CSSValueType;

    /*
     * from DOMCSSPrimitiveValue interface
     */
    public var primitiveType(default, null) : PrimitiveType;
    
    /*
     * from DOMCSSCounterValue interface
     */
    public var identifier(default, null) : String;
    public var listStyle(default, null) : String;
    public var separator(default, null) : String;
    public var nestedCounters(default, null) : Bool;
    
    /*
    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */

    public function get_cssText() : String {
        var rv = (this.nestedCounters ? "counters" : "counter");
        rv += "(" + this.identifier;
        if (this.nestedCounters)
            rv += ", \"" + this.separator + "\"";
        if ("" != this.listStyle)
            rv += ", " + this.separator + ")";
        return rv;
    }

    public function set_cssText(v : String) : String {
        // TBD
        throw NO_MODIFICATION_ALLOWED_ERR;
    }

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSPrimitiveValue
     */

    public function setFloatValue(unit : String, floatValue : Float) : Void {
        throw INVALID_ACCESS_ERR;
    }

    public function getFloatValue() : Float {
        throw INVALID_ACCESS_ERR;
    }

    public function getFloatUnit() : String {
        throw INVALID_ACCESS_ERR;
    }

    public function getStringValue() : String {
        throw INVALID_ACCESS_ERR;
    }

    public function setStringValue(stringValue : String) : Void {
        throw INVALID_ACCESS_ERR;
    }

    public function getRGBColorValue() : CSSColorValue {
        throw INVALID_ACCESS_ERR;
    }

    public function getRectValue() : CSSRectValue {
        throw INVALID_ACCESS_ERR;
    }

    public function getCounterValue() : CSSCounterValue {
        return this;
    }

    public function new() {
        this.primitiveType = CSS_COUNTER;
        this.cssValueType = CSS_PRIMITIVE_VALUE;

        this.identifier = "";
        this.listStyle = "";
        this.separator = "";
        this.nestedCounters = false;
    }
}
