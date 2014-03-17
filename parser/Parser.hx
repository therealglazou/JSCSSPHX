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

typedef SelectorSpecificity = {
    var a : UInt;
    var b : UInt;
    var c : UInt;
    var d : UInt;
}

typedef Selector = {
    var selector : String;
    var specificity : SelectorSpecificity;
}

typedef Declaration = {
    var property : String;
    var value : String;
    var priority : String;
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

            else if (token.isAtRule("")) {
                if (token.isAtRule("@import")) {
                    // @import rules MUST occur before all style and namespace rules
                    if (!foundStyleRules && !foundNamespaceRules)
                        foundImportRules = this.parseImportRule(token, sheet);
                    else {
                        this.reportError(IMPORT_RULE_POSITION);
                        this.addUnknownAtRule(sheet, null, token.value);
                    }
                }
                else if (token.isAtRule("@namespace")) {
                    // @namespace rules MUST occur before all style rule and
                    // after all @import rules
                    if (!foundStyleRules)
                        foundNamespaceRules = this.parseNamespaceRule(token, sheet);
                    else {
                        this.reportError(NAMESPACE_RULE_POSITION);
                        this.addUnknownAtRule(sheet, null, token.value);
                    }
                }
                // TBD to be finished
            }
            else // plain style rules
            {
                var ruleText = this.parseStyleRule(token, sheet, null);
                if ("" != ruleText)
                    foundStyleRules = true;
            }

            token = this.getToken(false, false);
        }
        // STUB
        return sheet;
    }

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

    public function parseCharsetRule(aSheet : StyleSheet) : Bool {
        var token = this.getToken(false, false);
        var s = "";
        if (token.isAtRule("@charset") && token.value == "@charset") { // lowercase check
            s = token.value;
            token = this.getToken(false, false);
            s += token.value;
            if (token.isWhiteSpace(" ")) {
                token = this.getToken(false, false);
                s += token.value;
                if (token.isString()) {
                    var encoding = token.value.substr(1, token.value.length - 2);
                    token = this.getToken(false, false);
                    s += token.value;
                    if (token.isSymbol(";")) {
                        trace("ok");
                        var rule = new CSSCharsetRule(encoding, CHARSET_RULE, aSheet, null);
                        rule.parsedCssText = s;
                        aSheet._appendRule(rule);
                        return true;
                    }
                    else
                        this.reportError(CHARSET_RULE_MISSING_SEMICOLON);
                }
                else
                    this.reportError(CHARSET_RULE_CHARSET_IS_STRING);
            }
            else
                this.reportError(CHARSET_RULE_MISSING_WS);
        }
      
        var rule = new CSSUnknownRule(s, CHARSET_RULE, aSheet, null);
        aSheet._appendRule(rule);
        return false;
    }

    private function reportError(aError : ParserError) : Void {
        this.mError = Std.string(ParserError);
        trace(this.mError);
    }

    private function consumeError() : String {
      var e = this.mError;
      this.mError = null;
      return e;
    }

    public function addWhitespace(aSheet : StyleSheet, aString : String) : Void {
        var rule = new CSSUnknownRule(aString, UNKNOWN_RULE, aSheet, null);
        rule.parsedCssText = aString;
        aSheet._appendRule(rule);
    }

    public function addComment(aSheet : StyleSheet, aString : String) : Void {
        var rule = new CSSUnknownRule(aString, UNKNOWN_RULE, aSheet, null);
        rule.parsedCssText = aString;
        aSheet._appendRule(rule);
    }
    public function parseImportRule(aToken : Token, aSheet : StyleSheet) : Bool {
        var s = aToken.value;
        this.preserveState();
        var token = this.getToken(true, true);
        var media = [];
        var href = "";
        if (token.isString()) {
            href = token.value;
            s += " " + href;
        }
        else if (token.isFunction("url(")) {
            token = this.getToken(true, true);
            var urlContent = this.parseURL(token);
            if ("" != urlContent) {
                href = "url(" + urlContent;
                s += " " + href;
            }
        }
        else
            this.reportError(IMPORT_RULE_MISSING_URL);
        
        if ("" != href) {
            token = this.getToken(true, true);
            while (token.isIdent()) {
                s += " " + token.value;
                media.push(token.value);
                token = this.getToken(true, true);
                if (!token.isNotNull())
                    break;
                if (token.isSymbol(",")) {
                    s += ",";
                } else if (token.isSymbol(";")) {
                    break;
                } else
                    break;
                token = this.getToken(true, true);
            }
            
            if (0 == media.length) {
                media.push("all");
            }
            
            if (token.isSymbol(";")) {
                s += ";";
                this.forgetState();
                var rule = new CSSImportRule(href, IMPORT_RULE, aSheet, null);
                rule.parsedCssText = s;
                for (i in 0...media.length - 1)
                    rule.media.appendMedium(media[i]);
                aSheet._appendRule(rule);
                return true;
            }
        }
        
        this.restoreState();
        this.addUnknownAtRule(aSheet, null, "@import");
        return false;
    };
    

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

    public function addUnknownAtRule(aSheet : StyleSheet, aRule: CSSRule, aString : String) : Void {
        var blocks = [];
        var token = this.getToken(false, false);
        while (token.isNotNull()) {
            aString += token.value;
            if (token.isSymbol(";") && 0 == blocks.length)
                break;
            else if (token.isSymbol("{")
                             || token.isSymbol("(")
                             || token.isSymbol("[")
                             || token.type == FUNCTION_TYPE) {
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
                        if (0 == blocks.length && token.isSymbol("}"))
                            break;
                    }
                }
            }
            token = this.getToken(false, false);
        }
        
        this.addUnknownRule(aSheet, aRule, aString);
    }
    
    public function addUnknownRule(aSheet : StyleSheet, aRule : CSSRule, aString : String) {
        var errorMsg = this.consumeError();
        var rule = new CSSUnknownRule(errorMsg, UNKNOWN_RULE, aSheet, null);
        rule.parsedCssText = aString;
        if (null != aRule)
            cast(aRule, CSSMediaRule)._appendRule(rule);
        else
            aSheet._appendRule(rule);
    }
    
    
    public function parseNamespaceRule(aToken : Token, aSheet : StyleSheet) : Bool {
        var s = aToken.value;
        var valid = false;
        this.preserveState();
        var token = this.getToken(true, true);
        if (token.isNotNull()) {
            var prefix = "";
            var url = "";
            if (token.isIdent()) {
                prefix = token.value;
                s += " " + prefix;
                token = this.getToken(true, true);
            }
            var foundURL = false;
            if (token.isNotNull()) {
                if (token.isString()) {
                    foundURL = true;
                    url = token.value;
                    s += " " + url;
                } else if (token.isFunction("url(")) {
                    // get a url here...
                    token = this.getToken(true, true);
                    var urlContent = this.parseURL(token);
                    if ("" != urlContent) {
                        url += "url(" + urlContent;
                        foundURL = true;
                        s += " " + urlContent;
                    }
                }
            }
            if (foundURL) {
                token = this.getToken(true, true);
                if (token.isSymbol(";")) {
                    s += ";";
                    this.forgetState();
                    var rule = new CSSNamespaceRule(url, prefix, NAMESPACE_RULE, aSheet, null);
                    rule.parsedCssText = s;
                    aSheet._appendRule(rule);
                    return true;
                }
            }
            
        }
        this.restoreState();
        this.addUnknownAtRule(aSheet, null, "@namespace");
        return false;
    };
    

    public function parseStyleRule(aToken : Token, aSheet : StyleSheet, aRule : CSSRule) : String {
        this.preserveState();
        // first let's see if we have a selector here...
        var selector = this.parseSelector(aToken, false);
        var valid = false;
        var declarations = [];
        var s = "";
        if (null != selector) {
            selector.selector = StringTools.trim(selector.selector);
            s = selector.selector;
            var token = this.getToken(true, true);
            if (token.isSymbol("{")) {
                s += " { ";
                var token = this.getToken(true, false);
                while (true) {
                    if (!token.isNotNull()) {
                        valid = true;
                        break;
                    }
                    if (token.isSymbol("}")) {
                        s += "}";
                        valid = true;
                        break;
                    } else {
                        var d = this.parseDeclaration(token, declarations, true, true, aSheet, aRule);
                        s += (("" != d && 0 != declarations.length) ? " " : "") + d;
                    }
                    token = this.getToken(true, false);
                }
            }
        }
        else {
            // selector is invalid so the whole rule is invalid with it
        }
        
        if (valid) {
            var rule = new CSSStyleRule(selector.selector, STYLE_RULE, aSheet, aRule);
            rule.parsedCssText = s;
            if (null != aRule) // that's a media rule
                cast(aRule, CSSMediaRule)._appendRule(rule);
            else
                aSheet._appendRule(rule);
            return s;
        }
        this.restoreState();
        s = this.currentToken().value;
        this.addUnknownAtRule(aSheet, aRule, s);

        return "";
    }

    public function parseDeclaration(aToken : Token,
                                     aDecl : Array<Declaration>,
                                     aAcceptPriority : Bool,
                                     aExpandShorthands : Bool,
                                     aSheet : StyleSheet,
                                     aRule : CSSRule) : String {
        return "";
    }
    
    public function parseSelector(aToken : Token, aParseSelectorOnly : Bool) : Selector {
        var s = "";
        var specificity : SelectorSpecificity = {a: 0, b: 0, c: 0, d: 0}; // CSS 2.1 section 6.4.3
        var isFirstInChain = true;
        var token = aToken;
        var valid = false;
        var combinatorFound = false;

        while (true) {
            if (!token.isNotNull()) {
                if (aParseSelectorOnly)
                    return {selector: s, specificity: specificity };
                return null;
            }
            
            if (!aParseSelectorOnly && token.isSymbol("{")) {
                // end of selector
                valid = !combinatorFound;
                // don't unget if invalid since addUnknownRule is going to restore state anyway
                if (valid)
                    this.ungetToken();
                break;
            }
            
            if (token.isSymbol(",")) { // group of selectors
                s += token.value;
                isFirstInChain = true;
                combinatorFound = false;
                token = this.getToken(false, true);
                continue;
            }
            // now combinators and grouping...
            else if (!combinatorFound
                             && (token.isWhiteSpace()
                                     || token.isSymbol("+")
                                     || token.isSymbol(">")
                                     || token.isSymbol("~"))) {
                                 if (token.isWhiteSpace()) {
                                     s += " ";
                                     var nextToken = this.lookAhead(true, true);
                                     if (!nextToken.isNotNull()) {
                                         if (aParseSelectorOnly)
                                             return {selector: s, specificity: specificity };
                                         return null;
                                     }
                                     if (nextToken.isSymbol(">")
                                             || nextToken.isSymbol("+")
                                             || nextToken.isSymbol("~")) {
                                         token = this.getToken(true, true);
                                         s += token.value + " ";
                                         combinatorFound = true;
                                     }
                                 }
                                 else {
                                     s += token.value;
                                     combinatorFound = true;
                                 }
                                 isFirstInChain = true;
                                 token = this.getToken(true, true);
                                 continue;
                             }
            else {
                var simpleSelector = this.parseSimpleSelector(token, isFirstInChain, true);
                if (null == simpleSelector)
                    break; // error
                s += simpleSelector.selector;
                specificity.b += simpleSelector.specificity.b;
                specificity.c += simpleSelector.specificity.c;
                specificity.d += simpleSelector.specificity.d;
                isFirstInChain = false;
                combinatorFound = false;
            }
            
            token = this.getToken(false, true);
        }
        
        if (valid) {
            return {selector: s, specificity: specificity };
        }
        return null;
    }
    
    public function isPseudoElement(aIdent : String) : Bool {
        switch (aIdent) {
            case "first-letter":
            case "first-line":
            case "before":
            case "after":
            case "marker":
                return true;
        }
        return false;
    }
    
    public function parseSimpleSelector(token : Token, isFirstInChain : Bool, canNegate : Bool) : Selector
    {
        var s = "";
        var specificity : SelectorSpecificity = {a: 0, b: 0, c: 0, d: 0}; // CSS 2.1 section 6.4.3
        
        if (isFirstInChain
                && (token.isSymbol("*") || token.isSymbol("|") || token.isIdent())) {
            // type or universal selector
            if (token.isSymbol("*") || token.isIdent()) {
                // we don't know yet if it's a prefix or a universal
                // selector
                s += token.value;
                var isIdent = token.isIdent();
                token = this.getToken(false, true);
                if (token.isSymbol("|")) {
                    // it's a prefix
                    s += token.value;
                    token = this.getToken(false, true);
                    if (token.isIdent() || token.isSymbol("*")) {
                        // ok we now have a type element or universal
                        // selector
                        s += token.value;
                        if (token.isIdent())
                            specificity.d++;
                    } else
                        // oops that's an error...
                        return null;
                } else {
                    this.ungetToken();
                    if (isIdent)
                        specificity.d++;
                }
            } else if (token.isSymbol("|")) {
                s += token.value;
                token = this.getToken(false, true);
                if (token.isIdent() || token.isSymbol("*")) {
                    s += token.value;
                    if (token.isIdent())
                        specificity.d++;
                } else
                    // oops that's an error
                    return null;
            }
        }
        
        else if (token.isSymbol(".") || token.isSymbol("#")) {
            var isClass = token.isSymbol(".");
            s += token.value;
            token = this.getToken(false, true);
            if (token.isIdent()) {
                s += token.value;
                if (isClass)
                    specificity.c++;
                else
                    specificity.b++;
            }
            else
                return null;
        }
        
        else if (token.isSymbol(":")) {
            s += token.value;
            token = this.getToken(false, true);
            if (token.isSymbol(":")) {
                s += token.value;
                token = this.getToken(false, true);
            }
            if (token.isIdent()) {
                s += token.value;
                if (this.isPseudoElement(token.value))
                    specificity.d++;
                else
                    specificity.c++;
            }
            else if (token.isFunction()) {
                s += token.value;
                if (token.isFunction(":not(")) {
                    if (!canNegate)
                        return null;
                    token = this.getToken(true, true);
                    var simpleSelector : Selector = this.parseSimpleSelector(token, isFirstInChain, false);
                    if (null == simpleSelector)
                        return null;
                    else {
                        s += simpleSelector.selector;
                        token = this.getToken(true, true);
                        if (token.isSymbol(")"))
                            s += ")";
                        else
                            return null;
                    }
                    specificity.c++;
                }
                else {
                    while (true) {
                        token = this.getToken(false, true);
                        if (token.isSymbol(")")) {
                            s += ")";
                            break;
                        } else
                            s += token.value;
                    }
                    specificity.c++;
                }
            } else
                return null;
            
        } else if (token.isSymbol("[")) {
            s += "[";
            token = this.getToken(true, true);
            if (token.isIdent() || token.isSymbol("*")) {
                s += token.value;
                var nextToken = this.getToken(true, true);
                if (nextToken.isSymbol("|")) {
                    s += "|";
                    token = this.getToken(true, true);
                    if (token.isIdent())
                        s += token.value;
                    else
                        return null;
                } else
                    this.ungetToken();
            } else if (token.isSymbol("|")) {
                s += "|";
                token = this.getToken(true, true);
                if (token.isIdent())
                    s += token.value;
                else
                    return null;
            }
            else
                return null;
            
            // nothing, =, *=, $=, ^=, |=
            token = this.getToken(true, true);
            if (token.isIncludes()
                    || token.isDashmatch()
                    || token.isBeginsmatch()
                    || token.isEndsmatch()
                    || token.isContainsmatch()
                    || token.isSymbol("=")) {
                s += token.value;
                token = this.getToken(true, true);
                if (token.isString() || token.isIdent()) {
                    s += token.value;
                    token = this.getToken(true, true);
                }
                else
                    return null;
                
                if (token.isSymbol("]")) {
                    s += token.value;
                    specificity.c++;
                }
                else
                    return null;
            }
            else if (token.isSymbol("]")) {
                s += token.value;
                specificity.c++;
            }
            else
                return null;
            
        }
        else if (token.isWhiteSpace()) {
            var t = this.lookAhead(true, true);
            if (t.isSymbol('{'))
                return null;
                }
        if (null != s) {
            return {selector: s, specificity: specificity};
        }
        return null;
    };
}
