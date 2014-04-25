
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
                        selector = rv;
                        while (null != selector.next)
                            selector = selector.next;
                        selector.next = s;
                        selector = s;
                    }
                    newInGroup = false;
                }
                else {
                    if (null == rv) {
                        rv = s;
                        selector = rv;
                    }
                    else {
                        selector.parent = s;
                        selector = s;
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
                                a = Std.parseInt(r1.matched(1));
                                b = 0;
                            }
                            else if (r2.match(s)) {
                                b = Std.parseInt(StringTools.replace(r2.matched(1), " ", ""));
                                a = 0;
                            }
                            else if (r3.match(s)) {
                                a = Std.parseInt(r3.matched(1));
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

