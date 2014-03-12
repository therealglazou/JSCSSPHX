
    public function new() {
        this.mPreserveWS = false;
        this.mPreserveComments = false;
        this.mPreservedTokens = [];
        this.mError = null;
    }

    public function parse(aString: String, aPreserveWS: Bool, aPreserveComments: Bool) : StyleSheet {
        mPreserveWS = aPreserveWS;
        mPreserveComments = aPreserveComments;
        mPreservedTokens = [];
        mError = null;

        // init the scanner with our string to parse
        mScanner = new Scanner(aString);

        // get ready for OM storage
        var sheet = new StyleSheet();

        // let's dance, baby...
        var token = this.getToken(false, false);
        if (!token.isNotNull())
            return sheet;

        if (token.isAtRule("@charset")) {
            this.ungetToken();
            this.parseCharsetRule(sheet);
            token = this.getToken(false, false);
        }

        var foundStyleRules     = false;
        var foundImportRules    = false;
        var foundNamespaceRules = false;
        while (true) {
            if (!token.isNotNull())
                break;

            if (token.isWhiteSpace()) {
                if (mPreserveWS)
                    this.addWhitespace(sheet, token.value);
            }

            else if (token.isComment()) {
                if (mPreserveComments)
                    this.addComment(sheet, token.value);
            }

            else if (token.isAtRule("@import")) {
                if (token.isAtRule("@import")) {
                    // @import rules MUST occur before all style and namespace rules
                    if (!foundStyleRules && !foundNamespaceRules)
                        foundImportRules = this.parseImportRule(token, sheet);
                    else {
                        this.reportError(IMPORT_RULE_POSITION);
                        this.addUnknownAtRule(sheet, token.value);
                    }
                }
            }
            else if (token.isAtRule("@namespace")) {
                // @namespace rules MUST occur before all style rule and
                // after all @import rules
                if (!foundStyleRules)
                    foundNamespaceRules = this.parseNamespaceRule(token, sheet);
                else {
                    this.reportError(NAMESPACE_RULE_POSITION);
                    this.addUnknownAtRule(sheet, token.value);
                }
            }
        }
        // STUB
        return null;
    }
