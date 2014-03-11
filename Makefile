DIRS += parser

all::
	cd parser && make
	haxe -main JSCSSPTest -cpp cpp
