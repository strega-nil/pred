.PHONY: docs clean build

build:
	jbuilder build

clean:
	jbuilder clean

docs:
	jbuilder build @doc
	rm -rf docs
	cp -r _build/default/_doc docs
