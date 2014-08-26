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
 *   Daniel Glazman <daniel.glazman@disruptive-innovations.com>
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
import om.interfaces.DOMException;

//import om.CSSColorValue;

class CSSPrimitiveValue implements DOMCSSPrimitiveValue {

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
    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */

    public function get_cssText() : String {
        switch (this.primitiveType) {
            case CSS_NUMBER:
                return Std.string(this.mFloatValue);
            case CSS_PERCENTAGE:
                return Std.string(this.mFloatValue) + "%";
            case CSS_UNIT:
                return Std.string(this.mFloatValue) + this.mUnit;
            case CSS_STRING:
                return this.mString;
            case CSS_IDENT:
                return this.mString;
            case CSS_ATTR:
                return "attr(" + this.mString + ")";
            case CSS_URI:
                return "url(" + this.mString + ")";
            case CSS_RGBCOLOR:
                return cast(this, CSSColorValue).cssText;
            case CSS_RECT:
                return cast(this, CSSRectValue).cssText;
            case CSS_COUNTER:
                return cast(this, CSSCounterValue).cssText;

            default:
                return "";
            
        }
    }

    public function set_cssText(v : String) : String {
        // TBD
        throw NO_MODIFICATION_ALLOWED_ERR;
    }

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSPrimitiveValue
     */
    private var mUnit : String;
    private var mFloatValue : Float; 
    private var mString : String;

    public function setFloatValue(unit : String, floatValue : Float) : Void {
        if (CSS_UNIT != this.primitiveType
            && CSS_PERCENTAGE != this.primitiveType)
            throw INVALID_ACCESS_ERR;

        this.mUnit = unit;
        this.mFloatValue = floatValue;
    }

    public function getFloatValue() : Float {
        if (CSS_UNIT != this.primitiveType
            && CSS_PERCENTAGE != this.primitiveType)
            throw INVALID_ACCESS_ERR;

        return this.mFloatValue;
    }

    public function getFloatUnit() : String {
        if (CSS_UNIT != this.primitiveType
            && CSS_PERCENTAGE != this.primitiveType)
            throw INVALID_ACCESS_ERR;

        return this.mUnit;
    }

    public function getStringValue() : String {
        switch (this.primitiveType) {
            case CSS_STRING:
            case CSS_IDENT:
            case CSS_URI:
            case CSS_ATTR:
            case CSS_COUNTER:
            case CSS_VARIABLE:
            case CSS_CALC:
                return this.mString;

            default:
                throw INVALID_ACCESS_ERR;
        }
        return ""; // never matches
    }

    public function setStringValue(stringValue : String) : Void {
        switch (this.primitiveType) {
            case CSS_STRING:
            case CSS_IDENT:
            case CSS_URI:
            case CSS_ATTR:
            case CSS_COUNTER:
            case CSS_VARIABLE:
            case CSS_CALC:
                this.mString = stringValue;

            default:
                throw INVALID_ACCESS_ERR;
        }
    }

    public function getRGBColorValue() : CSSColorValue {
        if (CSS_RGBCOLOR == this.primitiveType)
            return cast(this, CSSColorValue);
        throw INVALID_ACCESS_ERR;
    }

    public function getRectValue() : CSSRectValue {
        if (CSS_RECT == this.primitiveType)
            return cast(this, CSSRectValue);
        throw INVALID_ACCESS_ERR;
    }

    public function getCounterValue() : CSSCounterValue {
        if (CSS_COUNTER == this.primitiveType)
            return cast(this, CSSCounterValue);
        throw INVALID_ACCESS_ERR;
    }

    public function new(aPrimitiveType : PrimitiveType) {
        this.primitiveType = aPrimitiveType;
        this.cssValueType = CSS_PRIMITIVE_VALUE;

        this.mUnit = "";
        this.mFloatValue = 0;
        this.mString = "";
    }
}
