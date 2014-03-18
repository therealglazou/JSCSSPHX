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

import om.interfaces.DOMCSSRule;
import om.interfaces.DOMCSSStyleSheet;

class CSSRule implements DOMCSSRule {

    /*
     * from DOMCSSRule interface
     */
    public var type(default, null) : DOMCSSRuleType;
    public var cssText(get, set) : String;
    public var parentStyleSheet(default, null) : DOMCSSStyleSheet;
    public var parentRule(default, null) : DOMCSSRule;

    /*
     * PROPRIETARY
     */
    public var parsedCssText : String;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSRule
     */

    private function get_cssText() : String {
        // should be overriden by subclasses but who knows, eh?
        switch (this.type) {
            case UNKNOWN_RULE:
                return cast(this, CSSUnknownRule).cssText;
            case STYLE_RULE:
                return cast(this, CSSStyleRule).cssText;
            case CHARSET_RULE:
                return cast(this, CSSCharsetRule).cssText;
            case IMPORT_RULE:
                return cast(this, CSSImportRule).cssText;
            case MEDIA_RULE:
                return cast(this, CSSMediaRule).cssText;
            case FONT_FACE_RULE:
                return cast(this, CSSFontFaceRule).cssText;
            case PAGE_RULE:
                return cast(this, CSSPageRule).cssText;
            case KEYFRAMES_RULE:
                return cast(this, CSSKeyframesRule).cssText;
            case KEYFRAME_RULE:
                return cast(this, CSSKeyframeRule).cssText;
            case NAMESPACE_RULE:
                return cast(this, CSSNamespaceRule).cssText;
            case SUPPORTS_RULE:
            case FONT_FEATURE_VALUES_RULE:
        }
        return "";
    }

    private function set_cssText(v : String) : String {
        // should be overriden by subclasses but who knows, eh?
        switch (this.type) {
            case UNKNOWN_RULE:
                return cast(this, CSSUnknownRule).cssText = v;
            case STYLE_RULE:
                return cast(this, CSSStyleRule).cssText = v;
            case CHARSET_RULE:
                return cast(this, CSSCharsetRule).cssText = v;
            case IMPORT_RULE:
                return cast(this, CSSImportRule).cssText = v;
            case MEDIA_RULE:
                return cast(this, CSSMediaRule).cssText = v;
            case FONT_FACE_RULE:
                return cast(this, CSSFontFaceRule).cssText = v;
            case PAGE_RULE:
                return cast(this, CSSPageRule).cssText = v;
            case KEYFRAMES_RULE:
                return cast(this, CSSKeyframesRule).cssText = v;
            case KEYFRAME_RULE:
                return cast(this, CSSKeyframeRule).cssText = v;
            case NAMESPACE_RULE:
                return cast(this, CSSNamespaceRule).cssText = v;
            case SUPPORTS_RULE:
            case FONT_FEATURE_VALUES_RULE:
        }
        return v;
    }

    /*
     * CONSTRUCTOR
     */

    public function new(aType : DOMCSSRuleType,
                        aSheet: DOMCSSStyleSheet,
                        aRule : DOMCSSRule) {
        this.type = aType;
        this.parentStyleSheet = aSheet;
        this.parentRule = aRule;
   }
}
