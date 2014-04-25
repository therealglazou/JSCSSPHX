
    public function parseDefaultPropertyValue(token : Token,
                                              cssValue : CSSValue,
                                              parentCssValue : CSSValue) : CSSValue {

        var blocks : Array<String> = [];
        var foundComma = false;
        while (token.isNotNull()) { // iterate until end of stylesheet if needed

            // is it the end of this declaration or of the block?
            if ((token.isSymbol(";")
                 || token.isSymbol("}")
                 || token.isSymbol("!"))
                && 0 == blocks.length) {
                // unget the current token if we're closing the block
                if (token.isSymbol("}"))
                    this.ungetToken();
                break;
            }

            // look for reserved idents
            if (token.isIdent("inherit")
                || token.isIdent("initial")) {
                // this is ok only if we have no other value already
                if (null != cssValue)
                    return null;
                cssValue = new CSSValue(CSS_IDENT);
                cssValue.setStringValue(token.value);
                token = this.getToken(true, true);
                break;
            }

            // do we open a block?
            else if (token.isSymbol("{")
                     || token.isSymbol("(")
                     || token.isSymbol("[")) {
                blocks.push(token.value);
            }

            // or close a block?
            else if (token.isSymbol("}")
                     || token.isSymbol("]")
                     || token.isSymbol(")")) {
                // are we in a function?
                if (null != parentCssValue
                    && parentCssValue.type == CSS_VALUE_LIST
                    && parentCssValue.getStringValue() != "") {
                    // yes we are
                    return parentCssValue;
                }
                if (0 != blocks.length) {
                    var ontop = blocks[blocks.length - 1];
                    if ((token.isSymbol("}") && ontop == "{")
                        || (token.isSymbol("]") && ontop == "[")
                        || (token.isSymbol(")") && ontop == "(")) {
                        blocks.pop();
                    }
                }
            }

            var newValue : CSSValue = null;
            if (token.isSymbol(",")) {
                // we have a comma-separated of values or of list of values
                if (null == cssValue) {
                    if (null == parentCssValue) {
                        // in that case, the comma is right after the declaration's colon
                        // treat it as a symbol
                        newValue = new CSSValue(CSS_SYMBOL);
                        newValue.setStringValue(",");
                    }
                    else if (parentCssValue.commaSeparated) {
                        // parent value list is already comma-separated
                        // do nothing...
                        foundComma = true;
                    }
                    else {
                        foundComma = true;
                        // parent value is whitespace-separated so it is
                        // not the right parent for the next value
                        if (null != parentCssValue.parentValue) // must be comma-separated
                            parentCssValue = parentCssValue.parentValue;
                        else {
                            // create a new comma-separated list above the parent
                            var newParentCssValue = new CSSValue(CSS_VALUE_LIST);
                            newParentCssValue.commaSeparated = true;
                            newParentCssValue.setStringValue("");
                            newParentCssValue._appendValue(parentCssValue);
                            parentCssValue = newParentCssValue;
                        }
                    }
                }
                else {
                    foundComma = true;
                    // we already have an arbitrary value
                }
            }

            else {
                if (token.isSymbol("#")) {
                    token = this.getHexValue();
                    if (!token.isHex())
                        return null;
                    var length = token.value.length;
                    if (length != 3 && length != 6)
                        return null;
                    if (token.value.match( ~/[a-fA-F0-9]/g ).length != length)
                        return null;
                    newValue = new CSSValue(CSS_HEX_COLOR);
                    newValue.setStringValue(token.value);
                }
    
                else if (token.isString()) {
                    newValue = new CSSValue(CSS_STRING);
                    newValue.setStringValue(token.value.substr(1, token.value.length - 2));
                }
    
                else if (token.isNumber()) {
                    newValue = new CSSValue(CSS_NUMBER);
                    newValue.setFloatValue(Std.parseFloat(token.value));
                }
    
                else if (token.isSymbol()) {
                    newValue = new CSSValue(CSS_SYMBOL);
                    newValue.setStringValue(token.value);
                }
    
                else if (token.isIdent()) {
                    newValue = new CSSValue(CSS_STRING);
                    newValue.setStringValue(token.value);
                }
    
                else if (token.isPercentage()) {
                    newValue = new CSSValue(CSS_UNIT);
                    newValue.setFloatValue(Std.parseFloat(token.value));
                    newValue.setStringValue("%");
                }
    
                else if (token.isDimension()) {
                    newValue = new CSSValue(CSS_UNIT);
                    newValue.setFloatValue(Std.parseFloat(token.value));
                    newValue.setStringValue(token.unit);
                }
    
                else if (token.isFunction()) {
                    // the painful part...
                    newValue = new CSSValue(CSS_VALUE_LIST);
                    newValue.commaSeparated = true;
                    newValue.setStringValue(token.value.substr(0, token.value.length - 1));
    
                    token = this.getToken(true, true);
                    this.parseDefaultPropertyValue(token, null, newValue);
                }
			}

            // do we have a new value to store
            if (null != newValue) {
                // yes we do...
                if (null != parentCssValue) {
					parentCssValue._appendValue(newValue);
				}
            }

            token = this.getToken(true, true);
        }

        return cssValue;
    }
    
