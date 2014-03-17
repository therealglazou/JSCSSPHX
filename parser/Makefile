
HEADER=header.hx
FOOTER=footer.hx
TARGET=Parser.hx

FILES=main.hx \
	tokenizer.hx \
	charsetRule.hx \
	error.hx \
	whitespace.hx \
	comment.hx \
	importRule.hx \
	url.hx \
	unknownRule.hx \
	namespaceRule.hx \
	styleRule.hx \
	declarations.hx \
	selectors.hx \
	$(NULL)

all:
	cat $(HEADER) $(FILES) $(FOOTER) > $(TARGET) 
