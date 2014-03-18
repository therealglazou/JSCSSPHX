package om;

import om.interfaces.DOMCSSPrimitiveValue;
import om.interfaces.DOMCSSValue;
import om.interfaces.DOMCSSColorValue;
import om.interfaces.DOMException;

class CSSColorValue implements DOMCSSColorValue {

    /*
     * from DOMCSSValue interface
     */
    public var cssText(get, set) : String;
    public var cssValueType(default, null) : CSSValueType;

    /*
     * from DOMCSSPrimitiveValue interface
     */
    public var primitiveType(default, null) : PrimitiveType;
    
    /*
     * from DOMCSSColorValue interface
     */
    public var red : Float;
    public var green : Float;
    public var blue : Float;

    public var isRedPercentage : Bool;
    public var isGreenPercentage : Bool;
    public var isBluePercentage : Bool;

    public var alphaValue : Float;

    public var hue : Float;
    public var saturation : Float;
    public var lightness : Float;

    public var isHSL : Bool;
    
    /*
    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSValue
     */

    public function get_cssText() : String {
        if (this.isHSL)
            return "hsl" + (1 == this.alphaValue ? "" : "a") + "("
                         + this.hue + ", "
                         + this.saturation + "%, "
                         + this.lightness + "%"
                         + (1 == this.alphaValue ? "" : ", " + this.alphaValue)
                         + ")";

        return "rgb" + (1 == this.alphaValue ? "" : "a") + "("
                     + this.red + (this.isRedPercentage ? "%" : "") + ", "
                     + this.green + (this.isGreenPercentage ? "%" : "") + ", "
                     + this.blue + (this.isBluePercentage ? "%" : "")
                     + (1 == this.alphaValue ? "" : ", " + this.alphaValue)
                      + ")";
    }

    public function set_cssText(v : String) : String {
        // TBD
        throw NO_MODIFICATION_ALLOWED_ERR;
    }

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSPrimitiveValue
     */

    public function setFloatValue(unit : String, floatValue : Float) : Void {
        throw INVALID_ACCESS_ERR;
    }

    public function getFloatValue() : Float {
        throw INVALID_ACCESS_ERR;
    }

    public function getFloatUnit() : String {
        throw INVALID_ACCESS_ERR;
    }

    public function getStringValue() : String {
        throw INVALID_ACCESS_ERR;
    }

    public function setStringValue(stringValue : String) : Void {
        throw INVALID_ACCESS_ERR;
    }

    public function new() {
        this.primitiveType = CSS_RGBCOLOR;
        this.cssValueType = CSS_PRIMITIVE_VALUE;

        this.red = 0;
        this.green = 0;
        this.blue = 0;
        
        this.isRedPercentage = false;
        this.isGreenPercentage = false;
        this.isBluePercentage = false;

        this.alphaValue = 1;

        this.isHSL = false;
    }
}
