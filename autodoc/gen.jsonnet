local autodoc = import './vendor/github.com/Duologic/autodoc/main.libsonnet';

local file = importstr '../main.libsonnet';

'# soysonnet\n\n'
+ autodoc(file).render(1)
