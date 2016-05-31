
.PHONY: all
all: build

.PHONY: build
build: dist/direnvrc

dist/direnvrc: src
	@mkdir -p dist
	@cp src/commons.sh $@
	@find src -name "use_*.sh" -exec \
	 sh -c '(echo; cat "{}") >> $@' \;

.PHONY: install
install: build
	@cp dist/direnvrc $(HOME)/.direnvrc

.PHONY: clean
clean:
	@rm -rf dist
