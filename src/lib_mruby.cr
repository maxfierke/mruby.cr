@[Include(
  "mruby.h",
  "mruby/compile.h",
  prefix: %w(mrb_),
  remove_prefix: false,
  import_docstrings: "brief",
)]
@[Link("mruby")]
lib LibMRuby
end
