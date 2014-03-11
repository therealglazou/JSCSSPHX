DIRS += parser

all::
	rm -f parser/Parser.hx
	cd parser && make
	haxe -main JSCSSPTest -cpp cpp

js::
	rm -f parser/Parser.hx
	cd parser && make
	haxe -main JSCSSPTest -js JSCSSP.js

clean:
	rm -fr parser/Parser.hx cpp JSCSSP.js
