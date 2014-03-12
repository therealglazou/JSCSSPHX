
    private function reportError(aError : ParserError) : Void {
        this.mError = Std.string(ParserError);
        trace(this.mError);
    }

    private function consumeError() : String {
      var e = this.mError;
      this.mError = null;
      return e;
    }
