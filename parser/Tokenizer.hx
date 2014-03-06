package parser;

import scanner.Token;
import scanner.Scanner;

class Tokenizer {

	var mScanner : Scanner;
	var mToken : Token;
	var mLookAhead : Token;

	public function new(aScanner : Scanner) {
		mScanner = aScanner;
		mToken = null;
		mLookAhead = null;
	}

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
}
