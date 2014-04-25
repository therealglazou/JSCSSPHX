
    public function parseFontFaceRule(aToken : Token, aSheet : StyleSheet) : Bool {
        var s = aToken.value;
        var valid = false;
        var descriptors = [];
        this.preserveState();
        var token = this.getToken(true, true);
        if (token.isNotNull()) {
            // expecting block start
            if (token.isSymbol("{")) {
                s += " " + token.value;
                var token = this.getToken(true, false);
                while (true) {
                    if (token.isSymbol("}")) {
                        s += "}";
                        valid = true;
                        break;
                    } else {
                        var d = this.parseDeclaration(token, descriptors, false, false, aSheet, null);
                        s += ((d && descriptors.length) ? " " : "") + d;
                    }
                    token = this.getToken(true, false);
                }
            }
        }
        if (valid) {
            this.forgetState();
            var rule = new CSSFontFaceRule();
            rule.parsedCssText = s;
            rule.descriptors = descriptors;
            rule.parentStyleSheet = aSheet;
            aSheet.cssRules.push(rule);
            return true;
        }
        this.restoreState();
        return false;
    }
