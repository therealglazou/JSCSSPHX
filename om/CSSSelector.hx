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

import om.interfaces.DOMCSSSelector;
import om.interfaces.DOMCSSValue;

class CSSPseudoClass implements DOMCSSPseudoClass {
    public var name : String;

    public var aguments : Array<DOMCSSValue>;

    public function isPseudoElement() : Bool {
        if (name == "after" ||
            name == "before" ||
			name == "first-line" ||
			name == "first-letter")
			return true;
		return false;
    }
}

class CSSSelector implements DOMCSSSelector {

    public var elementType : String; // could become an Atom
    public var IDList : Array<String>;
    public var ClassList : Array<String>;

    public var AttrList : Array<DOMCSSAttrSelector>;
    public var PseudoClassList : Array<DOMCSSPseudoClass>;

    public var negations : DOMCSSSelector;
    public var parent : DOMCSSSelector;

    public var next : DOMCSSSelector;
    public var pseudoElement : String;

    // do we want namespaces here? not sure we need it

    public var combinator : DOMCSSCombinator;
    public var specificity(get, null) : DOMCSSSelectorSpecificity;

    private function get_specificity() : DOMCSSSelectorSpecificity {
        var specificity : DOMCSSSelectorSpecificity = {a: 0, b:0, c:0, d:0 };
        var s = this;
        while (null != s) {
            specificity.a += s.IDList.length;
            specificity.b += s.ClassList.length + s.AttrList.length;
            if (s.elementType != "*")
                specificity.c += 1;
            for (i in 0...s.PseudoClassList.length-1) {
                var p = cast(s.PseudoClassList[i], CSSPseudoClass);
				if (p.isPseudoElement())
					specificity.c += 1;
				else
					specificity.b += 1;
            }

			if (null != s.negations) {
	            specificity.a += s.negations.IDList.length;
	            specificity.b += s.negations.ClassList.length + s.negations.AttrList.length;
	            if (s.negations.elementType != "*")
	                specificity.c += 1;
	            for (i in 0...s.negations.PseudoClassList.length-1) {
	                var p = cast(s.negations.PseudoClassList[i], CSSPseudoClass);
					if (p.isPseudoElement())
						specificity.c += 1;
					else
						specificity.b += 1;
	            }
			}

            s = cast(s.parent, CSSSelector);
        }

        return specificity;
    }
}
