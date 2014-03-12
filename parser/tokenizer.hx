
    /*
     * TOKENIZATION
     */

    public function currentToken() : Token {
        return mToken;
    }

    public function getToken(aSkipWS : Bool, aSkipComment : Bool) : Token {
        if (null != mLookAhead) {
            mToken = mLookAhead;
            mLookAhead = null;
            return mToken;
        }

        mToken = mScanner.nextToken();
        while (null != mToken
               && ((aSkipWS && mToken.isWhiteSpace())
                   || (aSkipComment && mToken.isComment())))
            mToken = mScanner.nextToken();

        return mToken;
    }

    public function ungetToken() : Void {
        mLookAhead = mToken;
    }

    public function lookAhead(aSkipWS : Bool, aSkipComment : Bool) : Token {
        var preservedToken = mToken;
        mScanner.preserveState();
        var token = getToken(aSkipWS, aSkipComment);
        mScanner.restoreState();
        mToken = preservedToken;

        return token;
    }

    public function preserveState() {
        this.mPreservedTokens.push(this.currentToken());
        this.mScanner.preserveState();
    }

    public function restoreState() {
        if (0 != this.mPreservedTokens.length) {
            this.mScanner.restoreState();
            this.mToken = this.mPreservedTokens.pop();
        }
    }

    public function forgetState() {
        if (0 != this.mPreservedTokens.length) {
            this.mScanner.forgetState();
            this.mPreservedTokens.pop();
        }
    }
