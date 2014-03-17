
    public function addUnknownAtRule(aSheet : StyleSheet, aRule: CSSRule, aString : String) : Void {
        var blocks = [];
        var token = this.getToken(false, false);
        while (token.isNotNull()) {
            aString += token.value;
            if (token.isSymbol(";") && 0 == blocks.length)
                break;
            else if (token.isSymbol("{")
                             || token.isSymbol("(")
                             || token.isSymbol("[")
                             || token.type == FUNCTION_TYPE) {
                blocks.push(token.isFunction() ? "(" : token.value);
            } else if (token.isSymbol("}")
                                 || token.isSymbol(")")
                                 || token.isSymbol("]")) {
                if (0 != blocks.length) {
                    var ontop = blocks[blocks.length - 1];
                    if ((token.isSymbol("}") && ontop == "{")
                            || (token.isSymbol(")") && ontop == "(")
                            || (token.isSymbol("]") && ontop == "[")) {
                        blocks.pop();
                        if (0 == blocks.length && token.isSymbol("}"))
                            break;
                    }
                }
            }
            token = this.getToken(false, false);
        }
        
        this.addUnknownRule(aSheet, aRule, aString);
    }
    
    public function addUnknownRule(aSheet : StyleSheet, aRule : CSSRule, aString : String) {
        var errorMsg = this.consumeError();
        var rule = new CSSUnknownRule(errorMsg, UNKNOWN_RULE, aSheet, null);
        rule.parsedCssText = aString;
        if (null != aRule)
            cast(aRule, CSSMediaRule)._appendRule(rule);
        else
            aSheet._appendRule(rule);
    }
    
