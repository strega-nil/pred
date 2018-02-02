.PHONY: docs clean build format

build:
	jbuilder build

clean:
	jbuilder clean

docs:
	jbuilder build @doc
	rm -rf docs
	cp -r _build/default/_doc docs

format:
	ocamlformat --inplace pred/*.ml pred/*.mli pred/caml_stdlib/*.ml
