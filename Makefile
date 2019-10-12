CRYSTAL_BIN ?= $(shell which crystal)
SHARDS_BIN  ?= $(shell which shards)
GNU_SED_BIN			?= $(shell which gsed || which sed)
PREFIX      ?= /usr/local
RELEASE     ?=
STATIC      ?=
SOURCES      = src/*.cr src/**/*.cr

ifeq ($(shell brew info llvm@8 2>&1 | grep -c -E 'Poured from bottle on|Built from source on'), 1)
# we are using a homebrew clang, need new flags
export CC := /usr/local/opt/llvm@8/bin/clang
export CXX := $(CC)++
export LLVM_CONFIG := /usr/local/opt/llvm@8/bin/llvm-config
override LDFLAGS += -L/usr/local/opt/llvm@8/lib -Wl,-rpath,/usr/local/opt/llvm@8/lib
override CPPFLAGS += -I/usr/local/opt/llvm@8/include -I/usr/local/opt/llvm@8/include/c++/v1/ -DMRB_WORD_BOXING -DMRB_METHOD_T_STRUCT
endif

override CRFLAGS += $(if $(RELEASE),--release ,--debug )$(if $(STATIC),--static )$(if $(LDFLAGS),--link-flags="$(LDFLAGS)" )

.PHONY: all
all: binding

src/mruby.cr: src/lib_mruby.cr
	@echo "Generating lib binding, but working around some problematic generations"
	@echo "Ignore warnings about mrb_value and mrb_callinfo"
	$(CRYSTAL_BIN) lib/crystal_lib/src/main.cr -- src/lib_mruby.cr | \
	$(GNU_SED_BIN) -r 's/\b(super|def|self)\b/_\1/g' | \
	$(GNU_SED_BIN) 's/status : Void/status : Int32/' > src/mruby.cr

.PHONY: binding
binding: src/mruby.cr

.PHONY: deps
deps: shard.yml shard.lock
	$(SHARDS_BIN) check || $(SHARDS_BIN) install

.PHONY: clean
clean:
	rm -f ./src/mruby.cr

.PHONY: test
test: deps $(SOURCES)
	$(CRYSTAL_BIN) spec -Dmt_no_expectations

.PHONY: spec
spec: test
