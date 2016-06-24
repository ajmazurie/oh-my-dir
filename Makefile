
SOURCES = $(wildcard src/*.sh)
TARGET = direnvrc

.PHONY: all
all: build

.PHONY: build
build: dist/$(TARGET)

dist/$(TARGET): $(SOURCES)
	@mkdir -p dist
	@cp src/commons.sh $@
	@find src -name "use_*.sh" -exec \
	 sh -c '(echo; cat "{}") >> $@' \;

.PHONY: install
install: build
	@cp dist/$(TARGET) $(HOME)/.$(TARGET)

.PHONY: clean
clean:
	@rm -rf dist
