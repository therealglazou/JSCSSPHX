
    public function parseDeclaration(aToken : Token,
                                     aDecl : Array<Declaration>,
                                     aAcceptPriority : Bool,
                                     aExpandShorthands : Bool,
                                     aSheet : StyleSheet,
                                     aRule : CSSRule) : String {
        this.preserveState();
        var blocks = [];
        if (aToken.isIdent()) {
            var descriptor = aToken.value.toLowerCase();
            var token = this.getToken(true, true);
            if (token.isSymbol(":")) {
                var token = this.getToken(true, true);
                
                var declarations = [];
                var value = this.parseDefaultPropertyValue(token, null, null);
                token = this.currentToken();
                if (null != value) // no error above
                {
                    var priority = false;
                    if (token.isSymbol("!")) {
                        token = this.getToken(true, true);
                        if (token.isIdent("important")) {
                            priority = true;
                            token = this.getToken(true, true);
                            if (token.isSymbol(";") || token.isSymbol("}")) {
                                if (token.isSymbol("}"))
                                    this.ungetToken();
                            }
                            else return "";
                        }
                        else return "";
                    }
                    else if (token.isNotNull() && !token.isSymbol(";") && !token.isSymbol("}"))
                        return "";
                    for (i in 0...declarations.length - 1) {
                        declarations[i].priority = (priority ? "important" : "");
                        aDecl.push({ property : declarations[i].property,
                                     value:     declarations[i].value,
                                     priority : declarations[i].priority });
                    }
                    return descriptor + ": " + value + ";";
                }
            }
        }
        else if (aToken.isComment()) {
            /* Original jscssp code but we can't preserve comments inside
             * CSS OM's CSSRule, unfortunately...
             *
            if (this.mPreserveComments) {
                this.forgetState();
                var comment = new CSSUnknownRule(aToken.value, UNKNOWN_RULE, aSheet, aRule);
                comment.parsedCssText = aToken.value;
                aDecl.push(comment);
            }
            return aToken.value;
            */
            return "";
        }
        
        // we have an error here, let's skip it
        this.restoreState();
        var s = aToken.value;
        blocks = [];
        var token = this.getToken(false, false);
        while (token.isNotNull()) {
            s += token.value;
            if ((token.isSymbol(";") || token.isSymbol("}")) && 0 == blocks.length) {
                if (token.isSymbol("}"))
                    this.ungetToken();
                break;
            } else if (token.isSymbol("{")
                                 || token.isSymbol("(")
                                 || token.isSymbol("[")
                                 || token.isFunction()) {
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
                    }
                }
            }
            token = this.getToken(false, false);
        }
        return "";
    }
    