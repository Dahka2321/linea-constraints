(module hub)

(defconst
  PATTERN_0_0           0
  PATTERN_ONE_ITEM      1
  PATTERN_TWO_ITEMS     2
  PATTERN_THREE_ITEMS   3
  PATTERN_DUP           4
  PATTERN_SWAP          5
  PATTERN_RETURN_REVERT 6
  PATTERN_COPY          7
  PATTERN_LOG           8
  PATTERN_CALL          9
  PATTERN_CREATE        10)

(defcolumns
    INSTRUCTION
    INSTRUCTION_STAMP
    INSTRUCTION_ARGUMENT_HI
    INSTRUCTION_ARGUMENT_LO
    BYTECODE_ADDRESS_HI
    BYTECODE_ADDRESS_LO
    (IS_INITCODE :BOOLEAN)
    PC

    CONTEXT_NUMBER
    MAXIMUM_CONTEXT
    (CONTEXT_TYPE :BOOLEAN)

    CALLER_CONTEXT
    RETURNER_CONTEXT

    CALLDATA_OFFSET
    CALLDATA_SIZE
    RETURN_OFFSET
    RETURN_CAPACITY
    RETURNDATA_OFFSET
    RETURNDATA_SIZE

    (CONTEXT_REVERTS :BOOLEAN)
    (CONTEXT_REVERTS_BY_CHOICE :BOOLEAN)
    (CONTEXT_REVERTS_BY_FORCE :BOOLEAN)
    CONTEXT_REVERT_STORAGE_STAMP
    (CONTEXT_RUNS_OUT_OF_GAS :BOOLEAN)
    (CONTEXT_ERROR :BOOLEAN)

    CALLSTACK_DEPTH
    VALUE

    ;; =====================================================================
    ;; INSTRUCTION DECODED FLAGS
    ;;=====================================================================
    (STATICCALL_FLAG :BOOLEAN)
    (DELEGATECALL_FLAG :BOOLEAN)
    (CODECALL_FLAG :BOOLEAN)
    ;;(JUMP_FLAG :BOOLEAN)
    ;;(PUSH_FLAG :BOOLEAN)

    ;; =====================================================================
    ;; STACK STUFF
    ;; =====================================================================
    STACK_STAMP
    STACK_STAMP_NEW
    HEIGHT
    HEIGHT_NEW

    (ITEM_HEIGHT :array [1:4])
    (VAL_LO :array [1:4])
    (VAL_HI :array [1:4])
    (ITEM_STACK_STAMP :array [1:4])
    (POP :array [1:4] :boolean)

    ALPHA
    DELTA
    HEIGHT_UNDER
    HEIGHT_OVER

    (STACK_EXCEPTION			:BOOLEAN)
    (STACK_UNDERFLOW_EXCEPTION	:BOOLEAN)
    (STACK_OVERFLOW_EXCEPTION	:BOOLEAN)

    ;; Imported from the ID
    STATIC_GAS
    INST_PARAM
    (TWO_LINES_INSTRUCTION :BOOLEAN)
    STACK_PATTERN
    (COUNTER :BOOLEAN)

    (FLAG_1 :BOOLEAN)
    (FLAG_2 :BOOLEAN)
    (FLAG_3 :BOOLEAN)

    TX_NUM

    ALU_STAMP
    BIN_STAMP
    RAM_STAMP
    SHF_STAMP
    STO_STAMP
    WCP_STAMP
    ;; WRM_STAMP

    (ARITHMETIC_INST		:BOOLEAN)
    (BINARY_INST            :BOOLEAN)
    (RAM_INST               :BOOLEAN)
    (SHIFT_INST             :BOOLEAN)
    (STORAGE_INST           :BOOLEAN)
    (WORD_COMPARISON_INST   :BOOLEAN)
    ;; (WRM_INST			:BOOLEAN)

    (ALU_ADD_INST	:BOOLEAN)
    (ALU_EXT_INST	:BOOLEAN)
    (ALU_MOD_INST	:BOOLEAN)
    (ALU_MUL_INST	:BOOLEAN)

    (CN_POW_4         :interleaved (CONTEXT_NUMBER CONTEXT_NUMBER CONTEXT_NUMBER CONTEXT_NUMBER))
    (HEIGHT_1234	  :interleaved ([ITEM_HEIGHT 1] [ITEM_HEIGHT 2] [ITEM_HEIGHT 3] [ITEM_HEIGHT 4]))
    (STACK_STAMP_1234 :interleaved ([ITEM_STACK_STAMP 1] [ITEM_STACK_STAMP 2] [ITEM_STACK_STAMP 3] [ITEM_STACK_STAMP 4]))
    (POP_1234		  :interleaved ([POP 1] [POP 2] [POP 3] [POP 4]))
    (VAL_HI_1234	  :interleaved ([VAL_HI 1] [VAL_HI 2] [VAL_HI 3] [VAL_HI 4]))
    (VAL_LO_1234	  :interleaved ([VAL_LO 1] [VAL_LO 2] [VAL_LO 3] [VAL_LO 4])))


(defpermutation
  (SRT_CN_POW_4 SRT_HEIGHT_1234 SRT_STACK_STAMP_1234 SRT_POP_1234 SRT_VAL_HI_1234 SRT_VAL_LO_1234)
  (CN_POW_4 HEIGHT_1234 STACK_STAMP_1234 POP_1234 VAL_HI_1234 VAL_LO_1234)
  ())