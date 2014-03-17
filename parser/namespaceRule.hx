    
    public function parseNamespaceRule(aToken : Token, aSheet : StyleSheet) : Bool {
        var s = aToken.value;
        var valid = false;
        this.preserveState();
        var token = this.getToken(true, true);
        if (token.isNotNull()) {
            var prefix = "";
            var url = "";
            if (token.isIdent()) {
                prefix = token.value;
                s += " " + prefix;
                token = this.getToken(true, true);
            }
            var foundURL = false;
            if (token.isNotNull()) {
                if (token.isString()) {
                    foundURL = true;
                    url = token.value;
                    s += " " + url;
                } else if (token.isFunction("url(")) {
                    // get a url here...
                    token = this.getToken(true, true);
                    var urlContent = this.parseURL(token);
                    if ("" != urlContent) {
                        url += "url(" + urlContent;
                        foundURL = true;
                        s += " " + urlContent;
                    }
                }
            }
            if (foundURL) {
                token = this.getToken(true, true);
                if (token.isSymbol(";")) {
                    s += ";";
                    this.forgetState();
                    var rule = new CSSNamespaceRule(url, prefix, NAMESPACE_RULE, aSheet, null);
                    rule.parsedCssText = s;
                    aSheet._appendRule(rule);
                    return true;
                }
            }
            
        }
        this.restoreState();
        this.addUnknownAtRule(aSheet, null, "@namespace");
        return false;
    };
    
