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
