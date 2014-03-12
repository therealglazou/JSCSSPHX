    public function parseImportRule(aToken : Token, aSheet : StyleSheet) : Bool {
        var s = aToken.value;
        this.preserveState();
        var token = this.getToken(true, true);
        var media = [];
        var href = "";
        if (token.isString()) {
            href = token.value;
            s += " " + href;
        }
        else if (token.isFunction("url(")) {
            token = this.getToken(true, true);
            var urlContent = this.parseURL(token);
            if ("" != urlContent) {
                href = "url(" + urlContent;
                s += " " + href;
            }
        }
        else
            this.reportError(IMPORT_RULE_MISSING_URL);
        
        if ("" != href) {
            token = this.getToken(true, true);
            while (token.isIdent()) {
                s += " " + token.value;
                media.push(token.value);
                token = this.getToken(true, true);
                if (!token.isNotNull())
                    break;
                if (token.isSymbol(",")) {
                    s += ",";
                } else if (token.isSymbol(";")) {
                    break;
                } else
                    break;
                token = this.getToken(true, true);
            }
            
            if (0 == media.length) {
                media.push("all");
            }
            
            if (token.isSymbol(";")) {
                s += ";";
                this.forgetState();
                var rule = new CSSImportRule(href, IMPORT_RULE, aSheet, null);
                rule.parsedCssText = s;
                for (i in 0...media.length - 1)
                    rule.media.appendMedium(media[i]);
                aSheet._appendRule(rule);
                return true;
            }
        }
        
        this.restoreState();
        this.addUnknownAtRule(aSheet, "@import");
        return false;
    };
    
