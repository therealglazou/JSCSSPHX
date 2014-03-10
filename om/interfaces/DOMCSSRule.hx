package om.interfaces;

import om.interfaces.DOMCSSStyleSheet;

enum DOMCSSRuleType {
    UNKNOWN_RULE;
    STYLE_RULE;
    CHARSET_RULE;
    IMPORT_RULE;
    MEDIA_RULE;
    FONT_FACE_RULE;
    PAGE_RULE;
    KEYFRAMES_RULE;
    KEYFRAME_RULE;
    MOZ_KEYFRAMES_RULE;
    MOZ_KEYFRAME_RULE;
    NAMESPACE_RULE;
    SUPPORTS_RULE;
    FONT_FEATURE_VALUES_RULE;             
}

interface DOMCSSRule {

    /*
     * readonly attribute unsigned short      type;
     */
    var type(default, null) : DOMCSSRuleType;

    /*
     *          attribute DOMString        cssText;
     *                                       // raises(DOMException) on setting
     */
    var cssText(get, set) : String;

    /*
     * readonly attribute nsIDOMCSSStyleSheet parentStyleSheet;
     */
    var parentStyleSheet(default, null) : DOMCSSStyleSheet;

    /*
     * readonly attribute nsIDOMCSSRule       parentRule;
     */
    var parentRule(default, null) : DOMCSSRule;
}
