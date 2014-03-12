
    public function parseURL(token : Token) : String {
        var value = "";
        if (token.isString())
        {
            value += token.value;
            token = this.getToken(true, true);
        }
        else
            while (true)
            {
                if (!token.isNotNull()) {
                    this.reportError(URL_EOF);
                    return "";
                }
                if (token.isWhiteSpace()) {
                    var nextToken = this.lookAhead(true, true);
                    // if next token is not a closing parenthesis, that's an error
                    if (!nextToken.isSymbol(")")) {
                        this.reportError(URL_WS_INSIDE);
                        token = this.currentToken();
                        break;
                    }
                }
                if (token.isSymbol(")")) {
                    break;
                }
                value += token.value;
                token = this.getToken(false, false);
            }
        
        if (token.isSymbol(")")) {
            return value + ")";
        }
        return "";
    }
