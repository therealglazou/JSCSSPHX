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

    public function new() {
        this.type = DOMCSSRuleType.UNKNOWN_RULE;
        this.parentStyleSheet = null;
        this.parentRule = null;
   }
}
