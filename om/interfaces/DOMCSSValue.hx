package om.interfaces;

/*
 *   // UnitTypes
 *  const unsigned short      CSS_INHERIT                    = 0;
 *  const unsigned short      CSS_PRIMITIVE_VALUE            = 1;
 *  const unsigned short      CSS_VALUE_LIST                 = 2;
 *  const unsigned short      CSS_CUSTOM                     = 3;
 */
enum CSSValueType {
  CSS_INHERIT;
  CSS_INITIAL;
  CSS_PRIMITIVE_VALUE;
  CSS_VALUE_LIST;

  // CSS_CUSTOM;
}

interface DOMCSSValue {

    /*
     *          attribute DOMString        cssText;
     *                                       // raises(DOMException) on setting
     */
    var cssText(get, set) : String;

    /*
     * readonly attribute unsigned short   cssValueType;
     */
    var cssValueType(default, null) : CSSValueType;
}
