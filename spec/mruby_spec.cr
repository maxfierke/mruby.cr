require "./spec_helper"

describe "LibMRuby" do
  it "works" do
    mrb = LibMRuby.mrb_open
    code = "5.times { puts 'mruby is awesome!' }"
    LibMRuby.mrb_load_string(mrb, code)
    LibMRuby.mrb_close(mrb)
  end
end
