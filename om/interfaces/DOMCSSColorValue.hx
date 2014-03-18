package om.interfaces;

import om.interfaces.DOMCSSPrimitiveValue;

interface DOMCSSColorValue extends DOMCSSPrimitiveValue {

    var top(default, null)    : DOMCSSPrimitiveValue;
    var right(default, null)  : DOMCSSPrimitiveValue;
    var bottom(default, null) : DOMCSSPrimitiveValue;
    var left(default, null)   : DOMCSSPrimitiveValue;
}
