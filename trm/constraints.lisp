(module trm)

(defconst
  BALANCE      0x31
  EXTCODESIZE  0x3b
  EXTCODECOPY  0x3c
  EXTCODEHASH  0x3f
  CALL         0xf1
  CALLCODE     0xf2
  DELEGATECALL 0xf4
  STATICCALL   0xfa
  SELFDESTRUCT 0xff
  LLARGEMO     15)


;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     ;;
;;    2.1 heartbeat    ;;
;;                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstraint first-row (:domain {0})
                (vanishes! STAMP))

(defconstraint heartbeat ()
  (begin
   (* (will-remain-constant! STAMP) (will-inc! STAMP 1))
   (if-not-zero (will-remain-constant! STAMP) (vanishes! (next CT)))
   (if-not-zero STAMP
                (if-eq-else CT LLARGEMO
                            (will-inc! STAMP 1)
                            (will-inc! CT 1)))))

(defconstraint last-row (:domain {-1})
  (if-not-zero STAMP  (= CT LLARGEMO)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           ;;
;;    2.2 stamp constancy    ;;
;;                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstraint stamp-constancies ()
  (begin
   (stamp-constancy STAMP ADDR_HI)
   (stamp-constancy STAMP ADDR_LO)
   (stamp-constancy STAMP IS_PREC)
   (stamp-constancy STAMP TRM_ADDR_HI)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                   ;;
;;    2.4 binary, bytehood and byte decompositions   ;;
;;                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstraint binary-and-byte-decompositions ()
  (begin
   (is-binary IS_PREC)
   (is-binary ONES)
   (byte-decomposition CT ACC_HI BYTE_HI)
   (byte-decomposition CT ACC_LO BYTE_LO)
   (byte-decomposition CT ACC_T (* PBIT BYTE_HI))
))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                 ;;
;;    2.5 Target constraints       ;;
;;                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstraint trm-constraints ()
  (if-eq CT LLARGEMO
         (begin (= ADDR_HI ACC_HI)
                (= ADDR_LO ACC_LO))))
;;
;;                (= TRM_ADDR_HI ACC_T)
;;                (if-not-zero (+ TRM_ADDR_HI (- ADDR_LO BYTE_LO))
;;                             (= IS_PREC 0))
;;                (if-zero (+ TRM_ADDR_HI (- ADDR_LO BYTE_LO))
;;                         (if-zero BYTE_LO
;;                                  (= IS_PREC 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                 ;;
;;    2.3 Pivot bit constraints    ;;
;;                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstraint pivot-bit ()
  (begin
   (is-binary PBIT)
   (if-zero CT
            (vanishes! PBIT))
   (if-not-zero (- PBIT (prev PBIT))
                (= (- PBIT (prev PBIT)) 1))
   (if-eq CT 12 (= 1 (+ PBIT (prev PBIT))))))
