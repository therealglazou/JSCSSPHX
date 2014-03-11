
    public function parseCharsetRule(aSheet : StyleSheet) : Bool {
        var token = this.getToken(false, false);
        var s = "";
        if (token.isAtRule("@charset") && token.value == "@charset") { // lowercase check
            s = token.value;
            token = this.getToken(false, false);
            s += token.value;
            if (token.isWhiteSpace(" ")) {
                token = this.getToken(false, false);
                s += token.value;
                if (token.isString()) {
                    var encoding = token.value;
                    token = this.getToken(false, false);
                    s += token.value;
                    if (token.isSymbol(";")) {
                        var rule = new CSSCharsetRule(encoding, CHARSET_RULE, aSheet, null);
                        rule.parsedCssText = s;
                        aSheet._appendRule(rule);
                        return true;
                    }
                    else
                        this.reportError(CHARSET_RULE_MISSING_SEMICOLON);
                }
                else
                    this.reportError(CHARSET_RULE_CHARSET_IS_STRING);
            }
            else
                this.reportError(CHARSET_RULE_MISSING_WS);
        }
      
        var rule = new CSSCharsetRule(s, CHARSET_RULE, aSheet, null);
        aSheet._appendRule(rule);
        return false;
    }
