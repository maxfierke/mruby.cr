@[Link("mruby")]
lib LibMRuby
  struct MrbState
    jmp : MrbJmpbuf*
    flags : Uint32T
    allocf : MrbAllocf
    allocf_ud : Void*
    c : MrbContext*
    root_c : MrbContext*
    globals : Void*
    exc : RObject*
    top_self : RObject*
    object_class : Void*
    class_class : Void*
    module_class : Void*
    proc_class : Void*
    string_class : Void*
    array_class : Void*
    hash_class : Void*
    range_class : Void*
    float_class : Void*
    fixnum_class : Void*
    true_class : Void*
    false_class : Void*
    nil_class : Void*
    symbol_class : Void*
    kernel_module : Void*
    mems : Void*
    gc : MrbGc
    symidx : MrbSym
    symtbl : Void*
    symhash : MrbSym[256]
    symcapa : LibC::SizeT
    symbuf : LibC::Char[8]
    e_exception_class : Void*
    e_standard_error_class : Void*
    nomem_err : RObject*
    stack_err : RObject*
    ud : Void*
    atexit_stack : MrbAtexitFunc*
    atexit_stack_len : Uint16T
    ecall_nest : Uint16T
  end
  alias MrbJmpbuf = Void
  alias Uint32T = LibC::UInt
  alias MrbAllocf = (MrbState*, Void*, LibC::SizeT, Void* -> Void*)
  struct MrbContext
    prev : MrbContext*
    stack : Void*
    stbase : Void*
    stend : Void*
    ci : Void*
    cibase : Void*
    ciend : Void*
    rescue : Uint16T*
    rsize : Uint16T
    ensure : Void**
    esize : Uint16T
    eidx : Uint16T
    status : Int32
    vmexec : MrbBool
    fib : RFiber*
  end
  alias Uint16T = LibC::UShort
  alias Uint8T = UInt8
  alias MrbBool = Uint8T
  struct RFiber
    tt : MrbVtype
    color : Uint32T
    flags : Uint32T
    c : Void*
    gcnext : RBasic*
    cxt : MrbContext*
  end
  enum MrbVtype
    MrbTtFalse = 0
    MrbTtFree = 1
    MrbTtTrue = 2
    MrbTtFixnum = 3
    MrbTtSymbol = 4
    MrbTtUndef = 5
    MrbTtFloat = 6
    MrbTtCptr = 7
    MrbTtObject = 8
    MrbTtClass = 9
    MrbTtModule = 10
    MrbTtIclass = 11
    MrbTtSclass = 12
    MrbTtProc = 13
    MrbTtArray = 14
    MrbTtHash = 15
    MrbTtString = 16
    MrbTtRange = 17
    MrbTtException = 18
    MrbTtFile = 19
    MrbTtEnv = 20
    MrbTtData = 21
    MrbTtFiber = 22
    MrbTtIstruct = 23
    MrbTtBreak = 24
    MrbTtMaxdefine = 25
  end
  struct RBasic
    tt : MrbVtype
    color : Uint32T
    flags : Uint32T
    c : Void*
    gcnext : RBasic*
  end
  struct RObject
    tt : MrbVtype
    color : Uint32T
    flags : Uint32T
    c : Void*
    gcnext : RBasic*
    iv : Void*
  end
  struct MrbGc
    heaps : MrbHeapPage*
    sweeps : MrbHeapPage*
    free_heaps : MrbHeapPage*
    live : LibC::SizeT
    arena : RBasic**
    arena_capa : LibC::Int
    arena_idx : LibC::Int
    state : MrbGcState
    current_white_part : LibC::Int
    gray_list : RBasic*
    atomic_gray_list : RBasic*
    live_after_mark : LibC::SizeT
    threshold : LibC::SizeT
    interval_ratio : LibC::Int
    step_ratio : LibC::Int
    iterating : MrbBool
    disabled : MrbBool
    full : MrbBool
    generational : MrbBool
    out_of_memory : MrbBool
    majorgc_old_threshold : LibC::SizeT
  end
  struct MrbHeapPage
    freelist : RBasic*
    prev : MrbHeapPage*
    next : MrbHeapPage*
    free_next : MrbHeapPage*
    free_prev : MrbHeapPage*
    old : MrbBool
    objects : Void**
  end
  enum MrbGcState
    MrbGcStateRoot = 0
    MrbGcStateMark = 1
    MrbGcStateSweep = 2
  end
  alias MrbSym = Uint32T
  alias MrbAtexitFunc = (MrbState* -> Void)
  fun mrb_float_read(x0 : LibC::Char*, x1 : LibC::Char**) : LibC::Double
  struct MrbValue
    value : MrbValueValue
    tt : MrbVtype
  end
  union MrbValueValue
    f : MrbFloat
    p : Void*
    i : MrbInt
    sym : MrbSym
  end
  alias MrbFloat = LibC::Double
  alias Int64T = LibC::LongLong
  alias MrbInt = Int64T
  fun mrb_regexp_p(x0 : MrbState*, x1 : MrbValue) : MrbBool
  fun mrb_float_value(mrb : MrbState*, f : MrbFloat) : MrbValue
  fun mrb_cptr_value(mrb : MrbState*, p : Void*) : MrbValue
  fun mrb_fixnum_value(i : MrbInt) : MrbValue
  fun mrb_symbol_value(i : MrbSym) : MrbValue
  fun mrb_obj_value(p : Void*) : MrbValue
  fun mrb_nil_value : MrbValue
  fun mrb_false_value : MrbValue
  fun mrb_true_value : MrbValue
  fun mrb_bool_value(boolean : MrbBool) : MrbValue
  fun mrb_undef_value : MrbValue
  fun mrb_objspace_each_objects(mrb : MrbState*, callback : (MrbState*, RBasic*, Void* -> LibC::Int), data : Void*)
  fun mrb_free_context(mrb : MrbState*, c : MrbContext*)
  fun mrb_object_dead_p(mrb : MrbState*, object : RBasic*) : MrbBool
  alias MrbIrep = Void
  fun mrb_define_class(mrb : MrbState*, name : LibC::Char*, _super : Void*) : Void*
  fun mrb_define_module(x0 : MrbState*, x1 : LibC::Char*) : Void*
  fun mrb_singleton_class(x0 : MrbState*, x1 : MrbValue) : MrbValue
  fun mrb_include_module(x0 : MrbState*, x1 : Void*, x2 : Void*)
  fun mrb_prepend_module(x0 : MrbState*, x1 : Void*, x2 : Void*)
  fun mrb_define_method(mrb : MrbState*, cla : Void*, name : LibC::Char*, func : MrbFuncT, aspec : MrbAspec)
  alias MrbFuncT = (MrbState*, MrbValue -> MrbValue)
  alias MrbAspec = Uint32T
  fun mrb_define_class_method(x0 : MrbState*, x1 : Void*, x2 : LibC::Char*, x3 : MrbFuncT, x4 : MrbAspec)
  fun mrb_define_singleton_method(x0 : MrbState*, x1 : RObject*, x2 : LibC::Char*, x3 : MrbFuncT, x4 : MrbAspec)
  fun mrb_define_module_function(x0 : MrbState*, x1 : Void*, x2 : LibC::Char*, x3 : MrbFuncT, x4 : MrbAspec)
  fun mrb_define_const(x0 : MrbState*, x1 : Void*, name : LibC::Char*, x3 : MrbValue)
  fun mrb_undef_method(x0 : MrbState*, x1 : Void*, x2 : LibC::Char*)
  fun mrb_undef_method_id(x0 : MrbState*, x1 : Void*, x2 : MrbSym)
  fun mrb_undef_class_method(x0 : MrbState*, x1 : Void*, x2 : LibC::Char*)
  fun mrb_obj_new(mrb : MrbState*, c : Void*, argc : MrbInt, argv : MrbValue*) : MrbValue
  fun mrb_class_new_instance(mrb : MrbState*, argc : MrbInt, argv : MrbValue*, c : Void*) : MrbValue
  fun mrb_instance_new(mrb : MrbState*, cv : MrbValue) : MrbValue
  fun mrb_class_new(mrb : MrbState*, _super : Void*) : Void*
  fun mrb_module_new(mrb : MrbState*) : Void*
  fun mrb_class_defined(mrb : MrbState*, name : LibC::Char*) : MrbBool
  fun mrb_class_get(mrb : MrbState*, name : LibC::Char*) : Void*
  fun mrb_exc_get(mrb : MrbState*, name : LibC::Char*) : Void*
  fun mrb_class_defined_under(mrb : MrbState*, outer : Void*, name : LibC::Char*) : MrbBool
  fun mrb_class_get_under(mrb : MrbState*, outer : Void*, name : LibC::Char*) : Void*
  fun mrb_module_get(mrb : MrbState*, name : LibC::Char*) : Void*
  fun mrb_module_get_under(mrb : MrbState*, outer : Void*, name : LibC::Char*) : Void*
  fun mrb_notimplement(x0 : MrbState*)
  fun mrb_notimplement_m(x0 : MrbState*, x1 : MrbValue) : MrbValue
  fun mrb_obj_dup(mrb : MrbState*, obj : MrbValue) : MrbValue
  fun mrb_obj_respond_to(mrb : MrbState*, c : Void*, mid : MrbSym) : MrbBool
  fun mrb_define_class_under(mrb : MrbState*, outer : Void*, name : LibC::Char*, _super : Void*) : Void*
  fun mrb_define_module_under(mrb : MrbState*, outer : Void*, name : LibC::Char*) : Void*
  fun mrb_get_args(mrb : MrbState*, format : MrbArgsFormat, ...) : MrbInt
  alias MrbArgsFormat = LibC::Char*
  fun mrb_get_mid(mrb : MrbState*) : MrbSym
  fun mrb_get_argc(mrb : MrbState*) : MrbInt
  fun mrb_get_argv(mrb : MrbState*) : MrbValue*
  fun mrb_funcall(x0 : MrbState*, x1 : MrbValue, x2 : LibC::Char*, x3 : MrbInt, ...) : MrbValue
  fun mrb_funcall_argv(x0 : MrbState*, x1 : MrbValue, x2 : MrbSym, x3 : MrbInt, x4 : MrbValue*) : MrbValue
  fun mrb_funcall_with_block(x0 : MrbState*, x1 : MrbValue, x2 : MrbSym, x3 : MrbInt, x4 : MrbValue*, x5 : MrbValue) : MrbValue
  fun mrb_intern_cstr(x0 : MrbState*, x1 : LibC::Char*) : MrbSym
  fun mrb_intern(x0 : MrbState*, x1 : LibC::Char*, x2 : LibC::SizeT) : MrbSym
  fun mrb_intern_static(x0 : MrbState*, x1 : LibC::Char*, x2 : LibC::SizeT) : MrbSym
  fun mrb_intern_str(x0 : MrbState*, x1 : MrbValue) : MrbSym
  fun mrb_check_intern_cstr(x0 : MrbState*, x1 : LibC::Char*) : MrbValue
  fun mrb_check_intern(x0 : MrbState*, x1 : LibC::Char*, x2 : LibC::SizeT) : MrbValue
  fun mrb_check_intern_str(x0 : MrbState*, x1 : MrbValue) : MrbValue
  fun mrb_sym2name(x0 : MrbState*, x1 : MrbSym) : LibC::Char*
  fun mrb_sym2name_len(x0 : MrbState*, x1 : MrbSym, x2 : MrbInt*) : LibC::Char*
  fun mrb_sym2str(x0 : MrbState*, x1 : MrbSym) : MrbValue
  fun mrb_malloc(x0 : MrbState*, x1 : LibC::SizeT) : Void*
  fun mrb_calloc(x0 : MrbState*, x1 : LibC::SizeT, x2 : LibC::SizeT) : Void*
  fun mrb_realloc(x0 : MrbState*, x1 : Void*, x2 : LibC::SizeT) : Void*
  fun mrb_realloc_simple(x0 : MrbState*, x1 : Void*, x2 : LibC::SizeT) : Void*
  fun mrb_malloc_simple(x0 : MrbState*, x1 : LibC::SizeT) : Void*
  fun mrb_obj_alloc(x0 : MrbState*, x1 : MrbVtype, x2 : Void*) : RBasic*
  fun mrb_free(x0 : MrbState*, x1 : Void*)
  fun mrb_str_new(mrb : MrbState*, p : LibC::Char*, len : LibC::SizeT) : MrbValue
  fun mrb_str_new_cstr(x0 : MrbState*, x1 : LibC::Char*) : MrbValue
  fun mrb_str_new_static(mrb : MrbState*, p : LibC::Char*, len : LibC::SizeT) : MrbValue
  fun mrb_open : MrbState*
  fun mrb_open_allocf(f : MrbAllocf, ud : Void*) : MrbState*
  fun mrb_open_core(f : MrbAllocf, ud : Void*) : MrbState*
  fun mrb_close(mrb : MrbState*)
  fun mrb_default_allocf(x0 : MrbState*, x1 : Void*, x2 : LibC::SizeT, x3 : Void*) : Void*
  fun mrb_top_self(x0 : MrbState*) : MrbValue
  fun mrb_run(x0 : MrbState*, x1 : Void*, x2 : MrbValue) : MrbValue
  fun mrb_top_run(x0 : MrbState*, x1 : Void*, x2 : MrbValue, x3 : LibC::UInt) : MrbValue
  fun mrb_vm_run(x0 : MrbState*, x1 : Void*, x2 : MrbValue, x3 : LibC::UInt) : MrbValue
  fun mrb_vm_exec(x0 : MrbState*, x1 : Void*, x2 : MrbCode*) : MrbValue
  alias MrbCode = Uint8T
  fun mrb_p(x0 : MrbState*, x1 : MrbValue)
  fun mrb_obj_id(obj : MrbValue) : MrbInt
  fun mrb_obj_to_sym(mrb : MrbState*, name : MrbValue) : MrbSym
  fun mrb_obj_eq(x0 : MrbState*, x1 : MrbValue, x2 : MrbValue) : MrbBool
  fun mrb_obj_equal(x0 : MrbState*, x1 : MrbValue, x2 : MrbValue) : MrbBool
  fun mrb_equal(mrb : MrbState*, obj1 : MrbValue, obj2 : MrbValue) : MrbBool
  fun mrb_convert_to_integer(mrb : MrbState*, val : MrbValue, base : MrbInt) : MrbValue
  fun mrb_integer = mrb_Integer(mrb : MrbState*, val : MrbValue) : MrbValue
  fun mrb_float = mrb_Float(mrb : MrbState*, val : MrbValue) : MrbValue
  fun mrb_inspect(mrb : MrbState*, obj : MrbValue) : MrbValue
  fun mrb_eql(mrb : MrbState*, obj1 : MrbValue, obj2 : MrbValue) : MrbBool
  fun mrb_gc_arena_save(x0 : MrbState*) : LibC::Int
  fun mrb_gc_arena_restore(x0 : MrbState*, x1 : LibC::Int)
  fun mrb_gc_arena_save(mrb : MrbState*) : LibC::Int
  fun mrb_gc_arena_restore(mrb : MrbState*, idx : LibC::Int)
  fun mrb_garbage_collect(x0 : MrbState*)
  fun mrb_full_gc(x0 : MrbState*)
  fun mrb_incremental_gc(x0 : MrbState*)
  fun mrb_gc_mark(x0 : MrbState*, x1 : RBasic*)
  fun mrb_field_write_barrier(x0 : MrbState*, x1 : RBasic*, x2 : RBasic*)
  fun mrb_write_barrier(x0 : MrbState*, x1 : RBasic*)
  fun mrb_check_convert_type(mrb : MrbState*, val : MrbValue, type : MrbVtype, tname : LibC::Char*, method : LibC::Char*) : MrbValue
  fun mrb_any_to_s(mrb : MrbState*, obj : MrbValue) : MrbValue
  fun mrb_obj_classname(mrb : MrbState*, obj : MrbValue) : LibC::Char*
  fun mrb_obj_class(mrb : MrbState*, obj : MrbValue) : Void*
  fun mrb_class_path(mrb : MrbState*, c : Void*) : MrbValue
  fun mrb_convert_type(mrb : MrbState*, val : MrbValue, type : MrbVtype, tname : LibC::Char*, method : LibC::Char*) : MrbValue
  fun mrb_obj_is_kind_of(mrb : MrbState*, obj : MrbValue, c : Void*) : MrbBool
  fun mrb_obj_inspect(mrb : MrbState*, _self : MrbValue) : MrbValue
  fun mrb_obj_clone(mrb : MrbState*, _self : MrbValue) : MrbValue
  fun mrb_exc_new(mrb : MrbState*, c : Void*, ptr : LibC::Char*, len : LibC::SizeT) : MrbValue
  fun mrb_exc_raise(mrb : MrbState*, exc : MrbValue)
  fun mrb_raise(mrb : MrbState*, c : Void*, msg : LibC::Char*)
  fun mrb_raisef(mrb : MrbState*, c : Void*, fmt : LibC::Char*, ...)
  fun mrb_name_error(mrb : MrbState*, id : MrbSym, fmt : LibC::Char*, ...)
  fun mrb_warn(mrb : MrbState*, fmt : LibC::Char*, ...)
  fun mrb_bug(mrb : MrbState*, fmt : LibC::Char*, ...)
  fun mrb_print_backtrace(mrb : MrbState*)
  fun mrb_print_error(mrb : MrbState*)
  fun mrb_vformat(mrb : MrbState*, format : LibC::Char*, ap : VaList) : MrbValue
  alias X__DarwinVaList = LibC::VaList
  alias VaList = X__DarwinVaList
  fun mrb_yield(mrb : MrbState*, b : MrbValue, arg : MrbValue) : MrbValue
  fun mrb_yield_argv(mrb : MrbState*, b : MrbValue, argc : MrbInt, argv : MrbValue*) : MrbValue
  fun mrb_yield_with_class(mrb : MrbState*, b : MrbValue, argc : MrbInt, argv : MrbValue*, _self : MrbValue, c : Void*) : MrbValue
  fun mrb_yield_cont(mrb : MrbState*, b : MrbValue, _self : MrbValue, argc : MrbInt, argv : MrbValue*) : MrbValue
  fun mrb_gc_protect(mrb : MrbState*, obj : MrbValue)
  fun mrb_gc_register(mrb : MrbState*, obj : MrbValue)
  fun mrb_gc_unregister(mrb : MrbState*, obj : MrbValue)
  fun mrb_to_int(mrb : MrbState*, val : MrbValue) : MrbValue
  fun mrb_to_str(mrb : MrbState*, val : MrbValue) : MrbValue
  fun mrb_check_type(mrb : MrbState*, x : MrbValue, t : MrbVtype)
  fun mrb_define_alias(mrb : MrbState*, c : Void*, a : LibC::Char*, b : LibC::Char*)
  fun mrb_class_name(mrb : MrbState*, klass : Void*) : LibC::Char*
  fun mrb_define_global_const(mrb : MrbState*, name : LibC::Char*, val : MrbValue)
  fun mrb_attr_get(mrb : MrbState*, obj : MrbValue, id : MrbSym) : MrbValue
  fun mrb_respond_to(mrb : MrbState*, obj : MrbValue, mid : MrbSym) : MrbBool
  fun mrb_obj_is_instance_of(mrb : MrbState*, obj : MrbValue, c : Void*) : MrbBool
  fun mrb_func_basic_p(mrb : MrbState*, obj : MrbValue, mid : MrbSym, func : MrbFuncT) : MrbBool
  fun mrb_fiber_resume(mrb : MrbState*, fib : MrbValue, argc : MrbInt, argv : MrbValue*) : MrbValue
  fun mrb_fiber_yield(mrb : MrbState*, argc : MrbInt, argv : MrbValue*) : MrbValue
  fun mrb_fiber_alive_p(mrb : MrbState*, fib : MrbValue) : MrbValue
  fun mrb_stack_extend(x0 : MrbState*, x1 : MrbInt)
  alias MrbPool = Void
  fun mrb_pool_open(x0 : MrbState*) : MrbPool*
  fun mrb_pool_close(x0 : MrbPool*)
  fun mrb_pool_alloc(x0 : MrbPool*, x1 : LibC::SizeT) : Void*
  fun mrb_pool_realloc(x0 : MrbPool*, x1 : Void*, oldlen : LibC::SizeT, newlen : LibC::SizeT) : Void*
  fun mrb_pool_can_realloc(x0 : MrbPool*, x1 : Void*, x2 : LibC::SizeT) : MrbBool
  fun mrb_alloca(mrb : MrbState*, x1 : LibC::SizeT) : Void*
  fun mrb_state_atexit(mrb : MrbState*, func : MrbAtexitFunc)
  fun mrb_show_version(mrb : MrbState*)
  fun mrb_show_copyright(mrb : MrbState*)
  fun mrb_format(mrb : MrbState*, format : LibC::Char*, ...) : MrbValue
  struct MrbParserState
    mrb : MrbState*
    pool : MrbPool*
    cells : MrbAstNode*
    s : LibC::Char*
    send : LibC::Char*
    f : File*
    cxt : MrbcContext*
    filename_sym : MrbSym
    lineno : LibC::Int
    column : LibC::Int
    lstate : MrbLexStateEnum
    lex_strterm : MrbAstNode*
    cond_stack : LibC::UInt
    cmdarg_stack : LibC::UInt
    paren_nest : LibC::Int
    lpar_beg : LibC::Int
    in_def : LibC::Int
    in_single : LibC::Int
    cmd_start : MrbBool
    locals : MrbAstNode*
    pb : MrbAstNode*
    tokbuf : LibC::Char*
    buf : LibC::Char[256]
    tidx : LibC::Int
    tsiz : LibC::Int
    all_heredocs : MrbAstNode*
    heredocs_from_nextline : MrbAstNode*
    parsing_heredoc : MrbAstNode*
    lex_strterm_before_heredoc : MrbAstNode*
    ylval : Void*
    nerr : LibC::SizeT
    nwarn : LibC::SizeT
    tree : MrbAstNode*
    no_optimize : MrbBool
    on_eval : MrbBool
    capture_errors : MrbBool
    error_buffer : MrbParserMessage[10]
    warn_buffer : MrbParserMessage[10]
    filename_table : MrbSym*
    filename_table_length : Uint16T
    current_filename_index : Uint16T
    jmp : MrbJmpbuf*
  end
  struct MrbAstNode
    car : MrbAstNode*
    cdr : MrbAstNode*
    lineno : Uint16T
    filename_index : Uint16T
  end
  struct X__SFile
    _p : UInt8*
    _r : LibC::Int
    _w : LibC::Int
    _flags : LibC::Short
    _file : LibC::Short
    _bf : X__Sbuf
    _lbfsize : LibC::Int
    _cookie : Void*
    _close : (Void* -> LibC::Int)
    _read : (Void*, LibC::Char*, LibC::Int -> LibC::Int)
    _seek : (Void*, FposT, LibC::Int -> FposT)
    _write : (Void*, LibC::Char*, LibC::Int -> LibC::Int)
    _ub : X__Sbuf
    _extra : X__SFilex*
    _ur : LibC::Int
    _ubuf : UInt8[3]
    _nbuf : UInt8[1]
    _lb : X__Sbuf
    _blksize : LibC::Int
    _offset : FposT
  end
  type File = X__SFile
  struct X__Sbuf
    _base : UInt8*
    _size : LibC::Int
  end
  alias X__Int64T = LibC::LongLong
  alias X__DarwinOffT = X__Int64T
  alias FposT = X__DarwinOffT
  alias X__SFilex = Void
  struct MrbcContext
    syms : MrbSym*
    slen : LibC::Int
    filename : LibC::Char*
    lineno : LibC::Short
    partial_hook : (MrbParserState* -> LibC::Int)
    partial_data : Void*
    target_class : Void*
    capture_errors : MrbBool
    dump_result : MrbBool
    no_exec : MrbBool
    keep_lv : MrbBool
    no_optimize : MrbBool
    on_eval : MrbBool
    parser_nerr : LibC::SizeT
  end
  enum MrbLexStateEnum
    ExprBeg = 0
    ExprEnd = 1
    ExprEndarg = 2
    ExprEndfn = 3
    ExprArg = 4
    ExprCmdarg = 5
    ExprMid = 6
    ExprFname = 7
    ExprDot = 8
    ExprClass = 9
    ExprValue = 10
    ExprMaxState = 11
  end
  struct MrbParserMessage
    lineno : LibC::Int
    column : LibC::Int
    message : LibC::Char*
  end
  struct MrbParserHeredocInfo
    allow_indent : MrbBool
    line_head : MrbBool
    type : MrbStringType
    term : LibC::Char*
    term_len : LibC::Int
    doc : MrbAstNode*
  end
  enum MrbStringType
    StrNotParsing = 0
    StrSquote = 1
    StrDquote = 3
    StrRegexp = 7
    StrSword = 41
    StrDword = 43
    StrSsym = 17
    StrSsymbols = 49
    StrDsymbols = 51
    StrHeredoc = 65
    StrXquote = 131
  end
  fun mrb_parser_new(x0 : MrbState*) : MrbParserState*
  fun mrb_parser_free(x0 : MrbParserState*)
  fun mrb_parser_parse(x0 : MrbParserState*, x1 : MrbcContext*)
  fun mrb_parser_set_filename(x0 : MrbParserState*, x1 : LibC::Char*)
  fun mrb_parser_get_filename(x0 : MrbParserState*, idx : Uint16T) : MrbSym
  fun mrb_parse_file(x0 : MrbState*, x1 : File*, x2 : MrbcContext*) : MrbParserState*
  fun mrb_parse_string(x0 : MrbState*, x1 : LibC::Char*, x2 : MrbcContext*) : MrbParserState*
  fun mrb_parse_nstring(x0 : MrbState*, x1 : LibC::Char*, x2 : LibC::SizeT, x3 : MrbcContext*) : MrbParserState*
  fun mrb_generate_code(x0 : MrbState*, x1 : MrbParserState*) : Void*
  fun mrb_load_exec(mrb : MrbState*, p : MrbParserState*, c : MrbcContext*) : MrbValue
  fun mrb_load_file(x0 : MrbState*, x1 : File*) : MrbValue
  fun mrb_load_file_cxt(x0 : MrbState*, x1 : File*, cxt : MrbcContext*) : MrbValue
  fun mrb_load_string(mrb : MrbState*, s : LibC::Char*) : MrbValue
  fun mrb_load_nstring(mrb : MrbState*, s : LibC::Char*, len : LibC::SizeT) : MrbValue
  fun mrb_load_string_cxt(mrb : MrbState*, s : LibC::Char*, cxt : MrbcContext*) : MrbValue
  fun mrb_load_nstring_cxt(mrb : MrbState*, s : LibC::Char*, len : LibC::SizeT, cxt : MrbcContext*) : MrbValue
end
