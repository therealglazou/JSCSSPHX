/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is JSCSSP code.
 *
 * The Initial Developer of the Original Code is
 * Disruptive Innovations SAS
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Daniel Glazman <daniel.glazman@disruptive-innovations.com>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either of the GNU General Public License Version 2 or later (the "GPL"),
 * or the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */
 
package parser;

import scanner.Scanner;
import scanner.Token;
import om.*;
import om.interfaces.*;

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

    public function getHexValue() : Token {
        this.mToken = this.mScanner.nextHexValue();
        return this.mToken;
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
                for (i in 0...media.length)
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
        var selector = this.parseSelector(aToken, false);
        while (null != selector) {
            trace("================ " + selector.cssText);
            selector = selector.next;
        }
        /*
        this.preserveState();
        // first let's see if we have a selector here...
        var selector = this.parseSelector(aToken, false);
		trace(selector);
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
            // TBD don't forget to add the declarations...
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
        */

        return "";
    }

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
                    for (i in 0...declarations.length) {
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
    
    public function isTokenCombinator(aToken : Token) : Bool {
        return (aToken.isWhiteSpace()
               || aToken.isSymbol("+")
               || aToken.isSymbol("~")
               || aToken.isSymbol(">"));
    }

    public function parseSelector(aToken : Token, aParseSelectorOnly : Bool) : DOMCSSSelector {
        var rv : DOMCSSSelector = null;
        var selector = rv;
        var newInGroup = rv;
        var token = aToken;
        var newInGroup = true;

        while (true) {
            // end of the buffer?
            if (!token.isNotNull()) {
                if (aParseSelectorOnly) // no need to look for a curly brace or anything
                    return rv;
                // oops
                return null;
            }

            if (!aParseSelectorOnly && token.isSymbol("{")) {
                break;
            }

            if (token.isSymbol(",")) { // group of selectors;
                // we need a new selector in the chain
                if (newInGroup)
                    return null;
                newInGroup = true;
            }

            else if (this.isTokenCombinator(token)) { // we have found a combinator
                if (token.isWhiteSpace()) {
                    if (!newInGroup && selector.combinator == COMBINATOR_NONE) {
                        selector.combinator = COMBINATOR_DESCENDANT;
                    }
                }
                else {
                    if (newInGroup) {
                        // cannot have a combinator in first position
                        return null;
                    }
                    else if (selector.combinator == COMBINATOR_NONE
                            || selector.combinator == COMBINATOR_DESCENDANT) {
                        if (token.isSymbol("+"))
                            selector.combinator = COMBINATOR_ADJACENT_SIBLING;
                        else if (token.isSymbol("~"))
                            selector.combinator = COMBINATOR_SIBLING;
                        else if (token.isSymbol(">"))
                            selector.combinator = COMBINATOR_CHILD;
                    }
                }
            }

            else {
                // we have to consider this as the start of a complex selector
                var s = this.parseComplexSelector(token, aParseSelectorOnly, false);
                if (null == s)
                    return null;
                if (newInGroup) {
                    if (null == rv) {
                        rv = s;
                        selector = rv;
                    }
                    else {
                        s.next = rv;
                        rv = s;
                        selector = rv;
                    }
                    newInGroup = false;
                }
                else {
                    if (null == rv) {
                        rv = s;
                        selector = rv;
                    }
                    else {
                        s.parent = selector;
                        s.next = selector.next;
                        selector = s;
                        rv = s;
                    }
                }
            }

            token = this.getToken(false, true);
        }

        return rv;
    }

    public function parseComplexSelector(aToken : Token,
                                         aParseSelectorOnly : Bool,
                                         aNegated : Bool) : DOMCSSSelector {
        var firstInChain = true;
        var token = aToken;
        var rv : DOMCSSSelector = new CSSSelector();

        while (true) {
            if (!token.isNotNull()) {
                if (aParseSelectorOnly)
                    return rv;
                return null;
            }
            if (token.isSymbol(",")) {
                this.ungetToken();
                return rv;
            }

            if (firstInChain
                && (token.isSymbol("*")
                    || token.isIdent())) {
                rv.elementType = token.value;
            }

            else if (token.isSymbol("#")) {
                token = this.getToken(false, true);
                if (!token.isNotNull())
                    return null;
                if (!token.isIdent())
                    return null;
                rv.IDList.push(token.value);
            }

            else if (token.isSymbol(".")) {
                token = this.getToken(false, true);
                if (!token.isNotNull())
                    return null;
                if (!token.isIdent())
                    return null;
                rv.ClassList.push(token.value);
            }

            else if (token.isSymbol(":")) {
                token = this.getToken(false, true);
                if (!token.isNotNull())
                    return null;
                if (token.isSymbol(":")) {
                    token = this.getToken(false, true);
                    if (!token.isNotNull())
                        return null;
                }
                if (token.isIdent()) {
                    var pc = new CSSPseudoClass();
                    pc.name = token.value.toLowerCase();
                    if (!pc.isPseudoClass() && !pc.isPseudoElement())
                        return null;
                    rv.PseudoClassList.push(pc);
                }
                else if (token.isFunction()) {
                    var pc = new CSSPseudoClass();
                    pc.name = token.value.toLowerCase();
                    if (!pc.isFunctionalPseudoClass())
                        return null;

                    if (pc.name == "lang(") {
                        var l = "";
                        token = this.getToken(false, true);
                        
                        while (token.isNotNull()) {
                            if (token.isSymbol(",") || token.isSymbol(")")) {
                                if ("" == l) // can't happen in first position
                                    return null;
                                var v = new CSSValue(CSS_STRING);
                                v.setStringValue(l);
                                pc.arguments.push(v);
                                if (token.isSymbol(")"))
                                    break;
                                l = "";
                            }
                            else if (l == "" && !token.isIdent() && !token.isSymbol("*"))
                                return null; // selectors level 4 section 7.2
                            else if (l == "*" && !token.isIdent())
                                return null;

                            l += token.value.toLowerCase();
                            token = this.getToken(false, true);
                        }
                        // TBD
                    }
                    else if (pc.name == "not(" && !aNegated) {
                        // Selectors ***4*** fast profile
                        var s = this.parseComplexSelector(token, aParseSelectorOnly, true);
                        if (null == s)
                            return null;
                        this.ungetToken();
                        token = this.getToken(true, true);
                        if (!token.isSymbol(")"))
                            return null;
                        rv.negations.push(s);
                    }
                    else { // :foo(an+b) case
                        var pc = new CSSPseudoClass();
                        pc.name = token.value.toLowerCase();
                        var a = 0;
                        var b = 0;

                        token = this.getToken(true, true);
                        if (token.isIdent("odd")) {
                            a = 2;
                            b = 1;
                        }
                        else if (token.isIdent("even")) {
                            a = 2;
                            b = 0;
                        }
                        else if (token.isNotNull() && !token.isSymbol(")")){
                            var s : String = "";
                            while (token.isNotNull() && !token.isSymbol(")")) {
                                s += token.value;
                                if (token.type == DIMENSION_TYPE)
                                    s += token.unit;
                                token = this.getToken(false, true);
                            }
                            s = StringTools.trim(s);
                            var r1 = ~/^([\-\+]?[0-9]*)n$/gi;
                            var r2 = ~/^([\-\+]\s*[0-9]+)$/gi;
                            var r3 = ~/^([\-\+]?[0-9]*)n?\s*([\-\+]\s*[0-9]+)$/gi;
                            if (r1.match(s)) {
                                switch (r1.matched(1)) {
                                    case "-": a = -1;
                                    case "+": a = 1;
                                    default:  a = Std.parseInt(r1.matched(1));
                                }
                                b = 0;
                            }
                            else if (r2.match(s)) {
                                b = Std.parseInt(StringTools.replace(r2.matched(1), " ", ""));
                                a = 0;
                            }
                            else if (r3.match(s)) {
                                switch (r3.matched(1)) {
                                    case "-": a = -1;
                                    case "+": a = 1;
                                    default:  a = Std.parseInt(r3.matched(1));
                                }
                                b = Std.parseInt(StringTools.replace(r3.matched(2), " ", ""));
                            }
                            else
                                return null;
                       }
                        else
                            return null;

                        var va = new CSSValue(CSS_NUMBER);
                        va.setFloatValue(a);
                        var vb = new CSSValue(CSS_NUMBER);
                        vb.setFloatValue(b);
                        pc.arguments.push(va);
                        pc.arguments.push(vb);
                        rv.PseudoClassList.push(pc);
                     }

                    if (!token.isSymbol(")"))
                        return null;
                }
                else
                    return null;
            }

            else if (token.isSymbol("[")) {
                // attr selector
                var name = "";
                var value = "";
                var caseInsensitive = false;
                var operator = om.interfaces.DOMCSSAttrSelector.DOMCSSAttrSelectorFunction.ATTR_EXISTS; 
                token = this.getToken(false, true);
                if (!token.isNotNull())
                    return null;
                if (token.isSymbol("*") || token.isIdent()) {
                    name = token.value;
                    token = this.getToken(true, true);
                    if (!token.isNotNull())
                        return null;
                    if (token.isIncludes())
                        operator = om.interfaces.DOMCSSAttrSelector.DOMCSSAttrSelectorFunction.ATTR_INCLUDES;
                    else if (token.isDashmatch())
                        operator = om.interfaces.DOMCSSAttrSelector.DOMCSSAttrSelectorFunction.ATTR_DASHMATCH;
                    else if (token.isBeginsmatch())
                        operator = om.interfaces.DOMCSSAttrSelector.DOMCSSAttrSelectorFunction.ATTR_BEGINSMATCH;
                    else if (token.isEndsmatch())
                        operator = om.interfaces.DOMCSSAttrSelector.DOMCSSAttrSelectorFunction.ATTR_ENDSMATCH;
                    else if (token.isContainsmatch())
                        operator = om.interfaces.DOMCSSAttrSelector.DOMCSSAttrSelectorFunction.ATTR_CONTAINSMATCH;
                    else if (token.isSymbol("="))
                        operator = om.interfaces.DOMCSSAttrSelector.DOMCSSAttrSelectorFunction.ATTR_EQUALS;
                    else if (token.isSymbol("]")) {
                        var at = new CSSAttrSelector();
                        at.name = name;
                        at.operator = operator;
                        rv.AttrList.push(at);
                    }
                    else
                        return null;

                    // we need a value
                    token = this.getToken(true, true);
                    if (!token.isNotNull())
                        return null;
                    if (token.isString() || token.isIdent()) {
                        value = token.value;
                        token = this.getToken(true, true);
                        if (!token.isNotNull())
                            return null;
                        if (token.isIdent("i)")) {
                            caseInsensitive = true;
                            token = this.getToken(true, true);
                        }
                        if (token.isSymbol("]")) {
                            var at = new CSSAttrSelector();
                            at.name = name;
                            at.operator = operator;
                            at.value = value;
                            at.caseInsensitive = caseInsensitive;
                            rv.AttrList.push(at);
                        }
                        else
                          return null;
                    }
                }
                else
                    return null;
            }

            else if (this.isTokenCombinator(token)
                     || (aNegated && token.isSymbol(")"))
                     || (!aParseSelectorOnly && token.isSymbol("{"))) {
                this.ungetToken();
                return rv;
            }
            firstInChain = false;
            token = this.getToken(false, true);
        }
        return rv;
    }


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
    
}
