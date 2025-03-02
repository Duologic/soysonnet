local autodoc = import './vendor/github.com/Duologic/autodoc/main.libsonnet';

local file = importstr '../main.libsonnet';

autodoc(file).render(1)
