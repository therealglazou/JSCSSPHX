package parser;

import scanner.Scanner;
import scanner.Token;
import om.*;
import om.interfaces.DOMCSSRule;

enum ParserError {
    CHARSET_RULE_MISSING_SEMICOLON;
    CHARSET_RULE_CHARSET_IS_STRING;
    CHARSET_RULE_MISSING_WS;
    IMPORT_RULE_POSITION;
    IMPORT_RULE_MISSING_URL;
    URL_EOF;
    URL_WS_INSIDE;
    NAMESPACE_RULE_POSITION;
}

class Parser  {

    /*
     * general purpose
     */
    private var mPreserveWS : Bool;
    private var mPreserveComments : Bool;
    private var mPreservedTokens : Array<Token>;
    private var mError : String;

    /*
     * for tokenization
     */
    private var mScanner : Scanner;
    private var mToken : Token;
    private var mLookAhead : Token;
