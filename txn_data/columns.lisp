(module txn_data)

(defcolumns
  ABS_TX_NUM_MAX
  ABS_TX_NUM
  BTC_NUM_MAX
  BTC_NUM
  REL_TX_NUM_MAX
  REL_TX_NUM
  CT
  
  FROM_HI
  FROM_LO
  NONCE
  INITIAL_BALANCE
  VALUE

  TO_HI
  TO_LO
  (IS_DEP :BOOLEAN)

  GAS_LIMIT
  INITIAL_GAS
  GAS_PRICE
  
  BASEFEE
  COINBASE_HI
  COINBASE_LO

  DATA_SIZE
  (TYPE0 :BOOLEAN)
  (TYPE1 :BOOLEAN)
  (TYPE2 :BOOLEAN)

  (REQUIRES_EVM_EXECUTION :BOOLEAN) 
  LEFTOVER_GAS
  REFUND_COUNTER
  REFUND_AMOUNT

  CUMULATIVE_CONSUMED_GAS
  (STATUS_CODE :BOOLEAN)

  PHASE
  CODE_FRAGMENT_INDEX
  DATA_HI
  DATA_LO
  WCP_ARG_ONE_LO
  WCP_ARG_TWO_LO
  (WCP_RES_LO :BOOLEAN)
  WCP_INST
  ZEROCOL
  )

(defalias
  ABS_MAX             ABS_TX_NUM_MAX
  ABS                 ABS_TX_NUM

  BTC_MAX             BTC_NUM_MAX
  BTC                 BTC_NUM

  REL_MAX             REL_TX_NUM_MAX
  REL                 REL_TX_NUM

  REQ_EVM             REQUIRES_EVM_EXECUTION
  CUM_GAS             CUMULATIVE_CONSUMED_GAS
  CFI                 CODE_FRAGMENT_INDEX

  REF_CNT             REFUND_COUNTER
  REF_AMT             REFUND_AMOUNT
  
  IGAS                INITIAL_GAS
  IBAL                INITIAL_BALANCE

  GLIM                GAS_LIMIT
  GPRC                GAS_PRICE
  )