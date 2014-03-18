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
 * Samsung Electronic Co. Ltd
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

import om.interfaces.DOMCSSStyleDeclaration;
import om.interfaces.DOMCSSRule;

class CSSStyleDeclaration implements DOMCSSStyleDeclaration {

    /*
     * from DOMCSSStyleDeclaration interface
     */
    public var cssText(get, set) : String;
    public var length(get, null) : UInt;
    public var parentRule : DOMCSSRule;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSStyleDeclaration
     */

    private var mPropertyNameArray : Array<String>; 
    private var mPropertyValueArray : Array<String>; 
    private var mPropertyPriorityArray : Array<String>; 

    private function get_cssText() : String {
        var rv : String = "";
        for (i in 0...this.mPropertyNameArray.length - 1) {
            rv += ("" != rv) ? " " : "";
            rv += this.mPropertyNameArray[i] + ": " + this.mPropertyValueArray[i];
            if ("" != this.mPropertyPriorityArray[i])
                rv += " !important";
            rv += ";";
        }
        return rv;
    }

    private function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    private function get_length() : UInt {
        return this.mPropertyNameArray.length;
    }

    public function getPropertyValue(propertyName : String) : String {
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index)
            return "";
        return this.mPropertyValueArray[index];
    }

    public function getPropertyPriority(propertyName : String) : String {
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index)
            return "";
        return this.mPropertyPriorityArray[index];
    }

    public function removeProperty(propertyName : String) : String {
        // TBD deal with shorthands
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index)
            return "";
        var value = this.mPropertyValueArray[index];
        this.mPropertyNameArray.splice(index, 1);
        this.mPropertyValueArray.splice(index, 1);
        this.mPropertyPriorityArray.splice(index, 1);
        return value;
    }

    public function setProperty(propertyName : String,
                                value : String,
                                ?priority : String = "") : Void {
        // TBD validate value when parsing and om are done
        // TBD deal with shorthands
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index) {
            this.mPropertyNameArray.push(propertyName);
            this.mPropertyValueArray.push(value);
            this.mPropertyPriorityArray.push(priority);
        }
        else {
            this.mPropertyNameArray[index] = propertyName;
            this.mPropertyValueArray[index] = value;
            this.mPropertyPriorityArray[index] = priority;
        }
    }

    public function item(index : UInt) : String {
        if (index < this.mPropertyNameArray.length)
            return this.mPropertyNameArray[index];
        return "";
    }

    /*
     * CONSTRUCTOR
     */
    public function new() {
        this.parentRule = null;
        this.mPropertyNameArray = [];
        this.mPropertyValueArray = [];
        this.mPropertyPriorityArray = [];
    }
}
