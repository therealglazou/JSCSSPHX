package om;

import om.interfaces.DOMCSSRuleList;
import om.interfaces.DOMCSSRule;
import om.interfaces.DOMException;

class CSSRuleList implements DOMCSSRuleList {

    /*
     * from DOMCSSRuleList interface
     */
    public var length(get, null) : UInt;

    /*
     * http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSRuleList
     */

    private var mRules : Array<DOMCSSRule>;

    private function get_length() : UInt {
        return this.mRules.length;
    }

    public function item(index : UInt) : DOMCSSRule {
        if (index < this.mRules.length)
            return this.mRules[index];
        return null;
    }

    /*
     * NOT AVAILABLE TO END-USER
     */

    public function _insertRule(rule: String, index: UInt) : UInt {
        /// TBD when parsing is done
        return 0;
    }

    public function _deleteRule(index: UInt) : Void {
        if (index >= this.mRules.length)
            throw INDEX_SIZE_ERR;
        this.mRules.splice(index, 1);
    }

    /*
     * CONSTRUCTOR
     */

    public function new() {
        this.mRules = [];
    }
}
