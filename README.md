# mruby

mruby library bindings for Crystal. Currently only unsafe, generated bindings.
Very much a work-in-progress.

## Installation

0. Install mruby library and headers
  * On macOS, `brew install llvm@8 mruby` will install the required dependencies.
1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     mruby:
       github: maxfierke/mruby.cr
   ```

2. Run `shards install`
3. Run `cd lib/mruby && make` to generate the lib binding.
  (May want to do this in your `Makefile` or other build configuration)

## Usage

```crystal
require "mruby"

mrb = LibMRuby.mrb_open
code = "5.times { puts 'mruby is awesome!' }"
LibMRuby.mrb_load_string(mrb, code)
LibMRuby.mrb_close(mrb)
```

See `src/mruby.cr` once generated to view exposed methods (currently only those from `mruby.h` and `mruby/compile.h`)

## Development

* Follow [Installation step 0](#Installation) to get the required libraries installed.
  * If you're on macOS, ensure `gnu-sed` is installed. (e.g. `brew install gnu-sed`)
* Run `make` to generate the lib bindings
* Run `make spec` to run the tests

## Contributing

1. Fork it (<https://github.com/maxfierke/mruby.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Max Fierke](https://github.com/maxfierke) - creator and maintainer
