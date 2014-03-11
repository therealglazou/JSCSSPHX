DIRS += parser

all::
	rm parser/Parser.hx
	cd parser && make
	haxe -main JSCSSPTest -cpp cpp
