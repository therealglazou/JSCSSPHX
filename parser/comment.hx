
    public function addComment(aSheet : StyleSheet, aString : String) : Void {
        var rule = new CSSUnknownRule(aString, UNKNOWN_RULE, aSheet, null);
        rule.parsedCssText = aString;
        aSheet._appendRule(rule);
    }
