;;   hns_meg  for epilepsy analysis
;;   
;;   Coding since 2024-April... by Akira Hashizume
;;   Releaesd on 2024-May 6th
;;
;;  /opt/neuromag/setup/cliplab/Deflayouts.xxx should be devised for comfortable use.
;;  This hns_meg4.lsp is uploaded in GitHub 
;;  /https:github.com/Fiff2Mat/mjkLISP/

(require 'ssp)
(require 'xfit) ;;this must be here
(xfit)          ;;this must be here
;(require 'xplotter)
;(xplotter)

(defun add-parameter(top left)
  (let ((n)(frame001)(frame002)(frame001-label)(frame002-label)(radiobox002)(label101)(frame003)(frame003-label)(dispw)(disp)(form002)(form003))
    (setq pane001 (XmCreatePanedWindow form001 "pane001" (X-arglist) 0))
    (set-values pane001 :separatorOn 0 :sasIndent -1
     :topAttachment    XmATTACH_POSITION :topPosition top
     :bottomAttachment XmATTACH_FORM
     :leftAttachment   XmATTACH_POSITION :leftPosition left
     :rightAttachment  XmATTACH_FORM)
    (setq frame001 (make-frame pane001 "frame001"))
    (setq frame001-label (make-label frame001 "frame001-label" 
      :labelString (XmString "channels scales bandpass") :childType XmFRAME_TITLE_CHILD))
    (setq form002 (make-form frame001 "form002"))
    (setq frame002 (make-frame pane001 "frame002"))
    (setq frame002-label (make-label frame002 "frame002-label" 
      :labelString (XmString "others") :childType XmFRAME_TITLE_CHILD))   
    (setq form003 (make-form frame002 "form003"))
    (setq frame003 (make-frame pane001 "frame003"))
    (setq frame003-label (make-label frame003 "frame003-label" 
      :labelString (XmString "check GRA waves") :childType XmFRAME_TITLE_CHILD))   
    (setq form004 (make-form frame003 "form004"))    
    (dolist (n (list pane001 frame001 frame001-label frame002 frame002-label form002 form003 frame003 frame003-label form004))(manage n))

    (add-parameter2 form002);;MEG
    (add-parameter3 form002);;EEG/ECG/EOG
    (add-parameter4 form003);;others
    (add-parameter5 form004);;wave-check
  )
)

(defun add-parameter2(form002);;channels scales bandpass MEG
  (let ((label001)(label002)(radiobox001)(label003))
    (setq text001 (make-text form002 "text001" :columns 6
      :topAttachment   XmATTACH_POSITION :topPosition    0
      :rightAttachment XmATTACH_POSITION :rightPosition 50))
    (setq label001 (make-label form002 "label001" :labelString (XmString "Start")
      :topAttachment   XmATTACH_POSITION :topPosition    0
      :rightAttachment XmATTACH_WIDGET   :rightWidget text001))
    (setq text002 (make-text form002 "text002" :columns 6
      :topAttachment   XmATTACH_POSITION :topPosition    0
      :rightAttachment XmATTACH_POSITION :rightPosition 100))
    (setq label002 (make-label form002 "label002" :labelString (XmString "length")
      :topAttachment   XmATTACH_POSITION :topPosition    0
      :rightAttachment XmATTACH_WIDGET   :rightWidget text002))
    (setq radiobox001 (XmCreateRadioBox form002 "radiobox001" (X-arglist) 0))
    (set-values radiobox001 :topAttachment  XmATTACH_WIDGET 
      :topWidget text001  :leftAttachment XmATTACH_FORM )
    (setq gra204 (XmCreateToggleButtonGadget radiobox001 "gra204" (X-arglist) 0))
    (set-values gra204 :labelString (XmString "gradiometer") :set 1)
    (setq mag102 (XmCreateToggleButtonGadget radiobox001 "mag102" (X-arglist) 0))
    (set-values mag102 :labelString (XmString "magnetometer") :set 0)
    (setq text003 (make-text form002 "text003" :columns 10
      :topAttachment   XmATTACH_WIDGET   :topWidget text002
      :rightAttachment XmATTACH_POSITION :rightPosition 100))
    (setq text004 (make-text form002 "text004" :columns 10
      :topAttachment   XmATTACH_WIDGET   :topWidget text003
      :rightAttachment XmATTACH_POSITION :rightPosition 100))
    (setq text005 (make-text form002 "text004" :columns 17
      :topAttachment   XmATTACH_WIDGET   :topWidget text004
      :rightAttachment XmATTACH_POSITION :rightPosition 100
      :background (rgb-color 250 230 230)))
    (setq label003 (make-label form002 "label003" :labelString (XmString "MEG[Hz]")
      :topAttachment   XmATTACH_WIDGET    :topWidget text004
      :rightAttachment XmATTACH_WIDGET    :rightWidget text005))
    (dolist (n (list text001 label001 text002 label002 radiobox001 gra204 mag102 text003 text004 text005 label003))(manage n))
  )
)

(defun add-parameter3(form002);;channels scales bandpass EEG
  (let ((label004)(label005)(label006)(label007)(radiobox002))
    (setq text006 (make-text form002 "text006" :columns 10
      :topAttachment   XmATTACH_WIDGET   :topWidget text005
      :rightAttachment XmATTACH_POSITION :rightPosition 100))
    (setq text007 (make-text form002 "text006" :columns 10
      :topAttachment   XmATTACH_WIDGET   :topWidget text006
      :rightAttachment XmATTACH_POSITION :rightPosition 100))
    (setq text008 (make-text form002 "text006" :columns 10
      :topAttachment   XmATTACH_WIDGET   :topWidget text007
      :rightAttachment XmATTACH_POSITION :rightPosition 100))    
    (setq text009 (make-text form002 "text009" :columns 17
      :topAttachment   XmATTACH_WIDGET   :topWidget text008
      :rightAttachment XmATTACH_POSITION :rightPosition 100
      :background (rgb-color 250 230 230)))    
    (setq label004 (make-label form002 "label004" :labelString (XmString "EEG")
      :topAttachment   XmATTACH_WIDGET   :topWidget text005
      :rightAttachment XmATTACH_WIDGET   :rightWidget text006))
    (setq label005 (make-label form002 "label005" :labelString (XmString "ECG")
      :topAttachment   XmATTACH_WIDGET   :topWidget text006
      :rightAttachment XmATTACH_WIDGET   :rightWidget text007))
    (setq label006 (make-label form002 "label006" :labelString (XmString "EOG")
      :topAttachment   XmATTACH_WIDGET   :topWidget text007
      :rightAttachment XmATTACH_WIDGET   :rightWidget text008))
    (setq label007 (make-label form002 "label006" :labelString (XmString "EEG[Hz]")
      :topAttachment   XmATTACH_WIDGET   :topWidget text008
      :rightAttachment XmATTACH_WIDGET   :rightWidget text009))
    (setq radiobox002 (XmCreateRadioBox form002 "radiobox002" (X-arglist) 0))
    (set-values radiobox002 :leftAttachment XmATTACH_FORM
      :topAttachment XmATTACH_WIDGET :topWidget text005)
    (setq lead-mono (XmCreateToggleButtonGadget radiobox002 "lead-mono" (X-arglist) 0))
    (set-values lead-mono :labelString (XmString "mono") :set 0)
    (setq lead-banana (XmCreateToggleButtonGadget radiobox002 "lead-banana" (X-arglist) 0))
    (set-values lead-banana :labelString (XmString "bipolar") :set 1)
    (setq lead-coronal (XmCreateToggleButtonGadget radiobox002 "lead-coronal" (X-arglist) 0))
    (set-values lead-coronal :labelString (XmString "coronal") :set 0)
    (dolist (n (list text006 text007 text008 text009 label004 label005 label006 label007 radiobox002 lead-mono lead-banana lead-coronal))(manage n))
  )
)
(defun add-parameter4(form003);;others
  (let ((label101)(radiobox101)(label102)(radiobox))
    (setq label101 (make-label form003 "label101"  :labelString (XmString "stepwise sort[sec]")
      :topAttachment  XmATTACH_FORM  :leftAttachment XmATTACH_FORM))
    (setq button101 (make-button form003 "button101" :labelString (XmString "stepwise scan")
      :topAttachment XmATTACH_FORM  :rightAttachment XmATTACH_FORM))
    (setq radiobox101 (XmCreateRadioBox form003 "radiobox101" (X-arglist) 0))
    (set-values radiobox101 :leftAttachment XmATTACH_FORM :numColumns 3
      :topAttachment XmATTACH_WIDGET :topWidget button101)
    (setq stepwise1 (XmCreateToggleButtonGadget radiobox101 "0.5" (X-arglist) 0))
    (setq stepwise2 (XmCreateToggleButtonGadget radiobox101 "1.0" (X-arglist) 0))
    (setq stepwise3 (XmCreateToggleButtonGadget radiobox101 "2.0" (X-arglist) 0))
    (set-values stepwise1 :set 1)

    (setq label102 (make-label form003 "label102" :labelString (XmString "number of peaks")
      :topAttachment  XmATTACH_WIDGET :topWidget radiobox101 :leftAttachment XmATTACH_FORM))
    (setq button102 (make-button form003 "button102" :labelString (XmString "select peaks")
      :topAttachment XmATTACH_WIDGET :topWidget radiobox101
      :rightAttachment  XmATTACH_FORM))
    (setq radiobox102 (XmCreateRadioBox form003 "radiobox102" (X-arglist) 0))
    (set-values radiobox102 :leftAttachment XmATTACH_FORM :numColumns 4
      :topAttachment XmATTACH_WIDGET :topWidget button102)
    (setq npeak1 (XmCreateToggleButtonGadget radiobox102  "10" (X-arglist) 0))
    (setq npeak2 (XmCreateToggleButtonGadget radiobox102  "20" (X-arglist) 0))
    (setq npeak3 (XmCreateToggleButtonGadget radiobox102  "50" (X-arglist) 0))
    (setq npeak4 (XmCreateToggleButtonGadget radiobox102 "100" (X-arglist) 0))
    (set-values npeak1 :set 1)

    (setq label103 (make-label form003 "label103" :labelString (XmString "number of sensors")
      :topAttachment XmATTACH_WIDGET :topWidget radiobox102 :leftAttachment XmATTACH_FORM))
    (setq text101 (make-text form003 "text101" :columns 5
      :topAttachment XmATTACH_WIDGET :topWidget radiobox102 :rightAttachment XmATTACH_FORM))

    (dolist (n (list label101 stepwise1 stepwise2 stepwise3 radiobox101 button101 label102 radiobox102 npeak1 npeak2 npeak3 npeak4 button102 label103 text101))(manage n));;NEVER divide 
  )
)

(defun add-parameter5(form004);; check GRA waves
  (let ((disp)(dispw))
    (setq button201 (make-button form004 "button201" :labelString (XmString "note")
      :bottomAttachment XmATTACH_FORM 
      :leftAttachment  XmATTACH_POSITION :leftPosition 0
      :rightAttachment XmATTACH_POSITION :rightPosition 30))
    (manage button201)
    (if (G-widget "disp-peak" :quiet)(GetDeleteWidget (G-widget "disp-peak")))
    (setq disp (GtMakeObject 'plotter :name "disp-peak"
      :display-parent form004 :no-controls t :point 0 :length 1 :superpose t))
    (put disp :display-form form004)
    (GtPopupEditor disp);; indispensable
    (setq dispw (resource disp :display-widget))
    (set-values dispw :resize 1
      :topAttachment XmATTACH_FORM  :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_WIDGET :bottomWidget button201)
    (setq button202 (make-button form004 "button202" :labelString (XmString "FIT")
      :topAttachment XmATTACH_WIDGET  :topWidget dispw
      :leftAttachment  XmATTACH_WIDGET   :leftWidget button201
      :rightAttachment XmATTACH_POSITION :rightPosition 55))
    (setq button203 (make-button form004 "button203" :labelString (XmString "note & FIT")
      :topAttachment  XmATTACH_WIDGET  :topWidget dispw
      :leftAttachment  XmATTACH_WIDGET :leftWidget button202
      :rightAttachment XmATTACH_FORM))
    (manage button202)(manage button203)  
    (link (G-widget "win-peak")(G-widget "disp-peak"))
  )
)

(defun apply-ssp()
  (let ((filename (resource (G-widget "file"):filename)))
    (if (not (string-equal (filename-extension filename) "fif"))
      (setq filename "/neuro/dacq/setup/ssp/online-0.fif"))
    (GtOrganizePanel)
    (graph::ssp-popup)
    (graph::ssp-load-file filename)
    (setq graph::ssp-vectors graph::ssp-vector-pool)
    (graph::ssp-rebuild-space)
    (graph::ssp-on))
)

(defun assign-callback()
  (let ((n)(nn)(ndisp))
    (add-lisp-callback text003      "valueChangedCallback" '(change-scale-meg "gra"))
    (add-lisp-callback text004      "valueChangedCallback" '(change-scale-meg "mag"))
    (add-lisp-callback text005      "activateCallback" '(change-bandpass "meg"))
    (add-lisp-callback text006      "valueChangedCallback" '(change-scale-eeg))
    (add-lisp-callback text007      "valueChangedCallback" '(change-scale-eeg))
    (add-lisp-callback text008      "valueChangedCallback" '(change-scale-eeg)) 
    (add-lisp-callback text009      "activateCallback" '(change-bandpass "eeg"))
    (add-lisp-callback gra204       "valueChangedCallback" '(change-coil "gra"))
    (add-lisp-callback mag102       "valueChangedCallback" '(change-coil "mag"))
    (add-lisp-callback lead-mono    "valueChangedCallback" '(change-leads "mono"))
    (add-lisp-callback lead-banana  "valueChangedCallback" '(change-leads "banana"))
    (add-lisp-callback lead-coronal "valueChangedCallback" '(change-leads "coronal"))
    (add-button *user-menu* "apply SSP" '(apply-ssp))
    (add-button *user-menu* "change color" '(change-color))
    ;(add-button *user-menu* "calc average noise" '(calc-noise-level))
    (add-lisp-callback text001      "valueChangedCallback" '(change-p0span))
    (add-lisp-callback text002      "valueChangedCallback" '(change-p0span))
    (set-resource (G-widget "disp001") :move-hook '(sync-view-3 "disp001") :select-hook '(sync-selection-3 "disp001"))
    (set-resource (G-widget "disp002") :move-hook '(sync-view-3 "disp002") :select-hook '(sync-selection-3 "disp002"))
    (set-resource (G-widget "disp003") :move-hook '(sync-view-3 "disp003") :select-hook '(sync-selection-3 "disp003"))
    (set-resource (G-widget "disp004") :move-hook '(sync-view-3 "disp004") :select-hook '(sync-selection-3 "disp004"))
    (set-resource (G-widget "disp005") :move-hook '(sync-view-3 "disp005") :select-hook '(sync-selection-3 "disp005"))
    (set-resource (G-widget "disp006") :move-hook '(sync-view-3 "disp006") :select-hook '(sync-selection-3 "disp006"))
    (set-resource (G-widget "disp007") :move-hook '(sync-view-3 "disp006") :select-hook '(sync-selection-3 "disp007"))
    (set-resource (G-widget "disp008") :move-hook '(sync-view-3 "disp008") :select-hook '(sync-selection-3 "disp008"))
    (set-resource (G-widget "disp009") :move-hook '(sync-view-3 "disp009") :select-hook '(sync-selection-3 "disp009"))
    (add-lisp-callback stepwise1    "valueChangedCallback" '(setq stepwise 0.5))
    (add-lisp-callback stepwise2    "valueChangedCallback" '(setq stepwise 1.0))
    (add-lisp-callback stepwise3    "valueChangedCallback" '(setq stepwise 2.0))
    (add-lisp-callback button101    "activateCallback" '(scan-max))
    (add-lisp-callback button102    "activateCallback" '(number-of-peaks))
    (add-lisp-callback npeak1    "valueChangedCallback" '(setq npeaks  10))
    (add-lisp-callback npeak2    "valueChangedCallback" '(setq npeaks  20))
    (add-lisp-callback npeak3    "valueChangedCallback" '(setq npeaks  50))
    (add-lisp-callback npeak4    "valueChangedCallback" '(setq npeaks 100))
    (add-lisp-callback button201    "activateCallback" '(memo-note))  
    (add-lisp-callback button202 "activateCallback" '(fit-select))
    (add-lisp-callback button203 "activateCallback" '(progn(memo-note memo)(fit-select)))  

  )
)


(defun assign-callback2()
    (add-lisp-callback button98  "activateCallback" '(scan-zoom 0));;zoom-off
    (add-lisp-callback button99  "activateCallback" '(scan-zoom 1));;zoom-on
    (add-lisp-callback button97  "activateCallback" '(scan-focus));;focus
  )
)

(defun calc-gap()
  (let ((x))
    (setq x (* (resource (G-widget "buf") :low-bound)(resource (G-widget "buf") :x-scale)))
    (return x)
  )
)


(defun calc_near_coil()
  (let ((R nil)(dist)(x)(xx)(chname))
    (setq chname (make-chname))
    (dotimes (i (length ch_dist))
      (setq dist (nth i ch_dist))
      (setq x (sort-order dist))
      (setq xx nil)
      (dolist (j x)
        (setq xx (append xx (list (nth j chname)))))
      (setq R (append R (list xx))))
    (return R)
  )
)

(defun calc-noise-level()
  (let ((n)(t0)(tt)(span)(tspan 1)(mtx)(w)(smp)(S)(S0 0)(nch)(str0)(str1)(str2))
    (setq t0 (resource (G-widget "disp001") :selection-start))
    (setq span (resource (G-widget "disp001") :selection-length))
    (if (> span 0)(progn
      (setq w (G-widget "meg-sel"))
      (setq str0 (format nil "since  ~0,2fs to ~0,2fs" t0 (+ t0 span)))
      ;;gradiometer
      (set-resource w :names '("MEG*") :ignore '("MEG*1"));;gradiometer
      ;(setq t0 (resource (G-widget "disp001") :selection-start))
      ;(setq span (resource (G-widget "disp001") :selection-length))
      (setq span (- span tspan)); by 1 sec
      (setq smp nil S nil S0 0)
      (while (> span tspan)
        (setq mtx (get-data-matrix w (x-to-sample w t0)(x-to-sample w tspan)))
        (setq mtx (map-matrix mtx #'abs))
        (setq smp (append smp (list (array-dimension mtx 1))))
        (setq S   (append S   (list (matrix-element-sum mtx))))
        (setq span (- span tspan))
        (setq t0 (+ t0 tspan))
      )
      (setq mtx (get-data-matrix w (x-to-sample w t0)(x-to-sample w span)))
      (setq mtx (map-matrix mtx #'abs))
      (setq smp (append smp (list (array-dimension mtx 1))))
      (setq S   (append S   (list (matrix-element-sum mtx))))
      (setq S0 (/ (apply #'+ S)(apply #'+ smp)))
      (setq nch (resource (G-widget "meg-sel"):channels))
      (setq S0 (/ S0 nch))
      (setq str1 (format nil "gradiometer ~0,2f fT/cm" (* S0 1e+13)))
      ;;magnetometer
      (set-resource w :names '("MEG*1") :ignore nil);;magnetometer
      (setq t0 (resource (G-widget "disp001") :selection-start))
      (setq span (resource (G-widget "disp001") :selection-length))
      (setq span (- span tspan)); by 1 sec      
      (setq smp nil S nil S0 0)
      (while (> span tspan)
        (setq mtx (get-data-matrix w (x-to-sample w t0)(x-to-sample w tspan)))
        (setq mtx (map-matrix mtx #'abs))
        (setq smp (append smp (list (array-dimension mtx 1))))
        (setq S   (append S   (list (matrix-element-sum mtx))))
        (setq span (- span tspan))
        (setq t0 (+ t0 tspan))
      )
      (setq mtx (get-data-matrix w (x-to-sample w t0)(x-to-sample w span)))
      (setq mtx (map-matrix mtx #'abs))
      (setq smp (append smp (list (array-dimension mtx 1))))
      (setq S   (append S   (list (matrix-element-sum mtx))))
      (setq S0 (/ (apply #'+ S)(apply #'+ smp)))
      (setq nch (resource (G-widget "meg-sel"):channels))
      (setq S0 (/ S0 nch))
      (setq str2 (format nil "magnetometer  ~0,2f fT" (* S0 1e+15)))
      ;;final
      (memo-add memo0 (format nil "~a~%~a~%~a" str0 str1 str2))))
  )
)

(defun change-bandpass(sns)
  (if (string-equal sns "meg")
    (set-resource (G-widget "MEG-fil") :pass-band (read-from-string (XmTextGetString text005)))
    (set-resource (G-widget "EEG-fil") :pass-band (read-from-string (XmTextGetString text009)))
  )
)

(defun change-coil(coil)
  (let ((n)(ws)(chs)(w))
    (setq ws (list "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (if (string-equal coil "gra")
      (setq chs (list gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal))
      (setq chs (list mag-L-temporal mag-R-temporal mag-L-parietal mag-R-parietal mag-L-occipital mag-R-occipital mag-L-frontal mag-R-frontal)))
    (dotimes (n 8)(progn
      (setq w (G-widget (nth n ws)))
      (set-resource w :names (nth n chs))
      (link w (G-widget (format nil "disp00~a" (1+ n))))))
    (change-scale-meg coil))
)

(defun change-color()
  (let ((n)(col)(disps))
    (setq col (resource (G-widget "disp001"):background))
    (setq disps (list "disp001" "disp002" "disp003" "disp004" "disp005" "disp006" "disp007" "disp008" "disp009" "disp-peak"))
    (if (G-widget "scan-disp" :quiet)(setq disps (append disps (list "scan-disp" "scan-disp2"))))
    (if (string-equal col  "black")
      (dotimes (n (length disps))
        (set-resource (G-widget (nth n disps)) :default-color "black" :background "white" :highlight "gray80" :baseline-color "gray80"))
      (dotimes (n (length disps))
        (set-resource (G-widget (nth n disps)) :default-color "white" :background "black" :highlight "white" :baseline-color "gray80"))))
)

(defun change-leads(str)
  (let ((n)(nch)(chname nil))
    (set-eegchname)
    (if (string-equal str "mono")(progn
      (set-resource (G-widget "EEG1") :names EEG-mono)
      (link (G-widget "EEGs")(G-widget "EEG1"))
      (select-to 'sel (EEG1 0 - 18)(EEGs 19 20))
      (dotimes (n 19)(setq chname (append chname (list (format nil "~a-Oz" (nth n EEG-mono))))))
      (setq chname (append chname (list "ECG" "EOG")))
    ))
    (if (string-equal str "banana")(progn
      (set-resource (G-widget "EEG1") :names EEG-banana1)
      (set-resource (G-widget "EEG2") :names EEG-banana2)
      (link (G-widget "EEGs")(G-widget "EEG1"))
      (link (G-widget "EEGs")(G-widget "EEG2"))
      (link (G-widget "EEG1")(G-widget "fsub"))
      (link (G-widget "EEG2")(G-widget "fsub"))
      (select-to 'sel (fsub 0 - 17)(EEGs 19 20))
      (dotimes (n 18)(setq chname (append chname (list (format nil "~a-~a" (nth n EEG-banana1)(nth n EEG-banana2))))))
      (setq chname (append chname (list "ECG" "EOG")))
    ))
    (if (string-equal str "coronal")(progn
      (set-resource (G-widget "EEG1") :names EEG-coronal1)
      (set-resource (G-widget "EEG2") :names EEG-coronal2)
      (link (G-widget "EEGs")(G-widget "EEG1"))
      (link (G-widget "EEGs")(G-widget "EEG2"))
      (link (G-widget "EEG1")(G-widget "fsub"))
      (link (G-widget "EEG2")(G-widget "fsub"))
      (select-to 'sel (fsub 0 - 17)(EEGs 19 20))
      (dotimes (n 18)(setq chname (append chname (list (format nil "~a-~a" (nth n EEG-coronal1)(nth n EEG-coronal2))))))
      (setq chname (append chname (list "ECG" "EOG")))
    ))
    (setq nch (resource (G-widget "sel") :channels))
    (dotimes (n nch)(set-property (G-widget "sel") n :name (nth n chname)))
    (link (G-widget "sel")(G-widget "EEG-fil"))
    (link (G-widget "EEG-fil")(G-widget "disp009"))
    (change-scale-eeg)
  )
)

(defun change-p0span()
  (let ((p0)(span)(n)(disp))
    (setq p0   (read-from-string (XmTextGetString text001)))
    (setq span (read-from-string (XmTextGetString text002)))
    (setq p0   (/ (round (* p0 100)) 100))
    (setq span (/ (round (* span 100)) 100))
    ;(XmTextSetString text001 (format nil "~0,2f" p0))   ;;fatal error
    ;(XmTextSetString text002 (format nil "~0,2f" span)) ;;fatal error
    (set-resource (G-widget "disp001") :point p0 :length span)
    (dotimes (n 9)(progn
      (setq disp (format nil "disp00~d" (1+ n)))
      (set-resource (G-widget disp) :point p0 :length span))
    ))
)

(defun change-scale-eeg()
  (let ((n)(nch)(eeg)(ecg)(eog)(scale)(scales nil)(w)(chname))
    (setq eeg (read-from-string (XmTextGetString eeg-scale)))
    (setq ecg (read-from-string (XmTextGetString ecg-scale)))
    (setq eog (read-from-string (XmTextGetString eog-scale)))
    (setq eeg (* eeg 1e-6))
    (setq ecg (* ecg 1e-6))
    (setq eog (* eog 1e-6))
    (setq w (G-widget "disp009"))
    (setq nch (resource w :channels))
    (dotimes (n nch)
      (setq chname (get-property w n :name))
      (setq chname (string-right-trim " 0123456789" chname))
      (setq scale eeg)
      (if (string-equal chname "ECG")(setq scale ecg))
      (if (string-equal chname "EOG")(setq scale eog))
      (setq scales (append scales (list scale))))
    (set-resource w :scales (transpose (matrix (list scales))))
  )
)

(defun change-scale-meg(coil)
  (let ((n)(nch)(scale)(ws)(w)(mtx))
    (if (string-equal coil "gra")
      (setq scale (* (read-from-string (XmTextGetString gra-scale)) 1e-13))
      (setq scale (* (read-from-string (XmTextGetString mag-scale)) 1e-15)))
    (setq ws (list "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (dotimes (n 8)(progn
      (setq w (G-widget (nth n ws)))
      (setq nch (resource  w :channels))
      (setq mtx (make-matrix nch 1 scale))
      (set-resource (G-widget (format nil "disp00~d" (1+ n))) :scales mtx))))
)

(defun create-memo-old()
  (let ((n)(mid)(w)(label99)(nemubar99)(frame99)(frame99-label)(text99)(text98)(pane99)(memo96))
    (if (G-widget "scan-disp" :quiet)(delete-memo))   
    (setq mid 55)
    (setq form99 (make-form-dialog *application-shell* "form99" :autoUnmanage 0))
    (set-values form99 :resize 1)
    (setq menubar99 (make-menu-bar form99 "menubar99" :autounmanage 0
      :topAttachment   XmATTACH_FORM 
      :leftAttachment  XmATTACH_POSITION :leftPosition mid
      :rightAttachment XmATTACH_POSITION :rightPosition 100))
    (create-memo-menu menubar99)
    (manage menubar99)
    (setq memo96 (make-scrolled-text form99 "memo96" 
      :editMode XmMULTI_LINE_EDIT :rows 13 :columns 30));;the height of controls of plotter
    (manage memo96);;this must be here!!
    (setq pane99 (XmCreatePanedWindow form99 "pane99" (X-arglist) 0))
    (set-values pane99 
      :leftAttachment  XmATTACH_POSITION :leftPosition mid
      :topAttachment   XmATTACH_WIDGET   :topWidget        menubar99
      :rightAttachment XmATTACH_FORM     :bottomAttachment XmATTACH_FORM)
    (setq frame99 (make-frame pane99 "frame99"))
    (setq frame98 (make-frame pane99 "frame98"))
    (setq frame97 (make-frame pane99 "frame97"))
    (create-memo1 frame99)
    (create-memo2 frame98)
    (create-memo3 frame97)
    (dolist (n (list form99 pane99 frame99 frame98 frame97))(manage n))
    (setq pos (create-memo4 form99 pane99  memo96));;invisible structure
    (create-memo5 form99 pane99);;scaned gra waves
    (create-memo6 form99 memo96 pos pane99);top left right
    (add-button *user-menu* "show my-memo" '(manage form99))
  ) 
)

(defun create-memo()
  (let ((n)(menubar01)(frame01)(form02)(buttons)(memo01)(pane01)(frame02)(frame03)(frame04)(pos))
    (if (G-widget "scan-disp" :quiet)(delete-memo))   
    (setq mid 55)
    (setq form99 (make-form-dialog *application-shell* "form99" :autoUnmanage 0 :ersize 1))
    (setq menubar01 (make-menu-bar form99 "menubar99" :autounmanage 0
      :topAttachment   XmATTACH_FORM 
      :leftAttachment  XmATTACH_POSITION :leftPosition mid
      :rightAttachment XmATTACH_POSITION :rightPosition 100))
    (create-memo-menu menubar01)
    (manage menubar01)    
    (setq frame01 (make-frame form99 "frame01"
      :topAttachment  XmATTACH_WIDGET :topWidget menubar01
      :leftAttachment XmATTACH_POSITION :leftPosition mid
      :rightAttachment XmATTACH_FORM))
    (setq form02 (make-form frame01 "form02"))
    (setq buttons (create-memo-buttons form02))
    (setq memo99 (make-scrolled-text form99 "memo99" 
      :editMode XmMULTI_LINE_EDIT :rows 13 :columns 30));;the height of controls of plotter
    (manage memo99);;this must be here!!
    (dolist (n (list form99 menubar01 frame01 form02))(manage n))
    (setq pane01 (XmCreatePanedWindow form99 "pane01" (X-arglist) 0))
    (set-values pane01 
      :leftAttachment  XmATTACH_POSITION :leftPosition mid
      :topAttachment   XmATTACH_WIDGET   :topWidget        frame01
      :rightAttachment XmATTACH_FORM     :bottomAttachment XmATTACH_FORM)
    (setq frame02 (make-frame pane01 "frame02"));miscellaneous
    (setq frame03 (make-frame pane01 "frame03"));memo1
    (setq frame04 (make-frame pane01 "frame04"));memo2
    (setq memo0 (create-memo1 frame02));memo0
    (setq memo1 (create-memo2 frame03));memo1  memo01??invalid???
    (setq memo2 (create-memo2 frame04));memo2
    (dolist (n (list frame02 frame03 frame04 pane01))(manage n))
    (setq pos (create-memo4 form99 pane01 memo99));;invisible structure    
    (create-memo5 form99 pane01);;scaned gra waves
    (create-memo6 form99 memo99 pos pane01);top left right    
    (add-lisp-callback nmenu1  "valueChangedCallback" '(setq nmemo memo1))
    (add-lisp-callback nmenu2  "valueChangedCallback" '(setq nmemo memo2))
    (setq nmemo memo1)
    (add-button *user-menu* "show my-memo" '(manage form99))
  )
)

(defun create-memo1(frame);;memo99
  (let ((n)(form)(label)(memo));;
    (setq form (make-form frame "form"))
    (setq label (make-label frame "label" :childType XmFRAME_TITLE_CHILD 
      :labelString (XmString "miscellaneous")))
    (setq memo (make-scrolled-text frame "memo" :editMode XmMULTI_LINE_EDIT
      :rows 5 :columns 30 :bottomAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM))
    (dolist (n (list form label  memo))(manage n))
    (return memo)
  )
)

(defun create-memo2old(frame);;memo98
  (let ((n)(form)(button1)(button2)(button3)(button4)(button5)(frame1)(frame1-label)(memo))
    (setq form (make-form frame "form"))
    (setq button1 (make-button form "button1" :labelString (XmString "goto")
      :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM))
    (setq button2 (make-button form "button2" :labelString (XmString "full view")
      :topAttachment   XmATTACH_FORM 
      :leftAttachment  XmATTACH_WIDGET :leftWidget button1))
    (setq button3 (make-button form "button3" :labelString (XmString "note")
      :topAttachment   XmATTACH_FORM
      :leftAttachment  XmATTACH_WIDGET :leftWidget button2))
    (setq button4 (make-button form "button4" :labelString (XmString "FIT")
      :leftAttachment  XmATTACH_WIDGET :leftWidget button3))
    (setq button5 (make-button form "button5" :labelString (XmString "note & FIT")
      :leftAttachment  XmATTACH_WIDGET :leftWidget button4))
    (setq frame1 (make-frame form "frame1" :resize 1
      :topAttachment    XmATTACH_WIDGET :topWidget button1
      :leftAttachment   XmATTACH_FORM   :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM))
    (setq frame1-label (make-label frame1 "frame1-label" :childType XmFRAME_TITLE_CHILD))
    (set-values frame1-label 
      :labelString (XmString "  sec        span        sns          peak         fT/cm"))
    (setq memo (make-scrolled-text frame1 "memo" :editMode XmMULTI_LINE_EDIT
      :rows 5 :columns 30 :bottomAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM))
    (dolist (n (list form button1 button2 button3 button4 button5 frame1 frame1-label memo))(manage n))
    (add-lisp-callback button1 "activateCallback" '(goto memo98))
    (add-lisp-callback button2 "activateCallback" '(full-view))
    (add-lisp-callback button3 "activateCallback" '(memo-note memo))
    (add-lisp-callback button4 "activateCallback" '(fit-select))
    (add-lisp-callback button5 "activateCallback" '(progn(memo-note memo)(fit-select)))
    (return memo)
  )
)

(defun create-memo2(frame);;memo98
  (let ((n)(form)(button1)(button2)(button3)(button4)(button5)(frame1)(frame1-label)(memo))
    (setq form (make-form frame "form"))
    (setq frame1 (make-frame form "frame1" :resize 1
      :topAttachment    XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM   :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM))
    (setq frame1-label (make-label frame1 "frame1-label" :childType XmFRAME_TITLE_CHILD))
    (set-values frame1-label 
      :labelString (XmString "  sec        span        sns          peak         fT/cm"))
    (setq memo (make-scrolled-text frame1 "memo" :editMode XmMULTI_LINE_EDIT
      :rows 5 :columns 30 :bottomAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM))
    (dolist (n (list form frame1 frame1-label memo))(manage n))
    (return memo)
  )
)
(defun create-memo4(form pane memo)
  (let ((text01)(text02))
    (setq text01 (XmCreateText form "text01" (X-arglist) 0))
    (set-values text01 :topAttachment XmATTACH_WIDGET :topWidget memo
      :rightAttachment XmATTACH_WIDGET :rightWidget pane
      :columns 18 :marginHeight 1);; equals the controls of the plotter!
    (setq text02 (XmCreateText form "text02" (X-arglist) 0))
    (set-values text02
      :topAttachment   XmATTACH_WIDGET :topWidget text01 ;:leftAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_WIDGET :rightWidget text01)
    (dolist (n (list text01 text02))(manage n))
    (return text02)
  )
)

(defun create-memo5(form pane)
  (let ((dispw))
    (if (G-widget "scan-disp" :quiet)(GtDeleteWidget (G-widget "scan-disp")))
    (setq scan-disp (GtMakeObject 'plotter :name "scan-disp" :point 0.0 :length 10 
      :display-parent form  :scroll-parent form :ch-label-space 80 :no-controls nil))
    (put scan-disp :display-form form)
    (GtPopupEditor scan-disp)
    (setq dispw (resource (G-widget "scan-disp") :display-widget))
    (set-values dispw :resize 1
      :topAttachment   XmATTACH_FORM  :bottomAttachment XmATTACH_FORM 
      :leftAttachment  XmATTACH_FORM
      :rightAttachment XmATTACH_WIDGET :rightWidget pane)
    (set-values (resource (G-widget "scan-disp") :scroll-widget)
      :resize 1
      :topAttachment    XmATTACH_POSITION :topPosition 98
      :bottomAttachment XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_WIDGET :rightPosition pane)
  )
)

(defun create-memo6(form memo text pane)
  (let ((n)(dispw)(w)(frame01)(form01)(label01));form96
    (setq frame01 (make-frame form "frame01" :resize 1
      :topAttachment XmATTACH_WIDGET :topWidget memo 
      :leftAttachment XmATTACH_WIDGET :leftWidget text
      :rightAttachment XmATTACH_WIDGET :rightWidget pane 
      :bottomAttachment XmATTACH_FORM))
    (setq form01 (make-form frame01 "form01"))
    (setq text97 (XmCreateText form01 "text97" (X-arglist) 0))
    (set-values text97
      :bottomAttachment XmATTACH_FORM
      :leftAttachment   XmATTACH_POSITION :leftPosition 50
      :rightAttachment  XmATTACH_FORM)
    (XmTextSetString text97 (format nil "~0,2f" dipspan))
    (setq label01 (make-label form01 "label01" :labelString (XmString "length")
      :bottomAttachment XmATTACH_FORM :rightAttachment XmATTACH_WIDGET :rightWidget text97))
    (manage label01)
    (setq button99 (make-button form01 "button99" :labelString (XmString "zoom")
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text97))
    (setq button98 (make-button form01 "button98" :labelString (XmString "reset")
      :leftAttachment XmATTACH_WIDGET :leftWidget button99
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text97))
    (setq button97 (make-button form01 "button97" :labelString (XmString "focus")
      :leftAttachment XmATTACH_WIDGET :leftWidget button98
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text97))
    (dolist (n (list frame01 form01 text97 button99 button98 button97))(manage n))
    (if (G-widget "scan-disp2" :quiet)(GtDeleteWidget (G-widget "scan-disp2")))
    (setq scan-disp2 (GtMakeObject 'plotter :name "scan-disp2" :point 0.0 :length 0.1 
      :display-parent form01  :scroll-parent form01 :ch-label-space 0 :no-controls t))
    (put scan-disp2 :display-form form01)
    (GtPopupEditor scan-disp2)
    (setq dispw (resource (G-widget "scan-disp2") :display-widget))
    (set-values dispw :resize 1
      :topAttachment    XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM
      :bottomAttachment XmATTACH_WIDGET :bottomWidget button99)
    (setq w (G-widget "win-peak2"))
    (set-resource w :point 0)
    (set-resource (G-widget "scan-disp2") :superpose t)
    (link w (G-widget "scan-disp2"))
    (assign-callback2)
  )
)

(defun create-memo-buttons(form) 
  (let ((button1)(button2)(button3)(button4)(button5)(rb))
    (setq button1 (make-button form "button1" :labelString (XmString "goto")
      :topAttachment  XmATTACH_FORM
      :leftAttachment XmATTACH_FORM))
    (setq button2 (make-button form "button2" :labelString (XmString "full view")
      :topAttachment   XmATTACH_FORM
      :leftAttachment  XmATTACH_WIDGET  :leftWidget button1))
    (setq button3 (make-button form "button3" :labelString (XmString "note")
      :topAttachment   XmATTACH_FORM
      :leftAttachment  XmATTACH_WIDGET  :leftWidget button2))
    (setq button4 (make-button form "button4" :labelString (XmString "FIT")
      :topAttachment   XmATTACH_FORM
      :leftAttachment  XmATTACH_WIDGET  :leftWidget button3))
    (setq button5 (make-button form "button5" :labelString (XmString "note & FIT")
      :topAttachment   XmATTACH_FORM
      :leftAttachment  XmATTACH_WIDGET  :leftWidget button4))
    (setq rb (XmCreateRadioBox form "rb" (X-arglist) 0))
    (set-values rb :topAttachment XmATTACH_FORM :numColumns 2
      :leftAttachment  XmATTACH_WIDGET  :leftWidget button5)
    (setq nmenu1 (XmCreateToggleButtonGadget rb "menu1" (X-arglist) 0))
    (setq nmenu2 (XmCreateToggleButtonGadget rb "menu2" (X-arglist) 0))
    (set-values nmenu1 :set 1) 
    (dolist (n (list button1 button2 button3 button4 button5 rb nmenu1 nmenu2))(manage n))
    (add-lisp-callback button1 "activateCallback" '(goto))
    (add-lisp-callback button2 "activateCallback" '(full-view))
    (add-lisp-callback button3 "activateCallback" '(memo-note))
    (add-lisp-callback button4 "activateCallback" '(fit-select))
    (add-lisp-callback button5 "activateCallback" '(progn(memo-note)(fit-select)))
    (return button1)
  )
)

(defun create-memo-menu(bar)
  (let ((menus)(n))
    (setq menu1 (make-menu bar "menu" nil
      '("save as *-wave.txt" (memo-text-save))
      '("load *-wave.txt"    (memo-text-load))
      '("clear memo"         (XmTextSetString nmemo ""))))
    (setq menu2 (make-menu bar "waves"))
    (make-menu menu2 "waves" nil :tear-off
      '("discharge"    (memo-insert "discharge"))
      '("spike"        (memo-insert "spike"))
      '("polyspike"    (memo-insert "polyspike"))
      '("burst"        (memo-insert "burst"))
      '("ictal onset"  (memo-insert "ictal onset"))
      '("EEG spike"    (memo-insert "EEG spike"))
      '("physiological activities"  (memo-insert "phyisological activities"))
      '("noise"        (memo-insert "noise"))
      '("???"          (memo-insert "???")))
    (setq menu3 (make-menu bar "display"))
    (add-button menu3 "default-display" '(set-default-display))
    (add-button menu3 "change color" '(change-color))
    (make-menu menu3 "sort" nil :tear-off
      '("according to amplitude" (memo-sort "amplitude"))
      '("according to time"      (memo-sort "time"))
      '("according to sensor"    (memo-sort "sensor")))  
    (setq menu4 (make-menu bar "assorted"))
    
    (add-button menu4 "apply SSP" '(apply-ssp))
    (add-button menu4 "calc average noise" '(calc-noise-level))
  )
)

(defun create-widgets()
  (let ((w)(widget-name)(n)(gw)(L1)(L2))
    (progn
    (setq widget-name (list "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (dolist (w widget-name)(if (G-widget w :quiet)(GtDeleteWidget (G-widget w))))
    (require-widget :ringbuffer "buf" (list "size" 5000000))
    (require-widget :pick "MEG" (list "names" '("MEG*")))
    (require-widget :fft-filter "MEG-fil" (list "pass-band" '(band-pass 3 35)))
    (require-widget :pick "meg" (list "names" '("MEG*")))
    (require-widget :pick "meg-sel" (list "names" '("MEG*")))
    (require-widget :pick "gra" (list "names" '("MEG*") "ignore" '("MEG*1")))
    (setq L1 (list "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (setq L2 (list gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal))
    (link (G-widget "MEG-fil")(G-widget "meg"))
    (dotimes (n 8)
      (setq gw (GtMakeObject 'pick :name (nth n L1) :names (nth n L2)))
      (link (G-widget "meg") gw)
      (link gw (G-widget (format nil "disp00~d" (1+ n)))))
    (require-widget :pick "EEGs" (list "names" '("EEG*" "ECG*" "EOG*")))
    (require-widget :pick "EEG1")
    (require-widget :pick "EEG2")
    (require-widget :binary "fsub" (list "function" 'fsub))
    (require-widget :selector "sel")
    (require-widget :fft-filter "EEG-fil" (list "pass-band" '(band-pass 0.5 50)))
    (require-widget :data-window "win-peak")
    (require-widget :data-window "win-peak2")
    (require-widget :data-window "win-xp")
    (require-widget :command "xp")
    (link (G-widget "file")(G-widget "buf"))
    (link (G-widget "buf")(G-widget "MEG"))
    (link (G-widget "MEG")(G-widget "ssp"))
    (link (G-widget "ssp")(G-widget "MEG-fil"))
    (link (G-widget "MEG-fil")(G-widget "gra"))
    (link (G-widget "gra")(G-widget "win-peak"))
    (link (G-widget "gra")(G-widget "win-peak2"))
    (link (G-widget "MEG-fil")(G-widget "meg-sel"))
    (link (G-widget "buf")(G-widget "EEGs"))
    (link (G-widget "EEGs")(G-widget "EEG1"))
    (link (G-widget "EEGs")(G-widget "EEG2"))
    (link (G-widget "EEG1")(G-widget "fsub"))
    (link (G-widget "EEG2")(G-widget "fsub"))
    (link (G-widget "fsub")(G-widget "sel"));tentative!
    (link (G-widget "sel")(G-widget "EEG-fil"))
    (link (G-widget "EEG-fil")(G-widget "disp009"))
    (link (G-widget "meg-sel")(G-widget "win-xp"))
    (link (G-widget "win-xp")(G-widget "xp"))
    (GtOrganizePanel)
    )
  )
)

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
    (defparameter ch_dist chdist)
    (defparameter near_coil (calc_near_coil))
  )
)

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
  (defparameter EEG-channels 
    '("Fp1" "Fp2" "F7" "F3" "Fz" "F4" "F8" "T3" "C3" "Cz" "C4" "T4" "T5" "P3" "Pz" "P4" "T6" "O1" "O2" "ECG" "EOG"))
  (defparameter EEG-mono
    '("F7" "T3" "T5" "Fp1" "F3" "C3" "P3" "O1" "F7" "Fz" "Cz" "Pz" "Fp2" "F4" "C4" "P4" "O2" "F8" "T4" "T6"))
  (defparameter EEG-banana1 '("Fp1" "F7" "T3" "T5" "Fp1" "F3" "C3" "P3" "Fz" "Cz" "Fp2" "F4" "C4" "P4" "Fp2" "F8" "T4" "T6"))
  (defparameter EEG-banana2 '("F7" "T3" "T5" "O1" "F3" "C3" "P3" "O1" "Cz" "Pz" "F4" "C4" "P4" "O2" "F8" "T4" "T6" "O2"))
  (defparameter EEG-coronal1 '("F7" "Fp1" "Fp2" "F7" "F3" "Fz" "F4" "T3" "C3" "Cz" "C4" "T5" "P3" "Pz" "T4" "T5" "O1" "O2"))
  (defparameter EEG-coronal2 '("Fp1" "Fp2" "F8" "F3" "Fz" "F4" "F8" "C3" "Cz" "C4" "T4" "P3" "Pz" "P4" "T6" "O1" "O2" "T6"))
  (defparameter stepwise 0.5)
  (defparameter npeaks 10)
  (defparameter dipspan 0.2)
  (defparameter nmenu 1)
  ;; (defparameter defmemo memo98); this is defined after create-memo 
  (defvar wave-name 
      (list "discharge" "spike" "polyspike" "burst" "ictal onset" "EEG spike" "physiological activities" "noise" "???"))
)

(defun define-texts()
  (let ((n)(texts)(values)(x))
    (defparameter gra-scale text003)
    (defparameter mag-scale text004)
    (defparameter eeg-scale text006)
    (defparameter ecg-scale text007)
    (defparameter eog-scale text008)
    (defparameter nsensor-text text101)
    (setq texts (list text001 text002 gra-scale mag-scale text005 eeg-scale ecg-scale eog-scale text009 nsensor-text))
    (setq values (list "0.00" "10.00" 500 3000 "(band-pass 3 35)" 100 1000 100 "(band-pass 0.5 50)" 30))
    (dotimes (n (length texts))
      (setq x (nth n values))
      (if (numberp x)(setq x (format nil "~d" x)))
      (XmTextSetString (nth n texts) x))
  )
)

(defun delete-memo()
  (if (G-widget "scan-disp"  :quiet)(GtDeleteWidget (G-widget "scan-disp")))
  (if (G-widget "scan-disp2" :quiet)(GtDeleteWidget (G-widget "scan-disp2")))
  (XtDestroyWidget form99)
)

(defun fit-select()
  (let ((tm)(t1)(t2)(tt)(w)(mtx)(x)(ch)(n)(sns))
    (if (x-selection)(progn
      (setq w (G-widget "meg-sel"))
      (set-resource w :names '("MEG*") :ignore nil)
      (setq tm (x-selection))
      (setq t1 (first tm) t2 (second tm))
      (setq mtx (get-data-matrix w (x-to-sample w t1)(x-to-sample w t2)))
      (setq x (max-matrix mtx)) ; amp ch smp
      (setq ch (1- (second x))) ; 1,2,3...
      (setq ch (get-property w ch :name))
      (setq tt (* (1- (third  x))(resource w :x-scale)))
      (setq tt (+ tt t1)); sec
      (select-sensors ch);;sensor selection
      (xfit-transfer-data w (list t1 t2))
      (xfit-command (format nil "fit ~0,4f" (* tt 1000)));msec
      (xfit-command (format nil "samplech ~a" (string-left-trim "MEG " ch)))
      (xfit-command "fullview on")))
  )
)

(defun full-view()
  (let ((tm)(t1)(t2)(tt)(w)(mtx)(x)(ch))
    (if (x-selection)(progn
      (setq w (G-widget "meg-sel"))
      (set-resource w :names '("MEG*") :ignore nil)
      (setq tm (x-selection))
      (setq t1 (first tm) t2 (second tm))
      (setq mtx (get-data-matrix w (x-to-sample w t1)(x-to-sample w t2)))
      (setq x (max-matrix mtx)) ; amp ch smp
      (setq ch (1- (second x))) ; 1,2,3...
      (setq ch (get-property w ch :name))
      (setq tt (* (1- (third  x))(resource w :x-scale)))
      (setq tt (+ tt t1)); sec
      (xfit-transfer-data w (list t1 t2))
      (xfit-command (format nil "pick ~0,4f" (* tt 1000)));msec
      (xfit-command (format nil "samplech ~a" (string-left-trim "MEG " ch)))
      (xfit-command "fullview on")))
  )
)

(defun get-gra-matrix(t0 span)
  (let ((mtx)(gra))
    (setq gra (G-widget "gra"))
    (setq mtx (get-data-matrix gra (x-to-sample gra t0)(x-to-sample gra span)))
    (return mtx)
  )
)

(defun get-list-memo(memo)
  (let ((str)(n)(N)(LS)(L)(LL nil))
    (setq LS (get-list-string-memo memo))
    (dotimes (n (length LS))
      (setq str (format nil "(~a)" (nth n LS)))
      (setq L (read-from-string str))
       (setq LL (append LL (list L))))
    (return (list LL (get-string-return (XmTextGetString memo))))
  )
)

(defun get-list-memo_broken(memo)
  (let ((str)(strm)(n)(N)(LL nil)(L nil))
    (setq str (XmTextGetString memo))
    (setq strm (make-string-input-stream str))
    (setq N (get-string-return str))
    (setq N (append N (list 99999999)))
    (dotimes (n (length N))
      (setq L (read-line-as-list strm));; this does not work in caes of #\3 
      (print (list n L))
      (setq LL (append LL (list L))))
    (return (list LL N))
  )
)

(defun get-list-string-memo(memo)
  (let ((str)(strm)(n)(N)(L nil))
    (setq str (XmTextGetString memo))
    (setq strm (make-string-input-stream str))
    (setq N (get-string-return str))
    (setq N (append N (list 999999)))
    (dotimes (n (length N))
      (setq L (append L (list (read-line strm)))))
    (return L)
  )
)

(defun get-string-return(str)
  (let ((n)(nn nil)(strm))
    (setq strm (make-string-input-stream str))
    (dotimes (n (length str))
      (if (equal (read-char strm) #\Linefeed)
        (setq nn (append nn (list n)))))
    (return nn)
  )
)

(defun goto()
  (let ((n)(LL)(N)(pos)(L)(t0)(span)(span0)(t1))
    (setq LL (get-list-memo nmemo))
    (setq N (second LL))
    (setq N (append N (list 999999999)))
    (setq LL (first LL))
    (setq pos (XmTextGetInsertionPosition nmemo))
    (if (> (length N) 1)(progn
      (setq n 0)
      (while (> pos (nth n N))(progn
        (setq n (1+ n))))
      (setq L (nth n LL))
      (if (> (length L) 4)(progn
        (setq t0 (first L) span (second L))
        (setq span0 (resource (G-widget "disp001") :length))
        (setq t1 (- (+ t0 (/ span 2))(/ span0 2))) 
        (XmTextSetString text001 (format nil "~0,2f" t1))
        (dotimes (n 9)
          (set-resource (G-widget (format nil "disp00~d" (1+ n))) 
            :selection-start t0 :selection-length span))))))
  )
)

(defun initialize()
  (let ((x1 49)(x2 98)(n)(xx 60))
    (setq form001 (make-form *main-window* "form001"))
    (make-subplotter "disp001"   0  x1   0  20  "L-temporal")
    (make-subplotter "disp002"   0  x1  20  40  "L-parietal")
    (make-subplotter "disp003"   0  x1  40  60  "L-occipital")
    (make-subplotter "disp004"   0  x1  60  80  "L-frontal")
    (make-subplotter "disp005"  x1  x2   0  20  "R-temporal")
    (make-subplotter "disp006"  x1  x2  20  40  "R-parietal")
    (make-subplotter "disp007"  x1  x2  40  60  "R-occipital")
    (make-subplotter "disp008"  x1  x2  60  80  "R-frontal")
    (make-subplotter "disp009"   0  xx  80 100  "EEG ECG EOG")  
    (set-values (resource (G-widget "disp001") :scroll-widget)
      "resizable" 1
      :topAttachment    XmATTACH_POSITION :topPosition     x2
      :bottomAttachment XmATTACH_POSITION :bottomPosition 100
      :leftAttachment   XmATTACH_POSITION :leftPosition     0
      :rightAttachment  XmATTACH_POSITION :rightPosition   80)
    (manage form001);;This must be here!
    (define-parameters)
    (setq default-data-source "meg-sel")
    (defchpos)
    (create-widgets)
    (add-parameter xx 80)
    (define-texts)
    (assign-callback)
    (create-memo)
  )
)

(defun make-chname()
  (let ((x)(y)(ch nil))
    (dotimes (x 26)
      (dotimes (y 4)
        (setq n (+ (* x 10) y 11))
        (setq ch (append ch (list n)))))
    (setq ch (delete 83 ch))
    (setq ch (delete 84 ch))
    (return ch)
  )
)

(defun make-subplotter(disp-name top bottom left right title)
  (let ((disp)(dispw)(label nil))
    (if (G-widget disp-name :quiet)(GtDeleteWidget (G-widget disp-name)))
    (setq disp (GtMakeObject 'plotter :name disp-name
      :point 0.0              :length 10.0
      :display-parent form001 :scroll-parent form001
      :ch-label-space 80      :no-controls t))
    (put disp :display-form form001)
    (GtPopupEditor disp)
    (setq dispw (resource disp :display-widget))
    (set-values dispw :resize 1
      :topAttachment    XmATTACH_POSITION :topPosition    top :topOffset 20    
      :bottomAttachment XmATTACH_POSITION :bottomPosition bottom
      :leftAttachment   XmATTACH_POSITION :leftPosition   left
      :rightAttachment  XmATTACH_POSITION :rightPosition  right)
    (setq label (put disp :label (XmCreateLabel form001 "label" (X-arglist) 0)))
    (set-values label :resizable 0
      :topAttachment    XmATTACH_POSITION :topPosition   top
      :leftAttachment   XmATTACH_POSITION :leftPosition  left
      :rightAttachment  XmATTACH_POSITION :rightPosition right
      :labelString (XmString title))
    (manage label)
  )
)

(defun max-matrix(mtx) ;; 400x20,000 smp is OK 1,2,3,4,5 not start from 0!!!
  (let ((mx)(ch)(tm)(mx)(x)(y))
    (setq mtx (map-matrix mtx #'abs))
    (setq mx (apply #'max (matrix-extent mtx)))
    (setq mtx (map-matrix mtx #'/ mx))
    (setq mtx (map-matrix mtx #' floor)); 1 or 0
    (gc)
    (setq y (array-dimension mtx 0));channel
    (setq y (transpose (ruler-vector 1 y y)))
    (setq y (* y mtx))
    (setq ch (second (matrix-extent y))) 
    (gc)
    (setq x (array-dimension mtx 1));time
    (setq x (ruler-vector 1 x x))
    (setq x (* mtx x))
    (setq tm (second (matrix-extent x)))
    (gc)
    (return (list mx (round ch)(round tm)))
  )
)

(defun max-matrix2(mtx) ;;400x60,000 smp is OK
  (let ((mx)(ch)(tm)(z)(k))
    (setq mtx (map-matrix mtx #'abs))
    (setq mx (apply #'max (matrix-extent mtx)))
    (setq mtx (map-matrix mtx #'/ mx))
    (setq mtx (map-matrix mtx #' floor)); 1 or 0
    (setq ch 0 k 0.0)
    (setq z (row ch mtx))
    (setq k (apply #'max (matrix-extent z)))
    (while (= k 0.0)
      (setq z (row ch mtx))
      (setq k (apply #'max (matrix-extent z)))
      (inc ch)
      (gc))
    (setq tm 0 k 0.0)
    (while (= k 0.0)
      (setq k (vref z tm))
      (inc tm))
    (return (list mx ch tm))
  )
)

(defun max-matrix-verify()
  (let ((mtx)(x)(y)(z)(q))
    (setq x 30000  y 400)
    (setq mtx (map-matrix (random-matrix x y) #'/ (pow 2 31))) 
    (setq q (max-matrix  mtx))
    (setq z (row (1- (second q)) mtx))
    (setq z (vref z (1- (third q))))
    (print (- (first q) z))
  )
)

(defun memo-add(memo str)
  (let ((str0))
    (setq str0 (XmTextGetString memo))
    (if (> (length str0) 0)
      (setq str (format nil "~a~%~a" str0 str)))
    (XmTextSetString memo str)
  )
)

(defun memo-add-list(memo LL)
  (let ((str0)(str)(L)(t0)(span)(ch)(chname)(tm)(amp)(n))
    (setq str0 "")
    (dolist (L LL)
      (setq t0 (first L) span (second L) ch (third L) tm (fourth L) amp (fifth L))
      (setq chname (format nil "~a" (string-trim "MEG " (get-property (G-widget "gra") ch :name))))
      (setq str (format nil "~0,4f  ~0,4f  MEG~a  ~0,4f  ~0,1f" t0 span chname tm amp))
      (if (> (length L) 5)(progn
        (setq n 5)
        (while (< n (length L))
          (setq str (format nil "~a ~a" str (nth n L)))
          (setq n (1+ n)))))
      (if (string-equal str0 "")(setq str0 str)
        (setq str0 (format nil "~a~%~a" str0 str)))
    )
    (memo-add memo str0)
  )
)

(defun memo-delete-nil(memo)
  (let ((n)(str)(str0)(strm)(L)(LL)(LS nil)(N))
    (setq str0 (XmTextGetString memo))
    (setq LL (get-list-memo memo))
    (setq N (append (second LL) (list 9999999)))
    (setq LL (first LL))
    (setq strm (make-string-input-stream str0))
    (setq LS (get-list-string-memo memo))
    (setq str "")
    (dotimes (n (length N))
      (setq L (nth n LL))
       (if (> (length L) 4)
        (if (and (numberp (first L))(numberp (second L))
          (numberp (fourth L))(numberp (fifth L)))(progn
            (setq str0 (format nil "~a" (third L)))
            (setq str0 (string-trim " 1234567890" str0))
            (if (string-equal str0 "MEG")
              (if (string-equal str "")(setq str (nth n LS))
                (setq str (format nil "~a~%~a" str (nth n LS)))))))))
    (XmTextSetString memo str)
  )
)

(defun memo-insert(str)
  (let ((str0)(str1)(str2)(strm)(n)(N)(pos)(L)(m))
    (setq str0 (XmTextGetString nmemo))
    (setq strm (make-string-input-stream str0))
    (setq N (get-string-return str0))
    (setq N (append N (list 99999999)))
    (setq n 0)
    (setq pos (XmTextGetInsertionPosition nmemo))
    (while (> pos (nth n N))(setq n (1+ n)))
    (dotimes (m (length N))
      (setq str2 (read-line strm))
      (if (string-equal str2  "nil")(setq str2 ""))
      (if (= m n)(setq str2 (format nil "~a ~a" str2 str)))
      (if (= m 0)(setq str1 str2)(progn
        (if (> (length str2) 0)
        (setq str1 (format nil "~a~%~a" str1 str2))))))
    (setq str1 (string-left-trim "nil" str1))
    (XmTextSetString nmemo str1)
  )
)

(defun memo-note()
  (let ((w)(gra)(t0)(span)(mtx)(x)(chname)(amp)(tm)(str))
    (setq w (G-widget "disp001"))
    (setq gra (G-widget "gra"))
    (setq t0 (resource w :selection-start) span (resource w :selection-length))
    (if (> span 0)(progn
      (setq mtx (get-data-matrix gra (x-to-sample gra t0)(x-to-sample gra span)))
      (setq x (max-matrix mtx))
      (setq chname (get-property gra (second x) :name))
      (setq chname (string-trim "MEG " chname))
      (setq amp (* (first x) 1e+13))
      (setq tm (1- (third x)))
      (setq tm  (+ (* tm (resource gra :x-scale)) t0))
      (setq str (format nil "~0,4f  ~0,4f  MEG~a  ~0,4f  ~0,1f" t0 span chname tm amp))
      (memo-add nmemo str)));; ~% must be omitted!
  )
)

(defun memo-sort(str)
  (let ((LL)(N)(STR)(str0)(str1)(str2)(K nil)(Korder)(n))
    (memo-delete-nil nmemo);;delete nil row
    (setq str0 (XmTextGetString nmemo))
    (setq LL (get-list-memo nmemo))
    (setq N  (second LL))
    (setq N (append N (list 99999999)))
    (setq LL (first LL))
    (if (string-equal str "amplitude")(setq K (memo-sort-transpose LL 4)))
    (if (string-equal str "time"     )(setq K (memo-sort-transpose LL 0)))
    (if (string-equal str "sensor"   )(setq K (memo-sort-transpose2 LL 2)))
    (setq Korder (sort-order K))
    ;(setq K      (sort K))
    (if (string-equal str "amplitude")(setq Korder (reverse Korder)))
    (print Korder)

    (setq LL nil)
    (setq strm (make-string-input-stream str0))
    (dotimes (n (length N))
      (setq LL (append LL (list (read-line strm)))))
    (setq str1 "")
    (dotimes (n (length LL))
      (setq str2 (nth (nth n Korder) LL))
      (if (string-equal str1 "")(setq str1 str2)
        (setq str1 (format nil "~a~%~a" str1 str2))))
    (XmTextSetString nmemo str1)
  )
)

(defun memo-sort-transpose(LL n)
  (let ((m)(K nil))
    (dotimes (m (length LL))
      (setq K (append K (list (nth n (nth m LL))))))
    (return K)
  )
)

(defun memo-sort-transpose2(LL n)
  (let ((m)(K nil)(str))
    (dotimes (m (length LL))
      (setq str (format nil "~a" (nth n (nth m LL)))); symbol->string
      (setq str (string-trim "MEG " str))
      (setq K (append K (list (read-from-string str)))))
    (return K)
  )
)

(defun memo-text-load()
  (let ((filename)(fid)(str)(x))
    (setq filename (resource (G-widget "file"):filename))
    (if (not filename)(format nil "No file is selected")
      (progn
        (setq filename (format nil "~a-wave.txt" (string-right-trim ".fif" filename) "-wave.txt"))
        (if (file-exists-p filename)
          (progn
            (setq str "")
            (setq fid (open filename :direction :input))
            (dotimes (i 1000)
              (setq x (read-line fid))
              (if (> (length x) 0)
                (if (string-equal str "")(setq str x)
                (setq str (format nil "~a~%~a" str x)))))     
            (close fid)
            (XmTextSetString nmemo str)))))
  )
)

(defun memo-text-save()
  (let ((filename)(fid)(str))
    (setq filename (resource (G-widget "file"):filename))
    (if (> (length filename) 4)
      (progn
        (setq filename (format nil "~a-wave.txt" (string-right-trim ".fif" filename)))
        (setq fid (open filename :direction :output :if-exists :supersede))
        (princ (XmTextGetString nmemo) fid)
        (close fid)
        (setq str (format nil "~a has been saved." filename))
        (info str)))
  )
)

(defun number-of-peaks()
  (let ((n)(mtx)(nsmp)(nch)(x-scale)(L nil)(k1)(k2)(gap)(x-scale)(t0)(gra)(x)(LL nil)(t1)(nch)(amp))
    (setq mtx (resource (G-widget "scan-source") :matrix))
    (setq x-scale (resource (G-widget "scan-source") :x-scale))
    (setq nsmp (array-dimension mtx 1))
    (setq nch  (array-dimension mtx 0))
    (dotimes (n nsmp)
      (setq L (append L (list (second (matrix-extent (column n mtx))))))
    )
    (setq k1 (reverse (sort L)))
    (setq k2 (reverse (sort-order L)))
    (setq gap (calc-gap))
    (setq gra (G-widget "gra"))
    (dotimes (n npeaks)
      (setq t0 (+ (* (nth n k2) x-scale) gap))
      (setq mtx (get-gra-matrix t0 x-scale))
      (setq x (max-matrix mtx))
      (setq t1 (* (1- (third x))(resource (G-widget "buf"):x-scale)))
      (setq t1 (+ t1 t0))
      (setq nch (1- (second x)))
      (setq amp (* (first x) 1e+13))
      (setq LL (append LL (list (list t0 x-scale nch t1 amp)))))
    (memo-add-list nmemo  LL)
  )
)


(defun rgb-color(r g b)
  (+ (* (+ (* r 256) g) 256) b)
)

(defun run() 
  (let ((filename));;filename is tagert fiff file
    (open-diskfile filename)
    (set-default-display))
)

(defun scan-focus()
  (let ((n)(w)(w1)(t0)(span)(t1)(disp))
    (setq w (G-widget "scan-disp2"))
    (setq span (resource (G-widget w) :length))
    (if (< span 0.5)(progn
      (setq t0 (resource (G-widget "win-peak2") :point))
      (setq span2 (read-from-string (XmTextGetString text002))) 
      (setq t1 (+ t0 (/ span 2)))
      (setq t1 (- t1 (/ span2 2)))
      (XmTextSetString text001 (format nil "~0,2f" t1))
      (set-resource (G-widget "disp001") :selection-start t0 :selection-length span))))
      (sync-selection-3 (G-widget "disp001"))
  )
)

(defun scan-max()
  (let ((x-scale)(t0)(t1)(t2)(T1)(T2)(x)(mtx)(MTX nil)(count)(tt)(str99)(str97)(nch))
    (if (G-widget "scan-disp" :quiet)(delete-memo))
    (setq x-scale (resource (G-widget "buf") :x-scale)) 
    (setq t0 (* (resource (G-widget "buf") :low-bound) x-scale))
    (setq tend (* (resource (G-widget "buf") :high-bound) x-scale))
    (setq nn (round (ceil (/ (- tend t0) stepwise))))
    ;(setq nn (1- nn))
    (setq swin (require-widget :data-window "swin"))
    (setq meg8 (list "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF")); "gra"));for max check
    (setq nch (length meg8))
    (change-coil "gra")
    (setq count 0)
    (dolist (seg  meg8)
      (unless (longworking "scanning...." count 8)(error "interrupted"))
      (link (G-widget seg) swin)
      (setq t1 t0)
      (setq mtx nil)
      (set-resource swin :start 0 :end stepwise)
      (dotimes (n nn)
        (set-resource swin :point t1)
        (setq t2 (+ t1 stepwise))
        (setq T1 (resource swin :low-bound))
        (setq T2 (resource swin :high-bound))
        (setq x (matrix-extent (get-data-matrix swin T1 T2)))
        (setq x (apply #'max (mapcar #'abs x)))
        (setq x (* x 1e+13))
        (setq mtx (append mtx (list x)))
        (setq t1 t2))
      (inc count)
      (setq MTX (append MTX (list mtx))))
    (longworking "done" nch nch)
    (GtDeleteWidget (G-widget "swin"))
    (setq src (require-widget :matrix-source "scan-source"))
    (setq MTX (matrix MTX))
    (set-resource src :matrix MTX :x-scale stepwise :x-unit "s")
    ;(setq gap (* (resource (G-widget "buf") :low-bound)(resource (G-widget "buf") :x-scale)))
    ;(setq delay (require-widget :delay "delay"))
    ;(set-resource delay :delay gap)
    ;(link src delay)  ;;to be improved in the future!
    (setq str99 (XmTextGetString memo0))
    (setq str97 (XmTextGetString memo2))
    (delete-memo)
    (create-memo)
    (XmTextSetString memo0 str99)
    (XmTextSetString memo2 str97)
    (link src scan-disp)
    (GtPopupEditor scan-disp)
    (dotimes (n nch)(set-property scan-disp n :name (nth n meg8)))
    (setq MTX (resource (G-widget "scan-source") :matrix));MTX seems disappear!
    (setq tt (* (array-dimension MTX 1) stepwise))
    (set-resource scan-disp :point 0)
    (set-resource scan-disp :length tt)
    (setq tt (apply #'max (mapcar #'abs (matrix-extent MTX))))
    (set-resource scan-disp :scales (make-matrix nch 1 (/ tt 1.8)))
    (scan-max-dispcolor)
  )
)

(defun scan-max-dispcolor()
  (let ((n)(w1)(w2)(nch))
    (setq w1 (G-widget "scan-disp") w2 (G-widget "disp001"))
    (setq nch (resource w1 :channels))
    (set-resource w1 :select-hook '(scan-select-hook))
    (set-resource w1 :ch-label-space 40 :offsets (make-matrix nch 1 0.9))
    (dotimes (n 2) 
      (set-resource w1 :default-color  (resource w2 :default-color))
      (set-resource w1 :background     (resource w2 :background))
      (set-resource w1 :highlight      (resource w2 :highlight))
      (set-resource w1 :baseline-color (resource w2 :baseline-color))
      (setq w1 (G-widget "scan-disp2") w2 (G-widget "disp001"))) 
  )
)

(defun scan-select-hook()
  (let ((w)(w0)(w1)(w2)(buf)(t0)(tspan)(t1)(t2)(span)(gap)(mtx)(x)(nch)(smp)(span2))
    (setq w  (G-widget "scan-disp"))
    (setq buf (G-widget "buf"))
    (setq w2 (G-widget "scan-disp2"))
    (setq span (read-from-string (XmTextGetString text002)))
    (setq gap (* (resource buf :x-scale)(resource buf :low-bound)))
    (setq t0    (resource w :selection-start))
    (setq t1 (+ t0 gap))
    (setq tspan (resource w :selection-length))
    (setq t2 (- t1 (/ span 2)))
    (XmTextSetString text001 (format nil "~0,2f" t2))
    (GtUnlinkWidget w2)
    (if (> tspan 0.0)(progn
      (setq w0 (G-widget "scan-source"))
      (setq mtx (get-data-matrix w0 (x-to-sample w0 t0)(x-to-sample w0 tspan)))
      (gc)
      (setq x (second (matrix-extent mtx)));fT/cm
      (setq x (* x 1e-13))
      (setq w1 (G-widget "win-peak2"))
      (setq nch (resource w1 :channels))
      (set-resource w1 :point t1 :start 0 :end tspan)
      (if (> tspan 20)
        (progn
          (link w1 w2)
          (set-resource w2 :scales (make-matrix nch 1 x))
          (set-resource w2 :point 0 :length tspan))
        (progn
          (setq mtx (get-data-matrix w1 0 (resource w1 :high-bound)))
          (gc)
          (setq x (max-matrix mtx))
          (set-resource w2 :scales (make-matrix nch 1 (first x)))
          (setq smp (third x))
          (setq t1 (+ t1 (* (1- smp)(resource buf :x-scale))))
          (setq span2 (read-from-string (XmTextGetString text97)))
          (setq t1 (- t1 (/ span2 2)))
          (set-resource w1 :point t1 :end span2)
          (link w1 w2)
          (set-resource w2 :point 0 :length span2)))))
  )
)
      
(defun scan-select-hook_old()
  (let ((w)(w1)(t0)(tspan)(t1)(t2)(span)(gap)(mtx)(x)(nch))
    (setq w  (G-widget "scan-disp"))
    (setq w1 (G-widget "buf"))
    (setq t0    (resource w :selection-start))
    (setq tspan (resource w :selection-length))
    (if (> tspan 0)(setq t0 (+ t0 (/ tspan 2))))
    (setq span (read-from-string (XmTextGetString text002)))
    (setq t1 (- t0 (/ span 2)))
    (setq gap (* (resource w1 :low-bound)(resource w1 :x-scale)))
    (setq t2 (+ t1 gap))
    (XmTextSetString text001 (format nil "~0,2f" t2))

    (setq w  (G-widget "win-peak2"))
    (setq w1 (G-widget "scan-disp2"))
    (setq tspan (read-from-string (XmTextGetString text97)))
    (set-resource w :point (- t1 (/ tspan)) :end tspan)
    (link (G-widget "meg") w)
    (link w w1)
    (set-resource w1 :point 0 :length tspan)
    (setq mtx (get-data-matrix w 0 (resource w :high-bound)))
    (setq x (apply #'max (mapcar #'abs (matrix-extent mtx))))
    (setq nch (resource w :channels))
    (set-resource w1 :scales (make-matrix nch 1 x))))
    )
)

(defun scan-zoom(n)
  (let ((t1)(t2)(w)(w1))
    (setq w (G-widget "scan-disp"))
    (if (equal n 0) 
      (progn
        (setq w1 (G-widget "scan-source"))
        (setq t1 0 t2 (array-dimension (resource w1 :matrix) 1))
        (setq t2 (* t2 (resource w1 :x-scale)))
        (set-resource w :point t1 :length t2 :selection-start -1 :selection-length -1))
      (progn 
        (setq t1 (resource w :selection-start) t2 (resource w :selection-length))
        (if (> t2 0)(set-resource w :point t1 :length t2 :selection-start -1 :selection-length -1))))
  )
)

(defun select-sensors(snsno);use ch_dist() near_coil() 
  (let ((n)(sns)(snss)(str "MEG[")(str1)(nummber-of-sensors))
    (setq str1 (XmTextGetString nsensor-text))
    (setq n (read-from-string str1))
    (if (not (numberp n))
      (progn (info "number of sensors is set to be 30!")(setq n 30)))
    (if (and (< n 4)(> n 102))
      (progn (info "number of sensors is set to be 30!")(setq n 30)))
    (setq number-of-sensors n)
    (setq snsno (format nil "~a" snsno));string
    (setq snsno (string-left-trim "MEG " snsno))
    (setq snsno (/ (read-from-string snsno) 10))
    (setq snsno (round (floor snsno)))
    (dotimes (n (length near_coil))
      (if (equal snsno (nth 0 (nth n near_coil)))
        (setq snss (nth n near_coil))))
    (dotimes (n number-of-sensors)
      (setq sns (nth n snss))
      (setq str1 (format nil "~a1 ~a2 ~a3" sns sns sns))
      (setq str (format nil "~a ~a" str str1)))
    (set-resource (G-widget "meg-sel") :names (list (format nil "~a]" str)))
  )
)



(defun set-default-display()
  (change-coil "gra")
  (change-leads "banana")
)

(defun set-eegchname()
  (let ((n)(nch))
    (setq nch (resource (G-widget "EEGs") :channels))
    (dotimes (n nch)(set-property (G-widget "EEGs") n :name (nth n EEG-channels)))
  )
)

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
    (return R))
)

(defun sort2(xlist)
  (let ((N)(xmin)(x nil)(xx nil))
    (dotimes (i (length xlist))(setq xx (append xx (list (nth i xlist)))))
    (setq N (length xx))
    (while (> N 0)
      (setq xmin (apply #'min xx))
      (setq xx (delete xmin xx))
      (setq N (length xx))
      (setq x (append x (list xmin))))
    (return x))
)

(defun sort-order(xlist)
  (let ((xx (sort2 xlist))(x nil)(R nil))
    (dotimes (i (length xx) R)
      (setq x (nth i xx))
      (dotimes (j (length xlist))
        (if (equal x (nth j xlist))(setq R (append R (list j))))))
    (return R))
)

(defun sync-selection-3(disp)
  (let ((p0)(span)(disps (list "disp001" "disp002" "disp003" "disp004" "disp005" "disp006" "disp007" "disp008" "disp009"))(n)(w)(mtx)(nch))
    (setq p0   (resource (G-widget disp) :selection-start))
    (setq span (resource (G-widget disp) :selection-length))
    (dolist (n disps)(if (not (equal disp n))
      (set-resource (G-widget n) :selection-start p0 :selection-length span)))
    (if (> span 0)(progn
      (setq w (G-widget "meg"))
      (set-resource (G-widget "win-peak") :point p0 :start 0 :end span)
      (link (G-widget "win-peak")(G-widget "disp-peak"))
      (set-resource (G-widget "disp-peak") :point 0 :length span)
      (setq w (G-widget "win-peak"))
      (setq mtx (get-data-matrix w 0 (x-to-sample w span)))
      (setq n (matrix-extent mtx))
      (setq n (apply #'max (mapcar #'abs n)))
      (setq nch (resource w :channels))
      (set-resource (G-widget "disp-peak") :scales (make-matrix nch 1 n)))) 
  )
)

(defun sync-selection-4()
  (let ((n)(p0)(p1)(span))    
    (setq p1   (resource (G-widget "win-peak") :point))
    (setq p0   (resource (G-widget "disp-peak") :selection-start))
    (setq span (resource (G-widget "disp-peak") :selection-length))
    (dotimes (n 9)
      (set-resource (G-widget (format nil "disp00~d" (1+ n))) :selection-start (+ p1 p0) :selection-length span))
  )
)

(defun sync-view-3(disp)
  (let ((p0)(p1)(span)(n)(disp001 (G-widget "disp001")))
    (setq p0   (resource (G-widget disp) :point))
    (setq span (resource (G-widget disp) :length))
    (setq p0   (/ (round (* p0 100)) 100))
    (setq span (/ (round (* span 100)) 100))
    (XmTextSetString text001 (format nil "~0,2f" p0))
    (XmTextSetString text002 (format nil "~0,2f" span))
    (dotimes (n 9)
      (set-resource (G-widget (format nil "disp00~d" (1+ n))) :point p0 :length span))
  )
)

(progn
  (if (G-widget "display" :quiet)(GtDeleteWidget (G-widget "display")))
  ;(initialize);; it does not compatible with GtDeleteWidget & this code.  Execute separetely!
)
