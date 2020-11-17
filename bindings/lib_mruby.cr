@[Include(
  "mruby.h",
  "mruby/compile.h",
  flags: "-Ibuild/mruby-out/include",
  prefix: %w(mrb_),
  remove_prefix: false,
  import_docstrings: "brief",
)]
@[Link("mruby")]
lib LibMRuby
end
