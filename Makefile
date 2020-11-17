CRYSTAL_BIN ?= $(shell which crystal)
SHARDS_BIN  ?= $(shell which shards)
GNU_SED_BIN	?= $(shell which gsed || which sed)
PREFIX      ?= /usr/local
RELEASE     ?=
STATIC      ?=
SOURCES      = src/*.cr src/**/*.cr

ifeq ($(shell brew info llvm 2>&1 | grep -c -E 'Poured from bottle on|Built from source on'), 1)
# we are using a homebrew clang, need new flags
export CC := /usr/local/opt/llvm/bin/clang
export CXX := $(CC)++
export LLVM_CONFIG := /usr/local/opt/llvm/bin/llvm-config
override LDFLAGS += -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib
override CPPFLAGS += -I/usr/local/opt/llvm/include -I/usr/local/opt/llvm/include/c++/v1/
endif

override LDFLAGS += -L$(PWD)/build/mruby-out/lib
override CRFLAGS += $(if $(RELEASE),--release ,--debug )$(if $(STATIC),--static )$(if $(LDFLAGS),--link-flags="$(LDFLAGS)" )

.PHONY: all
all: binding

build/mruby-out/include/mruby.h: script/get-mruby.sh
	script/get-mruby.sh

src/lib_mruby.cr: bindings/lib_mruby.cr build/mruby-out/include/mruby.h
	@echo "Generating lib binding, but working around some problematic generations"
	@echo "Ignore warnings about mrb_value and mrb_callinfo"
	$(CRYSTAL_BIN) lib/crystal_lib/src/main.cr bindings/lib_mruby.cr | \
	$(GNU_SED_BIN) -r 's/\b(super|def|self)\b/_\1/g' | \
	$(GNU_SED_BIN) 's/status : Void/status : Int32/' > src/lib_mruby.cr
	$(CRYSTAL_BIN) tool format src/lib_mruby.cr

.PHONY: binding
binding: src/lib_mruby.cr

.PHONY: deps
deps: shard.yml shard.lock
	$(SHARDS_BIN) check || $(SHARDS_BIN) install

.PHONY: clean
clean:
	rm -rf ./build ./src/lib_mruby.cr ./mruby-out.tar

.PHONY: test
test: deps $(SOURCES)
	CRYSTAL_LIBRARY_PATH="$(PWD)/build/mruby-out/lib" $(CRYSTAL_BIN) spec -Dmt_no_expectations

.PHONY: spec
spec: test
