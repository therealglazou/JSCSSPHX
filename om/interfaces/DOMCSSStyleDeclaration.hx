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

package om.interfaces;

import om.interfaces.DOMCSSRule;

interface DOMCSSStyleDeclaration {

    /*
     *          attribute DOMString        cssText;
     */
    var cssText(get, set) : String;

    /*
     * DOMString          getPropertyValue(in DOMString propertyName);
     */
    function getPropertyValue(propertyName : String) : String;

    /*
     * nsIDOMCSSValue     getPropertyCSSValue(in DOMString propertyName);
     */
    // function getPropertyCSSValue(propertyName : String) : DOMCSSValue;

    /*
     * DOMString          removeProperty(in DOMString propertyName)
     *                                       raises(DOMException);
     */
    function removeProperty(propertyName : String) : String;

    /*
     * DOMString          getPropertyPriority(in DOMString propertyName);
     */
    function getPropertyPriority(propertyName : String) : String;

    /*
     * void               setProperty(in DOMString propertyName,
     *                                in DOMString value, 
     *                                [optional] in DOMString priority)
     *                                       raises(DOMException);
     */
    function setProperty(propertyName : String,
                         value : String,
                         ?priority : String = "") : Void;

    /*
     * readonly attribute unsigned long    length;
     */
    var length(get, null) : UInt;

    /*
     * DOMString          item(in unsigned long index);
     */
    function item(index : UInt) : String;

    /*
     * readonly attribute nsIDOMCSSRule    parentRule;
     */
    var parentRule : DOMCSSRule;
}
