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

import om.interfaces.DOMCSSMediaRule;
import om.interfaces.DOMMediaList;
import om.interfaces.DOMCSSRuleList;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSStyleSheet;

import om.MediaList;

class CSSMediaRule extends CSSRule
                   implements DOMCSSMediaRule {

    /*
     * from DOMCSSMediaRule interface
     */

    public var media(default, null) : DOMMediaList;
    public var cssRules(default, null) : DOMCSSRuleList;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSMediaRule
     */

    public function insertRule(rule: String, index: UInt) : UInt {
        return cast(this.cssRules, CSSRuleList)._insertRule(rule, index);
    }

    public function deleteRule(index: UInt) : Void {
        cast(this.cssRules, CSSRuleList)._deleteRule(index);
    }

    override function get_cssText() : String {
        var rv : String = "@media ";
        var m : String = this.media.mediaText;
        if ("" == m)
            rv += "all";
        else
            rv += " " + m;
        rv += " {";
        // TBD browse cssRules
        rv += " }";
        return rv;
    }

    override function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    /*
     * PROPRIETARY
     */
    
    public function _appendRule(rule : CSSRule) : Void {
        cast(this.cssRules, CSSRuleList)._appendRule(rule);
    }

    /*
     * CONSTRUCTOR
     */
    public function new(aType : DOMCSSRuleType,
                        aSheet: DOMCSSStyleSheet,
                        aRule : DOMCSSRule) {
        super(aType, aSheet, aRule);
        this.media = new MediaList();
    }
}
