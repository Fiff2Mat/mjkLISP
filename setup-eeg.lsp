;(require '/home/neurosurgery/lisp/setup-eeg)
;;(graph:initializeWidgets);unused?

(defparameter eeg1-triuxneo
  (list "Fp1" "Fp2" "F7" "F3" "Fz" "F4" "F8" "T3" "C3" "Cz" "C4" "T4" 
        "T5" "P3" "Pz" "P4" "T6" "O1" "O2"))
(defparameter eeg0-triuxneo
  (list "Oz"  "Oz"  "Oz" "Oz" "Oz" "Oz" "Oz" "Oz" "Oz" "Oz" "Oz" "Oz"
        "Oz" "Oz" "Oz" "Oz" "Oz" "Oz" "Oz"))
        
(defparameter eeg1-vectorview
  (list "Fp1" "F3" "C3" "P3" "O1" "F7" "T3" "T5" 
        "Fp2" "F4" "C4" "P4" "O2" "F8" "T4" "T6" "Fz" "Cz" "Pz" "ECG" "EOG"))

(defparameter eeg0-vectorview
  (list "Fp1" "F3" "C3" "P3" "O1" "F7" "T3" "T5" 
        "Fp2" "F4" "C4" "P4" "O2" "F8" "T4" "T6" "Fz" "Cz" "Pz" "" ""))

(defparameter eeg1-cleaveland60 (list 
  "Fp1" "Fpz" "Fp2" 
  "AF7" "AF3" "AF4" "AF8" 
  "F7" "F5" "F3" "F1" "Fz" "F2" "F4" "F6" "F8"
  "FT9" "FT7" "FC5" "FC3" "FC4" "FC6" "FT8" "FT10"
  "T9" "T7" "C5" "C3" "C1" "Cz" "C2" "C4" "C6" "T8" "T10"
  "TP9" "TP7" "CP5" "CP3" "CP4" "CP6" "TP8" "TP10"
  "P7" "P5" "P3" "P1" "Pz" "P2" "P4" "P6" "P8"
  "PO7" "PO3" "PO4" "PO8" 
  "O1" "Oz" "O2" "Iz"))

(defparameter eeg1-cleaveland(list
  "Fp1" "Fp2"  "F7" "F3" "Fz" "F4" "F8"  "T7" "C3" "Cz" "C4" "T8"
  "P7" "P3" "Pz" "P4" "P8"  "A1" "A2" "FT9" "FT10"))

(defparameter banana1a (list
  "F7" "T3" "Fp1" "F3" "C3" "P3" "Fz" "Cz" "Fp2" "F4" "C4" "P4" "F8" "T4"))

(defparameter banana1b (list
   "T3" "T5" "F3" "C3" "P3" "O1" "Cz" "Pz" "F4" "C4" "P4" "O2" "T4" "T6"))

(defparameter banana2a (list
  "Fp1" "Fp2" "F3" "F4" "C3" "C4" "P3" "P4" "F7" "F8" "T3" "T4" "Fz" "Cz"))

(defparameter banana2b (list
  "F3" "F4" "C3" "C4" "P3" "P4" "O1" "O2" "T3" "T4" "T5" "T6" "Cz" "Pz"))

(defparameter transversea (list
  "Fp1" "F7" "F3" "Fz" "F4" "T3" "C3" "Cz" "C4" "T5" "P3" "Pz" "P4" "O1"))

(defparameter transverseb (list
  "Fp2" "F3" "Fz" "F4" "F8" "C3" "Cz" "C4" "T4" "P3" "Pz" "P4" "T6" "O2"))

(defparameter mono1 (list "Fp1" "F3" "C3" "P3" "O1" "Fp2" "F4" "C4" "P4" "O2" 
  "F7" "T3" "T5" "F8" "T4" "T6" "Fz" "Cz" "Pz"))

(defparameter mono2 (list "Fp1" "Fp2" "F3" "F4" "C3" "C4" "P3" "P4" "O1" "O2" 
  "F7" "F8" "T3" "T4" "T5" "T6" "Fz" "Cz" "Pz"))

(defparameter banana3a(list
  "Fp1" "F7" "FT9" "T7" "P7"  "Fp2" "F8" "FT10" "T8" "P8"  
  "FT9"  "A1" "Fp1" "F3" "C3" "Fp2" "F4" "C4")) 
(defparameter banana3b(list
  "F7" "FT9" "T7" "P7" "O1"   "F8" "FT10" "T8" "P8" "O2"   
  "FT10" "A2" "F3"  "C3" "P3" "F4" "C4" "P4"))
