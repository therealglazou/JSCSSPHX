import parser.Parser;

import om.CSSValue;
import om.CSSStyleRule;
import om.CSSSelector;

class JSCSSPTest {

    static function main() : Void {
        //new debugger.Local(true);
        var j = new Parser();
        var sheet = j.parse("div h1:nth-last-of-type(-n-1):hover, foo { color: red }", false, false);
        for (i in 0...sheet.cssRules.length) {
            if (sheet.cssRules.item(i).type == STYLE_RULE)
                trace(cast(sheet.cssRules.item(i), CSSStyleRule).cssText);
        }
    }

}

