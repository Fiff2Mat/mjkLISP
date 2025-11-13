;; released by Akira Hashizume @ Hiroshima University Hospital
;; on 2025 July 3rd
;; revised on 2025 November 13th
;; This code requires three C-compiled files, criteria_bdip, read_bdip, and select_time.

(setq MEGsite 1 *hns-meg* "/home/neurosurgery/lisp/hns_meg5");1: Hiroshima University Hospital
;(setq MEGsite 2 *hns-meg* "/home/neuromag/lisp/hns_meg5");2: Cleaveland 10-10 rule
;(setq MEGsite 3 *hns-meg* "/home/neuromag/lisp/hns_meg5");3: Cleaveland 10-20 rule

(defun add-arrows(form text labelname)
  (let ((wd 15)(arrow1)(arrow2)(label))
    (setq arrow1 (XmCreateArrowButton form "arrow1" (X-arglist) 0))
    (setq arrow2 (XmCreateArrowButton form "arrow2" (X-arglist) 0))
    (setq label  (XmCreateLabel       form "label"  (X-arglist) 0))
    (set-values text :rightOffset wd)
    (set-values arrow1 :leftAttachment XmATTACH_WIDGET :leftWidget text
      :arrowDirection XmARROW_UP :width wd
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text
      :shadowThickness 0 :detailShadowThickness 0
      :foreground (rgb 0 100 0))
    (set-values arrow2 :leftAttachment XmATTACH_WIDGET :leftWidget text
      :arrowDirection XmARROW_DOWN :width wd
      :bottomAttachment XmATTACH_OPPOSITE_WIDGET :bottomWidget text
      :shadowThickness 0 :detailShadowThickness 0 :bottomOffset -3
      :foreground (rgb 0 100 0))
    (set-values label :labelString (XmString labelname)
      :rightAttachment XmATTACH_WIDGET :rightWidget text 
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text 
      :rightOffset 5 :topOffset 5)
    (return (list arrow1 arrow2 label))
))

(defun add-color()
  (make-menu *display-menu* "color" nil
    '("default-white  background-black" (change-color 1))
    '("default-black  background-white" (change-color 2)))
)

(defun add-layout()
  (make-menu *display-menu* "layout" nil 
    '("MEG : EEG | meg" (change-layout 1))    
    '("EEG : MEG | meg" (change-layout 2))
    '("EEG : MEG : meg" (change-layout 5))
    '("8meg :EEG"       (change-layout 3))
    '("paned MEG : meg :EEG" (change-layout  4))
    '("MEG:paned  meg:EEG" (change-layout 6))
    '("meg:paned MEG:EEG" (change-layout 7)))
)

(defun add-megsel()
  (make-menu *display-menu* "MEG selection" nil :tear-off
    '("gra-L-temporal"  (change-megsel "gra-L-temporal"))
    '("gra-R-temporal"  (change-megsel "gra-R-temporal"))
    '("gra-L-parietal"  (change-megsel "gra-L-parietal"))
    '("gra-R-parietal"  (change-megsel "gra-R-parietal"))
    '("gra-L-occipital" (change-megsel "gra-L-occipital"))
    '("gra-R-occipital" (change-megsel "gra-R-occipital"))
    '("gra-L-frontal"   (change-megsel "gra-L-frontal"))
    '("gra-R-frontal"   (change-megsel "gra-R-frontal"))
    '("mag-L-temporal"  (change-megsel "mag-L-temporal"))
    '("mag-R-temporal"  (change-megsel "mag-R-temporal"))
    '("mag-L-parietal"  (change-megsel "mag-L-parietal"))
    '("mag-R-parietal"  (change-megsel "mag-R-parietal"))
    '("mag-L-occipital" (change-megsel "mag-L-occipital"))
    '("mag-R-occipital" (change-megsel "mag-R-occipital"))
    '("mag-L-frontal"   (change-megsel "mag-L-frontal"))
    '("mag-R-frontal"   (change-megsel "mag-R-frontal")))
)

(defun add-sync()
  (if (G-widget "disp000" :quiet)(set-resource (G-widget "disp000");; selected MEG
    :move-hook '(sync-move-hook (G-widget "disp000"))
    :select-hook '(sync-select-hook (G-widget "disp000"))))
  (if (G-widget "disp001" :quiet)(set-resource (G-widget "disp001")
    :move-hook '(sync-move-hook (G-widget "disp001"))
    :select-hook '(sync-select-hook (G-widget "disp001"))))
  (if (G-widget "disp002" :quiet)(set-resource (G-widget "disp002")
    :move-hook '(sync-move-hook (G-widget "disp002"))
    :select-hook '(sync-select-hook (G-widget "disp002"))))
  (if (G-widget "disp003" :quiet)(set-resource (G-widget "disp003")
    :move-hook '(sync-move-hook (G-widget "disp003"))
    :select-hook '(sync-select-hook (G-widget "disp003"))))
  (if (G-widget "disp004" :quiet)(set-resource (G-widget "disp004")
    :move-hook '(sync-move-hook (G-widget "disp004"))
    :select-hook '(sync-select-hook (G-widget "disp004"))))
  (if (G-widget "disp005" :quiet)(set-resource (G-widget "disp005")
    :move-hook '(sync-move-hook (G-widget "disp005"))
    :select-hook '(sync-select-hook (G-widget "disp005"))))
  (if (G-widget "disp006" :quiet)(set-resource (G-widget "disp006")
    :move-hook '(sync-move-hook (G-widget "disp006"))
    :select-hook '(sync-select-hook (G-widget "disp006"))))
  (if (G-widget "disp007" :quiet)(set-resource (G-widget "disp007")
    :move-hook '(sync-move-hook (G-widget "disp007"))
    :select-hook '(sync-select-hook (G-widget "disp007"))))
  (if (G-widget "disp008" :quiet)(set-resource (G-widget "disp008")
    :move-hook '(sync-move-hook (G-widget "disp008"))
    :select-hook '(sync-select-hook (G-widget "disp008"))))
  (if (G-widget "disp009" :quiet)(set-resource (G-widget "disp009");; EEG
    :move-hook '(sync-move-hook (G-widget "disp009"))
    :select-hook '(sync-select-hook (G-widget "disp009"))))
)

(defun autoscale(chtype);; under construction
  (let ((n)(mtx)(w)(w0)(fs)(T0)(SPAN)(N)(ch nil)(range nil)(amp))
    (setq w (G-widget "disp009"))
    (setq w0 (G-widget "sel"))
    (setq fs (resource w :x-scale))
    (setq T0 (round   (/ (resource w :point) fs)))
    (setq SPAN (round (/ (resource w :length) fs))) 
    (cond
      ((string-equal chtype "EEG")(progn
        (setq N (resource w :channels))
        (setq mtx (get-data-matrix w0 T0 SPAN))
        (dotimes (n N)
          (when (= (get-property w n :kind) 2)
            (setq ch (append ch (list n)))))
        (dolist (n ch)
          (setq range (append range (matrix-extent (row n mtx)))))
        (setq amp (eval (cons 'max (mapcar #'abs range))))
        (XmTextSetString text-eeg (format nil "~0,0f" (* amp 1e+6)))
        (change-eegscale)))
      ((string-equal chtype "EOG")(progn
        (setq N (resource w :channels))
        (setq mtx (get-data-matrix w0 T0 SPAN))
        (dotimes (n N)
          (when (= (get-property w n :kind) 202)
            (setq ch (append ch (list n)))))
        (dolist (n ch)
          (setq range (append range (matrix-extent (row n mtx)))))
        (setq amp (eval (cons 'max (mapcar #'abs range))))
        (XmTextSetString text-eog (format nil "~0,0f" (* amp 1e+6)))
        (change-eegscale)))
      ((string-equal chtype "ECG")(progn
        (setq N (resource w :channels))
        (setq mtx (get-data-matrix w0 T0 SPAN))
        (dotimes (n N)
          (when (= (get-property w n :kind) 402)
            (setq ch (append ch (list n)))))
        (dolist (n ch)
          (setq range (append range (matrix-extent (row n mtx)))))
        (setq amp (eval (cons 'max (mapcar #'abs range))))
        (XmTextSetString text-ecg (format nil "~0,0f" (* amp 1e+6)))
        (change-eegscale)))
      ((string-equal chtype "MEG")(progn
        (setq mtx (get-data-matrix (G-widget "gra") T0 SPAN))
        (setq range (matrix-extent mtx))
        (setq amp (eval (cons 'max (mapcar #'abs range))))
        (XmTextSetString text-gra (format nil "~0,0f" (* amp 1e+13)))
        (change-grascale)
        (setq mtx (get-data-matrix (G-widget "mag") T0 SPAN))
        (setq range (matrix-extent mtx))
        (setq amp (eval (cons 'max (mapcar #'abs range))))
        (XmTextSetString text-mag (format nil "~0,0f" (* amp 1e+15)))
        (change-magscale)))
    )
))

(defun build()
  (let ((dir)(str)(files))
    (setq files (list "read_bdip" "criteria_bdip" "select_time"))
    (setq dir (string-right-trim "hns_meg5" *hns-meg*))
    (dolist (n files)
      (if (string-equal n "read_bdip")
        (setq str (format nil "gcc ~a~a5.c -o ~a~a" dir n dir n))
        (setq str (format nil "gcc ~a~a.c -o ~a~a" dir n dir n)))
      (print str)
      (system str)
      (setq str (format nil "chmod +x ~a~a" dir n))
      (print str)
      (system str))
    (print (format nil "~d files are build" (length files)))
))

(defun calc-near-coil()
  (let ((R nil)(dist)(x)(xx)(chname))
    (setq chname (make-chname))
    (dotimes (i (length ch-dist))
      (setq dist (nth i ch-dist))
      (setq x (sort-order dist))
      (setq xx nil)
      (dolist (j x)
        (setq xx (append xx (list (nth j chname)))))
      (setq R (append R (list xx))))
    (return R)
))

(defun calc-noise-level()
  (let ((w1)(w2)(t0)(span)(mtx)(rms-gra)(rms-mag)(w)(N)(str))
    (setq t0   (resource (G-widget "disp009") :selection-start))
    (setq span (resource (G-widget "disp009") :selection-length))
    (unless (G-widget "nzwin" :quiet)
      (setq w1 (require-widget :data-window "nzwin")))
    (unless (G-widget "nzvecop" :quiet)
      (setq w2 (require-widget :vecop "nzvecop")))
    (set-resource w1 :point t0 :start 0 :end span)
    (set-resource w2 :mode "rms")
    (link (G-widget "gra")w1)
    (link w1 w2)
    (setq N (resource w1 :high-bound))
    (setq mtx (get-data-matrix w2 0 N));#<1xN matrix> no channel info
    (setq rms-gra (/ (* mtx (ruler-vector 1 1 N))N))
    (setq rms-gra (* rms-gra 1e+13))
    (link (G-widget "mag") w1)
    (setq mtx (get-data-matrix w2 0 N))
    (setq rms-mag (/ (* mtx (ruler-vector 1 1 N))N))
    (setq rms-mag (* rms-mag 1e+15))
    ;(xfit-command "qscale 20")
    (XmTextSetString text-granoise (format nil "~0,1f" rms-gra))
    (XmTextSetString text-magnoise (format nil "~0,1f" rms-mag)) 
    (dolist (w (list w1 w2))(GtDeleteWidget w))
))

(defun calc-noise-level-old()
  (let ((w)(t0)(R)(span)(smp)(mtx)(ave-gra)(ave-mag)(str))
    (setq w (G-widget "disp001"))
    (setq R (GtGetResources w (list "selection-start" "selection-length")))
    (setq t0 (first R) span (second R))
    (if (> span 0)(progn
      (setq smp (/ 1 (resource w :x-scale)))
      (setq t0   (round (* t0 smp)))
      (setq span (round (* span smp)))
      (setq mtx (get-data-matrix (G-widget "gra") t0 span))
      (setq mtx (map-matrix mtx #'abs))
      (setq ave-gra (matrix-element-sum mtx))
      (setq ave-gra (/ ave-gra (* 204 span)))
      (setq mtx (get-data-matrix (G-widget "mag") t0 span))
      (setq mtx (map-matrix mtx #'abs))
      (setq ave-mag (matrix-element-sum mtx))
      (setq ave-mag (/ ave-mag (* 102 span)))
      (setq ave-gra (* ave-gra 1e+13))
      (setq ave-mag (* ave-mag 1e+15))
      (info (format nil "  noise level~% gradiometer ~0,1f [fT/cm]~% magnetometer ~0,1f [fT]" ave-gra ave-mag)) 
      (setq str (format nil "noise constant ~0,1f ~0,1f ~%" ave-gra ave-mag))
      (xfit-command str)
      (xfit-command "qscale 20")
      (return (list ave-gra ave-mag))
    ))
))

(defun calctimes()
  (let ((tmin)(tmax)(span)(x)(smp)(w))
    (setq w (G-widget "buf"))
    (setq smp (resource w :x-scale))
    (setq tmin (* smp (resource w :low-bound)))
    (setq tmax (* smp (resource w :high-bound)))
    (setq span (read-from-string (XmTextGetString text-length)))
    (return (list tmin tmax span)) 
))

(defun change-color(nn)
  (let ((n)(dc)(bg)(hl)(bc)(disp)(w (G-widget "disp001")))
    ;default-color background highlight baseline-color
    (cond 
      ((= nn 0)(setq dc (resource w :default-color)
                     bg (resource w :background)
                     hl (resource w :highlight)
                     bc (resource w :baseline-color)))
      ((= nn 1)(setq dc "white" bg "black" hl "white" bc "white"))
      ((= nn 2)(setq dc "black" bg "white" hl "gray80" bc "white"))
    )
    (dotimes (n 10)
      (setq disp (format nil "disp00~a" n))
      (if (G-widget disp :quiet)(set-resource (G-widget disp)
        :default-color dc :background bg :highlight hl :baseline-color bc)))
    (set-resource (G-widget "000")
        :default-color dc :background bg :highlight hl :baseline-color bc)
    (if (G-widget "scan" :quiet)(set-resource (G-widget "scan")
     :default-color dc :background bg :highlight hl :baseline-color bc))
))

(defun change-eegscale()
  (let ((w)(n)(eegscale)(ecgscale)(emgscale)(eogscale)(mtx nil)(kind))
    (setq w (G-widget "disp009"))
    (setq eegscale (list (get-eegscale)))
    (setq ecgscale (list (get-ecgscale)))
    (setq emgscale (list (get-emgscale)))
    (setq eogscale (list (get-eogscale)))
    (dotimes (n (resource w :channels))
      (setq kind (get-property w n :kind))
      (case kind
        (2   (setq mtx (append mtx eegscale)))
        (402 (setq mtx (append mtx ecgscale)))
        (302 (setq mtx (append mtx emgscale)))
        (202 (setq mtx (append mtx eogscale)))
      ))
    (setq mtx (transpose (matrix (list mtx))))
    (set-resource w :scales mtx)
))

(defun change-grascale()
  (let ((scale)(scale2)(n)(w)(nch))
    (setq scale (get-grascale))
    (dotimes (n 10)
      (setq w (format nil "disp00~a" n))
      (if (G-widget w :quiet)(progn
        (if (resource (G-widget w) :superpose)
          (setq scale2 (* scale 16))(setq scale2 scale));8* 2
        (setq nch (resource (G-widget w) :channels))
        (if (> nch 0)
          (if (string-equal (checkchannel (G-widget w)) "GRA")(progn
            (set-resource (G-widget w) :scales (make-matrix nch 1 scale2))))))))
))

(defun change-grascale000(nn)
  (let ((mtx))
    (setq mtx (resource (G-widget "000") :scales))
    (if (not mtx)(setq mtx (make-matrix 204 1 (get-grascale))))
    (case nn
      (1  (setq mtx (* mtx 1.25)))
      (-1 (setq mtx (* mtx 0.8)))
    ) 
    (set-resource (G-widget "000") :scales mtx)
))

(defun change-layout(nn)
  (let ((n)(disp)(eeg)(t0)(t1)(span)(span2)(col))
    (if (= nn 0)(progn
      (dotimes (n (resource (G-widget "ECG") :channels))
        (set-property (G-widget "ECG") n :kind 402))
      (dotimes (n (resource (G-widget "EOG") :channels))
        (set-property (G-widget "EOG") n :kind 202))
      (dotimes (n (resource (G-widget "EMG") :channels))
        (set-property (G-widget "EMG") n :kind 302))
      (setq nn nlayout)))
    (setq nlayout nn)
    (if (string-equal (resource (G-widget "disp001") :default-color) "white")
        (setq col 1)(setq col 2))
    (setq disp (G-widget "disp001"))
    (setq t0    (read-from-string (XmTextGetString text-start)))
    (setq span  (read-from-string (XmTextGetString text-length)))
    (setq t1    (resource disp :selection-start))
    (setq span2 (resource disp :selection-length))
    (case nn
      (1 (layout1 0))
      (2 (layout1 1))
      (3 (layout2))
      (4 (layout3))
      (5 (layout4))
      (6 (layout5))
      (7 (layout6))
    )
    (set-values frame001 :width 200);;necessary!
    (set-values gra204 :set 1)(set-values mag102 :set 0)
    (if (< (resource (G-widget "disp009") :channels) 3)
      (case MEGsite
        (1 (EEGHiroshima 1))
        (2 (EEGCleaveland 1))
        (3 (EEGCleaveland2 1))
      ))
    (dotimes (n 10)
      (setq disp (format nil "disp00~a" n))
      (if (G-widget disp :quiet)(set-resource (G-widget disp)
        :point t0 :length span :selection-start t1 :selection-length span2)))
    (add-sync)
    (change-color col)
    (if (get-property (G-widget "gra") 0 :kind)(progn
      (change-grascale)
      (change-eegscale)))
    (set-values form001 :bottomOffset 50)
))

(defun change-length()
  (let ((str)(x)(n))
    (setq str (XmTextGetString text-length))
    (setq x (read-from-string str))
    (dotimes (n 10)
      (setq str (format nil "disp00~a" n))
      (if (G-widget str :quiet)
        (set-resource (G-widget str) :length x)))
))

(defun change-magscale()
  (let ((scale)(scale2)(n)(w)(nch))
    (setq scale (get-magscale))
    (dotimes (n 10)
      (setq w (format nil "disp00~a" n))
      (if (G-widget w :quiet)(progn
        (if (resource (G-widget w) :superpose)
          (setq scale2 (* scale 16))(setq scale2 scale));8* 2
        (setq nch (resource (G-widget w) :channels))
        (if (> nch 0)
          (if (string-equal (checkchannel (G-widget w)) "MAG")
            (set-resource (G-widget w) :scales (make-matrix nch 1 scale2)))))))
))

(defun change-megsel(str); gra 26-26-26-26-24-24-26-26 mag 13-13-13-13-12-12-13-13
  (let ((megsel)(disp)(name)(t0)(span)(t1)(span2)(n)(megscale))
    (setq megsel (G-widget "meg-sel"))
    (if (not (G-widget "disp000" :quiet))(setq disp (require-widget :plotter "disp000")))
    (setq disp (G-widget "disp000"))
    (setq t0    (read-from-string (XmTextGetString text-start)))
    (setq span  (read-from-string (XmTextGetString text-length)))    
    (setq t1    (resource (G-widget "disp001") :selection-start))
    (setq span2 (resource (G-widget "disp001") :selection-length))       
    (cond 
      ((string-equal str "gra-L-temporal") (select-to megsel (meg   0 -  25)))
      ((string-equal str "gra-R-temporal") (select-to megsel (meg  26 -  51)))
      ((string-equal str "gra-L-parietal") (select-to megsel (meg  52 -  77)))
      ((string-equal str "gra-R-parietal") (select-to megsel (meg  78 - 103)))
      ((string-equal str "gra-L-occipital")(select-to megsel (meg 104 - 127)))
      ((string-equal str "gra-R-occipital")(select-to megsel (meg 128 - 151)))
      ((string-equal str "gra-L-frontal")  (select-to megsel (meg 152 - 177)))
      ((string-equal str "gra-R-frontal")  (select-to megsel (meg 178 - 203)))
      ((string-equal str "mag-L-temporal") (select-to megsel (meg 204 - 216)))
      ((string-equal str "mag-R-temporal") (select-to megsel (meg 217 - 229)))
      ((string-equal str "mag-L-parietal") (select-to megsel (meg 230 - 242)))
      ((string-equal str "mag-R-parietal") (select-to megsel (meg 243 - 255)))
      ((string-equal str "mag-L-occipital")(select-to megsel (meg 256 - 267)))
      ((string-equal str "mag-R-occipital")(select-to megsel (meg 268 - 279)))
      ((string-equal str "mag-L-frontal")  (select-to megsel (meg 280 - 292)))
      ((string-equal str "mag-R-frontal")  (select-to megsel (meg 293 - 305)))
    )
    (link megsel disp)
    (set-resource disp :point t0 :length span :ch-label-space 80)
    (if (string-equal str (string-left-trim "m" str))
      (setq megscale (get-grascale))(setq megscale (get-magscale)))
    (set-resource disp :scales (make-matrix (resource disp :channels) 1 megscale))
    (set-resource disp :selection-start t1 :selection-length span2)
    (GtPopupEditor disp)
    (dotimes (n 10)
      (setq disp (format nil "disp00~a" n))
      (if (G-widget disp :quiet)(set-resource (G-widget disp)
        :selection-start t1 :selection-length span2)))
    (add-sync)
    (change-color 0)
))

(defun change-megsel2(nn)
  (let ((str))
    (cond
      ((= nn 0)(setq str "L-temporal"))
      ((= nn 1)(setq str "R-temporal"))
      ((= nn 2)(setq str "L-parietal"))
      ((= nn 3)(setq str "R-parietal"))
      ((= nn 4)(setq str "L-occipital"))
      ((= nn 5)(setq str "R-occipital"))
      ((= nn 6)(setq str "L-frontal"))
      ((= nn 7)(setq str "R-frontal"))
    )
    (if (string-equal (checkchannel (G-widget "disp001")) "GRA")
      (setq str (format nil "gra-~a" str))
      (setq str (format nil "mag-~a" str)))
    (change-megsel str)
))

(defun change-memo(nn)
  (let ((n)(N))
    (setq nmemo nn)
    (setq nn (- nn 1))
    (setq N (list memo1 memo2 memo3))
    (dotimes (n 3)
      (if (= n nn)
        (set-values (nth n N) :background (rgb 255 255 255))
        (set-values (nth n N) :background (rgb 200 200 200))))
))

(defun change-offsets(x)
  (let ((w (G-widget "scan"))(mtx))
    (setq mtx (resource w :offsets))
    (setq x (/ x 2))
    (set-resource w :offsets (+ mtx (make-matrix 8 1 x)))
))

(defun change-scanscale()
  (let ((x))
    (setq x (read-from-string (XmTextGetString text-scan)))
    (setq x (* x 1e-13))
    (set-resource (G-widget "scan") :scales
      (make-matrix 8 1 x))
))

(defun change-start()
  (let ((str)(x)(n)(tt))
    (setq str (XmTextGetString text-start))
    (setq x (read-from-string str))
    (setq tt (calctimes))
    (if (< x (first tt))(setq x (first tt)))
    (setq tt (- (second tt)(third tt)))
    (if (> x tt)(setq x tt))
    (setq str (format nil "~0,2f" x))
    (XmTextSetString text-start str)
    (dotimes (n 10)
      (setq str (format nil "disp00~a" n))
      (if (G-widget str :quiet)
        (set-resource (G-widget str):point x)))
    (GtUnlinkWidget (G-widget "win000"))
))

(defun change-start000(nn)
  (let ((w (G-widget "win000"))(t0)(span))
    (setq t0   (resource w :point))
    (setq span (resource w :end))
    (setq span (* (/ span 4) nn))
    (setq t0 (+ t0 span))
    (set-resource w :point t0)
))

(defun chchsEEG();; EEG ECG EOG
  (let ((n)(w)(buf (G-widget "buf")))
    (dolist (w (list "EEG0" "ECG" "EOG" "EMG"))
      (unless (G-widget w :quiet)(require-widget :pick w)))
    (set-resource (G-widget "EEG0") :names '("EEG*"))
    (set-resource (G-widget "ECG" ) :names '("ECG*"))
    (set-resource (G-widget "EOG" ) :names '("EOG*"))  
    (set-resource (G-widget "EMG" ) :names '("EMG*"))
    (dolist (w (list "EEG-fil" "ECG-fil" "EOG-fil" "EMG-fil"))
      (unless (G-widget w :quiet)
        (require-widget :fft-filter w '("pass-band" (band-pass 0.5 50)))))   
    (unless (G-widget "sel" :quiet)(require-widget :selector "sel"))
    (link (G-widget "file")(G-widget "buf"))
    (link buf (G-widget "EEG0"))
    (link buf (G-widget "ECG"))
    (link buf (G-widget "EOG"))
    (link buf (G-widget "EMG")) 
    (link (G-widget "EEG0")(G-widget "EEG-fil"))
    (link (G-widget "ECG")(G-widget "ECG-fil"))
    (link (G-widget "EOG")(G-widget "EOG-fil"))
    (link (G-widget "EMG")(G-widget "EMG-fil"))
))

(defun chchsMEG()
  (let ((n)(w)(ws1)(ws2))
    (setq ws1 '("LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (setq ws2 '(gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal 
                gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal))
    (if (not (G-widget "buf" :quiet))(require-widget :ringbuffer "buf" '("size" 5000000)))
    (if (not (G-widget "MEG" :quiet))(require-widget :pick "MEG" '("names" ("MEG*"))))
    (if (not (G-widget "MEG-fil" :quiet))(require-widget :fft-filter "MEG-fil" '("pass-band" (band-pass 3 35)))) 
    (if (not (G-widget "ssp" :quiet))(require 'ssp))
    (set-resource (G-widget "ssp") :buffer-length 5000000)
    ; gra 26-26-26-26-24-24-26-26 mag 13-13-13-13-12-12-13-13
    (if (not (G-widget "meg" :quiet))(progn (require-widget :pick "meg")(set-resource (G-widget "meg") :names (append
      gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal 
      gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal
      mag-L-temporal mag-R-temporal mag-L-parietal mag-R-parietal 
      mag-L-occipital mag-R-occipital mag-L-frontal mag-R-frontal))))
    (if (not (G-widget "gra" :quiet))(require-widget :pick "gra" '("names" ("MEG*") "ignore" ("MEG*1"))))
    (if (not (G-widget "mag" :quiet))(require-widget :pick "mag" '("names" ("MEG*") "ignore" ("MEG*2" "MEG*3"))))
    (link (G-widget "file")(G-widget "buf"))
    (link (G-widget "buf")(G-widget "MEG"))
    (link (G-widget "MEG")(G-widget "ssp"))
    (link (G-widget "ssp")(G-widget "MEG-fil"))
    (link (G-widget "MEG-fil")(G-widget "meg"))
    (link (G-widget "meg")(G-widget "gra"))
    (link (G-widget "meg")(G-widget "mag"))
    (if (not (G-widget "meg-sel" :quiet))(require-widget :selector "meg-sel"))
    (if (not (G-widget "meg2" :quiet))(require-widget :pick "meg2"))
    (link (G-widget "meg")(G-widget "meg-sel"));selector for L/R temp/pari/occi/fron
    (link (G-widget "meg")(G-widget "meg2")); max sns +alpha
    (if (not (G-widget "win000" :quiet))(require-widget :data-window "win000"))
    (link (G-widget "gra")(G-widget "win000"))
    (set-resource (G-widget "file") :directory "/data/neuro-data/*.fif")
))

(defun chchsMEGmax()
  (let ((w1)(w2))
    (unless (G-widget "mxwin" :quiet)(require-widget :data-window "mxwin"))
    (unless (G-widget "mxvcp" :quiet)(require-widget :vecop "mxvcp"))
    (setq w1 (G-widget "mxwin"))
    (setq w2 (G-widget "mxvcp"))
    (set-resource w2 :mode "max-abs")
    (link w1 w2)
))

(defun checkchannel(w);G-widget
  (let ((n 0)(kind)(str)(str1))
    (setq kind (get-property w 0 :kind))
    (if (= kind 1)(progn
      (setq str (get-property w 0 :name))
      (if (string-equal str (string-right-trim "1" str))
        (setq n 3012)(setq n 3022)));; gra / mag
      (setq n kind)) ;;2 EEG  402 ECG 202 EOG
    (cond ((= n 3012)(return "GRA"))
          ((= n 3022)(return "MAG"))
          ((= n 2)(return "EEG"))
          ((= n 402)(return "ECG"))
          ((= n 302)(return "EMG"))
          ((= n 202)(return "EOG")))
))

(defun control-panel-show()
  (let ((W)(w));GtOrganizePanel
    (setq W (list
      '("file"     10  250) '("buf"      70  250) '("MEG"     130   70)
      '("ssp"     190  130) '("MEG-fil" 250   70) '("meg"     370   70)
      '("meg-sel" 430  190) '("disp000" 490  190) '("mag"     430  130)
      '("gra"     430   70) '("win000"  490  130) '("000"     540  130)
      '("mxwin"   540   10) '("mxvcp"   600   10) '("disp001" 490   70)
      '("meg2"    430   10) '("mtx"     430  250) '("scan"    490  250)
      '("fmul"    490  310) '("scan1"   550  310) '("EEG0"    130  370)
      '("EEG1"    190  310) '("EEG2"    250  370) '("fsub"    250  310)
      '("EEG-fil" 310  370) '("sel"     370  430) '("disp009" 430  430)
      '("ECG"     130  430) '("ECG-fil" 310  430) '("EOG"     130  490)
      '("EOG-fil" 310  490) '("fav"     190  370) '("s19"     250  370)
      '("stat-mtx" 130  10) '("stat-dsp" 190  10) '("EMG"     130  550)
      '("EMG-fil" 310  550)
      ))
    (dolist (w W)
      (when (G-widget (first w) :quiet)(progn
        (set-resource (G-widget (first w))
          :face-x (second w) :face-y (third w)))))
    (manage *control-panel*)
))

(defun create-initial-source()
  (let ((w)(mtx)(n)(x)(y)(z)(kind)(ch)(CH nil))
    (setq mtx (make-random-matrix (+ 306 19 1 1)(* 1 10)))
    (setq w (require-widget :matrix-source "mtx"))
    (set-resource w :matrix mtx :x-scale 1 :x-unit "s")
    (dotimes (x 26)
      (dotimes (y 4)
        (dotimes (z 3)
          (setq n (+ z 1 (* (+ y 1 (* (+ x 1) 10)) 10)))
          (setq ch (list (format nil "MEG~a" n)))
          (if (< n 830)(setq CH (append CH ch)))
          (if (> n 850)(setq CH (append CH ch))))))
    (dotimes (x 9)
      (setq ch (list(format nil "EEG00~a" (+ x 1))))
      (setq CH (append CH ch)))
    (dotimes (x 10)
      (setq ch (list (format nil "EEG0~a" (+ x 10))))
      (setq CH (append CH ch)))
    (setq CH (append CH (list "ECG001" "EOG001")))
    (setq kind 1)
    (dotimes (ch (length CH))
      (set-property w ch :name (nth ch CH))
      (if (> ch 306)(setq kind 2));;EEG
      (if (= ch 325)(setq kind 402));;ECG
      (if (= ch 326)(setq kind 202))
      (set-property w ch :kind kind))
      
))    

(defun create-launch()
  (let ((btn)(h))
    (setq form-launch (make-form-dialog *application-shell* "form-launch" 
     :autoUnmanage 0 :resize 1))
    (setq btn (make-button form-launch "btn" :labelString (XmString "Launch")
      :topAttachment   XmATTACH_FORM :leftAttachment   XmATTACH_FORM
      :rightAttachment XmATTACH_FORM :bottomAttachment XmATTACH_FORM))
    (set-values btn :width 200 :height 100 :background (rgb 0 255 255))
    (dolist (n (list btn form-launch))(manage n))
    (set-lisp-callback btn "activateCallback" '(initialize))
))

(defun create-memos()
  (let ((form)(btn1)(btn2)(pane)(n)(bar)(label1)(label2)(label3))
    (setq form (make-form-dialog *application-shell* "memos"
      :autoUnmanage 0 :resize 1))
    (setq bar (make-menu-bar form "bar" :autoUnmanage 0
      :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM))
    (create-memos-menu bar)
    (setq btn1 (make-button form "btn1" :labelString (XmString "note")
      :topAttachment XmATTACH_WIDGET :topWidget bar :height 30
      :leftAttachment XmATTACH_FORM :width 50))
    (setq btn2 (make-button form "btn2" :labelString (XmString "goto")
      :topAttachment XmATTACH_WIDGET :topWidget bar :height 30
      :leftAttachment XmATTACH_WIDGET :leftWidget btn1 :width 50))
    (setq btn3 (make-button form "btn3" :labelString (XmString "fit")
      :topAttachment XmATTACH_WIDGET :topWidget bar :height 30
      :leftAttachment XmATTACH_WIDGET :leftWidget btn2 :width 50))

    (setq label1 (make-label form "label1" :labelString (XmString "GOF")
      :topAttachment XmATTACH_WIDGET :topWidget bar :topOffset 5
      :leftAttachment XmATTACH_WIDGET :leftWidget btn3 :leftOffset 5))
    (setq text-gof (make-text form "text" ;;global variant
      :topAttachment XmATTACH_WIDGET :topWidget bar 
      :leftAttachment XmATTACH_WIDGET :leftWidget label1 :width 50))
    (XmTextSetString text-gof "70")
    (setq label2 (make-label form "label2" :labelString (XmString "CV")
      :topAttachment XmATTACH_WIDGET :topWidget bar :topOffset 5
      :leftAttachment XmATTACH_WIDGET :leftWidget text-gof :leftOffset 5))
    (setq text-cv (make-text form "text" ;;global variant
      :topAttachment XmATTACH_WIDGET :topWidget bar 
      :leftAttachment XmATTACH_WIDGET :leftWidget label2 :width 50))
    (XmTextSetString text-cv "-1")
    (setq label3 (make-label form "label3" :labelString (XmString "KHI2")
      :topAttachment XmATTACH_WIDGET :topWidget bar :topOffset 5
      :leftAttachment XmATTACH_WIDGET :leftWidget text-cv :leftOffset 5))
    (setq text-khi (make-text form "text" ;;global variant
      :topAttachment XmATTACH_WIDGET :topWidget bar 
      :leftAttachment XmATTACH_WIDGET :leftWidget label3 :width 70))
    (XmTextSetString text-khi "-1")    

    (setq pane (XmCreatePanedWindow form "pane" (X-arglist) 0))
    (set-values pane :separatorOn 0 :sasIndent -1
      :topAttachment XmATTACH_WIDGET :topWidget btn1
      :bottomAttachment XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM)
    (setq memo1 (create-memos-form pane));global variant
    (setq memo2 (create-memos-form pane));global variant
    (setq memo3 (create-memos-form pane));global variant
    (dolist (n (list bar btn1 btn2 btn3 label1 text-gof label2 text-cv label3 text-khi pane form))(manage n))
    (setq nmemo 1)
    (set-values memo2 :background (rgb 200 200 200))
    (set-values memo3 :background (rgb 200 200 200))
    (set-lisp-callback memo1 "focusCallback" '(change-memo 1))
    (set-lisp-callback memo2 "focusCallback" '(change-memo 2))
    (set-lisp-callback memo3 "focusCallback" '(change-memo 3))
    (set-lisp-callback btn1 "activateCallback" '(memo-note))
    (set-lisp-callback btn2 "activateCallback" '(memo-goto))
    (set-lisp-callback btn3 "activateCallback" '(memo-fit))
    (setq form-memo form)
    (unmanage form-memo)
))

(defun create-memos-form(pane)
  (let ((form)(frame)(memo)(n))
    (setq form (make-form pane "form"))
    (setq frame (make-frame form "frame" :resize 1
      :topAttachment  XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_FORM :rightAttachment  XmATTACH_FORM))
    (manage (make-label frame "label" :childType XmFRAME_TITLE_CHILD
      :labelString (XmString "  sec        span        sns          peak         fT/cm")))
    (setq memo (make-scrolled-text frame "memo" :editMode XmMULTI_LINE_EDIT
      :rows 5 :columns 40 :topAttachment XmATTACH_FORM 
      :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM :scrollHorizontal 0))
    (XmTextSetString memo "")
    (dolist (n (list memo frame form))(manage n))
    (return memo)
))

(defun create-memos-menu(bar)
  (let ((n)(btn)(menu))
    (setq this (make-menu bar "file" nil))
      (add-button this "load *-wave.txt"   '(memo-load))
      (add-button this "save *-wave.txt"   '(memo-save))
      (add-separator this)
      (add-button this "load BDIP file"    '(memo-dipload))
      (add-button this "save as BDIP file" '(memo-dipsave))
      (add-separator this)
      (add-button this "save consecutive epochs as PNG file" '(memo-save-png))
    (setq this (make-menu bar "display" nil)) 
      (add-button this "clear"     '(memo-clear))
      (add-button this "clear all" '(memo-clear-all))
      (add-separator this)
      (make-menu this "waves" nil :tear-off
        '("discharge"   (memo-insert " discharge"))
        '("spike"       (memo-insert " spike"))
        '("polyspike"   (memo-insert " polyspike"))
        '("burst"       (memo-insert " burst"))
        '("ictal onset" (memo-insert " ictal onset"))
        '("EEG spike"   (memo-insert " EEG spike"))
        '("physiological activities" (memo-insert " physiological activities"))
        '("noise"       (memo-insert " noise"))
        '("???"         (memo-insert " ???")))
      (make-menu this "copy" nil
        '("to memo1" (memo-copy 1))
        '("to memo2" (memo-copy 2))
        '("to memo3" (memo-copy 3)))
      (make-menu this "sort" nil
        '("time"      (memo-sort 3))
        '("coil"      (memo-sort 2))
        '("amplitude" (memo-sort 4)))
    (setq this (make-menu bar "dipoles" nil))
      (add-button this "clear all dipoles" '(memo-dipclear))
      (add-button this "consecutive fit" '(memo-fitfit))
      (add-button this "read dipoles" '(memo-readbdip))
      (add-separator this)
      (add-button this "extract dipoles filled with criteria" '(memo-dipselect))
      (add-button this "extract dipoles with PNG" '(memo-dipselect-png))
      (add-button this "extract epoch with dipoes" '(memo-extractepoch))
    (make-menu bar "routine" nil
      '("fit fit > dipole filter > a*.png" (routine1))
      '("PNG filter > ep*.png" (routine2))
      '("ep*.png > a*.png" (rename-png "ep" "a")))
    (setq this (make-menu bar "miscellaneous" nil))
      (add-button this "time to selection" '(memo-peak2selection 0))
      (add-button this "time + gap to selection" '(memo-peak2selection 1))
      (add-separator this)
      (add-button this "build C-files (only 1st use)" '(build))
      (add-button this "arrange Control Panel" '(control-panel-show))
))

(defun create-pca()
  (let ((xsel)(t0)(t1))
    (unless (G-widget "pca-fields" :quiet)(require 'pca))
    (setq xsel (x-selection (G-widget "000")))
    (if xsel 
      (setq xsel (list (+ (first xsel)(resource (G-widget "win000") :point))(second xsel)))
      (setq xsel (x-selection (G-widget "disp009"))))
    (when xsel 
      (when  xsel (progn 
        (setq t0 (first xsel) t1 (second xsel)))
        (if (> t1 0.001)(progn 
          (graph::pca-on-widget (G-widget "ssp") t0 (+ t0 t1))
          (graph::ssp-popup)
          (graph::ssp-add-pca 8) ))))
))


(defun create-xfit()
  (let ((btn)(btn5)(n)(rb1)(tb1)(tb2)(tb3)(tb4)(rb2)(rb3)(rb4)(form1)(form2)(label1)(btn2))
    (setq form-xfit (make-form-dialog *application-shell* "form-xfit"
      :autoUnmanage 0 :resize 1))
    (setq sns-num (make-text form-xfit "sns-num" :width 50 ;;global variant
      :topAttachment XmATTACH_FORM 
      :leftAttachment XmATTACH_FORM :leftOffset 220))
    (XmTextSetString sns-num "30")
    (setq rb1 (XmCreateRadioBox form-xfit "rb1" (X-arglist) 0))
    (set-values rb1 :topAttachment XmATTACH_FORM 
      :leftAttachment XmATTACH_FORM :numColumns 2)
    (setq tb1 (XmCreateToggleButtonGadget rb1 "tb1" (X-arglist) 0))
    (set-values tb1 :labelString (XmString "use all 102") :set 1) 
    (setq tb2 (XmCreateToggleButtonGadget rb1 "tb2" (X-arglist) 0))
    (set-values tb2 :labelString (XmString "use nearest") :set 0)
    (set-lisp-callback tb1 "valueChangedCallback" '(setq meg306 t))
    (set-lisp-callback tb2 "valueChangedCallback" '(setq meg306 nil))
    (dolist (n (list sns-num tb1 tb2 rb1))(manage n))    

    (setq rb2 (XmCreateRadioBox form-xfit "rb2" (X-arglist) 0))
    (set-values rb2 :topAttachment XmATTACH_WIDGET :topWidget rb1    
      :leftAttachment XmATTACH_FORM :numColumns 3)
    (setq tb1 (XmCreateToggleButtonGadget rb2 "tb1" (X-arglist) 0))
    (set-values tb1 :labelString (XmString "GRA") :set 0)
    (setq tb2 (XmCreateToggleButtonGadget rb2 "tb2" (X-arglist) 0))
    (set-values tb2 :labelString (XmString "MAG") :set 0)
    (setq tb3 (XmCreateToggleButtonGadget rb2 "tb3" (X-arglist) 0))
    (set-values tb3 :labelString (XmString "BOTH") :set 1)    
    (set-lisp-callback tb1 "valueChangedCallback" '(setq gramag 204))
    (set-lisp-callback tb2 "valueChangedCallback" '(setq gramag 102))
    (set-lisp-callback tb3 "valueChangedCallback" '(setq gramag 306))
    (setq gramag 306);;global variant
    (dolist (n (list rb2 tb1 tb2 tb3))(manage n))

    (setq text-prepeak (make-text form-xfit "text-prepeak" :width 50
      :topAttachment XmATTACH_WIDGET :topWidget rb2
      :leftAttachment XmATTACH_FORM :leftOffset 120))
    (setq label1 (make-label form-xfit "label1" :labelString (XmString "% of peak")
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text-prepeak :topOffset 5
      :leftAttachment XmATTACH_WIDGET :leftWidget text-prepeak))
    (XmTextSetString text-prepeak "80")
    (setq rb3 (XmCreateRadioBox form-xfit "rb3" (X-arglist) 0))
    (set-values rb3 :topAttachment XmATTACH_WIDGET :topWidget rb2
      :leftAttachment XmATTACH_FORM :numColumns 2)
    (setq tb1 (XmCreateToggleButtonGadget rb3 "tb1" (X-arglist) 0))
    (set-values tb1 :labelString (XmString "at peak") :set 1)
    (setq tb2 (XmCreateToggleButtonGadget rb3 "tb2" (X-arglist) 0))
    (set-values tb2 :labelString (XmString "at ") :set 0)
    (set-lisp-callback tb1 "valueChangedCallback" '(setq prepeak 100))
    (set-lisp-callback tb2 "valueChangedCallback" '(setq prepeak 0))
    (setq prepeak 100);;global variant
    (dolist (n (list text-prepeak label1 tb1 tb2 rb3))(manage n))

    (setq label1 (make-label form-xfit "label1" 
      :labelString (XmString "Noise estimation method")
      :topAttachment XmATTACH_WIDGET :topWidget rb3 :topOffset 15
      :leftAttachment XmATTACH_FORM))
    (manage label1)

    (setq rb4 (XmCreateRadioBox form-xfit "rb4" (X-arglist) 0))
    (set-values rb4 :topAttachment XmATTACH_WIDGET :topWidget label1
      :leftAttachment XmATTACH_FORM)
    (setq tb1 (XmCreateToggleButtonGadget rb4 "tb1" (X-arglist) 0))
    (set-values tb1 :labelString (XmString "Compute from baseline (default)") :set 0)
    (setq tb2 (XmCreateToggleButtonGadget rb4 "t23" (X-arglist) 0))
    (set-values tb2 :labelString (XmString "Compute from baseline (defined)") :set 0)
    (setq form1 (XmCreateForm rb4 "form1" (X-arglist) 0))
    (create-xfit-form1 form1)
    (manage form1)
    (setq tb3 (XmCreateToggleButtonGadget rb4 "tb3" (X-arglist) 0))   
    (set-values tb3 :labelString (XmString "Constant value for all channels") :set 1)
    (setq form2 (XmCreateForm rb4 "form2" (X-arglist) 0))
    (create-xfit-form2 form2)
    (manage form2)
    (set-lisp-callback tb1 "valueChangedCallback" '(setq noise-estimation 1))
    (set-lisp-callback tb2 "valueChangedCallback" '(setq noise-estimation 2))
    (set-lisp-callback tb3 "valueChangedCallback" '(setq noise-estimation 3)) 
    (setq noise-estimation 3);global variant
    (dolist (n (list tb1 tb2 tb3 rb4))(manage n))

    (setq btn2 (make-button form-xfit "btn" 
      :labelString (XmString "calc noise level from selected span")
      :topAttachment XmATTACH_WIDGET :topWidget rb4
      :leftAttachment XmATTACH_FORM :leftOffset 20))
    (set-lisp-callback btn2 "activateCallback" '(calc-noise-level))
    (dolist (n (list text-granoise text-magnoise btn2))(manage n))

    (setq btn (make-button form-xfit "btn" :labelString (XmString "evaluate & close")
      :topAttachment XmATTACH_WIDGET :topWidget btn2 :topOffset 15
      :leftAttachment XmATTACH_FORM :leftOffset 50))
    (set-lisp-callback btn "activateCallback" '(create-xfit-close))
    (setq btn5 (make-button form-xfit "btn5" :labelString (XmString "delete")
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget btn
      :leftAttachment XmATTACH_WIDGET :leftWidget btn))
    (set-lisp-callback btn5 "activateCallback" '(XtDestroyWidget form-xfit))
    (dolist (n (list btn btn5 form-xfit))(manage n))
    (unmanage btn5)
    (create-xfit-close)
))

(defun create-xfit-close()
  (let ((n)(text)(val)(val1)(st)(st1))
    (if (= prepeak 100)
      (setq st (format nil "ECD fit at peak~%"))
      (progn (setq val (read-from-string (XmTextGetString text-prepeak)))
        (setq text (format nil "~0,0f" val))
        (XmTextSetString text-prepeak text)
        (setq prepeak (read-from-string text))
        (setq st (format nil "ECD fit at~a% of peak~%" text))))  
    (if meg306
      (setq st (str-append st (format nil "using all 102 sensors~%")))
      (progn
        (setq val (read-from-string (XmTextGetString sns-num)))
        (setq text (format nil "~0,0f" val))
        (XmTextSetString sns-num text)
        (setq st (str-append st 
        (format nil "using nearest~a sensors~%" text)))))
    (case gramag
      (204 (setq st (str-append st (format nil "of only GRA~%"))))
      (102 (setq st (str-append st (format nil "of only MAG~%"))))
      (306 (setq st (str-append st (format nil "of GRA&MAG~%"))))
    )
    (case noise-estimation
      (1 (progn (setq st1 "noise baseline")
         (xfit-command st1)
         (setq st1 (str-append st1 (format nil "~%(default)")))))
      (2 (progn (xfit-command "noise baseline")
        (setq val (read-from-string (XmTextGetString text-baselinestart)))
        (XmTextSetString text-baselinestart (format nil "~0,2f" val))
        (setq val1 (read-from-string (XmTextGetString text-baselineend)))
        (XmTextSetString text-baselineend (format nil "~0,2f" val1))
        (setq st1 (format nil "noise baseline ~%~0,2f ~~ ~0,2f(s)" val val1))))
      (3 (progn
        (setq val  (read-from-string (XmTextGetString text-granoise)))
        (setq val1 (read-from-string (XmTextGetString text-magnoise)))
        (setq st1 (format nil "noise constant~%GRA ~0,1ffT/cm MAG ~0,1ffT" val val1))
        (xfit-command (format nil "noise constant ~0,0f ~0,0f" val val1))))
    )
    (setq st (str-append st st1))  
  (set-values btn-xfit :labelString (XmString (format nil "~a" st)))
  (unmanage form-xfit)  
))

(defun create-xfit-form1(form)
  (let ((n)(label1)(label2))
    (setq label1 (make-label form "label1" :labelString (XmString "peak from")
      :topAttachment XmATTACH_FORM :topOffset 5 :width 100
      :leftAttachment XmATTACH_FORM :leftOffset 20))
    (setq text-baselinestart (make-text form "text-baselinestart" 
      :topAttachment  XmATTACH_FORM :width 50
      :leftAttachment XmATTACH_WIDGET :leftWidget label1))
    (XmTextSetString text-baselinestart "-0.4")
    (setq label2 (make-label form "label2" :labelString (XmString "to")
      :topAttachment  XmATTACH_FORM :topOffset 5 :width 20
      :leftAttachment XmATTACH_WIDGET :leftWidget text-baselinestart))
    (setq text-baselineend (make-text form "text-baselineend"
      :topAttachment  XmATTACH_FORM :width 50
      :leftAttachment XmATTACH_WIDGET :leftWidget label2))
    (XmTextSetString text-baselineend "-0.1")
    (dolist (n (list label1 label2 text-baselinestart text-baselineend))
      (manage n))
))

(defun create-xfit-form2(form)
  (let ((n)(label1)(label2))
    (setq text-granoise (make-text form "text-granoise"
      :topAttachment XmATTACH_FORM :width 50
      :leftAttachment XmATTACH_FORM :leftOffset 20))
    (XmTextSetString text-granoise "5")
    (setq label1 (make-label form "label1" :labelString (XmString "fT/cm")
      :topAttachment XmATTACH_FORM :topOffset 5
      :leftAttachment XmATTACH_WIDGET :leftWidget text-granoise))
    (setq text-magnoise (make-text form "text-magnoise"
      :topAttachment XmATTACH_FORM :width 50
      :leftAttachment XmATTACH_WIDGET :leftWidget label1 :leftOffset 20))
    (XmTextSetString text-magnoise "20")
    (setq label2 (make-label form "label2" :labelString (XmString "fT")
      :topAttachment XmATTACH_FORM :topOffset 5
      :leftAttachment XmATTACH_WIDGET :leftWidget text-magnoise))
    (dolist (n (list label1 label2 text-granoise text-magnoise))
      (manage n))
))

(defun defchpos() 
  (let ((x)(y)(z)(dist)(chdist))
    (setq x '( -0.1066   -0.1020   -0.1085   -0.1099   -0.1074   -0.0989   -0.1011   -0.1083
               -0.0861   -0.0887   -0.0702   -0.1003   -0.0808   -0.0526   -0.0537   -0.0829
               -0.0637   -0.0332   -0.0337   -0.0672   -0.0358    0.0001   -0.0184   -0.0368
               -0.0185    0.0186    0.0186   -0.0185    0.0001    0.0001    0.0331    0.0638
                0.0671    0.0338    0.0001    0.0358    0.0368    0.0184    0.0525    0.0809
                0.0828    0.0535    0.0862    0.1003    0.0887    0.0699    0.0989    0.1074
                0.1083    0.1010    0.1020    0.1065    0.1098    0.1083   -0.1088   -0.1017  
               -0.0951   -0.1068   -0.1017   -0.0952   -0.0781   -0.0866   -0.0758   -0.0861
               -0.0632   -0.0489   -0.0786   -0.0518   -0.0181   -0.0552   -0.0513   -0.0335
               -0.0331   -0.0636   -0.0186    0.0186    0.0169   -0.0170         0         0
                0.0170   -0.0171    0.0517    0.0786    0.0553    0.0182    0.0513    0.0637
                0.0330    0.0333    0.0952    0.1017    0.0866    0.0781    0.0630    0.0861
                0.0757    0.0488    0.1087    0.1068    0.0951    0.1017))  
    (setq y '(  0.0464    0.0631    0.0302    0.0131    0.0329    0.0403    0.0044   -0.0011
                0.0988    0.0757    0.0758    0.0659    0.0413    0.0406    0.0059    0.0062
                0.1254    0.1397    0.1274    0.1089    0.1048    0.0775    0.0440    0.0753
                0.0105    0.0105   -0.0233   -0.0237    0.1445    0.1316    0.1397    0.1253
                0.1088    0.1273    0.1093    0.1048    0.0752    0.0442    0.0406    0.0413
                0.0061    0.0062    0.0986    0.0660    0.0757    0.0758    0.0404    0.0329
               -0.0011    0.0044    0.0630    0.0469    0.0131    0.0301   -0.0032   -0.0360
               -0.0524   -0.0205   -0.0339   -0.0308   -0.0628   -0.0640   -0.0797   -0.0660
               -0.0905   -0.0994   -0.0287   -0.0277   -0.0542   -0.0627   -0.0861   -0.1033
               -0.1051   -0.0884   -0.0801   -0.0802   -0.0972   -0.0972   -0.1086   -0.1106
               -0.1098   -0.1098   -0.0276   -0.0284   -0.0628   -0.0542   -0.0861   -0.0884
               -0.1051   -0.1034   -0.0306   -0.0338   -0.0639   -0.0629   -0.0906   -0.0661
               -0.0798   -0.0994   -0.0033   -0.0206   -0.0524   -0.0361))
    (setq z '( -0.0604   -0.0256   -0.0266   -0.0627    0.0080    0.0413    0.0408    0.0071
                0.0090    0.0412    0.0707    0.0081    0.0720    0.0952    0.0969    0.0728
                0.0136    0.0174    0.0485    0.0443    0.0750    0.0967    0.1063    0.0922
                0.1096    0.1096    0.1059    0.1058    0.0187    0.0500    0.0173    0.0135
                0.0444    0.0486    0.0771    0.0750    0.0923    0.1062    0.0953    0.0721
                0.0728    0.0970    0.0089    0.0082    0.0412    0.0709    0.0413    0.0081
                0.0068    0.0410   -0.0260   -0.0600   -0.0622   -0.0262   -0.0284   -0.0281
               -0.0623   -0.0625    0.0056    0.0391    0.0394    0.0055   -0.0621   -0.0282
               -0.0278   -0.0621    0.0696    0.0927    0.0923    0.0707    0.0397    0.0062
               -0.0278    0.0060    0.0690    0.0689    0.0397    0.0397    0.0070   -0.0275
               -0.0618   -0.0619    0.0928    0.0698    0.0706    0.0922    0.0397    0.0062
               -0.0277    0.0063    0.0392    0.0058    0.0056    0.0394   -0.0276   -0.0280
               -0.0620   -0.0621   -0.0280   -0.0621   -0.0620   -0.0278))
    (setq chdist nil)
    (dotimes (j (length x))
      (progn
        (setq dist nil)
        (dotimes (i (length x))
          (setq dist (append dist (list 
            (+ (sqr (- (nth i x) (nth j x)))(sqr (- (nth i y)(nth j y)))(sqr (- (nth i z)(nth j z))))
          ))))
        (setq chdist (append chdist (list (mapcar #'sqrt dist))))))
    (defparameter ch-dist chdist)
    (defparameter near-coil (calc-near-coil))
))

(defun define-parameters()
  (defparameter gra-L-temporal
    '("MEG[ 223  222  212  213  133  132  112  113  233  232  242  243 1513 1512  142  143]" 
      "MEG[1623 1622 1612 1613 1523 1522 1542 1543 1532 1533]"))
  (defparameter gra-R-temporal
    '("MEG[1313 1312 1322 1323 1443 1442 1422 1423 1343 1342 1332 1333 2613 2612 1432 1433]" 
      "MEG[2413 2412 2422 2423 2643 2642 2622 2623 2632 2633]"))
  (defparameter gra-L-parietal
    '("MEG[ 632  633  423  422  412  413  712  713  433  432  442  443  742  743 1823 1822]" 
      "MEG[1812 1813 1833 1832 1842 1843 1633 1632 2012 2013]"))
  (defparameter gra-R-parietal
    '("MEG[1042 1043 1113 1112 1122 1123  722  723 1143 1142 1132 1133  732  733 2213 2212]" 
      "MEG[2222 2223 2243 2242 2232 2233 2443 2442 2022 2023]"))
  (defparameter gra-L-occipital
    '("MEG[2043 2042 1913 1912 2112 2113 1922 1923 1942 1943 1642 1643 1933 1932 1733 1732]" 
      "MEG[1723 1722 2143 2142 1742 1743 1712 1713]"))
  (defparameter gra-R-occipital
    '("MEG[2033 2032 2313 2312 2342 2343 2322 2323 2432 2433 2123 2122 2333 2332 2513 2512]" 
      "MEG[2523 2522 2132 2133 2542 2543 2532 2533]"))
  (defparameter gra-L-frontal
    '("MEG[ 522  523  512  513  312  313  342  343  123  122  823  822  533  532  543  542]" 
      "MEG[ 323  322  612  613  332  333  623  622  643  642]"))
  (defparameter gra-R-frontal
    '("MEG[ 812  813  912  913  922  923 1212 1213 1222 1223 1413 1412  943  942  933  932]" 
      "MEG[1233 1232 1012 1013 1022 1023 1242 1243 1033 1032]"))
  (defparameter mag-L-temporal
    '("MEG[ 221  211  131  111  231  241 1511  141 ]" "MEG[1621 1611 1521 1541 1531]"))
  (defparameter mag-R-temporal
    '("MEG[1311 1321 1441 1421 1341 1331 2611 1431]" "MEG[2411 2421 2641 2621 2631]"))
  (defparameter mag-L-parietal
    '("MEG[ 631  421  411  711  431  441  741 1821]" "MEG[1811 1831 1841 1631 2011]"))
  (defparameter mag-R-parietal
    '("MEG[1041 1111 1121  721 1141 1131  731 2211]" "MEG[2221 2241 2231 2441 2021]"))
  (defparameter mag-L-occipital
    '("MEG[2041 1911 2111 1921 1941 1641 1931 1731]" "MEG[1721 2141 1741 1711]"))
  (defparameter mag-R-occipital
    '("MEG[2031 2311 2341 2321 2431 2121 2331 2511]" "MEG[2521 2131 2541 2531]"))
  (defparameter mag-L-frontal
    '("MEG[ 521  511  311  341  121  821  531  541]" "MEG[ 321  611  331  621  641]"))
  (defparameter mag-R-frontal
    '("MEG[ 811  911  921 1211 1221 1411  941  931]" "MEG[1231 1011 1021 1241 1031]"))
  (defparameter stepwise 0.5)
  (defparameter npeaks 10)
  (defparameter dipspan 0.2)
  (defparameter nmenu 1)
  ;; (defparameter defmemo memo98); this is defined after create-memo 
  (defvar wave-name 
      (list "discharge" "spike" "polyspike" "burst" "ictal onset" "EEG spike" "physiological activities" "noise" "???"))
)

(defun diag(vec)
  (let ((m 0)(n)(nn)(mtx nil))
    (setq nn (array-dimensions vec))
    (when (or (= (first nn) 1)(= (second nn) 1))
      (setq nn (* (first nn)(second nn)))
      (setq mtx (make-matrix (* nn nn) 1 0))
      (dotimes (n nn)
        (vset mtx m (vref vec n))
        (setq m (+ m nn 1))
      )
      (setq mtx (redimension mtx nn nn))
    )
    (return mtx)
))

(defun disp000(num)
  (cond 
    ((< num 10)(format nil "disp00~0,0d" num))
    ((< num 100)(format nil "disp0~0,0d" num))
    ((< num 1000)(format nil "disp~0,0d" num)) 
  )
)

(defun EEGCleaveland(num); EEG 60ch
  (let ((n)(name)(EEG0)(EEG1)(EEG2)(fsub))
    (EEGroutineDelete)
    (setq EEG0 (G-widget "EEG0"))
    (setq EEG1 (require-widget :selector "EEG1"))
    (setq EEG2 (require-widget :selector "EEG2"))
    (setq fsub (require-widget :binary "fsub" '("function" fsub)))
    (case num
      (0 (progn (setq name '("Fp1" "Fpz" "Fp2" 
                      "AF7" "AF3" "AF4" "AF8" 
                      "F7" "F5" "F3" "F1" "Fz" "F2" "F4" "F6" "F8"
                      "FT9" "FT7" "FC5" "FC3" "FC4" "FC6" "FT8" "FT10"
                      "T9" "T7" "C5" "C3" "C1" "Cz" "C2" "C4" "C6" "T8" "T10"
                      "TP9" "TP7" "CP5" "CP3" "CP4" "CP6" "TP8" "TP10"
                      "P7" "P5" "P3" "P1" "Pz" "P2" "P4" "P6" "P8"
                      "PO7" "PO3" "PO4" "PO8" 
                      "O1" "Oz" "O2" "Iz"));; only 10-10 rules!
            (select-to EEG1 (EEG0 0 - 59))
            (link EEG1 (G-widget "EEG-fil"))
            (EEGroutineSel) ))
      (1 (progn (setq name 
         '("Fp1-F7" "F7-T7" "T7-P7" "P7-O1" "Fp2-F8" "F8-T8" "T8-P8" "P8-O2" 
           "Fp1-F3" "F3-C3" "C3-P3" "P3-O1" "Fp2-F4" "F4-C4" "C4-P4" "P4-O2"
           "Fz-Cz"  "Cz-Pz"));; 18ch banana
         (select-to (G-widget "EEG1")
           (EEG0 0 7 25 43  2 15 33 51  0 9 27 45  2 13 31 49  11 29)) 
         (select-to (G-widget "EEG2")
           (EEG0 7 25 43 56  15 33 51 58  9 27 45 56  13 31 49 58  29 47))
         (EEGroutineFsub) ))
      (2 (progn (setq name 
           '("Fp1-TP9" "F7-TP9" "T7-TP9" "P7-TP9" "Fp2-TP10" "F8-TP10" "T8-TP10" "P8-TP10"
             "F3-TP9"  "C3-TP9" "P3-TP9" "O1-TP9" "F4-TP10"  "C4-TP10" "P4-TP10" "O2-TP10"
            "Fz-TP10" "Pz-TP10"));;18ch mono TP9/TP10
         (select-to (G-widget "EEG1")
           (EEG0 0 7 25 43  2 15 33 51  9 27 45 56  13 31 49 58  11 47))
         (select-to (G-widget "EEG2")
           (EEG0 35 35 35 35  42 42 42 42  35 35 35 35  42 42 42 42  42 42))
         (EEGroutineFsub) ))
      (3 (progn (setq name 
         '("Fp1-F7" "Fp2-F8" "F7-T7" "F8-T8" "T7-P7" "T8-P8" "P7-O1" "P8-O2" 
           "Fp1-F3" "Fp2-F4" "F3-C3" "F4-C4" "C3-P3" "C4-P4" "P3-O1" "P4-O2"
           "Fz-Cz"  "Cz-Pz"));;18ch banana L-R-L-R
         (select-to (G-widget "EEG1")
           (EEG0 0 2 7 15  25 33 43 51  0 2 9 13  27 31 45 49  11 29))
         (select-to (G-widget "EEG2")
           (EEG0 7 15 25 33  43 51 56 58  9 13 27 31  45 49 56 58 29 47))
         (EEGroutineFsub) ))
      (4 (progn (setq name 
         '("Fpz-Cz" "Fp2-Cz" "F7-Cz" "F8-Cz" "T7-Cz" "T8-Cz" "P7-Cz" "P8-Cz"
           "F3-Cz" "F4-Cz" "C3-Cz" "C4-Cz" "P3-Cz" "P4-Cz" "O1-Cz" "O2-Cz"
           "TP9-Cz" "TP10-Cz"));;18ch mono Cz
         (select-to (G-widget "EEG1")
           (EEG0 0 2 7 15  25 33 43 51  9 13 27 31  45 49 56 58 35 42))
         (select-to (G-widget "EEG2")
           (EEG0 29 29 29 29  29 29 29 29  29 29 29 29  29 29 29 29  29 29))
         (EEGroutineFsub) ))
      (5 (progn (setq name 
         '("F7-F3" "F3-Fz" "Fz-F4" "F4-F8" "TP9-T7" "T7-C3" "C3-Cz" "Cz-C4"
           "C4-T8" "T8-TP10" "P7-P3" "P3-Pz" "Pz-P4" "P4-P8" "Fp1-TP9" "Fp2-TP10"
           "O1-TP9" "O2-TP10"));;18ch bipo transverse
         (select-to (G-widget "EEG1")
           (EEG0 7 9 11 13  35 25 27 29 31 33 43 45  47 49  0 2 56 58)) 
         (select-to (G-widget "EEG2")
           (EEG0 9 11 13 15  25 27 29 31 33 42  45 47 49 51  35 42 35 42))
         (EEGroutineFsub) )) 
      (6 (progn (setq name 
         '("Fp1-F7" "F7-FT9" "FT9-T7" "T7-P7" "P7-O1" "Fp2-F8" "F8-FT10" "FT10-T8" 
           "T8-P8" "P8-O2" "FT9-FT10" "TP9-TP10" "Fp1-F3" "F3-C3" "C3-P3" "Fp2-F4"
           "F4-C4" "C4-P4"));; 18ch    NR1/NR2 ... FT9/FT10 replaced
         (select-to (G-widget "EEG1")
           (EEG0 0 7 16 25 43  2 15 23 33 51  16 35  0 9 27 2 13 31)) 
         (select-to (G-widget "EEG2")
           (EEG0 7 16 25 43 56  15 23 33 51 58  23 42  9 27 45 13 31 49))
         (EEGroutineFsub) ))
    )
    (EEGroutineNameFinish name)
))

(defun EEGCleaveland2(num)  
  (let ((n)(name)(EEG0)(EEG1)(EEG2)(fsub))
    (EEGroutineDelete)
    (setq EEG0 (G-widget "EEG0"))
    (setq EEG1 (require-widget :selector "EEG1"))
    (setq EEG2 (require-widget :selector "EEG2"))
    (setq fsub (require-widget :binary "fsub" '("function" fsub)))
    (setq nch (resource (G-widget "EEG0") :channels))
 
    (case num
      (1 (progn (setq name 
         '("Fp1-F7" "F7-T7" "T7-P7" "P7-O1" "Fp2-F8" "F8-T8" "T8-P8" "P8-O2" 
           "Fp1-F3" "F3-C3" "C3-P3" "P3-O1" "Fp2-F4" "F4-C4" "C4-P4" "P4-O2"
           "Fz-Cz"  "Cz-Pz"));; 18ch banana
         (select-to (G-widget "EEG1")
           (EEG0 0 2 7 12  1 6 11 16  0 3 8 13  1 5 10 15  4 9))
         (select-to (G-widget "EEG2")
           (EEG0 2 7 12 17  6 11 16 18  3 8 13 17  5 10 15 18  9 14))
         (EEGroutineFsub) ))
      (2 (progn (setq name
         '("Fp1-A1" "F7-A1" "T7-A1" "P7-A1" "Fp2-A2" "F8-A2" "T8-A2" "P8-A2"
           "F3-A1"  "C3-A1" "P3-A1" "O1-A1" "F4-A2"  "C4-A2" "P4-A2" "O2-A2"
           "Fz-A2" "Pz-A2"));;18ch mono A1/A2
         (select-to (G-widget "EEG1")
           (EEG0 0 2 7 12  1 6 11 16  3 8 13 17  5 10 15 18  4 14))
         (select-to (G-widget "EEG2")
           (EEG0 19 19 19 19  20 20 20 20  19 19 19 19  20 20 20 20  20 20))
         (EEGroutineFsub) ))
      (3 (progn (setq name 
         '("Fp1-F7" "Fp2-F8" "F7-T7" "F8-T8" "T7-P7" "T8-P8" "P7-O1" "P8-O2" 
           "Fp1-F3" "Fp2-F4" "F3-C3" "F4-C4" "C3-P3" "C4-P4" "P3-O1" "P4-O2"
           "Fz-Cz"  "Cz-Pz"));;18ch banana L-R-L-R
         (select-to (G-widget "EEG1")
           (EEG0 0 1 2 6  7 11 12 16  0 1 3 5   8 10 13 16  4 9)) 
         (select-to (G-widget "EEG2")
           (EEG0 2 6 7 11  12 16 17 18  3 5 8 10  13 15 17 18  9 14))
         (EEGroutineFsub) ))
      (4 (progn (setq name 
         '("Fpz-Cz" "Fp2-Cz" "F7-Cz" "F8-Cz" "T7-Cz" "T8-Cz" "P7-Cz" "P8-Cz"
           "F3-Cz" "F4-Cz" "C3-Cz" "C4-Cz" "P3-Cz" "P4-Cz" "O1-Cz" "O2-Cz"
           "A1-Cz" "A2-Cz"));;18ch mono Cz
         (select-to (G-widget "EEG1")
           (EEG0 0 1 2 6  7 11 12 16  3 5 8 10  13 15 17 18  19 20)) 
         (select-to (G-widget "EEG2")
           (EEG0 9 9 9 9  9 9 9 9  9 9 9 9  9 9 9 9  9 9))
         (EEGroutineFsub) ))
      (5 (progn (setq name 
         '("F7-F3" "F3-Fz" "Fz-F4" "F4-F8" "A1-T7" "T7-C3" "C3-Cz" "Cz-C4"
           "C4-T8" "T8-A2" "P7-P3" "P3-Pz" "Pz-P4" "P4-P8" "Fp1-A1" "Fp2-A2"
           "O1-A1" "O2-A2"));;18ch bipo transverse
         (select-to (G-widget "EEG1")
           (EEG0 2 3 4 5  19 7 8 9 10 11  12 13 14 15  0 1 17 18))
         (select-to (G-widget "EEG2")
           (EEG0 3 4 5 6  7 8 9 10 11 20  13 14 15 16  19 20 19 20))
         (EEGroutineFsub) ))
     (6 (progn (setq name 
         '("Fp1-F7" "F7-FT9" "FT9-T7" "T7-P7" "P7-O1" "Fp2-F8" "F8-FT10" "FT10-T8" 
           "T8-P8" "P8-O2" "FT9-FT10" "A1-A2" "Fp1-F3" "F3-C3" "C3-P3" "Fp2-F4"
           "F4-C4" "C4-P4"));; 18ch    NR1/NR2 ... FT9/FT10 replaced
         (select-to (G-widget "EEG1")
           (EEG0 0 2 21 7 12  1 6 22 11 16  21 19  0 3 8  1 5 10))  
         (select-to (G-widget "EEG2")
           (EEG0 2 21 7 12 17  6 22 11 16 18  22 20  3 8 13  5 10 15))
         (EEGroutineFsub) ))
    )
    (EEGroutineNameFinish name)
))

(defun EEGCleavelanddummy();; for check of Cleaveland EEG using Hiroshima Univ EEG
  (let ((w1)(w2))
    (setq w1 (require-widget :pick "EEG00"))
    (setq w2 (G-widget "EEG0"))
    (set-resource w1 :names '(
        "EEG[1 1 2]" 
        "EEG[1 1 2 2]" 
        "EEG[3 3 4 4 5 6 6 7 7]"
        "EEG[3 3 4 4   6 6 7 7]"
        "EEG[8 8 9 9 10 10 10 11 11 12 12]"
        "EEG[8 8 9 9          11 11 12 12]"
        "EEG[13 13 14 14 15 16 16 17 17]"
        "EEG[13    14       16    17]"
        "EEG[18 18 19]" "ECG*" "EOG*"))
    (link (G-widget "buf") w1)
    (set-resource  w2 :names '("EEG*" "ECG*"))
    (link (G-widget "EEG00")(G-widget "EEG0"))
))

(defun EEGCleavelandmenu()
  (let ((menubar)(menu))
    (setq MEGsite 2)
    (XtDestroyWidget EEGmenubar)
    (setq EEGmenubar (make-menu-bar EEGmenuform "menubar"
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text-eeg
      :rightAttachment XmATTACH_WIDGET :rightWidget text-eeg
      :leftAttachment XmATTACH_FORM :leftOffset 20
      :detailShadowThickness 0 :shadowThickness 0))    
    (setq this (make-menu EEGmenubar "EEG   uV" nil :tear-off))
    (add-button this "EEG I banana1"    '(EEGCleaveland 1))
    (add-button this "EEG II mono1"     '(EEGCleaveland 2))
    (add-button this "EEG III banana2"  '(EEGCleaveland 3))
    (add-button this "EEG IV mono2"     '(EEGCleaveland 4))
    (add-button this "EEG V transverse" '(EEGCleaveland 5))
    (add-button this "EEG VI banana3"   '(EEGCleaveland 6))    
    (add-separator this)
    (add-button this "auto scale" '(autoscale "EEG"))   
    (add-button this "filter" '(GtPopupEditor (G-widget "EEG-fil")))  
    (manage EEGmenubar)
))

(defun EEGCleavelandmenu2()
  (let ((menubar)(menu))
    (setq MEGsite 3)
    (XtDestroyWidget EEGmenubar)
    (setq EEGmenubar (make-menu-bar EEGmenuform "menubar"
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text-eeg
      :rightAttachment XmATTACH_WIDGET :rightWidget text-eeg
      :leftAttachment XmATTACH_FORM :leftOffset 20
      :detailShadowThickness 0 :shadowThickness 0))    
    (setq this (make-menu EEGmenubar "EEG   uV" nil :tear-off))
    (add-button this "EEG I banana1"    '(EEGCleaveland2 1))
    (add-button this "EEG II mono1"     '(EEGCleaveland2 2))
    (add-button this "EEG III banana2"  '(EEGCleaveland2 3))
    (add-button this "EEG IV mono2"     '(EEGCleaveland2 4))
    (add-button this "EEG V transverse" '(EEGCleaveland2 5))
    (add-button this "EEG VI banana3"   '(EEGCleaveland2 6))    
    (add-separator this)
    (add-button this "auto scale" '(autoscale "EEG"))      
    (add-button this "filter" '(GtPopupEditor (G-widget "EEG-fil")))   
    (manage EEGmenubar)
))

(defun EEGHiroshima(num)
  (let ((n)(EEG0)(EEG1)(EEG2)(ECG)(EOG)(name))
    (setq EEG0 (G-widget "EEG0") ECG (G-widget "ECG"))
    (setq EOG  (G-widget "EOG"))

    (if (and (> (resource EEG0 :channels) 19)(= (resource ECG :channels) 0))
      (progn (set-resource ECG :ignore '("ECG[20 21]")
          :names '("EEG[1 9  6 2 17 10 14  7 3 18 11 15  8 4 19 12 16  5 13]"))
        (set-resource ECG :names '("EEG[20]"))(link EEG0 ECG)
        (set-resource EOG :names '("EEG[21]"))(link EEG0 EOG) ))

    (EEGroutineDelete)
    (setq EEG1 (require-widget :selector "EEG1"))
    (setq EEG2 (require-widget :selector "EEG2"))
    (setq fsub (require-widget :binary "fsub" '("function" fsub)))  
  (case num
    (1 (progn (setq name ;;banana 18ch 
       '("Fp1-F7" "F7-T3" "T3-T5" "T5-O1" 
         "Fp1-F3" "F3-C3" "C3-P3" "P3-O1"
         "Fz-Cz" "Cz-Fz"
         "Fp2-F4" "F4-C4" "C4-P4" "P4-O2"
         "Fp2-F8" "F8-T4" "T4-T6" "T6-O2"))
       (select-to EEG1 
         (EEG0 0 2 7 12  0 3 8 13  4 9  1 5 10 15  1 6 11 16))
       (select-to EEG2
         (EEG0 2 7 12 17  3 8 13 17  9 14  5 10 15 18  6 11 16 18))
       (EEGroutineFsub) ))
    (2 (progn (setq name ;;transverse 18ch 
       '("F7-Fp1" "Fp1-Fp2" "Fp2-F8"  
         "F7-F3" "F3-Fz" "Fz-F4" "F4-F8"
         "T3-C3" "C3-Cz" "Cz-C4" "C4-T4"
         "T5-P3" "P3-Pz" "Pz-P4" "P4-T6"
         "T5-O1" "O1-O2" "O2-T6"))
       (select-to EEG1 
         (EEG0 2 0 1  2 3 4 5  7 8 9 10  12 13 14 15  12 17 18))
       (select-to EEG2
         (EEG0 0 1 6  3 4 5 6  8 9 10 11  13 14 15 16  17 18 16))
       (EEGroutineFsub) ))
    (3 (progn (setq name ;;mono 19ch 
       '("Fp1-Oz" "F3-Oz" "C3-Oz" "P3-Oz" "O1-Oz"
         "F7-Oz" "T3-Oz" "T5-Oz" 
         "Fz-Oz" "Cz-Oz" "Pz-Oz"
         "Fp2-Oz" "F4-Oz" "C4-Oz" "P4-Oz" "O2-Oz"
         "F8-Oz" "T4-Oz" "T6-Oz"))
       (select-to EEG1 
         (EEG0 0 3 8 13 17  2 7 12  16 17 18  1 5 10 15 18  6 11 16))
       (GtDeleteWidget EEG2)(GtDeleteWidget fsub)
       (link EEG1 (G-widget "EEG-fil"))
       (EEGroutineSel) ))
    (4 (progn (setq name ;;average 19ch        
        '("Fp1-av" "F3-av" "C3-av" "P3-av" "O1-av"
         "F7-av" "T3-av" "T5-av" 
         "Fz-av" "Cz-av" "Pz-av"
         "Fp2-av" "F4-av" "C4-av" "P4-av" "O2-av"
         "F8-av" "T4-av" "T6-av"))
       (select-to EEG1 
         (EEG0 0 3 8 13 17  2 7 12  16 17 18  1 5 10 15 18  6 11 16))
       (require-widget :vecop "fav" '("mode" "average"))
       (link EEG1 (G-widget "fav"))
       (select-to EEG2
         (fav 0 0 0 0 0  0 0 0  0 0 0  0 0 0 0 0  0 0 0)) 
       (EEGroutineFsub) ))
    )
    (EEGroutineNameFinish name)
))

(defun EEGHiroshimamenu()
  (let ((menubar)(menu))
    (setq MEGsite 1)
    (XtDestroyWidget EEGmenubar)
    (setq EEGmenubar (make-menu-bar EEGmenuform "menubar"
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text-eeg
      :rightAttachment XmATTACH_WIDGET :rightWidget text-eeg
      :leftAttachment XmATTACH_FORM :leftOffset 20
      :detailShadowThickness 0 :shadowThickness 0))    
    (setq this (make-menu EEGmenubar "EEG   uV" nil :tear-off))
    (add-button this "banana leads"  '(EEGHiroshima 1))
    (add-button this "coronal leads" '(EEGHiroshima 2))
    (add-button this "mono leads"    '(EEGHiroshima 3))
    (add-button this "average leads" '(EEGHiroshima 4))
    (add-separator this)
    (add-button this "auto scale"    '(autoscale "EEG")) 
    (add-button this "filter" '(GtPopupEditor (G-widget "EEG-fil")))   
    (manage EEGmenubar)
))

(defun EEGroutineDelete()
  (dolist (w (list "EEG1" "EEG2" "fsub" "fav"))
    (if (G-widget w :quiet)(GtDeleteWidget (G-widget w))))
)  

(defun EEGroutineNameFinish(name)
  (let ((n)(sel (G-widget "sel"))(disp (G-widget "disp009"))(necg)(neog)(nemg))
    (setq necg (resource (G-widget "ECG-fil") :channels))
    (setq neog (resource (G-widget "EOG-fil") :channels))
    (setq nemg (resource (G-widget "EMG-fil") :channels))
    (case necg
      (1 (setq name (append name (list "ECG"))))
      (2 (setq name (append name (list "ECG1" "ECG2"))))
      (3 (setq name (append name (list "ECG1" "ECG2" "ECG3"))))
    )
    (case neog
      (1 (setq name (append name (list "EOG"))))
      (2 (setq name (append name (list "EOG1" "EOG2"))))
      (3 (setq name (append name (list "EOG1" "EOG2" "EOG3"))))
    )
    (case nemg
      (1 (setq name (append name (list "EMG"))))
      (2 (setq name (append name (list "EMG1" "EMG2"))))
      (3 (setq name (append name (list "EMG1" "EMG2" "EMG3"))))
      (4 (setq name (append name (list "EMG1" "EMG2" "EMG3" "EMG4"))))
      (5 (setq name (append name (list "EMG1" "EMG2" "EMG3" "EMG4" "EMG5"))))
    )
    (if (= (length name)(resource sel :channels));; unless launch will fail
      (dotimes (n (length name))
        (set-property sel n :name (nth n name))))
    (link sel disp)
    (set-resource disp :point  (read-from-string (XmTextGetString text-start)))
    (set-resource disp :length (read-from-string (XmTextGetString text-length)))
    (change-eegscale)
))

(defun EEGroutineSel()
  (let ((sel)(neeg)(necg)(neog)(nemg)(st))
    (setq sel (G-widget "sel"))
    (link (G-widget "ECG")(G-widget "ECG-fil"))
    (link (G-widget "EOG")(G-widget "EOG-fil"))
    (link (G-widget "EMG")(G-widget "EMG-fil"))
    (setq neeg (resource (G-widget "EEG-fil") :channels))
    (setq necg (resource (G-widget "ECG-fil") :channels))
    (setq neog (resource (G-widget "EOG-fil") :channels))
    (setq nemg (resource (G-widget "EMG-fil") :channels))
    (setq st (format nil "(select-to sel (EEG-fil 0 - ~d)" (1- neeg)))
    (if (> necg 0)(setq st (str-append st (format nil "(ECG-fil 0 - ~d)" (1- necg)))))
    (if (> neog 0)(setq st (str-append st (format nil "(EOG-fil 0 - ~d)" (1- neog)))))
    (if (> nemg 0)(setq st (str-append st (format nil "(EMG-fil 0 - ~d)" (1- nemg)))))    
    (setq st (str-append st ")"))
    (eval (read-from-string st))
))


(defun EEGroutineFsub()
  (let ((EEG1)(EEG2)(fsub)(EEG-fil))
    (setq EEG1 (G-widget "EEG1"))
    (setq EEG2 (G-widget "EEG2"))
    (setq fsub (G-widget "fsub"))
    (setq EEG-fil (G-widget "EEG-fil"))
    (link EEG1 fsub)(link EEG2 fsub)(link fsub EEG-fil)
    (EEGroutineSel)
))


(defun findmax001()
  (let ((w0)(w1)(w2)(w3)(mtx)(r1)(r2)(k))
    (setq w0 (G-widget "win000"))
    (setq w1 (G-widget "000"))
    (setq w2 (G-widget "mxwin"))
    (setq w3 (G-widget "mxvcp"))
    (link w1 w2)(link w2 w3)
    (set-resource w2 :point (resource w1 :selection-start))
    (set-resource w2 :end   (resource w1 :selection-length))
    (setq mtx (get-data-matrix w3 0 (resource w3 :high-bound)))
    (setq r1 (row 0 mtx)); max
    (setq r2 (row 1 mtx)); ch
    (setq r1 (map-matrix r1 #'abs))
    (setq k (max-matrix r1)) 
    (print k)
))

(defun findmax000()
  (let ((LL nil)(val)(ch)(tm)(w0)(w1)(str)(t0)(span))
    (setq LL (findmax000core)) 
    (if LL (progn
      (setq w0 (G-widget "win000"))
      (setq w1 (G-widget "000"))
      (setq val (* (first LL) 1e+13));fT/cm
      (setq ch (get-property w1 (second LL) :name))
      (setq tm (third LL))
      (setq tm (* tm (resource w1 :x-scale)))
      (setq tm (+ tm (resource w1 :selection-start)))
      (setq tm (+ tm (resource w0 :point)))
      (setq str (format nil "~a    ~0,0f fT/cm" ch val))
      (set-values label-gra000 :labelString (XmString str))
      (setq str (format nil "fit ~0,3f" tm))
      (set-values fit-button :labelString (XmString str)))
    (progn
      (setq t0 (resource (G-widget "win000"):point))
      (setq span (resource (G-widget "win000"):end)) 
      (set-values label-gra000 :labelString 
        (XmString (format nil "Gra ~0,1f ~~ ~0,1f(s)" t0 (+ t0 span))))
      (set-values fit-button   :labelString (XmString "to xfit"))
      ))
    ;;Warning XmForm contracitory constrains of fit-button
))

(defun findmax000core()
  (let ((ww)(w0)(mw)(mv)(t0)(t1)(span0)(mtx)(chx)(val)(n)(ch)(L))
    (setq ww (G-widget "win000") w0 (G-widget "000"))
    (setq span (resource w0 :selection-length))
    (if (<= span 0.0)(return nil)(progn
      (setq mw (G-widget "mxwin")  mv (G-widget "mxvcp"))
      (setq t0 (resource ww :point))
      (setq t1 (resource w0 :selection-start))
      (link ww mw)
      (set-resource mw :point t1 :end span)
      (set-resource mv :mode "abs-max")
      (setq mtx (get-data-matrix mv 0 (resource mv :high-bound)))
      (setq chx (row 1 mtx)); max channel
      (setq mtx (row 0 mtx)); max value
      (if (= prepeak 100)(progn
        (setq val (max-vector mtx))
        (setq n (round (second val)));smp
        (setq ch (vref chx n))
        (setq L (list (first val) (round ch) n)))
      (progn
        (setq prepeak (read-from-string (XmTextGetString text-prepeak)))
        (if (or (>= prepeak 100)(< prepeak 50))(setq prepeak 80))
        (XmTextSetString text-prepeak (format nil "~0,0f" prepeak))
        (setq L (max-vector-pre mtx prepeak))
        (setq val (second L))
        (setq n (round (first L)))
        (setq ch (vref chx n))
        (setq L (list val (round ch) n))))
      (return L)))
))


(defun fit000()
  (let ((LL)(t0)(span)(ch)(tm)(w)(w1)(w2)(tpeak)(tmin)(tmax)(tend))
    (setq w0 (G-widget "win000"))
    (setq w1 (G-widget "000"))
    (cond
        ((= gramag 306)(setq w (G-widget "meg")))
        ((= gramag 204)(setq w (G-widget "gra")))
        ((= gramag 102)(setq w (G-widget "mag")))
    )
    (setq LL (findmax000core)); max-val, ch, smp, pre-smp, pre-max-val
    (if LL (progn    
      (setq t0 (resource w1 :selection-start))
      (setq span (resource w1 :selection-length))
      (setq t0 (+ t0 (resource w0 :point)))
      (setq ch (get-property w1 (second LL) :name))
      (setq tm (* (third LL) (resource w0 :x-scale)))
      (setq tpeak (+ tm t0))
      (if (not meg306)(progn
        (link w (G-widget "meg2"))
        (set-near-coil ch)
        (setq w (G-widget "meg2"))))
      (if (= noise-estimation 2)(progn
        (setq tend (+ t0 span))
        (setq tmin (read-from-string (XmTextGetString text-baselinestart)))
        (setq tmax (read-from-string (XmTextGetString text-baselineend)))
        (setq tmin (+ tmin tpeak) tmax (+ tmax tpeak))
        (if (< tmin t0)(setq t0 tmin span (- tend t0)))
        (if (> tmax tend)(setq span (- tmax t0)))  ))        
      (xfit-transfer-data w (list t0 span))   
      (if (> gramag 102)
      (xfit-command (format nil "samplech ~a" (string-left-trim "MEG " ch))))
      (case noise-estimation
        (1 (xfit-command (format nil "baseline ~0,1f ~0,1f" (* t0 1000)(* (+ t0 span) 1000))))
        (2 (xfit-command (format nil "baseline ~0,1f ~0,1f" (* tmin 1000)(* tmax 1000))))
        (3 (xfit-command (format nil "baseline off")))
      )
      (xfit-command (format nil "fit ~a" (* tpeak 1000))))
    (progn  ;; not dipole fitting
      (setq t0   (resource w0 :point))
      (setq span (resource w0 :end));start is 0
      (xfit-transfer-data w (list t0 span))))
))


(defun fitcore(t0 span ch tpeak)
  (let ((w)(R)(t1)(t2)(tend)(tmin)(tmax))
    (cond 
      ((= gramag 306)(setq w (G-widget "meg")))
      ((= gramag 204)(setq w (G-widget "gra")))
      ((= gramag 102)(setq w (G-widget "mag")))
    )
    (unless meg306 (progn
      (link w (G-widget "meg2"))
      (set-near-coil ch)
      (setq w (G-widget "meg2"))))
    (if (= noise-estimation 2)(progn
      (setq tend (+ t0 span))
      (setq tmin (read-from-string (XmTextGetString text-baselinestart)))
      (setq tmax (read-from-string (XmTextGetString text-baselineend)))
      (setq tmin (+ tmin tpeak) tmax (+ tmax tpeak))
      (if (< tmin t0)(setq t0 tmin span (- tend t0)))
      (if (> tmax tend)(setq span (- tmax t0)))))
    (xfit-transfer-data w (list t0 span))
    (setq ch (string-left-trim "MEG" ch))
    (xfit-command (format nil "samplech ~a" ch)) 
    (case noise-estimation
      (1 (xfit-command (format nil "baseline ~0,1f ~0,1f" (* t0 1000)(* (+ t0 span) 1000))))
      (2 (xfit-command (format nil "baseline ~0,1f ~0,1f" (* tmin 1000)(* tmax 1000))))
      (3 (xfit-command (format nil "baseline off")))
    )
    (xfit-command (format nil "fit ~a" (* tpeak 1000)))
))

(defun get-date()
  (let ((x)(xx)(str))
    (setq x (get-universal-time))
    (setq x (multiple-value-list (decode-universal-time x)))
    (setq str (format nil "~a" (sixth x)))
    (setq xx (fifth x))
    (if (< xx 10)(setq str (format nil "~a0~a" str xx))
                 (setq str (format nil "~a~a" str xx)))
    (setq xx (fourth x))
    (if (< xx 10)(setq str (format nil "~a0~a" str xx))
                 (setq str (format nil "~a~a" str xx)))
    (return str)
))

(defun get-datetime()
  (let ((x)(xx)(str))
    (setq x (get-universal-time))
    (setq x (multiple-value-list (decode-universal-time x)))
    (setq str (format nil "~a" (sixth x)))
    (setq xx (fifth x))
    (if (< xx 10)(setq str (format nil "~a0~a" str xx))
                 (setq str (format nil "~a~a" str xx)))
    (setq xx (fourth x))
    (if (< xx 10)(setq str (format nil "~a0~a" str xx))
                 (setq str (format nil "~a~a" str xx)))
    (setq xx (third x))
    (if (< xx 10)(setq str (format nil "~a0~a" str xx))
                 (setq str (format nil "~a~a" str xx)))
    (setq xx (second x))
    (if (< xx 10)(setq str (format nil "~a0~a" str xx))
                 (setq str (format nil "~a~a" str xx)))
    (setq xx (first x))
    (if (< xx 10)(setq str (format nil "~a0~a" str xx))
                 (setq str (format nil "~a~a" str xx)))
    (return str)
))

(defun get-ecgscale()(* (read-from-string (XmTextGetString text-ecg)) 1e-6))

(defun get-eegscale()(* (read-from-string (XmTextGetString text-eeg)) 1e-6))

(defun get-emgscale()(* (read-from-string (XmTextGetString text-emg)) 1e-6))

(defun get-eogscale()(* (read-from-string (XmTextGetString text-eog)) 1e-6))

(defun get-file-extension(filename)
  " Return file-extension.
    Syntax: (get-file-extension filename)"
  (let ((n)(strm)(N)(pos nil)(R)(str  ""))
    (setq strm (make-string-input-stream filename))
    (setq N (length filename))
    (dotimes (n N)
      (setq R (read-char strm))
      (if (eq R #\.)(setq pos n)))
    (setq strm (make-string-input-stream filename))
    (dotimes (n N)
      (setq R (read-char strm))
      (if (> n pos)(setq str (format nil "~a~a" str R))))
    (return str) 
))

(defun get-grascale()(* (read-from-string (XmTextGetString text-gra)) 1e-13))

(defun get-magscale()(* (read-from-string (XmTextGetString text-mag)) 1e-15))

(defun get-matrix-sum(mtx)
  (let ((n))
    (setq n (array-dimensions mtx))
    (when (> (first n)(second n))(setq mtx (transpose mtx)))
    (setq n (array-dimension mtx 1))
    (setq mtx (* mtx (ruler-vector 1 1 n)))
    (when (matrixp mtx)(progn
      (setq mtx (transpose mtx))
      (setq n (array-dimension mtx 1))
      (setq mtx (* mtx (ruler-vector 1 1 n)))))
    (print mtx)
))

(defun get-memo()
  (let ((memo))
    (cond
      ((= nmemo 1)(setq memo memo1))
      ((= nmemo 2)(setq memo memo2))
      ((= nmemo 3)(setq memo memo3))
    )
   (return memo)
))

(defun initialize()
  (let ((n)(btn))
    (define-parameters)
    (defchpos)
    (add-color)
    (add-layout)
    (add-megsel)
    (chchsMEG);(require 'ssp)
    (chchsMEGmax);...vecop
    (chchsEEG)
    (add-button *command-menu* "capture this widnow" '(screen-capture))
    (add-button *command-menu* "PCA" '(create-pca))
    ;(manage *control-panel*)
    (setq nlayout 5)
    (setq form000 (make-form *main-window* "form000"))
    (setq form001 (make-form form000 "form001" :topAttachment XmATTACH_FORM
      :leftAttachment  XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM :rightOffset 200 :bottomOffset 60))
    (setq form002 (make-form form001 "form002"))
    (setq frame001 (make-frame form000 "frame001"
      :topAttachment XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :bottomOffset 60 :rightAttachment XmATTACH_FORM :width 200))
    (manage frame001)
    (setframe001)
    (setq frame002 (make-frame form000 "frame002"
      :leftAttachment  XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :topAttachment   XmATTACH_WIDGET :topWidget frame001
      :rightAttachment XmATTACH_FORM :height 60 :shadowThickness 0))
    (manage frame002)
    (setframe002)
    (create-initial-source)
    (link (G-widget "mtx")(G-widget "buf"))
    (layout4)
    ;(GtOrganizePanel)
    (dolist (n (list form002 form001 form000))(manage n))
    (link (G-widget "gra")(G-widget "disp001"))
    (link (G-widget "EEG-fil")(G-widget "disp009"))
    (require 'xfit)
    (xfit)
    (XtDestroyWidget form-launch)
    (require *hns-meg*);; this calls second form-launch
    (XtDestroyWidget form-launch)
    ;(xfit-command "origin head 0 0 40"); not recognized
    ;(kill-xfit)

    (change-grascale)
    (change-eegscale)
    (case MEGsite
      (1 (progn (EEGHiroshimamenu)(EEGHiroshima 1)))
      (2 (progn (EEGCleavelandmenu)(EEGCleaveland 1))); 10-10 rules
      (3 (progn (EEGCleavelandmenu2)(EEGCleaveland2 1))); 10-20 rules
     )
    (link (G-widget "file")(G-widget "buf"))
    (link (G-widget "EEG-fil")(G-widget "disp009"))
    (create-memos)
    (create-xfit)
    (add-button *display-menu* "show memo" 
     '(if (XtIsManaged form-memo)(unmanage form-memo)(manage form-memo)))
    (unmanage form-memo)

))

(defun layout-meg(nn)
  (if (= nlayout 3)
    (if (= nn 0)(layout2gra)(layout2mag))
    (if (= nn 0)(layout1gra)(layout1mag)))
)

(defun layout-routine();; delete disp00?
  (let ((n)(disp))
    (XtDestroyWidget form002)
    (XtDestroyWidget form001)
    (gc)
    (setq form001 (make-form form000 "form001" 
      :topAttachment    XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_WIDGET :rightWidget frame001))
    (setq form002 (make-form form001 "form002"
      :topAttachment    XmATTACH_FORM :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM :bottomOffset 20))
    (manage form002)(manage form001)
    (dotimes (n 10)
      (setq disp (format nil "disp00~a" n))
      (if (G-widget disp :quiet)(GtDeleteWidget (G-widget disp))))
    (dotimes (n 8); for layout2
      (setq disp (format nil "sel0~a" n))
      (if (G-widget disp :quiet)(GtDeleteWidget (G-widget disp))))
))

(defun layout1(nn)
  (let ((sp))
    (layout-routine)
    (setq sp (* 50 nn))
    (make-meg8 0 100 sp (+ sp 50) form002 "disp001")
    (make-plotter 0 100 (- 50 sp)(- 100 sp) form002 "disp009")
    (if (get-property (G-widget "gra") 0 :kind)(layout1gra));; initial setting!
))

(defun layout1gra()
  (let ((mtx)(x8)(w))
    (link (G-widget "gra")(G-widget "disp001"))
    (setq x8 (/ (ruler-vector -3.5 3.5 8) 4))
    (setq mtx (mat-append 
      (make-matrix 1 26 (vref x8 0))(make-matrix 1 26 (vref x8 1))
      (make-matrix 1 26 (vref x8 2))(make-matrix 1 26 (vref x8 3))
      (make-matrix 1 24 (vref x8 4))(make-matrix 1 24 (vref x8 5))
      (make-matrix 1 26 (vref x8 6))(make-matrix 1 26 (vref x8 7))))
    (setq w (G-widget "disp001"))
    (set-resource w :offsets (transpose mtx) :superpose t :ch-label-space 0)
    (change-grascale)
))

(defun layout1mag()
  (let ((mtx)(x8)(w))
    (link (G-widget "mag")(G-widget "disp001"))
    (setq x8 (/ (ruler-vector -3.5 3.5 8) 4))
    (setq mtx (mat-append 
      (make-matrix 1 13 (vref x8 0))(make-matrix 1 13 (vref x8 1))
      (make-matrix 1 13 (vref x8 2))(make-matrix 1 13 (vref x8 3))
      (make-matrix 1 12 (vref x8 4))(make-matrix 1 12 (vref x8 5))
      (make-matrix 1 13 (vref x8 6))(make-matrix 1 13 (vref x8 7))))
    (setq w (G-widget "disp001"))
    (set-resource w :offsets (transpose mtx))
    (change-magscale)
))

(defun layout2(); gra 26-26-26-26-24-24-26-26 mag 13-13-13-13-12-12-13-13
  (let ((n)(sel0n))
    (layout-routine) 
    (set-values form002 :topOffset 20 :leftOffset 20)
    (setq label1 (make-label form001 "label1" :labelString (XmString "temporal")
      :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_POSITION :leftPosition 10))
    (setq label2 (make-label form001 "label2" :labelString (XmString "parietal")
      :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_POSITION :leftPosition 30 ))
    (setq label3 (make-label form001 "label3" :labelString (XmString "occipital")
      :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_POSITION :leftPosition 50))
    (setq label4 (make-label form001 "label4" :labelString (XmString "frontal")
      :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_POSITION :leftPosition 70 ))
    (setq label5 (make-label form001 "label5" :labelString (XmString "L")
      :topAttachment XmATTACH_POSITION :topPosition 25 :leftAttachment XmATTACH_FORM))
    (setq label6 (make-label form001 "label6" :labelString (XmString "R")
      :topAttachment XmATTACH_POSITION :topPosition 75 :leftAttachment XmATTACH_FORM))
    (dolist (n (list label1 label2 label3 label4 label5 label6))(manage n))
    (make-plotter  0  50  0  20 form002 "disp001")
    (make-plotter 50 100  0  20 form002 "disp002")
    (make-plotter  0  50 20  40 form002 "disp003")
    (make-plotter 50 100 20  40 form002 "disp004")
    (make-plotter  0  50 40  60 form002 "disp005")
    (make-plotter 50 100 40  60 form002 "disp006")
    (make-plotter  0  50 60  80 form002 "disp007")
    (make-plotter 50 100 60  80 form002 "disp008")
    (make-plotter  0 100 80 100 form002 "disp009") 
    (dotimes (n 8)
      (setq sel0n (format nil "sel0~a" (+ n 1)))
      (if (not (G-widget sel0n :quiet))(require-widget :selector sel0n)))
    (if (get-property (G-widget "gra") 0 :kind)(layout2gra))
))

(defun layout2end()
  (let ((n)(disp)(t0)(span))
    (setq t0   (read-from-string (XmTextGetString text-start)))
    (setq span (read-from-string (XmTextGetString text-length)))
    (dotimes (n 8)
      (setq disp (G-widget (format nil "disp00~a" (+ n 1))))
      (set-resource disp :ch-label-space 80 :point t0 :length span)
      (link (G-widget (format nil "sel0~a" (+ n 1))) disp))
    (set-resource (G-widget "disp009") :ch-label-space 80 :point t0 :length span)
    (link (G-widget "sel")(G-widget "disp009"))
))

(defun layout2gra()
  (let ((meg (G-widget "meg")))
    (select-to (G-widget "sel01")(meg   0 -  25))
    (select-to (G-widget "sel02")(meg  25 -  51))
    (select-to (G-widget "sel03")(meg  52 -  77))
    (select-to (G-widget "sel04")(meg  78 - 103))
    (select-to (G-widget "sel05")(meg 104 - 127))
    (select-to (G-widget "sel06")(meg 128 - 151))
    (select-to (G-widget "sel07")(meg 152 - 177))
    (select-to (G-widget "sel08")(meg 178 - 203))
    (layout2end)
    (change-grascale)
))

(defun layout2mag();203 +13-13-13-13-12-12-13-13
  (let ((meg (G-widget "meg")))
    (select-to (G-widget "sel01")(meg 204 - 216))
    (select-to (G-widget "sel02")(meg 217 - 229))
    (select-to (G-widget "sel03")(meg 230 - 242))
    (select-to (G-widget "sel04")(meg 243 - 255))
    (select-to (G-widget "sel05")(meg 256 - 267))
    (select-to (G-widget "sel06")(meg 268 - 279))
    (select-to (G-widget "sel07")(meg 280 - 292))
    (select-to (G-widget "sel08")(meg 293 - 305))
    (layout2end)
    (change-magscale)
))

(defun layout3()
  (let ((n)(pane)(form1)(form2)(form3)(x))
    (layout-routine)
    (setq pane (XmCreatePanedWindow form002 "pane" (X-arglist) 0))
    (set-values pane :separatorOn 0 :sasIndent -1 :resize 1
      :topAttachment XmATTACH_FORM  :bottomAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_FORM :rightAttachment  XmATTACH_FORM
      :paneMinimum 20); :paneMinimum is invalid!
    (manage pane);; this must be here!
    (setq form1 (make-form pane "form1"))
    (setq form2 (make-form pane "form2"))
    (setq form3 (make-form pane "form3"))
    ;;disp001 8 stack megs
    (make-meg8 0 100 0 100 form1 "disp001")
    ;;disp000 selected meg
    (make-plotter 0 100 0 100 form2 "disp000"); selected MEG
    (make-plotter 0 100 0 100 form3 "disp009"); EEG etc
    (link (G-widget "gra")(G-widget "disp001"))
    (link (G-widget "meg")(G-widget "disp000"))
    (link (G-widget "sel")(G-widget "disp009"))
    (if (get-property (G-widget "gra") 0 :kind)(progn
      (layout1gra)
      (change-megsel "gra-L-temporal")))
   (dolist (n (list form1 form2 form3))(manage n))
   ;(set-values form2 :height 100)
   ;(set-values form3 :height 100)
))

(defun layout4()
  (let ((n)))
    (layout-routine)
    (make-plotter 0 100  0  33 form002 "disp009")
    (make-meg8    0 100 33  67 form002 "disp001")
    (make-plotter 0 100 67 100 form002 "disp000")
    (if (get-property (G-widget "gra") 0 :kind)(progn
      (layout1gra)
      (change-megsel "gra-L-temporal")))
))

(defun layout5()
  (let ((n)(pane)(form1)(form2)(x))
    (layout-routine)
    (make-meg8 0 100 0 50 form002 "disp001")
    (setq pane (XmCreatePanedWindow form002 "pane" (X-arglist) 0))
    (set-values pane :separatorOn 0 :sasIndent -1 :resize 1
      :topAttachment XmATTACH_FORM  :bottomAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_POSITION :leftPosition 50
      :rightAttachment  XmATTACH_FORM)
    (manage pane)
    (setq form1 (make-form pane "form1"))
    (setq form2 (make-form pane "form2"))       
    (make-plotter 0 100 0 100 form1 "disp000"); selected MEG
    (make-plotter 0 100 0 100 form2 "disp009"); EEG etc 
    (manage form1)
    (manage form2)
    (if (get-property (G-widget "gra") 0 :kind)(progn
      (layout1gra)
      (change-megsel "gra-L-temporal")))
))

(defun layout6()
  (let ((n)(pane)(form1)(form2)(x))
    (layout-routine)
    (make-plotter 0 100 0 50 form002 "disp000")
    (setq pane (XmCreatePanedWindow form002 "pane" (X-arglist) 0))
    (set-values pane :separatorOn 0 :sasIndent -1 :resize 1
      :topAttachment XmATTACH_FORM  :bottomAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_POSITION :leftPosition 50
      :rightAttachment  XmATTACH_FORM)
    (manage pane)
    (setq form1 (make-form pane "form1"))
    (setq form2 (make-form pane "form2"))       
    (make-meg8    0 100 0 100 form1 "disp001")
    (make-plotter 0 100 0 100 form2 "disp009"); EEG etc 
    (manage form1)
    (manage form2)
    (if (get-property (G-widget "gra") 0 :kind)(progn
      (layout1gra)
      (change-megsel "gra-L-temporal")))
))


(defun make-chname()
  (let ((x)(y)(ch nil))
    (dotimes (x 26)
      (dotimes (y 4)
        (setq n (+ (* x 10) y 11))
        (setq ch (append ch (list n)))))
    (setq ch (delete 83 ch))
    (setq ch (delete 84 ch))
    (return ch) 
))

(defun make-frame001(form)
  (let ((frame))
    (setq frame (make-frame form "frame001"
      :topAttachment    XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM 
      :width 200))
    (return frame)
))

(defun make-meg8(top bottom left right form name)
  (let ((dispw)(x8)(x)(label)(str)(n)(w))
    (setq x8 (/ (ruler-vector -3.5 3.5 8) 4))
    (setq dispw (make-plotter top bottom left right  form name))
    (set-values dispw :leftOffset 80 :ch-label-space 0); :superpose t)
    (setq label (list "L-temporal"  "R-temporal"  "L-parietal" "R-parietal"
                      "L-occipital" "R-occipital" "L-frontal"  "R-frontal"))
    (dotimes (n 8)
      (setq x (vref x8 n))
      (setq x (round (+ (* x 45) 46)));;thumb's rule
      (setq str (nth n label))
      ;(setq w (make-label form str :labelString (XmString str)
      (setq w (make-button form str :labelString (XmString str)
        :topAttachment  XmATTACH_POSITION :topPosition x
        :leftAttachment XmATTACH_POSITION :leftPosition left
        :leftOffset 5 :shadowThickness 0))
        ; :background (rgb 240 240 240)))
      (cond
        ((= n 0)(set-lisp-callback w "activateCallback" '(change-megsel2 0)))
        ((= n 1)(set-lisp-callback w "activateCallback" '(change-megsel2 1)))
        ((= n 2)(set-lisp-callback w "activateCallback" '(change-megsel2 2)))
        ((= n 3)(set-lisp-callback w "activateCallback" '(change-megsel2 3)))
        ((= n 4)(set-lisp-callback w "activateCallback" '(change-megsel2 4)))
        ((= n 5)(set-lisp-callback w "activateCallback" '(change-megsel2 5)))
        ((= n 6)(set-lisp-callback w "activateCallback" '(change-megsel2 6)))
        ((= n 7)(set-lisp-callback w "activateCallback" '(change-megsel2 7)))
      )
      (manage w))
))

(defun make-plotter(top bottom left right form name)
  (let ((disp)(dispw))
    (if (G-widget name :quiet)(GtDestroyWidget (G-widget name)))
    (setq disp (GtMakeObject 'plotter :name name :display-parent form
      :scroll-parent form001 :no-controls t))
    (put disp :display-form form)
    (GtPopupEditor disp)
    (setq dispw (resource disp :display-widget))
    (set-values dispw :resize 1 
      :topAttachment    XmATTACH_POSITION :topPosition    top
      :bottomAttachment XmATTACH_POSITION :bottomPosition bottom
      :leftAttachment   XmATTACH_POSITION :leftPosition   left
      :rightAttachment  XmATTACH_POSITION :rightPosition  right)
    (set-resource disp :scroll-visible 0 :x-unit "s" :length 10
      :point 0 :ch-label-space 80)
    (set-values (resource disp :scroll-widget)
      :topAttachment    XmATTACH_WIDGET :topWidget    form002
      :bottomAttachment XmATTACH_WIDGET :bottomWidget form001
      :leftAttachment   XmATTACH_WIDGET :leftWidget   form001
      :rightAttachment  XmATTACH_WIDGET :rightWidget  form001)
    (return dispw)
))

(defun make-random-matrix(x y)
  (let ((R))
    (setq R (/ (random-matrix x y)(pow 2 31)))
    (return R)
))

(defun max-gra(t0 span)
  (let ((w)(xscale)(T0)(SPAN)(mtx)(mx)(ch)(tmax)(R))
    (setq w (G-widget "gra"))
    (setq xscale (resource w :x-scale))
    (setq T0   (round (/ t0 xscale)))
    (setq SPAN (round (/ span xscale)))
    (setq mtx (get-data-matrix w T0 SPAN))
    (setq mx (max-matrix mtx))
    (setq ch (get-property w (second mx) :name))
    (setq tmax (+ (* (third mx) xscale) t0))
    (setq R (list (first mx) ch tmax))
    (return R)
))

(defun max-gra-list(t0 span)
  (let ((w)(xscale)(T0)(SPAN)(mtx)(mx)(tmax)(R))
    (setq w (G-widget "gra"))
    (setq xscale (resource w :x-scale))
    (setq T0   (round (/ t0 xscale)))
    ;(setq T0 (+ T0 (resource w :low-bound)))
    (setq SPAN (round (/ span xscale)))
    (setq mtx (get-data-matrix w T0 SPAN))
    (setq mx (max-matrix mtx))
    (setq ch (get-property w (second mx) :name))
    (setq tmax (+ (* (third mx) xscale) t0))
    (setq R (list t0 span ch tmax (* (first mx) 1e+13)))
    (return R)
))

(defun max-matrix(mtx)
  (let ((Nch)(Ntm)(val)(val1)(tmvec)(vec)(chvec)(ch)(tm)(n))
    (setq Nch (array-dimension mtx 0))
    (setq Ntm (array-dimension mtx 1))
    (setq tmvec (ruler-vector 0 (- Ntm 1) Ntm))
    (setq chvec (ruler-vector 0 (- Nch 1) Nch))
    (setq chvec (transpose chvec))
    (setq mtx (map-matrix mtx #'fabs))
    (setq val (second (matrix-extent mtx)))
    (setq mtx (/ mtx val))
    (setq val1 (second (matrix-extent mtx)))
    (setq mtx (/ mtx val1))
    (setq mtx (map-matrix mtx #'floor));; Nch x Ntm 0.0 or 1.0
    (setq vec (* mtx tmvec))
    (setq tm (round (second (matrix-extent vec))))
    (setq vec (column tm mtx))
    (setq ch (round (* chvec vec)))
    (return (list val ch tm))
))

(defun maxfun(x)
  (setq sumfunsum (max sumfunsum (abs x)))
)

(defun max-vector_old(vec)
  (let ((N)(val)(val1)(n))
    (setq N (array-dimension vec 0))
    (if (= N 1)(setq N (array-dimension vec 1))
      (setq vec (transpose vec)))
    (setq vec (map-matrix vec #'abs))
    (setq val (second (matrix-extent vec)))
    (setq vec (/ vec val))
    (setq val1 (second(matrix-extent vec)))
    (setq vec (/ vec val1))
    (setq vec (map-matrix vec #'floor))
    (setq vec (map-matrix vec #'round))
    (setq k (* vec (ruler-vector 1 1 N)))
    (if (= k 1)
      (setq val1 (- (* vec (ruler-vector 1 N N))1))
      (progn (catch 'exit
        (dotimes (n N)
          (if (= (vref vec n) 1)
            (throw 'exit (setq val1 n)))))))
    (return (list val (round val1)))
))


(defun max-vector(vec);vec is row vector
  (let ((n)(mx)(vec0)(nn -1))
    (setq vec (map-matrix vec #'abs))
    (setq mx (second (matrix-extent vec)))
    (setq vec0 (map-matrix vec #'threshold mx))
    (progn (catch 'exit
      (dotimes (n (length vec0))
        (if (= (vref vec0 n) mx)
          (throw 'exit (setq nn n))))))
    (return (list mx nn))
))

(defun max-vector-pre(vec pre)
  (let ((n)(mx)(vec0)(vec1)(nn -1)(val))
    (setq vec (map-matrix vec #'abs))
    (setq mx (second (matrix-extent vec)))
    (setq vec0 (map-matrix vec #' threshold mx))
    (setq vec1 (map-matrix vec #' threshold (* mx pre 0.01)))
    (progn (catch 'exit
      (dotimes (n (length vec1))
        ;(print (list n nn (vref vec0 n)(vref vec1 n)))        
        (if (= (vref vec1 n) 0.0)(setq nn -1)
          (progn 
            (if (= nn -1)(setq nn n))
            (if (= (vref vec0 n) mx)
              (throw 'exit (setq val nn))))))))
    ;(print (list mx (vref vec val)))
    (return (list val (vref vec val)))
))

(defun memo-check()
  (let ((n)(N)(memo)(str)(strm)(char))
    (setq memo (get-memo))
    (setq str (XmTextGetString memo))
    (setq strm (make-string-input-stream str))
    (setq N (+ 1 (length str)))
    (dotimes (n N)
      (setq char (read-char strm))
      (print (char-code char)))
))

(defun memo-clear()
  (let ((memo))
    (setq memo (get-memo))
    (XmTextSetString memo "")
))

(defun memo-clear-all()
  (XmTextSetString memo3 "")
  (XmTextSetString memo2 "")
  (XmTextSetString memo1 "")
)

(defun memo-coordinate(&optional (x 0)(y 0)(z 40))
  (xfit-command (format nil "origin head ~0,2f ~0,2f ~0,2f" x y z))
)

(defun memo-copy(n)
  (let ((memo)(str))
    (setq memo (get-memo))
    (setq str (XmTextGetString memo))
    (cond
      ((= n 1)(XmTextSetString memo1 str))
      ((= n 2)(XmTextSetString memo2 str))
      ((= n 3)(XmTextSetString memo3 str))
    )
))

(defun memo-dipclear()
  (xfit-command "dipclear");selected dipole is cleared
  (xfit-command "dipclear");all dipoles are cleared
)

(defun memo-dipload()
  (let ((folder)(loadname)(filename)(ext))
    (setq folder (resource (G-widget "file") :directory))
    (setq folder (str-append (filename-directory folder) "*.bdip"))
    (setq loadname (resource (G-widget "file") :filename))
    (setq loadname (format nil "~a.bdip" (filename-base loadname)))
    (setq filename (ask-filename "select BDIP file" :template folder :default loadname))
    (when (file-exists-p filename)
      (xfit-command (format nil "dipload ~a" filename)))      
))

(defun memo-dipsave()
  (let ((folder)(savename)(filename)(ext))
    (setq folder (resource (G-widget "file") :directory))
    (setq folder (str-append (filename-directory folder) "*.bdip"))
    (setq savename (resource (G-widget "file") :filename))
    (setq savename (format nil "~a.bdip" (filename-base savename)))
    (setq filename (ask-filename "Give new filename" :new t
                      :template folder :default savename :if-exists :ask))    
    (when filename (progn
      (setq ext (filename-extension filename))
      (unless (string-equal ext "bdip")
        (setq filename (format nil "~a~a.bdip" (filename-directory filename)(filename-base filename))))
      (xfit-command (format nil "dipsave ~a" filename))))
))

(defun memo-dipselect1()
  (let ((gof)(folder)(filename)(str)(fid)(bytes))
    (setq gof (read-from-string (XmTextGetString text-gof)))
    (setq folder (filename-directory (resource (G-widget "file") :filename)))
    (setq filename (format nil "~agraph000.bdip" folder))
    (xfit-command (format nil "dipsave ~a" filename))
    (setq folder (string-right-trim "hns_meg5" *hns-meg*))
    (setq str (format nil "~a/delete_lowgof ~a ~a" folder filename gof))
    (system str)
    (system (format nil "stat -c~As ~a > byte000.txt" "%" filename))
    ;(system (format nil "ls -lh ~a | awk '{print $5'} > byte000.txt" filename))
    (setq fid (open "byte000.txt" :direction :input))
    (setq bytes (read fid))
    (close fid)
    (if (= bytes 0)(info (format nil "No dipole with GOF >=~0,0f" gof))
      (progn
        (info (format nil "~0,0f dipoles are selected" (/ bytes 196)))
        (xfit-command "dipclear");selected dipole
        (xfit-command "dipclear");all dipoles
        (xfit-command (format nil "dipload ~a" filename))))
    (system "rm byte000.txt")
    (system (format nil "rm ~a" filename))
))

(defun memo-dipselect()
  (let ((gof)(cv)(khi)(folder)(filename)(str)(fid)(bytes))
    (setq gof (read-from-string (XmTextGetString text-gof)))
    (setq cv  (read-from-string (XmTextGetString text-cv)))
    (setq khi (read-from-string (XmTextGetString text-khi)))
    (setq folder (filename-directory (resource (G-widget "file") :filename)))
    (setq filename (format nil "~agraph000.bdip" folder))
    (xfit-command (format nil "dipsave ~a" filename))
    (setq folder (string-right-trim "hns_meg5" *hns-meg*))
    (setq str (format nil "~a/criteria_bdip ~a ~a ~a ~a" folder filename gof cv khi))
    (system str)
    (system (format nil "stat -c~As ~a > byte000.txt" "%" filename))
    ;(system (format nil "ls -lh ~a | awk '{print $5'} > byte000.txt" filename))
    (setq fid (open "byte000.txt" :direction :input))
    (setq bytes (read fid))
    (close fid)
    (if (= bytes 0)(info (format nil "No dipole with GOF >=~0,0f" gof))
      (progn
        (info (format nil "~0,0f dipoles are selected" (/ bytes 196)))
        (xfit-command "dipclear");selected dipole
        (xfit-command "dipclear");all dipoles
        (xfit-command (format nil "dipload ~a" filename))))
    (system "rm byte000.txt")
    (system (format nil "rm ~a" filename))
))

(defun memo-dipselect-png()
  (let ((fid)(n)(L)(files)(folder)(textfile)(dipfile)(str)(cmd))
    (system "ls a*.png  > ls.txt")
    (setq fid (open "ls.txt" :direction :input))
    (catch 'exit
      (dotimes (n 500);max 500!
        (setq L (read-line fid))
        (unless L (throw 'exit t))
        (setq L (string-trim "a.png" L))
        (setq files (append files (list(read-from-string L))))))
    (close fid)
    (system "rm ls.txt")    
    (when (> (length files))(progn
      (setq folder (filename-directory (resource (G-widget "file") :filename)))   
      (setq textfile (str-append folder "ls.txt"))
      (setq fid (open textfile :direction :output :if-exists :supersede))
      (dolist (n files)
        (format fid "~f " n));
      (close fid)
      (setq dipfile (str-append folder "graphpng.bdip"))
      (xfit-command (format nil "dipsave ~a" dipfile))
      (setq cmd (str-append (filename-directory *hns-meg*) "select_time"))
      (system (format nil "~a ~a ~a" cmd dipfile textfile))
      (xfit-command (format nil "dipload ~a" dipfile))
      (system (format nil "rm ~a" textfile))
      (memo-dipclear)
      (xfit-command (format nil "dipload ~a" dipfile))
      (system (format nil "rm ~a" dipfile))))
))

(defun memo-extractepoch()
  (let ((folder)(str)(filename1)(filename2)(fid)(L)(LL nil)(n)(N)(memo)(tt))
    (setq folder (filename-directory (resource (G-widget "file") :filename)))
    (setq filename1 (str-append folder "graph012.bdip"))
    (setq filename2 (str-append folder "graph012.txt"))
    (xfit-command (format nil "dipsave ~a" filename1))
    (setq str (format nil "~a/read_bdip ~a ~a" (filename-directory *hns-meg*) filename1 filename2))
    (system str)
    (system (format nil "rm ~a" filename1))
    (setq str "")
    (setq fid (open filename2 :direction :input))
    (catch 'exit
      (dotimes (n 100000)
        (setq L (read-line-as-list fid))
        (if L (setq LL (append LL (list (first L))))(throw 'exit t))))
    (close fid)
    (system (format nil "rm ~a" filename2))
    (setq str "")  
    (setq memo (get-memo))
    (setq fid (make-string-input-stream (XmTextGetString memo)))
    (setq N (memo-getline))
    (setq N (+ (second N) 1))
    (dotimes (n N)
      (setq L (read-line-as-list fid))
      (when (> (length L) 4)(progn
        (setq tt (* (fourth L) 1000)) ; unit is msec
        (when (member tt LL)
          (setq str (format nil "~a~a~%" str (memo-line L)))))))
    (XmTextSetString memo str)        
))

(defun memo-fit()
  (let ((R)(sns)))
    (setq R (memo-readline))
    (when (> (length R) 4)(progn
      (setq sns (format nil "~a" (third R)))
      (unless (string-equal sns (string-trim "MEG" sns))
        (fitcore (first R)(second R) sns (fourth R))))) 
))        

(defun memo-fitfit()
  (let ((R)(L)(n)(N)(strm)(sns))
    (setq memo (get-memo))
    (setq strm (make-string-input-stream(XmTextGetString memo)))
    (setq R (memo-getline))
    (setq N (+ (second R) 1))
    (dotimes (n N)
      (setq R (read-line-as-list strm))
      (when (> (length R) 4)(progn
        (setq sns (format nil "~a" (third R)))
        (unless (string-equal sns (string-trim "MEG" sns))
          (fitcore (first R)(second R) sns (fourth R))))))
))

(defun memo-fullview();unused
   (let ((R)(sns))
     (setq R (memo-readline))
     (when (> (length R) 4)(progn
       (setq sns (format nil "~a" (third R)))
       (unless (string-equal sns (string-trim "MEG" sns))(progn
         (memo-goto)
         (fit000)
         (xfit-command "fullview")
     )))))
))

(defun memo-getline()
  (let ((pos)(memo)(str)(num 0)(fin 0)(n)(strm)(char))
    (setq memo (get-memo))
    (setq pos (XmTextGetInsertionPosition memo))
    (setq str (XmTextGetString memo))
    (setq strm (make-string-input-stream str))
    (dotimes (n (length str))
      (setq char (read-char strm))
      (if (or (equal char #\Linefeed)(equal char #\Eof))(progn
       (if (< n pos)(setq num (+ num 1)))
       (setq fin (+ fin 1)))))
    (return (list num fin))
))

(defun memo-getline2()
  (let ((memo)(str)(strm)(R)(n)(N)(L))
    (setq memo (get-memo))
    (setq str (XmTextGetString memo))
    (setq strm (make-string-input-stream str))
    (setq N (memo-getline))
    (setq N (+ (second N) 1))
    (dotimes (n N)
      (setq L (read-line-as-list strm))
      (setq R (list (stream-index strm)(stream-column strm)(stream-line strm)))
      (print R));; shows (0 0 0)  valid in output-stream and print?
))

(defun memo-goto()
  (let ((R)(sns)(t0)(t1)(span)(span1)(w))
    (setq R (memo-readline))
    (when (> (length R) 4)(progn
      (setq sns (format nil "~a" (third R)))
      (unless (string-equal sns (string-trim "MEG" sns))(progn
        (if (> nlayout 3)(change-megsel (which-gra8 sns)))
        (setq t1 (first R) span1 (second R))
        (setq w (G-widget "disp009"))
        (setq span (resource w :length))
        (setq t0 (- (+ t1 (/ span1 2)) (/ span 2)))
        (set-resource w :point t0 :selection-start t1 :selection-length span1)
        (sync-move-hook w)
        (sync-select-hook w)))))
))

(defun memo-insert(str)
  (let ((memo)(pos)(strm0)(strm1)(char)(ck)(str0)(char)(n)(N))
    (setq memo (get-memo))
    (setq pos (XmTextGetInsertionPosition memo))
    (setq str0 (XmTextGetString memo))
    (setq N (+ (length str0) 1))
    (setq strm0 (make-string-input-stream str0))
    (setq strm1 (make-string-output-stream))
    (setq ck -2)
    (dotimes (n N)
      (setq char (read-char strm0))
      (if (= n pos)(setq ck -1))
      (if (= ck -1)
        (if (or (eq char #\Linefeed)(eq char #\Eof))(progn
          (write-string (format nil "~a" str) strm1)
          (setq ck n))))
      (if (not (eq char #\Eof))
        (write-string (format nil "~a" char) strm1)))
    (setq pos (+ ck (length str)))
    (XmTextSetString memo (get-output-stream-string strm1))
    (XmTextSetInsertionPosition memo pos)
    ;(memo-check)
))

(defun memo-line(L)
  (let ((memo)(str)(k)(n))
    (setq memo (get-memo))
    (setq str (format nil "~9,3f" (first L)))
    (setq str (format nil "~a   ~6,3f" str (second L)))
    (setq str (format nil "~a   ~a" str (third L)))
    (setq str (format nil "~a  ~8,3f" str (fourth L)))
    (setq str (format nil "~a    ~4,0f" str (fifth L)))
    (dotimes (n (length L))
      (when (> n 4)
        (setq str (format nil "~a ~a" str (nth n L)))))
    (return str)
))

(defun memo-load()
  (let ((folder)(filename)(loadname)(memo)(fid)(strm)(char)(n)(str ""))
    (setq filename (resource (G-widget "file") :filename))
    (setq folder (str-append (filename-directory filename) "*-wave.txt"))
    (setq loadname (str-append (filename-base filename) "-wave.txt"))
    (setq filename (ask-filename "select *-wave.txt" 
      :template folder :default loadname))
    (when (file-exists-p filename)(progn
      (setq strm (make-string-output-stream))
      (setq fid (open filename :direction :input))
      (catch 'exit
        (dotimes (n 100000)
          (setq char (read-char fid))
          (setq str (format nil "~a~a" str char))
          (when (equal char #\Eof)(throw 'exit t))))
      (close fid)
      (setq memo (get-memo))
      (XmTextSetString memo str)))
))

(defun memo-note()
  (let ((mxt)(t0)(span)(T0)(Span)(w)(w1)(xscale)(mx)(str)(ch)(tmax))
    (setq w (G-widget "000"))
    (setq span (resource w :selection-length))
    (if (> span 0.0)(progn
      (setq t0   (resource w :selection-start))
      (setq span (resource w :selection-length))
      (setq t0 (+ t0 (resource (G-widget "win000") :point))))(progn
      (setq w (G-widget "disp001"))
      (setq t0   (resource w :selection-start))
      (setq span (resource w :selection-length))))
    (when (> span 0)(progn
      (setq xscale (resource w :x-scale))
      (setq T0 (round (/ t0 xscale)))
      (setq Span (round (/ span xscale)))
      (setq mtx (get-data-matrix (G-widget "gra") T0 Span))
      (setq mx (max-matrix mtx))
      (setq ch (get-property (G-widget "gra") (second mx) :name))
      (setq tmax (+ t0 (* (third mx) xscale)))
      (setq mx (* (first mx) 1e+13))
      (setq str (memo-line (list t0 span ch tmax mx)))
      (memo-insert (format nil "~%~a" str))))
))

(defun memo-paste(str);; slow!
  (let ((memo)(str0 nil)(str1 nil)(st)(line)(pos1)(pos2)(n)(strm))
    (setq memo (get-memo))
    (setq line (memo-getline))
    (setq pos1 (first line) pos2 (second line))
    (setq pos2 (+ pos2 1))
    (setq strm (make-string-input-stream (XmTextGetString memo)))
    (dotimes (n pos2)
      (setq st (read-line strm))
      (if st 
        (if (> n pos1)
          (if str1 (setq str1 (format nil "~a~%~a" str1 st))
                   (setq str1 (format nil "~a" st)))
          (if str0 (setq str0 (format nil "~a~%~a" str0 st))
                   (setq str0 (format nil "~a" st))))))
    (if (not str0)(setq str0 ""))
    (if (not str1)(setq str1 ""))
    (setq str (format nil "~a~%~a" str0 str))
    (setq N (length str))
    (setq str (format nil "~a~%~a" str str1))
    (XmTextSetString memo str)
    (XmTextSetInsertionPosition memo N)
))

(defun memo-peak2selection(&optional(nn 0))
  (let ((memo)(n)(N)(L)(LL nil)(R)(w)(xscale)(strm)(tmax)(tmin)(tnow)(mtx)(K))
    (setq memo (get-memo))
    (setq R (memo-getline))
    (setq N (+ (second R) 1))
    (setq strm (make-string-input-stream (XmTextGetString memo)))
    (setq w (G-widget "buf"))
    (setq xscale (resource w :x-scale))
    (setq tmin (* (resource w :low-bound) xscale))
    (setq tmax (* (resource w :high-bound) xscale))
    (if (= nn 1)(setq nn tmin))
    (dotimes (n N)
      (setq L (read-line-as-list strm))
      (when (= (length L) 1)
        (when (numberp (first L))(progn
          (setq tnow (+ (first L) nn))
          (when (and (>= tnow tmin)(<= tnow tmax))(progn
            (setq R (max-gra tnow xscale))
            (setq K (list (- tnow 0.25) 0.5 (second R) tnow (* (first R) 1e+13)))
            (setq LL (append LL (list K)))
          ))))))
    (memo-clear)
    (setq N (length LL))
    (dotimes (n N)
      (memo-insert (format nil "~a~%" (memo-line (nth n LL)))))
    ;(memo-fitfit)
))

(defun memo-readbdip()
  (let ((folder)(str)(filename1)(filename2))
    (setq folder (resource(G-widget "file") :directory))
    (setq folder (string-right-trim "*" folder)) 
    (setq filename1 (format nil "~agraph123.bdip" folder))
    (setq filename2 (format nil "~agraph123.txt" folder))
    (xfit-command (format nil "dipsave ~a" filename1))
    (setq folder (string-right-trim "hns_meg5" *hns-meg*))
    (setq str (format nil "~a/read_bdip ~a ~a" folder filename1 filename2))
    (system str)
    (system (format nil "rm ~a" filename1))
    (memo-readbdip2 filename2)
))

(defun memo-readbdip2(filename)
  (let ((fid)(str)(str0))
    (setq str "time/ms    x/m     y/m     z/m    Qx/m    Qy/m    Qz/m   gof   CV   khi2")
    (setq str (format nil "~a~%" str))  
    (setq fid (open filename :direction :input))
    (catch 'exit 
      (dotimes (n 100000)
        (setq char (read-char fid))
        (setq str (format nil "~a~a" str char))
        (when (equal char #\Eof)(throw 'exit t))))
    (close fid)
    (setq memo (get-memo))
    (setq str0 (XmTextGetString memo))
    (if (> (length str0) 0)(setq str (format nil "~a~%~a" str0 str)))
    (XmTextSetString memo str)
    (system (format nil "rm ~a" filename))
))

(defun memo-readline()
  (let ((memo)(N)(n)(strm)(R)(L)(LL nil))
    (setq memo (get-memo))
    (setq strm (make-string-input-stream (XmTextGetString memo)))
    (setq R (memo-getline))
    (setq N (first R))
    (catch 'exit
      (dotimes (n (+ (second R) 1))
        (setq L (read-line-as-list strm))
        (when (= n N)(throw 'exit
          (progn
            (setq LL L))))))
    (return LL)
))

(defun memo-save()
  (let ((memo)(folder)(filename)(savename)(n)(fid)(str))
    (setq filename (resource (G-widget "file") :filename))
    (setq folder (str-append (filename-directory filename) "*-wave.txt"))
    (setq filename (str-append (filename-base filename) "-wave.txt"))
    (setq filename (ask-filename "Give new filename *-wave.txt" :new t 
      :new t :template folder :default filename :if-exists :ask))
    (when filename (progn
      (setq n (- (length filename)(length (string-right-trim "wave.txt" filename))))
      (when (= n 8)(progn
        (setq memo (get-memo))
        (setq str (XmTextGetString memo))
        (setq fid (open filename :direction :output :if-exists :supersede))
        (princ str fid)
        (close fid)
        (print (format nil "~a has been saved." filename))))))
))

(defun memo-save-png()
  (let ((memo)(strm)(R)(N)(n)(sns)(t0)(span)(t1)(span1)(w)(id)(str)(col))
    (setq memo (get-memo))
    (setq strm (make-string-input-stream (XmTextGetString memo)))
    (setq R (memo-getline))
    (setq N (+ (second R) 1))
    (setq w (G-widget "disp009"))
    (setq span (resource w :length))
    (setq id (window-id (XtWindow form000)))
    (when (G-widget "disp009" :quiet)(setq col "white")
      (setq col (resource (G-widget "disp009") :default-color)))
    (change-color 2)
    (unmanage form-memo)
    
    (system "rm a*.png")
    (system "xset b off")
    (dotimes (n N)
      (setq R (read-line-as-list strm))
      (when (> (length R) 4)(progn
        (setq sns (format nil "~a" (third R)))
        (unless (string-equal sns (string-trim "MEG" sns))(progn
          (if (> nlayout 3)(change-megsel (which-gra8 sns)))
          (setq t1 (first R) span1 (second R))
          (setq t0 (- (+ t1 (/ span1 2))(/ span 2)))
          (set-resource  w :point t0 :selection-start t1 
            :selection-length span1)
          (sync-move-hook w)
          (sync-select-hook w)
          (set-values label-gra000 :labelString 
            (XmString (format nil "~a    ~0,0f fT/cm" sns (fifth R))))
          (set-values fit-button :labelString
            (XmString (format nil "fit ~0,3f" (fourth R))))
          (setq str (format nil "~0,0f" (* (fourth R) 1000)))
          (setq str (string-left-trim " " str));" 1234"->"1234"
          (setq str (str-append "a" str))
          (system (format nil "xwd -id ~a >~a.xwd" id str))
          (system (format nil "convert ~a.xwd ~a.png" str str))
          (system (format nil "rm ~a.xwd" str))  )))))    
    (manage form-memo)
    (system "xset b on")
    (set-values label-gra000 :labelString (XmString "Gra 204ch"))
    (set-values fit-button   :labelString (XmString "to xfit")) 
    (if (string-equal col "white")(change-color 1))
))

(defun memo-sort(kind);2 sns 3 peak 4 fT/cm 
  (let ((memo)(n)(N)(L)(nL)(LL nil)(R)(strm)(sns)(k)(K nil)(str))
    (setq memo (get-memo))
    (setq strm (make-string-input-stream (XmTextGetString memo)))
    (setq R (memo-getline))
    (setq N (+ 1 (second R)))
    (dotimes (n N)
      (setq L (read-line-as-list strm))
      (setq nL (length L))
      (unless (< nL 5)(progn
        (setq sns (format nil "~a" (third L)))
        (unless (string-equal sns (string-trim "MEG" sns))(progn
          (setq LL (append LL (list L)))
          (if (= kind 2)
            (setq k (read-from-string (string-trim "MEG" sns)))
            (setq k (nth kind L)))
          (setq K (append K (list k))))))))
    (setq K (sort-order K))
    (if (= kind 4)(setq K (reverse K)))
    (memo-clear)
    (dotimes (n (length K))
      (setq L (nth (nth n K) LL))
      (setq str (memo-line L))
      (memo-insert (format nil "~a~%" str)))
))

(defun open-diskfile2(&optional (filename :interactive)) 
  "replaced original open-disikfile 
  within /graph-2.94/commands/open-diskfile.lsp"
  (let ((w)(folder)(extension))
    (setq w (G-widget "file"))
    (setq folder (resource w :filename))
    (if folder (setq folder 
      (str-append (filename-directory folder) "*.fif"))
      (setq folder "/data/neuro-data/*.fif"))
    (set-resource w :directory folder)
    (when (eql filename :interactive)(progn
      (GtPopupEditor w)
      (setq filename (resource w :filename))))
    (setq extension (filename-extension filename))
    (when (file-exists-p filename)
      (when (string-equal extension "fif")(progn
        (set-resource w :filename filename)
        ;(done)
        (change-layout 0);done before loading a file
        (set-resource (G-widget "mtx") :matrix #m((0))))))
))

(defun rgb(r g b)
  (+ (* (+ (* r 256) g) 256) b)
)

(defun rename-png(a b)
  (let ((fid)(n)(L1)(L2)));a "a" b "ep"
    (system (format nil "ls ~a*.png > ls.txt" a))
    (setq fid (open "ls.txt" :direction :input))
    (catch 'exit
      (dotimes (n 500) ;max 500 png files
        (setq L1 (read-line fid))
        (unless L1 (throw 'exit t))
        (setq L2 (string-left-trim a L1))
        (setq L2 (str-append b L2))
        (system (format nil "mv ~a ~a" L1 L2))))
    (close fid)
    (system "rm ls.txt")
)) 

(defun round10(v)
  (let ((x)(y)(z)(zmax))
    (setq x (floor (log10 v)))
    (setq x (pow 10 x))
    (setq y (/ v x))
    (cond
      ((< y 2)(setq z (* x 0.2)))
      ((< y 5)(setq z (* x 0.5)))
      ((< y 11)(setq z x))
    )
    (setq zmax (* (ceil (/ v z)) z))
    (if (= zmax v)(setq zmax (+ zmax z)))
    (return (list zmax z))
))

(defun routine1()
  (let ((span))
    (memo-dipclear)    ;clear all dipoles
    (memo-fitfit)      ;consecutive fit
    (memo-dipselect)   ;extract dipoles filled with criteria
    (setq span (XmTextGetString text-length))
    (XmTextSetString text-length "5")
    (change-length)
    (memo-extractepoch);extract epoch with dipoles
    (memo-save-png)    ;save consecutive epochs as PNG file
    (XmTextSetString text-length span)
    (change-length)
))

(defun routine2()
  (memo-dipselect-png) ;"extract dipoles with PNG
  (memo-extractepoch)  ;"extract epoch with dipoles
  (rename-png "a" "ep");a*.png -> ep*.png
)

(defun ruler-vector2(nrow ncol)
  (let ((mtx)(vecrow)(veccol))
    (setq vecrow (ruler-vector 0 (- nrow 1) nrow))
    (setq veccol (ruler-vector 0 (- ncol 1) ncol))
    (setq veccol (*(transpose veccol) nrow))
    (setq mtx (+ (* vecrow (make-matrix 1 ncol 1))
                 (* (make-matrix nrow 1 1) veccol)))
    (setq mtx (redimension mtx 1 (* nrow ncol)))
    (return mtx)
))

(defun ruler-vector3(nrow ncol)
  (let ((mtx))
    (if (and (> nrow 1)(> ncol 1))
      (setq mtx (+ (transpose (ruler-vector 0 (- nrow 1) nrow ncol))
                   (* (ruler-vector 0 (- ncol 1) ncol nrow) nrow)))
      (setq mtx (+ (ruler-vector 0 (- nrow 1) nrow ncol)
                   (* (ruler-vector 0 (- ncol 1) ncol nrow) nrow))) )
    (setq mtx (redimension mtx 1 (* nrow ncol)))
    (return mtx)
))

(defun scan-autoscale();;upper part of the plotter is hidden by the scrollbar
  (let ((val)(w)(vmax)(vmin)(amp)(k))
    (setq w (G-widget "scan"))
    (setq val (matrix-extent (resource (G-widget "mtx") :matrix)))
    (setq vmin (first val) vmax (second val))
    (setq amp (- vmax vmin))
    (setq amp (/ amp 2))
    (setq k (* amp 1e+13 1.25))
    (XmTextSetString text-scan (format nil "~0,0f" k))
    (change-scanscale)
    (set-resource w :offsets (make-matrix 8 1 1))
))

(defun scan-check()
  (let ((num)(mtx)(ncol)(xscale)(L nil)(n)(x)(K)(tt))
    (setq num (read-from-string (XmTextGetString text-peak)))
    (setq mtx (resource (G-widget "mtx") :matrix))
    (setq ncol (array-dimension mtx 1))
    (setq xscale (resource (G-widget "mtx") :x-scale))
    (dotimes (n ncol)
      (setq x (column n mtx))
      (setq x (matrix-extent x))
      (setq L (append L (list (second x)))))
    (setq K (reverse (sort L)))
    (setq x (nth num K))
    ;(setq tt (get-universal-time))
    (scan-check-fin3 L x xscale)
    ;(print (- (get-universal-time) tt))
))

(defun scan-check-fin3(L x xscale)
  (let ((str)(w)(mw)(mv)(fs)(tmin)(tmax)(n)(N)(t0)(mtx)(val)(R)(tt1)(tt2)(t1)(sns)(n0 nil)(t12))
    (manage form-memo)
    (setq w (G-widget "gra") mw (G-widget "mxwin"))
    (setq mv (G-widget "mxvcp"))
    (set-resource mv :mode "abs-max")
    (link w mw)(link mw mv) 
    (setq fs (/ 1 (resource w :x-scale))); xscale 0.5 fs 1000
    (setq tmin (/ (resource w :low-bound) fs)
          tmax (/ (resource w :high-bound) fs)); limitation of time
    (setq tmax (- tmax xscale))
    (setq N (length L))
    (dotimes (n N)     
      (unless (longworking "checking..." n N)(error "intgerrupted"))
      (if (>= (nth n L) x)(progn  ;; epoch > greater threshold
        (setq t0 (+ (* n xscale) tmin));; epoch is limitation of measured time
        (when (>= t0 tmax)(setq t0 tmax))
        (set-resource mw :point t0 :end xscale);; original epoch span 
        (setq mtx (get-data-matrix mv 0 (resource mv :high-bound)))
        (setq val (max-vector (row 0 mtx)))
        (setq tt1 (+ t0 (/ (second val) fs)))
        (setq t1 (- tt1 (/ xscale 2)))
        (when (< t1 tmin)(setq t1 tmin))
        (when (> t1 tmax)(setq t1 tmax))
        (set-resource mw :point t1 :end xscale);; peak +/- half epoch span
        (setq mtx (get-data-matrix mv 0 (resource mv :high-bound)))
        (setq val (max-vector (row 0 mtx)))
        (setq tt2 (+ t1 (/ (second val) fs)))
        (setq t12 (abs (- tt1 tt2)));;for rounding error
        (when (< t12 2e-3)(progn
          (setq sns (vref (row 1 mtx)(second val)))
          (setq sns (get-property w (round sns) :name))
          (setq R (list t1 xscale sns tt2 (* (first val) 1e+13)))
          (setq str (memo-line R))
          (if n0 (setq str (format nil "~%~a" str))(setq n0 t))
          (memo-insert str))))))
     (longworking "done" N N)    
     (link nil-pointer (G-widget "mxwin"))
))

(defun scan-data(step)
  (let ((w)(T0)(Tend)(STEP)(xscale)(t0)(n)(N)(T1)(tend)(str)(L nil)(tt))
    (setq w (G-widget "meg"))
    (setq xscale (resource w :x-scale))
    (setq T0   (resource w :low-bound))
    (setq Tend (resource w :high-bound))
    (setq STEP (round (/ step xscale)))
    (setq t0   (* T0   xscale))
    (setq tend (* Tend xscale))
    (setq N (round (/ (- Tend T0) STEP)))
    (dotimes (n 8)
      (require-widget :selector (format nil "GG~d" n)))
    (select-to (G-widget "GG0")(meg   0 -  25))
    (select-to (G-widget "GG1")(meg  25 -  51))
    (select-to (G-widget "GG2")(meg  52 -  77))
    (select-to (G-widget "GG3")(meg  78 - 103))
    (select-to (G-widget "GG4")(meg 104 - 127))
    (select-to (G-widget "GG5")(meg 128 - 151))
    (select-to (G-widget "GG6")(meg 152 - 177))
    (select-to (G-widget "GG7")(meg 178 - 203))
    (dotimes (n 8)
      (require-widget :vecop (format nil "GV~d" n)
        (list "mode" "abs-max")))
    ;(dotimes (n 8); it does not work properly!
    ;  (link (G-widget (format nil "GG~d" n))
    ;        (G-widget (format nll "GV~d" n)))) 
    (link (G-widget "GG0")(G-widget "GV0"))
    (link (G-widget "GG1")(G-widget "GV1"))
    (link (G-widget "GG2")(G-widget "GV2"))
    (link (G-widget "GG3")(G-widget "GV3"))
    (link (G-widget "GG4")(G-widget "GV4"))
    (link (G-widget "GG5")(G-widget "GV5"))
    (link (G-widget "GG6")(G-widget "GV6"))
    (link (G-widget "GG7")(G-widget "GV7"))
    ;(setq tt (get-universal-time))
    (dotimes (n N)
      (unless (longworking "scanning..." n N)(error "interrupted"))
      (setq T1 (+ T0 STEP))
      (if (> T1 Tend)(setq STEP (- Tend T0)))
      (setq L (append L (scan-data-core T0 STEP)))
      (setq t0 (+ t0 step))
      (setq T0 (round (/ t0 xscale))))
    (longworking "done" N N)
    (dotimes (n 8)
      (GtDeleteWidget (G-widget (format nil "GG~d" n)))
      (GtDeleteWidget (G-widget (format nil "GV~d" n))))
    (scan-plot (matrix L) step)
    (scan-autoscale)
    ;(print (- (get-universal-time) tt))
))

(defun scan-data-core(T0 STEP)
  (let ((L nil)(n)(str)(M)(x))
    (dotimes (n 8)
      (setq M (get-data-matrix (G-widget (format nil "GV~a" n)) T0 STEP))
      (setq x (second (matrix-extent (row 0 M))))
      (setq L (append L (list x))))
    (return (list L))
))

(defun scan-data-statistics()
  (let ((mtx)(n)(x)(xx nil)(nch nil)(vcp0)(src)(dsp))
    (setq nch (resource (G-widget "scan") :channels))
    (setq mtx (resource (G-widget "mtx") :matrix))
    (when (= nch 8)(progn
      (unless (G-widget "vcp0p" :quiet)
        (setq vcp0 (require-widget :vecop "vcp0" '("mode" "max"))))
      (link (G-widget "mtx") vcp0)
      (setq x (get-data-matrix vcp0 0 (resource vcp0 :high-bound)))
      (GtDeleteWidget vcp0)
      (setq x (map-matrix (row 0 x) #'* 1e+13))
      (dotimes (n (length x))
        (setq xx (append xx (list (vref x n)))))
      (setq xx (reverse (sort xx)))
      (setq mtx (matrix (list xx)))
      (unless (G-widget "stat-mtx" :quiet)
        (require-widget :matrix-source "stat-mtx"))
      (unless (G-widget "stat-dsp" :quiet)
        (require-widget :plotter "stat-dsp"))
      (setq src (G-widget "stat-mtx"))
      (setq dsp (G-widget "stat-dsp"))
      (set-resource src :matrix mtx)
      (link src dsp)
      (set-resource dsp :offsets #m((1)))
      (setq x (/ (first xx) 2))
      (set-resource dsp :scales (matrix (list (list x))))
      (set-resource dsp :point 0 :length 60 :tick-inteval 10)
      (GtPopupEditor dsp)
    ))
))

(defun scan-plot(mtx step)
  (let ((form)(M)(disp)(dispw)(x)(w))
    (if (G-widget "mtx" :quiet)(GtDeleteWidget (G-widget "mtx")))
    (setq M (require-widget :matrix-source "mtx"))
    (setq x (array-dimension mtx 0))
    (setq x (* x step))
    ;(setq y (second (matrix-extent mtx)))
    (set-resource M :matrix (transpose mtx) :x-scale step :x-unit "s")
    (setq w (G-widget "scan"))
    (set-resource w :superpose t)
    (link M w);; this must be here!
    (set-resource w :point 0 :length x)
))

(defun scan-select-hook(&optional (nn 0));0: scan 1:scan1
  (let ((w (G-widget "scan"))(b (G-widget "buf"))(t0)(span)(span2)(gap)(w1 nil))
    (if (G-widget "scan1" :quiet)(setq w1 (G-widget "scan1")))
    (case nn
      (1 (progn
        (setq t0   (resource w1 :selection-start))
        (setq span (resource w1 :selection-length))
        (set-resource w :selection-start  t0)
        (set-resource w :selection-length span)))
      (0 (progn
        (setq t0   (resource w :selection-start))
        (setq span (resource w :selection-length))
        (if w1
          (if (/= t0 (resource w1 :selection-start))
            (progn
              (set-resource w1 :selection-start  t0)
              (set-resource w1 :selection-length span))))))
    )
    (setq span2 (read-from-string (XmTextGetString text-length)))
    (setq t0 (- (+ t0 (/ span 2))(/ span2 2)))
    (setq gap (* (resource b :low-bound)(resource b :x-scale)))
    (setq t0 (+ t0 gap))
    (XmTextSetString text-start (format nil "~0,2f" t0))
    (change-start)
    (if (> span 0)(scan-select-max))
))

(defun scan-select-max()
  (let ((mtx)(w)(t0)(span)(xcale)(ch)(str)(chname))
    (setq w (G-widget "scan"))
    (setq t0   (resource w :selection-start))
    (setq span (resource w :selection-length))
    (if (> span 0)(progn
      (setq xscale (resource w :x-scale))
      (setq t0 (round (/ t0 xscale)))
      (setq span (round (/ span xscale)))
      (setq mtx (get-data-matrix w t0 span))
      (setq ch (second (max-matrix mtx)))
      (case ch
        (0 (setq str "L-temporal"))
        (1 (setq str "R-temporal"))
        (2 (setq str "L-parietal"))
        (3 (setq str "R-parietal"))
        (4 (setq str "L-occipital"))
        (5 (setq str "R-occipital"))
        (6 (setq str "L-frontal"))
        (7 (setq str "R-frontal"))
      )
      (setq chname (get-property (G-widget "disp001") 0 :name))
      (if (string-equal chname (string-right-trim "1" chname))
        (setq str (format nil "gra-~a" str))
        (setq str (format nil "mag-~a" str)))
      (change-megsel str)))
))

(defun scan1-plot()
  (let ((w0)(w1)(w2)(w3)(n)(names)(mtx))
    (unless (G-widget "scan1" :quiet)(require-widget :plotter "scan1"))
    (unless (G-widget "fmul" :quiet)(require-widget :unary "fmul"))
    (setq w0 (G-widget "mtx"))
    (setq w1 (G-widget "scan"))
    (setq w2 (G-widget "fmul"))
    (set-resource w2 :function 'fmul :arguments '(1e+13))
    (setq w3 (G-widget "scan1"))
    (link w0 w2)
    (link w2 w3)
    (setq names (list "L-temporal" "R-temporal" "L-parietal" "R-parietal" "L-occipital" "R-occipital" "L-frontal" "R-frontal"))
    (dotimes (n 8)
      (set-property w0 n :name (nth n names)))
    (set-resource w3 :ch-label-space 120)
    (setq names (list :point :length :default-color :background :highlight :baseline-color))
    (dolist (n names)
      (set-resource w3 n (resource w1 n)))
    (setq n (matrix-extent (resource w0 :matrix)))
    (setq n (* (second n) 1e+13))
    (set-resource w3 :scales (make-matrix 8 1 n)
                     :offsets (make-matrix 8 1 0.5)
                     :select-hook '(scan-select-hook 1))
    (GtPopupEditor w3)
))

(defun screen-capture(&optional (disp form000))
  (let ((id)(str))
     (if (G-widget-p disp)(progn
        (GtPopupEditor disp)
        (setq disp (resource disp :display-widget))))
     (setq str (get-datetime))
     (setq id (window-id (XtWindow disp)))
     (system (format nil "xwd -id ~a >~a.xwd" id str))
     (system (format nil "convert ~a.xwd ~a.png" str str))
     (system (format nil "rm ~a.xwd" str))
))

(defun set-button-noedge(btn)
  (set-values btn :shadowThickness 0 :detailShadowThickness 0 
    :background (rgb 240 240 240)))
)

(defun set-default()
  ;; execute after load a fif file
  (let ((bund)(smp)(t0)(n)(disp))
    (setq bnd (resource (G-widget "buf") :low-bound))
    (setq smp (resource (G-widget "buf") :x-scale))
    (setq t0 (* bnd smp))
    (XmTextSetString text-start  (format nil "~0,2f" t0))
    (XmTextSetString text-length (format nil "~0,2f" 10.00))
    (dotimes (n 10)
      (setq disp (format nil "disp00~a" n))
      (if (G-widget disp :quiet)(progn
        (set-resource (G-widget disp):point t0 :length 10)
      )))
    (layout1gra)
    (case MEGsite
      (1 (EEGHiroshima 1))
      (2 (EEGCleaveland 1))
    )
    (set-resource (G-widget "disp009") :ch-label-space 80)
    (add-sync)
))

(defun set-near-coil(ch);;under construction
  (let ((w (G-widget "meg2"))(nch)(str)(text sns-num)(n)(m)(sns)(snss nil)(str "MEG["))
    (setq ch (read-from-string (string-trim "MEG " ch)))
    (setq ch (round (floor (/ ch 10))))
    (setq nch (read-from-string (XmTextGetString text)))
    (setq nch (round nch))
    (if (> nch 102)(setq nch 30))
    (if (< nch 4)(setq nch 30))
    (XmTextSetString text (format nil "~a" nch))
    (dotimes (n (length near-coil))
      (if (= ch (first (nth n near-coil)))(setq sns (nth n near-coil))))
    (dotimes (m nch)
      (setq snss (append snss (list (nth m sns)))))
    (dotimes (m nch)
      (setq n (nth m snss))
      (setq str (format nil "~a ~a1 ~a2 ~a3" str n n n)))
    (setq str (format nil "~a]" str));
    (set-resource w :names (list str))
))

(defun setframe001()
  (let ((n)(form)(pane)(form1)(form2)(form3)(form4))
    (setq form (make-form frame001 "form"))
    (setq pane (XmCreatePanedWindow form "pane" (X-arglist) 0))
    (set-values pane :separatorOn 0 :sasIndent -1 :resize 1
      :topAttachment  XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_FORM :rightAttachment  XmATTACH_FORM)
    (setq form1 (make-form pane "form1"))
    (setq form2 (make-form pane "form2"))
    (setq form3 (make-form pane "form3"))
    (setq form4 (make-form pane "form4"))

    (dolist (n (list form1 form2 form3 form4 pane))(manage n))
    ; Start & length
    (setframe001-time form1)
 
    ;; MEG
    (setframe001-meg form2)

    ;;EEG etc
    (setframe001-eeg form3)
    (setq EEGmenuform form3)

    ;; plot
    (setframe001-plot form4)

    ;; finish
    (dolist (n (list form))(manage n))
 
    ;(set-values frame1 :width 200);; <=important!
    (XmTextSetString text-start  "0.00")
    (XmTextSetString text-length "10.00")
    (XmTextSetString text-gra    "500")
    (XmTextSetString text-mag    "2500") 
    (XmTextSetString text-megfil "(band-pass 3 35)")
    (XmTextSetString text-eeg    "60")
    (XmTextSetString text-ecg    "300")
    (XmTextSetString text-eog    "100")
    (XmTextSetString text-emg    "500")
    (XmTextSetString text-eegfil "(band-pass 0.5 50)")
    (text-callback)
))

(defun setframe001-eeg(form)
  (let ((text1)(text2)(text3)(text4)(text5)(R)(menubar)(text4)(menu))
    (setq text1 (make-text form "text1" :topAttachment XmATTACH_FORM 
      :rightAttachment XmATTACH_FORM :width 70))
    (setq text2 (make-text form "text2" :topAttachment XmATTACH_WIDGET 
      :topWidget text1 :leftAttachment XmATTACH_FORM :width 170))
    (setq label2 (make-label form "label2" :topAttachment   XmATTACH_WIDGET 
      :topWidget text1 :labelString (XmString "Hz") :topOffset 10 
      :leftAttachment  XmATTACH_WIDGET :leftWidget text2))
    (setq text3 (make-text form "text3" :topAttachment XmATTACH_WIDGET 
      :topWidget text1 :rightAttachment XmATTACH_FORM :width 70))
    (setq text4 (make-text form "text4" :topAttachment XmATTACH_WIDGET 
      :topWidget text3 :rightAttachment XmATTACH_FORM :width 70))    
    (setq text5 (make-text form "text5" :topAttachment XmATTACH_WIDGET 
      :topWidget text4 :rightAttachment XmATTACH_FORM :width 70))      
    (dolist (n (list text1 text3 text4 text5))(manage n));;text2 label2 are deleted
    (setq text-eeg text1)   ;;global variant
    (setq text-eegfil text2);;global variant
    (setq text-ecg text3)   ;;global variant
    (setq text-eog text4)   ;;global variant
    (setq text-emg text5)   ;;global variant
    (setq R (add-arrows form text1 ""))
    (set-lisp-callback (first   R) "activateCallback" '(UpDownText text-eeg  1))
    (set-lisp-callback (second  R) "activateCallback" '(UpDownText text-eeg -1))    (dolist (n R)(manage n))
    (setq menubar (make-menu-bar form "menubar"
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text1
      :rightAttachment XmATTACH_WIDGET :rightWidget text1
      :detailShadowThickness 0 :shadowThickness 0))
    (setq menu (make-menu menubar "EEG   uV" nil :tear-off
      '("banana leads" (EEGlead1)) )) ;; this is replaced later
    (manage menubar); unnecessory (manage menu)
    (setq EEGmenubar menubar)

    (setq R (add-arrows form text3 ""))
    (setq menubar (make-menu-bar form "menubar"
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text3
      :rightAttachment XmATTACH_WIDGET :rightWidget text3
      :detailShadowThickness 0 :shadowThickness 0))
    (setq menu (make-menu menubar "ECG   uV" nil 
      '("auto scale" (autoscale "ECG"))
      '("filter" (GtPopupEditor (G-widget "ECG-fil")))))
    (manage menubar)
    (set-lisp-callback (first   R) "activateCallback" '(UpDownText text-ecg  1))
    (set-lisp-callback (second  R) "activateCallback" '(UpDownText text-ecg -1))
    (dolist (n R)(manage n))

    (setq R (add-arrows form text4 ""))
    (setq menubar (make-menu-bar form "menubar"
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text4
      :rightAttachment XmATTACH_WIDGET :rightWidget text4
      :detailShadowThickness 0 :shadowThickness 0))
    (setq menu (make-menu menubar "EOG   uV" nil 
      '("auto scale" (autoscale "EOG"))
      '("filter" (GtPopupEditor (G-widget "EOG-fil")))))
    (manage menubar)
    (set-lisp-callback (first   R) "activateCallback" '(UpDownText text-eog  1))
    (set-lisp-callback (second  R) "activateCallback" '(UpDownText text-eog -1))
    (dolist (n R)(manage n))

    (setq R (add-arrows form text5 ""))
    (setq menubar (make-menu-bar form "menubar"
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text5
      :rightAttachment XmATTACH_WIDGET :rightWidget text5
      :detailShadowThickness 0 :shadowThickness 0))
    (setq menu (make-menu menubar "EMG   uV" nil 
      '("auto scale" (autoscale "EMG"))
      '("filter" (GtPopupEditor (G-widget "EMG-fil")))))
    (manage menubar)    
    (set-lisp-callback (first   R) "activateCallback" '(UpDownText text-emg  1))
    (set-lisp-callback (second  R) "activateCallback" '(UpDownText text-emg -1))
    (dolist (n R)(manage n))
))

(defun setframe001-meg(form)
  (let ((text1)(text2)(rb)(text3)(label)(R))
    (setq text1 (make-text form "text1" :topAttachment XmATTACH_FORM 
      :rightAttachment XmATTACH_FORM :width 70))
    (setq text2 (make-text form "text2" :topAttachment XmATTACH_WIDGET 
      :topWidget text1
       :rightAttachment XmATTACH_FORM :width 70))
    (setq rb (XmCreateRadioBox form "rb" (X-arglist) 0))
    (set-values rb :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM)
    (setq gra204 (XmCreateToggleButtonGadget rb "gra204" (X-arglist) 0));;global variant
    (set-values gra204 :labelString (XmString "GRA  fT/cm") :set 1)
    (setq mag102 (XmCreateToggleButtonGadget rb "mag102" (X-arglist) 0));;global variant
    (set-values mag102 :labelString (XmString "MAG   fT") :set 0)
    (setq text3 (make-text form "text3" :topAttachment XmATTACH_WIDGET :topWidget text2
      :leftAttachment XmATTACH_FORM :width 170))
    (setq label (make-label form "label" :topAttachment XmATTACH_WIDGET :topWidget text2 :topOffset 10
     :rightAttachment XmATTACH_FORM :labelString (XmString "Hz")))
    (dolist (n (list text1 text2 gra204 mag102 rb text3 label))(manage n))
    (setq text-gra text1)   ;;global variant
    (setq text-mag text2)   ;;global variant
    (setq text-megfil text3);;global variant
    (setq R (add-arrows form text1 ""))
    (set-lisp-callback (first   R) "activateCallback" '(UpDownText text-gra  1))
    (set-lisp-callback (second  R) "activateCallback" '(UpDownText text-gra -1))  
    (dolist (n R)(manage n))
    (setq R (add-arrows form text2 ""))
    (set-lisp-callback (first   R) "activateCallback" '(UpDownText text-mag  1))
    (set-lisp-callback (second  R) "activateCallback" '(UpDownText text-mag -1))  
    (dolist (n R)(manage n))
))


(defun setframe001-plot(form0)
  (let ((form)(disp)(dispw)(label1)(btn)(form1)(arrow1)(arrow2)(arrow3)(arrow4)(n)(rb)(tb1)(tb2)(n)(rb1)(tb3)(tb4)(tb5)(rb2))
    (setq btn-xfit (make-button form0 "xfit condition" :height (* 20 5)
      :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM))
    (set-lisp-callback btn-xfit "activateCallback" '(manage form-xfit))
    (manage btn-xfit);;global variant
    (setq frame (make-frame form0 "frame" :topAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn-xfit))
    (set-values frame :height 250)
    (setq form (make-form frame "form"))

    (setq label1 (make-label frame "label1" :childType XmFRAME_TITLE_CHILD
      :labelString (XmString "Gra 204ch")))
    (manage label1)
    (setq form (make-form frame "form" :height 250 :resize 0))

    (setq arrow1 (XmCreateArrowButton form "arrow1" (X-arglist) 0))   
    (set-values arrow1 :leftAttachment XmATTACH_FORM 
      :bottomAttachment XmATTACH_FORM
      :arrowDirection XmARROW_UP :shadowTickness 0 
      :detailShadowThickness 0 :width 15)
    (setq arrow2 (XmCreateArrowButton form "arrow2" (X-arglist) 0))
    (set-values arrow2 :leftAttachment XmATTACH_WIDGET :leftWidget arrow1 
      :bottomAttachment XmATTACH_FORM
      :arrowDirection XmARROW_DOWN :shadowThickness 0 
      :detailShadowThickness 0 :width 15)
    (setq arrow3 (XmCreateArrowButton form "arrow3" (X-arglist) 0))
    (set-values arrow3 :leftAttachment XmATTACH_WIDGET :leftWidget arrow2 
      :bottomAttachment XmATTACH_FORM
      :arrowDirection XmARROW_LEFT :shadowThickness 0 
      :detailShadowThickness 0 :width 15)
    (setq arrow4 (XmCreateArrowButton form "arrow4" (X-arglist) 0))
    (set-values arrow4 :leftAttachment XmATTACH_WIDGET :leftWidget arrow3 
      :bottomAttachment XmATTACH_FORM
      :arrowDirection XmARROW_RIGHT :shadowThickness 0 
      :detailShadowThickness 0 :width 15)
    (dolist (n (list arrow1 arrow2 arrow3 arrow4))
      (set-values n :shadowThickness 0 :detaileShadowThickness 0
       :foreground (rgb 0 100 0)))
    (set-lisp-callback arrow1 "activateCallback" '(change-grascale000 -1))
    (set-lisp-callback arrow2 "activateCallback" '(change-grascale000 1))
    (set-lisp-callback arrow3 "activateCallback" '(change-start000 -1))
    (set-lisp-callback arrow4 "activateCallback" '(change-start000 1))
    (setq btn (make-button form "btn" :labelString (XmString "fit --")
      :leftAttachment XmATTACH_WIDGET :leftWidget arrow4
      :rightAttachment XmATTACH_FORM 
      :bottomAttachment XmATTACH_FORM))
    (dolist (n (list arrow1 arrow2 arrow3 arrow4 btn))
      (manage n))
    (if (G-widget "000" :quiet)(GtDeleteWidget (G-widget "000")))
    (setq disp (GtMakeObject 'plotter :name "000" :display-parent form 
      :scroll-parent form :no-controls t))
    (put disp :display-form form)
    (GtPopupEditor disp)
    (setq dispw (resource (G-widget disp) :display-widget))
    (set-values dispw :resize 0
      :topAttachment XmATTACH_FORM :bottomAttachment XmATTACH_WIDGET :bottomWidget arrow1
      :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM)
    (manage form)(manage frame)
    (set-resource (G-widget "000") :superpose t :select-hook '(findmax000))
    (link (G-widget "win000")(G-widget "000"))
    (set-values frame001 :width 200)
    (set-lisp-callback btn "activateCallback" '(fit000))
    (setq label-gra000 label1);global variant
    (setq fit-button btn);global variant
    (setq meg306 t);global variant
    (set-values form :resize 0)
    (set-values btn :resize 0)
    (setq form-plot form);global variant
))

(defun setframe001-time(form)
  (let ((label1)(btn)(label2)(label3)(text1)(text2)(n))
    ;(setq form (make-form frame "form"))
    (setq label1 (make-label form "label1" :topAttachment XmATTACH_FORM 
      :leftAttachment XmATTACH_FORM
      ;:labelString (XmString "  Start       &       length")))
      :labelString (XmString " Start & length")))
    (setq btn (make-button form "btn" :labelString (XmString "redraw")
      :rightAttachment XmATTACH_FORM :topAttachment XmATTACH_FORM))
    (set-button-noedge btn)
    (setq btn1 (make-button form "btn1" :labelString (XmString "ssp")
      :rightAttachment XmATTACH_WIDGET :rightWidget btn
      :rightOffset 10 :topAttachment XmATTACH_FORM))
    (set-button-noedge btn1)
    (set-lisp-callback btn "activateCallback" '(change-layout 0))
    (set-lisp-callback btn1 "activateCallback" '(setSSP))
    (setq text1 (make-text form "text1" :topAttachment XmATTACH_WIDGET 
      :topWidget label1 :leftAttchment   XmATTACH_FORM :width 70))
    (setq label2 (make-label form "label2" :topAttachment XmATTACH_WIDGET
      :topWidget label1 :leftAttachment XmATTACH_FORM
      :leftOffset 70 :topOffset 10 :labelString (XmString "s")))
    (setq label3 (make-label form "label3" :topAttachment XmATTACH_WIDGET
      :topWidget label1 :rightAttachment XmATTACH_FORM :rightOffset 10
      :topOffset 10 :labelString (XmString "s")))
    (setq text2 (make-text form "text2" :topAttachment XmATTACH_WIDGET 
      :topWidget label1  :rightAttachment XmATTACH_WIDGET 
      :rightWidget label3 :width 70))
    (dolist (n (list label1 btn btn1 text1 label2 label3 text2))(manage n))
    (setq text-start text1)  ;;global variant
    (setq text-length text2) ;;global variant
))

(defun setframe002()
  (let ((form)(frame1)(frame2)(n))
    (setq form  (make-form frame002 "form"))
    (setq frame1 (make-frame form "frame1" 
      :topAttacment    XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM :width 200 :height 60))
    (setframe002-scan frame1)
    (manage frame1)
    (setq frame2 (make-frame form "frame2"
      :topAttachment   XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :leftAttachment  XmATTACH_FORM :shadowThickness 0
      :rightAttachment XmATTACH_WIDGET :rightWidget frame1))
    (manage frame2)
    (setframe002-plot frame2)
    (manage form)
))

(defun setframe002-plot(frame)
  (let ((form)(disp)(dispw))
    (setq form (make-form frame "form"))
    (manage form)
    (setq disp (GtMakeObject 'plotter :name "scan" :display-parent form
      :scroll-parent form :no-controls t))
    (put disp :display-form form)
    (GtPopupEditor disp)
    (setq dispw (resource disp :display-widget))
    (set-values dispw :resize 1
      :topAttachment   XmATTACH_FORM :leftAttachment   XmATTACH_FORM
      :rightAttachment XmATTACH_FORM :bottomAttachment XmATTACH_FORM)
    (set-resource disp :scroll-visible 0 :x-unit "s"
      :offsets (make-matrix 8 1 0.9)
      :select-hook '(scan-select-hook))
    (change-scanscale)
))

(defun setframe002-scan(frame)
  (let ((form)(text1)(text2)(R)(ar1)(ar2)(ar3)(ar4)(btn1)(btn2)(btn3)(n))
    (setq form (make-form frame "form" :height 60 :width 200))
    (setq label (make-label form "label" :labelString (XmString "peaks")
      :rightAttachment XmATTACH_FORM :topAttachment XmATTACH_FORM
      :topOffset 5 :rightOffset 10))
    (setq text1 (make-text form "text1" :rightAttachment XmATTACH_WIDGET
      :rightWidget label :rightOffset 10 :topAttachment XmATTACH_FORM
      :width 40))
    (XmTextSetString text1 "50")
    (setq btn1 (make-button form "btn1" :labelString (XmString "scan")
      :rightAttachment  XmATTACH_FORM :width 60
      :topAttachment    XmATTACH_WIDGET :topWidget text1
      :bottomAttchment  XmATTACH_FORM))
    (set-button-noedge btn1)
    (setq btn2 (make-button form "btn2" :labelString (XmString "check")
      :rightAttachment   XmATTACH_WIDGET :rightWidget btn1
      :topAttachment    XmATTACH_WIDGET  :topWidget text1
      :bottomAttachment XmATTACH_FORM :rightOffset 10 :width 60))
    (set-button-noedge btn2)
    (setq btn3 (make-button form "btn3" :labelString (XmString "8 waves")
      :leftAttachment   XmATTACH_FORM 
      :topAttachment    XmATTACH_WIDGET  :topWidget text1
      :bottomAttachment XmATTACH_FORM :width 60))
    (set-button-noedge btn3)
    (setq text2 (make-text form "text2" :width 70 
      :topAttachment    XmATTACH_FORM 
      :leftAttachment   XmATTACH_FORM))
    (XmTextSetString text2 "500")
    (setq R (add-arrows form text2 ""))
    (setq ar1 (first R) ar2 (second R))
    (setq ar3 (XmCreateArrowButton form "arrow3" (X-arglist) 0))
    (setq ar4 (XmCreateArrowButton form "arrow4" (X-arglist) 0))
    (set-values ar3 :leftAttachment XmATTACH_FORM :leftOffset 65
      :topAttachment    XmATTACH_WIDGET :topWidget text2 
      :shadowThickness 0 :detailShadowThickness 0 :foreground (rgb 0 0 150)
      :arrowDirection XmARROW_UP :width 15)
    (set-values ar4 :leftAttachment XmATTACH_FORM :leftOffset 80
      :topAttachment    XmATTACH_WIDGET :topWidget text2 
      :shadowThickness 0 :detailShadowThickness 0 :foreground (rgb 0 0 150)
      :arrowDirection XmARROW_DOWN :width 15)    
    (setq text-scan text2)
    (set-lisp-callback text-scan "activateCallback" '(change-scanscale))
    (setq text-peak text1)
    (set-lisp-callback btn1 "activateCallback" '(scan-data 0.5))    
    (set-lisp-callback btn2 "activateCallback" '(scan-check))
    (set-lisp-callback btn3 "activateCallback" '(scan1-plot))
    (set-lisp-callback ar1  "activateCallback" '(UpDownText text-scan  1))
    (set-lisp-callback ar2  "activateCallback" '(UpDownText text-scan -1))  
    (set-lisp-callback ar3  "activateCallback" '(change-offsets -0.1))
    (set-lisp-callback ar4  "activateCallback" '(change-offsets  0.1))
    (dolist (n (list label text1 text2 ar1 ar2 ar3 ar4 btn1 btn2 btn3 form))(manage n))))
))

(defun setSSP()
  (let ((filename (resource (G-widget "file") :filename)))
    (if (not (string-equal (filename-extension filename) "fif"))
      (setq filename "/neuro/dacq/setup/ssp/online-0.fif"))
    (graph::ssp-popup)
    (graph::ssp-load-file filename)
    (setq graph::ssp-vectors graph::ssp-vector-pool)
    (graph::ssp-rebuild-space)
    (graph::ssp-on)
))

(defun sort(xlist)
  (let ((N0 (length xlist))(N1)(xx nil)(xmin)(R nil))
    (dolist (i xlist)(setq xx (append xx (list i))));; We must duplicate xlist
    (while (> N0 0)
      (setq xmin (apply #'min xx))
      (setq xx (delete xmin xx))
      (setq N1 (length xx))
      (dotimes (i (- N0 N1))
        (setq R (append R (list xmin))))
      (setq N0 N1))
    (return R)
))

(defun sort2(xlist)
  (let ((N)(xmin)(x nil)(xx nil))
    (dotimes (i (length xlist))(setq xx (append xx (list (nth i xlist)))))
    (setq N (length xx))
    (while (> N 0)
      (setq xmin (apply #'min xx))
      (setq xx (delete xmin xx))
      (setq N (length xx))
      (setq x (append x (list xmin))))
    (return x)
))

(defun sort-order(xlist)
  (let ((xx (sort2 xlist))(x nil)(R nil))
    (dotimes (i (length xx) R)
      (setq x (nth i xx))
      (dotimes (j (length xlist))
        (if (equal x (nth j xlist))(setq R (append R (list j))))))
    (return R)
))

(defun sync-move-hook(w)
  (let ((n)(t0)(span)(disp))
  (setq t0   (resource w :point))
  (setq span (resource w :length))
  (setq t0   (format nil "~0,2f" t0))
  (setq span (format nil "~0,2f" span))
  (XmTextSetString text-start t0)
  (XmTextSetString text-length span)
  (setq t0 (read-from-string t0))
  (setq span (read-from-string span))
  (dotimes (n 10)
    (setq disp (format nil "disp00~a" n))
    (if (G-widget disp :quiet)
      (set-resource (G-widget disp) :point t0 :length span)))
  (GtUnlinkWidget (G-widget "win000"))
))

(defun sync-select-hook(w)
  (let ((n)(t0)(span)(disp)(win)(plot)(nch)(t1))
    (setq win (G-widget "win000"))
    (setq plot (G-widget "000"))
    (setq t0   (resource w :selection-start))
    (setq span (resource w :selection-length))
    (GtUnlinkWidget win);;necessary! important
    (set-resource win  :point t0 :end span)
    (set-resource plot :point t0 :length span)
    (dotimes (n 10)
      (setq disp (format nil "disp00~a" n))
      (if (G-widget disp :quiet)
        (set-resource (G-widget disp) 
          :selection-start t0 :selection-length span)))
    (setq nch (resource plot :channels))
    (link (G-widget "gra") win)
    (link win plot)
    (if (> span 0)(progn (sync-select-scale)
      (set-values label-gra000 :labelString 
        (XmString (format nil "Gra ~0,1f ~~ ~0,1f(s)" t0 (+ t0 span)))))
      (set-values label-gra000 :labelString (XmString "Gra 204ch")))
    ;(set-resource plot :scales (make-matrix 204 1 (* (get-grascale) 2)))
    ;(if (= (resource (G-widget "scan"):channels) 8)
    ;  (progn (setq t1 (+ t0 (/ span 2)))
    ;         (set-resource (G-widget "scan") :selection-start t1)
    ;         (set-resource (G-widget "scan") :selection-length 0.0)))
)) 

(defun sync-select-scale()
  (let ((w)(d)(mtx)(x))
    (setq w (G-widget "win000"))
    (setq d (G-widget "000"))
    (setq mtx (get-data-matrix w 
      (resource w :low-bound)(resource w :high-bound)))
    (setq x (matrix-extent mtx))
    (setq x (max (abs (first x))(abs (second x))))
    (set-resource d :scales (make-matrix 204 1 x))
))

(defun text-callback()
  (set-lisp-callback text-gra    "activateCallback" '(change-grascale))
  (set-lisp-callback text-mag    "activateCallback" '(change-magscale))
  (set-lisp-callback text-megfil "activateCallback" '(set-resource (G-widget "MEG-fil") 
    :pass-band (read-from-string (XmTextGetString text-megfil))))
  (set-lisp-callback text-start  "activateCallback" '(change-start))   
  (set-lisp-callback text-length "activateCallback" '(change-length))
  (set-lisp-callback gra204      "valueChangedCallback" '(layout-meg 0))
  (set-lisp-callback mag102      "valueChangedCallback" '(layout-meg 1)) 
  (set-lisp-callback text-eeg    "activateCallback" '(change-eegscale))
  (set-lisp-callback text-ecg    "activateCallback" '(change-eegscale))
  (set-lisp-callback text-eog    "activateCallback" '(change-eegscale))  
  (set-lisp-callback text-emg    "activateCallback" '(change-eegscale))
  (set-lisp-callback text-eegfil "activateCallback" '(set-resource (G-widget "EEG-fil") 
    :pass-band (read-from-string (XmTextGetString text-eegfil))))
)

(defun UpDownText(text val)
  (let ((x)(xx)(n1)(n2)(str))
    (setq x (read-from-string (XmTextGetString text)))
    (setq xx (pow 0.8 val))
    (setq str (format nil "~0,0f" (* x xx)))
    (XmTextSetString text str))
    (cond
      ((eq text text-gra)(change-grascale))
      ((eq text text-mag)(change-magscale))
      ((eq text text-eeg)(change-eegscale))
      ((eq text text-ecg)(change-eegscale))
      ((eq text text-emg)(change-eegscale))
      ((eq text text-eog)(change-eegscale))
      ((eq text text-scan)(change-scanscale))
    )
))

(defun UpDownTextPower(text val)
  (let ((x)(xx)(n1)(n2)(str))
    (setq x (read-from-string (XmTextGetString text)))
    (setq xx (pow 0.8 val))
    (setq x (* x xx))
    (setq n1 (round (floor (log10 x))))
    (setq n2 (/ x (pow 10 n1)))
    (setq str (format nil "~0,2fe~a" n2 n1))
    (XmTextSetString text str))
    (cond
      ((eq text text-gra)(change-grascale))
      ((eq text text-mag)(change-magscale))
      ((eq text text-eeg)(change-eegscale))
      ((eq text text-ecg)(change-eegscale))
      ((eq text text-emg)(change-eegscale))
      ((eq text text-eog)(change-eegscale))
      ((eq text text-scan)(change-scanscale))
    )
))

(defun which-gra8(sns)
  (let ((n)(nn nil)(str))
    (dotimes (n 204)
      (if (string-equal sns (get-property (G-widget "gra") n :name))
        (setq nn n)))
    (cond 
      ((< nn  26)(setq str "gra-L-temporal"))
      ((< nn  52)(setq str "gra-R-temporal"))
      ((< nn  78)(setq str "gra-L-parietal"))
      ((< nn 104)(setq str "gra-R-parietal"))
      ((< nn 128)(setq str "gra-L-occipital"))
      ((< nn 152)(setq str "gra-R-occipital"))
      ((< nn 178)(setq str "gra-L-frontal"))
      ((< nn 204)(setq str "gra-R-frontal"))
    )
    (return str)
))

(if (G-widget "display" :quiet)
  (GtDeleteWidget (G-widget "display"))
  (XmjkDone)
)

(create-launch)


