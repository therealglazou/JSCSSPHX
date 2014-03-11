package parser;

import scanner.Scanner;
import scanner.Token;
import om.*;

class Parser  {

    var mPreserveWS : Bool;
    var mPreserveComments : Bool;
    var mPreservedTokens : Array<Token>;
    var mError : String;

