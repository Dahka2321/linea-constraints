(module shf)


;; opcode values
(defconst
    SHL                 27
    SHR                 28
    SAR                 29
    LIMB_SIZE_MINUS_ONE 15
    LIMB_SIZE           16)


;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     ;;
;;    2.1 heartbeat    ;;
;;                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;


;; 2.1.1)
(defconstraint firstRow (:domain {0}) (vanishes STAMP))

;; 2.1.2)
(defconstraint stampIncrements ()
  (vanishes (* (inc STAMP 0)
               (inc STAMP 1))))
;; 2.1.3)
(defconstraint zeroRow ()
  (if-zero STAMP (vanishes CT))) ;; TODO: more zero columns required ?

;; 2.1.4)
(defconstraint counterReset ()
  (if-not-zero (remains-constant STAMP)
               (vanishes (shift CT 1))))
;; 2.1.5)
(defconstraint heartbeat ()
  (if-not-zero STAMP
               (if-zero OLI
                        ;; 2.1.5.b)
                        ;; If OLI == 0
                        (if-eq-else CT LIMB_SIZE_MINUS_ONE
                                    ;; 2.1.5.b).(ii)
                                    ;; If CT == LIMB_SIZE_MINUS_ONE (15)
                                    (inc STAMP 1)
                                    ;; 2.1.5.b).(i)
                                    ;; If CT != LIMB_SIZE_MINUS_ONE (15)
                                    (begin (inc CT 1)
                                           (remains-constant OLI)))
                        ;; 2.1.5.a)
                        ;; If OLI == 1
                        (inc STAMP 1))))
;; 2.1.6)
(defconstraint last-row (:domain {-1})
  (if-not-zero STAMP
               (if-zero OLI
                        (= CT LIMB_SIZE_MINUS_ONE))))

;; counter-constancy constraints
(defun (counter-constancy ct X)
    (if-not-zero ct (didnt-change X)))

;; counter-constant columns
(defconstraint counter-constancies ()
  (begin
   (counter-constancy CT BIT_B_3)
   (counter-constancy CT BIT_B_4)
   (counter-constancy CT BIT_B_5)
   (counter-constancy CT BIT_B_6)
   (counter-constancy CT BIT_B_7)
   (counter-constancy CT NEG)
   (counter-constancy CT SHD)
   (counter-constancy CT LOW_3)
   (counter-constancy CT µSHP)
   (counter-constancy CT OLI)
   (counter-constancy CT KNOWN)))

;; stamp constancies
(defconstraint stamp-constancies ()
  (begin
   (stamp-constancy STAMP ARG_1_HI)
   (stamp-constancy STAMP ARG_1_LO)
   (stamp-constancy STAMP ARG_2_HI)
   (stamp-constancy STAMP ARG_2_LO)
   (stamp-constancy STAMP RES_HI)
   (stamp-constancy STAMP RES_LO)
   (stamp-constancy STAMP INST)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                         ;;
;;    2.3 binary columns   ;;
;;                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; binary columns
(defconstraint binary_constraints ()
  (begin
   (is-binary BIT_1)
   (is-binary BIT_2)
   (is-binary BIT_3)
   (is-binary BIT_4)
   (is-binary BIT_B_3)
   (is-binary BIT_B_4)
   (is-binary BIT_B_5)
   (is-binary BIT_B_6)
   (is-binary BIT_B_7)
   (is-binary BITS)
   (is-binary NEG)
   (is-binary OLI)
   (is-binary SHD)
   (is-binary KNOWN)))

;; 2.2.2 SHD constraints
(defconstraint shift_direction_constraint (:guard STAMP)
  (if-eq-else INST SHL
              ;; INST == SHL => SHD = 0
              (vanishes SHD)
              ;; INST != SHL => SHD = 1
              (eq SHD 1)))

;; 2.2.3 OLI constraints
(defconstraint oli_constraints (:guard STAMP)
  (if-zero (* (- INST SAR) ARG_1_HI)
           (vanishes OLI)
           (eq OLI 1)))

;; 2.2.4 BITS constraints
(defconstraint bits_constraints (:guard STAMP)
  (if-zero OLI
           (begin (if-zero CT
                           (begin (= NEG BITS)
                                  (= BYTE_2
                                     (+ (* 128 BITS)
                                        (* 64 (shift BITS 1))
                                        (* 32 (shift BITS 2))
                                        (* 16 (shift BITS 3))
                                        (* 8 (shift BITS 4))
                                        (* 4 (shift BITS 5))
                                        (* 2 (shift BITS 6))
                                        (shift BITS 7))))
                           (if-eq CT LIMB_SIZE_MINUS_ONE
                                  (= BYTE_1
                                     (+ (* 128 (shift BITS -7))
                                        (* 64 (shift BITS -6))
                                        (* 32 (shift BITS -5))
                                        (* 16 (shift BITS -4))
                                        (* 8 (shift BITS -3))
                                        (* 4 (shift BITS -2))
                                        (* 2 (shift BITS -1))
                                        BITS)))))))
(defconstraint setting_stuff ()
  (if-eq CT LIMB_SIZE_MINUS_ONE
         (begin (= LOW_3
                   (+
                    (* 4 (shift BITS -2))
                    (* 2 (shift BITS -1))
                    BITS))
                (if-zero SHD
                         (= µSHP (- 8 LOW_3))
                         (= µSHP LOW_3))
                (= BIT_B_3 (shift BITS -3))
                (= BIT_B_4 (shift BITS -4))
                (= BIT_B_5 (shift BITS -5))
                (= BIT_B_6 (shift BITS -6))
                (= BIT_B_7 (shift BITS -7)))))

;; 2.2.5 KNOWN constraints
(defconstraint known_constraint ()
  (if-eq CT LIMB_SIZE_MINUS_ONE
         (if-eq-else INST SAR
                     (if-zero ARG_1_HI
                              (if-eq-else ARG_1_LO BYTE_1
                                          (vanishes KNOWN)
                                          (= KNOWN 1))
                              (= KNOWN 1))
                     (if-eq-else ARG_1_LO BYTE_1
                                 (vanishes KNOWN)
                                 (= KNOWN 1)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                              ;;
;;    2.3 byte decompositions   ;;
;;                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun (byte-decomposition ct acc bytes)
            (if-zero ct
                (eq acc bytes)
                (eq acc (+ (* 256 (shift acc -1)) bytes))))

;; byte decompositions
(defconstraint byte_decompositions ()
            (begin
                (byte-decomposition CT ACC_1 BYTE_1)
                (byte-decomposition CT ACC_2 BYTE_2)
                (byte-decomposition CT ACC_3 BYTE_3)
                (byte-decomposition CT ACC_4 BYTE_4)
                (byte-decomposition CT ACC_5 BYTE_5)))

;; bytehood constraints TODO


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                             ;;
;;    2.4 target constraints   ;;
;;                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defconstraint target_constraints ()
            (if-eq CT LIMB_SIZE_MINUS_ONE
                (begin
                    (= ACC_1 ARG_1_LO)
                    (= ACC_2 ARG_2_HI)
                    (= ACC_3 ARG_2_LO)
                    (= ACC_4 RES_HI)
                    (= ACC_5 RES_LO))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                               ;;
;;    2.5 shifting constraints   ;;
;;                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun (left-shift-by
            k ct
            bit_b bit_n
            B1_init B2_init
            B1_shft B2_shft)
            (begin
                (plateau-constraint ct bit_n (- LIMB_SIZE k))
                (if-zero bit_b
                    (begin
                        (= B1_shft B1_init)
                        (= B2_shft B2_init))
                    (if-zero bit_n
                        (begin
                            (= B1_shft (shift B1_init k))
                            (= B2_shft (shift B2_init k)))
                        (begin
                            (= B1_shft (shift B2_init (- k LIMB_SIZE)))
                            (vanishes B2_shft))))))

(defun (right-shift-by
            k ct
            neg inst
            bit_b bit_n
            B1_init B2_init
            B1_shft B2_shft)
            (begin
                (plateau-constraint ct bit_n k)
                (if-zero bit_b
                    (begin
                        (= B1_shft B1_init)
                        (= B2_shft B2_init))
                    (if-zero bit_n
                        ;; bit_n == 0
                        (begin
                            (if-eq-else inst SAR
                                ;; INST == SAR
                                (= B1_shft (* 255 neg))
                                ;; INST != SAR
                                (vanishes B1_shft))
                            (= B2_shft (shift B1_init (- LIMB_SIZE k))))
                        ;; bit_n == 1
                        (begin
                            (= B1_shft (shift B1_init (- 0 k)))
                            (= B2_shft (shift B2_init (- 0 k))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                    ;;
;;    2.6 shifted bytes constraints   ;;
;;                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun (shb_3)
            (if-zero SHD
                ;; SHD == 0
                (if-eq-else CT LIMB_SIZE_MINUS_ONE
                    ;; CT == 15
                    (begin
                        (= SHB_3_HI (+ LA_HI (shift RA_LO (- 0 LIMB_SIZE_MINUS_ONE))))
                        (= SHB_3_LO LA_LO))
                    ;; CT != 15
                    (begin
                        (= SHB_3_HI (+ LA_HI (shift RA_HI 1)))
                        (= SHB_3_LO (+ LA_LO (shift RA_LO 1)))))
                ;; SHD == 1
                (if-zero CT
                    ;; CT == 0
                    (begin
                        (if-not-zero (- INST SHR) (= SHB_3_HI (+ (* NEG ONES) RA_HI)))
                        (if-not-zero (- INST SAR) (= SHB_3_HI RA_HI))
                        (= SHB_3_LO (+ (shift LA_HI LIMB_SIZE_MINUS_ONE) RA_LO)))
                    ;; CT != 0
                    (begin
                        (= SHB_3_HI (+ (shift LA_HI (- 0 1)) RA_HI))
                        (= SHB_3_LO (+ (shift LA_LO (- 0 1)) RA_LO))))))

(defun (shb_4)
            (if-zero SHD
                (left-shift-by
                    1 CT
                    BIT_B_3 BIT_1
                    SHB_3_HI SHB_3_LO
                    SHB_4_HI SHB_4_LO)

                (right-shift-by
                    1 CT
                    NEG INST
                    BIT_B_3 BIT_1
                    SHB_3_HI SHB_3_LO
                    SHB_4_HI SHB_4_LO)))

(defun (shb_5)
            (if-zero SHD
                (left-shift-by
                    2 CT
                    BIT_B_4 BIT_2
                    SHB_4_HI SHB_4_LO
                    SHB_5_HI SHB_5_LO)
                (right-shift-by
                    2 CT
                    NEG INST
                    BIT_B_4 BIT_2
                    SHB_4_HI SHB_4_LO
                    SHB_5_HI SHB_5_LO)))

(defun (shb_6)
            (if-zero SHD
                (left-shift-by
                    4 CT
                    BIT_B_5 BIT_3
                    SHB_5_HI SHB_5_LO
                    SHB_6_HI SHB_6_LO)
                (right-shift-by
                    4 CT
                    NEG INST
                    BIT_B_5 BIT_3
                    SHB_5_HI SHB_5_LO
                    SHB_6_HI SHB_6_LO)))

(defun (shb_7)
            (if-zero SHD
                (left-shift-by
                    8 CT
                    BIT_B_6 BIT_4
                    SHB_6_HI SHB_6_LO
                    SHB_7_HI SHB_7_LO)
                (right-shift-by
                    8 CT
                    NEG INST
                    BIT_B_6 BIT_4
                    SHB_6_HI SHB_6_LO
                    SHB_7_HI SHB_7_LO)))

(defun (res_bytes)
            (if-zero KNOWN
                ;; KNOWN == 0
                (if-zero SHD
                    ;; SHD == 0
                    (if-zero BIT_B_7
                        (begin
                            (= BYTE_4 SHB_7_HI)
                            (= BYTE_5 SHB_7_LO))
                        (begin
                            (= BYTE_4 SHB_7_LO)
                            (vanishes BYTE_5)))
                    ;; SHD == 1
                    (if-zero BIT_B_7
                        (begin
                            (= BYTE_4 SHB_7_HI)
                            (= BYTE_5 SHB_7_LO))
                        (begin
                            (if-eq-else INST SHR
                                (vanishes BYTE_4)
                                (= BYTE_4 (* 255 NEG)))
                            (= BYTE_5 SHB_7_HI))))
                ;; KNOWN == 1
                (if-eq-else INST SAR
                    ;; INST == SAR
                    (begin
                        (eq BYTE_4 (* 255 NEG))
                        (eq BYTE_5 (* 255 NEG)))
                    ;; INST != SAR
                    (begin
                        (vanishes BYTE_4)
                        (vanishes BYTE_5))
                    )))

;; all shift constraints
(defconstraint shifted_byte_columns ()
            (if-not-zero STAMP
                (if-zero OLI
                    (begin
                        (shb_3)
                        (shb_4)
                        (shb_5)
                        (shb_6)
                        (shb_7)
                        (res_bytes)))))


;; IS_DATA
(defconstraint is_data ()
            (if-zero STAMP
                (vanishes IS_DATA)
                (eq IS_DATA 1)))