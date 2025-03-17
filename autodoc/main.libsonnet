local autodoc = import './vendor/autodoc/main.libsonnet';
function(title, file)
  autodoc.new(title, file).render(0)
