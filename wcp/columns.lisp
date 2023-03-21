(module wcp)

(defcolumns
	WORD_COMPARISON_STAMP
	(ONE_LINE_INSTRUCTION	:BOOLEAN)
	COUNTER
	INST
	ARGUMENT_1_HI
	ARGUMENT_1_LO
	ARGUMENT_2_HI
	ARGUMENT_2_LO
	RESULT_HI
	RESULT_LO
	(BITS	:BOOLEAN)
	(NEG_1	:BOOLEAN)
	(NEG_2	:BOOLEAN)
	(BYTE_1 :BYTE)
	(BYTE_2 :BYTE)
	(BYTE_3 :BYTE)
	(BYTE_4 :BYTE)
	(BYTE_5 :BYTE)
	(BYTE_6 :BYTE)
	ACC_1
	ACC_2
	ACC_3
	ACC_4
	ACC_5
	ACC_6
	(BIT_1	:BOOLEAN)
	(BIT_2	:BOOLEAN)
	(BIT_3	:BOOLEAN)
	(BIT_4	:BOOLEAN))

;; aliases
(defalias
	STAMP		WORD_COMPARISON_STAMP
	OLI			ONE_LINE_INSTRUCTION
	CT			COUNTER
	ARG_1_HI	ARGUMENT_1_HI
	ARG_1_LO	ARGUMENT_1_LO
	ARG_2_HI	ARGUMENT_2_HI
	ARG_2_LO	ARGUMENT_2_LO
	RES_HI		RESULT_HI
	RES_LO		RESULT_LO)