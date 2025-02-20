README.md: main.libsonnet
	jrsonnet -S --max-stack 10000  -J autodoc/vendor autodoc/gen.jsonnet > README.md
