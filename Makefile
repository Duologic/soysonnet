soy-gen/README.md: soy-gen/main.libsonnet
	jrsonnet -S \
		-J ./autodoc/vendor \
		--max-stack 1000 \
		-A title=soy-gen \
		--tla-str-file file=./soy-gen/main.libsonnet \
		./autodoc/main.libsonnet \
		> soy-gen/README.md

soy-common/README.md: soy-common/main.libsonnet
	jrsonnet -S \
		-J ./autodoc/vendor \
		--max-stack 1000 \
		-A title=soy-common \
		--tla-str-file file=./soy-common/main.libsonnet \
		./autodoc/main.libsonnet \
		> soy-common/README.md
