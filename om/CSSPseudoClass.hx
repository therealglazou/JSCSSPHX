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

import om.interfaces.DOMCSSPseudoClass;
import om.interfaces.DOMCSSValue;

class CSSPseudoClass implements DOMCSSPseudoClass {
    public var name : String;

    public var arguments : Array<DOMCSSValue>;
    public var cssText(get, null) : String;

    private var mPeudoElementList = [
        "after",
        "before",
        "first-line",
        "first-letter"
    ];

    private var mPeudoClassList = [
        "hover",
        "active",
        "focus",
        "enabled",
        "disabled",
        "checked",
        "indeterminate",
        "root",
        "first-child",
        "last-child",
        "first-of-type",
        "last-of-type",
        "only-child",
        "only-of-type",
        "empty"
    ];

    private var mFunctionalPseudoClassList = [
        "lang(",
        "nth-child(",
        "nth-last-child(",
        "nth-of-type(",
        "nth-last-of-type(",
        "not("
    ];


    public function isPseudoElement() : Bool {
        return (-1 != this.mPeudoElementList.indexOf(this.name));
    }

    public function isPseudoClass() : Bool {
        return (-1 != this.mPeudoClassList.indexOf(this.name));
    }

    public function isFunctionalPseudoClass() : Bool {
        return (-1 != this.mFunctionalPseudoClassList.indexOf(this.name));
    }

    private function get_cssText() : String {
        if (this.isPseudoElement()) {
            return "::" + this.name;
        }
        if (this.isPseudoClass()) {
            return ":" + this.name;
        }

        if ("lang(" == this.name) {
            var s = "";
            for (i in 0...this.arguments.length-1) {
                if ("" != s)
                    s += ", ";
                s += this.arguments[i].cssText;
            }
            return ":lang(" + s + ")";
        }

        // we're in the :foo(an+b) case because negations are stored differently
        if (this.arguments.length != 2) // Houston, we have a problem...
            return "";
        var a = this.arguments[1].getFloatValue();
        var b = this.arguments[1].getFloatValue();
        var s = "";
        if (a != 0)
            s = Std.string(a) + "n";
        if (b > 0) {
            if ("" == s)
                s = Std.string(b);
            else
                s += "+" + Std.string(b);
        }
        else if (b < 0)
            s += Std.string(b);

        return ":" + this.name + s + ")";
    }

    public function new() {
        this.name = "";
        this.arguments = [];
    }
}