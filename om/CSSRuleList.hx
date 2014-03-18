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

import om.interfaces.DOMCSSRuleList;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMException;

class CSSRuleList implements DOMCSSRuleList {

    /*
     * from DOMCSSRuleList interface
     */
    public var length(get, null) : UInt;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSRuleList
     */

    private var mRules : Array<DOMCSSRule>;

    private function get_length() : UInt {
        return this.mRules.length;
    }

    public function item(index : UInt) : DOMCSSRule {
        if (index < this.mRules.length)
            return this.mRules[index];
        return null;
    }

    /*
     * NOT AVAILABLE TO END-USER
     */

    public function _insertRule(rule: String, index: UInt) : UInt {
        /// TBD when parsing is done
        return 0;
    }

    public function _appendRule(rule : DOMCSSRule) : Void {
        this.mRules.push(rule);
    }

    public function _deleteRule(index: UInt) : Void {
        if (index >= this.mRules.length)
            throw INDEX_SIZE_ERR;
        this.mRules.splice(index, 1);
    }

    /*
     * CONSTRUCTOR
     */

    public function new() {
        this.mRules = [];
    }
}
