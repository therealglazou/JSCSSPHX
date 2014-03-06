package parser;

import scanner.Scanner;
import parser.Tokenizer;

class Parser {

	var mPreserveWS : Bool;
    var mPreserveComments : Bool;
    var mPreservedTokens : Dynamic;
    var mToken : Dynamic;
    var mLookAhead : Dynamic;
    var mError : String;

    var mScanner : Scanner;

    public function new(aString: String, aPreserveWS: Bool, aPreserveComments: Bool) {
        this.mPreserveWS = aPreserveWS;
        this.mPreserveComments = aPreserveComments;
        this.mPreservedTokens = [];
        this.mError = null;

        // init the scanner with our string to parse
        this.mScanner = new Scanner(aString);
    }
}
