package om.interfaces;

import om.interfaces.DOMCSSPrimitiveValue;

interface DOMCSSColorValue extends DOMCSSPrimitiveValue {

    var red : Float;
    var green : Float;
    var blue : Float;

    var isRedPercentage : Bool;
    var isGreenPercentage : Bool;
    var isBluePercentage : Bool;

    var alphaValue : Float;

    var hue : Float;
    var saturation : Float;
    var lightness : Float;

    var isHSL : Bool;
}
