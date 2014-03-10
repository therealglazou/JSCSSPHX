package om;

import om.interfaces.DOMCSSStyleDeclaration;
import om.interfaces.DOMCSSRule;

class CSSStyleDeclaration implements DOMCSSStyleDeclaration {

    /*
     * from DOMCSSStyleDeclaration interface
     */
    public var cssText(get, set) : String;
    public var length(get, null) : UInt;
    public var parentRule : DOMCSSRule;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSStyleDeclaration
     */

    private var mPropertyNameArray : Array<String>; 
    private var mPropertyValueArray : Array<String>; 
    private var mPropertyPriorityArray : Array<String>; 

    private function get_cssText() : String {
        // TBD when serializer and om are done
        return "";
    }

    private function set_cssText(v : String) : String {
        // TBD when parsing and om are done
        return v;
    }

    private function get_length() : UInt {
        return this.mPropertyNameArray.length;
    }

    public function getPropertyValue(propertyName : String) : String {
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index)
            return "";
        return this.mPropertyValueArray[index];
    }

    public function getPropertyPriority(propertyName : String) : String {
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index)
            return "";
        return this.mPropertyPriorityArray[index];
    }

    public function removeProperty(propertyName : String) : String {
        // TBD deal with shorthands
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index)
            return "";
        var value = this.mPropertyValueArray[index];
        this.mPropertyNameArray.splice(index, 1);
        this.mPropertyValueArray.splice(index, 1);
        this.mPropertyPriorityArray.splice(index, 1);
        return value;
    }

    public function setProperty(propertyName : String,
                                value : String,
                                ?priority : String = "") : Void {
        // TBD validate value when parsing and om are done
        // TBD deal with shorthands
        var index = this.mPropertyNameArray.indexOf(propertyName);
        if (-1 == index) {
            this.mPropertyNameArray.push(propertyName);
            this.mPropertyValueArray.push(value);
            this.mPropertyPriorityArray.push(priority);
        }
        else {
            this.mPropertyNameArray[index] = propertyName;
            this.mPropertyValueArray[index] = value;
            this.mPropertyPriorityArray[index] = priority;
        }
    }

    public function item(index : UInt) : String {
        if (index < this.mPropertyNameArray.length)
            return this.mPropertyNameArray[index];
        return "";
    }

    /*
     * CONSTRUCTOR
     */
    public function new() {
        this.parentRule = null;
        this.mPropertyNameArray = [];
        this.mPropertyValueArray = [];
        this.mPropertyPriorityArray = [];
    }
}
