package parser;

import scanner.Scanner;
import parser.Tokenizer;
import om.*;

class Parser {

    var mPreserveWS : Bool;
    var mPreserveComments : Bool;
    var mPreservedTokens : Dynamic;
    var mToken : Dynamic;
    var mLookAhead : Dynamic;
    var mError : String;

    var mScanner : Scanner;
    var mTokenizer : Tokenizer;

    public function new() {
    }

    public function parse(aString: String, aPreserveWS: Bool, aPreserveComments: Bool) {
        mPreserveWS = aPreserveWS;
        mPreserveComments = aPreserveComments;
        mPreservedTokens = [];
        mError = null;

        // init the scanner with our string to parse
        mScanner = new Scanner(aString);
        mTokenizer = new Tokenizer(mScanner);

        var sheet = new StyleSheet();
    }
}
