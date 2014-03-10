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
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSRule
     */

    private function get_cssText() : String {
        // should be overriden by subclasses but who knows, eh?
        switch (this.type) {
            case UNKNOWN_RULE:
            case STYLE_RULE:
                return cast(this, CSSStyleRule).cssText;
            case CHARSET_RULE:
            case IMPORT_RULE:
            case MEDIA_RULE:
            case FONT_FACE_RULE:
            case PAGE_RULE:
            case KEYFRAMES_RULE:
            case KEYFRAME_RULE:
            case MOZ_KEYFRAMES_RULE:
            case MOZ_KEYFRAME_RULE:
            case NAMESPACE_RULE:
            case SUPPORTS_RULE:
            case FONT_FEATURE_VALUES_RULE:
        }
        return "";
    }

    private function set_cssText(v : String) : String {
        return v;
    }

    /*
     * CONSTRUCTOR
     */

    public function new() {
        this.type = DOMCSSRuleType.UNKNOWN_RULE;
        this.parentStyleSheet = null;
        this.parentRule = null;
   }
}
