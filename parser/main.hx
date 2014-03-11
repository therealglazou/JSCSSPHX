
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

        // STUB
        return null;
    }
