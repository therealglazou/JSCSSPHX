
    public function parseStyleRule(aToken : Token, aSheet : StyleSheet, aRule : CSSRule) : String {
        var selector = this.parseSelector(aToken, false);
        trace("================");
        /*
        this.preserveState();
        // first let's see if we have a selector here...
        var selector = this.parseSelector(aToken, false);
		trace(selector);
        var valid = false;
        var declarations = [];
        var s = "";
        if (null != selector) {
            selector.selector = StringTools.trim(selector.selector);
            s = selector.selector;
            var token = this.getToken(true, true);
            if (token.isSymbol("{")) {
                s += " { ";
                var token = this.getToken(true, false);
                while (true) {
                    if (!token.isNotNull()) {
                        valid = true;
                        break;
                    }
                    if (token.isSymbol("}")) {
                        s += "}";
                        valid = true;
                        break;
                    } else {
                        var d = this.parseDeclaration(token, declarations, true, true, aSheet, aRule);
                        s += (("" != d && 0 != declarations.length) ? " " : "") + d;
                    }
                    token = this.getToken(true, false);
                }
            }
        }
        else {
            // selector is invalid so the whole rule is invalid with it
        }
        
        if (valid) {
            var rule = new CSSStyleRule(selector.selector, STYLE_RULE, aSheet, aRule);
            // TBD don't forget to add the declarations...
            rule.parsedCssText = s;
            if (null != aRule) // that's a media rule
                cast(aRule, CSSMediaRule)._appendRule(rule);
            else
                aSheet._appendRule(rule);
            return s;
        }
        this.restoreState();
        s = this.currentToken().value;
        this.addUnknownAtRule(aSheet, aRule, s);
        */

        return "";
    }
