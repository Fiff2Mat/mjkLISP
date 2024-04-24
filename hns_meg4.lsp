(defun add-parameter(top left)
  (let ((n)(frame001)(frame002)(frame001-label)(frame002-label)(label001)(label002)(label003)(label004)(label005)(label006)(label007)(radiobox001)(radiobox002));(form002)(form003))
    (setq top 70 left 80)
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
      :labelString (XmString "stepwise sorting") :childType XmFRAME_TITLE_CHILD))   
    (setq form003 (make-form frame002 "form003"))
    (dolist (n (list pane001 frame001 frame001-label frame002 frame002-label form002 form003))(manage n))
    ;;MEG
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
    ;;EEG/ECG/EOG
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
    ;;stepwise sorting
    (setq radiobox101 (XmCreateRadioBox form003 "radiobox101" (X-arglist) 0))
    (set-values radiobox101 :leftAttachment XmATTACH_FORM :topAttachment XmATTACH_FORM :numColumns 3)
    (setq stepwise1 (XmCreateToggleButtonGadget radiobox101 "0.5 sec" (X-arglist) 0))
    (setq stepwise2 (XmCreateToggleButtonGadget radiobox101 "1.0 sec" (X-arglist) 0))
    (setq stepwise3 (XmCreateToggleButtonGadget radiobox101 "2.0 sec" (X-arglist) 0))
    (set-values stepwise1 :set 1)
    (progn
    (setq button101 (make-button form003 "button101" :labelString (XmString "stepwise scan")
      :topAttachment XmATTACH_WIDGET :topWidget radiobox101))
    (manage button101)
    )
    (dolist (n (list stepwise1 stepwise2 stepwise3 radiobox101))(manage n))
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
    (setq disps (list "disp001" "disp002" "disp003" "disp004" "disp005" "disp006" "disp007" "disp008" "disp009"))
    (if (G-widget "scan-disp" :quiet)(setq disps (append disps (list "scan-disp"))))
    (if (string-equal col  "black")
      (dotimes (n (length disps))
        (set-resource (G-widget (nth n disps)) :default-color "black" :background "white" :highlight "gray80" :baseline-color "gray80"))
      (dotimes (n 9)
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

(defun create-memo()
  (let ((n))
    (setq form99 (make-form-dialog *application-shell* "form99" :autoUnmanage 0))
    (set-values form99 :resize 1)
    (setq frame99 (make-frame form99 "frame99" :resize 1
      :topAttachment XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_POSITION :leftPosition 70
      :rightAttachment XmATTACH_FORM))
    (setq memo99 (make-scrolled-text frame99 "memo99" :editMode XmMULTI_LINE_EDIT))
    (set-values memo99 :editMode XmMULTI_LINE_EDIT :rows 20 :columns 30)
    (set-values memo99 :bottomAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM)
    (setq memo98 (make-scrolled-text form99 "memo98" 
      :editMode XmMULTI_LINE_EDIT :rows 13 :columns 30));;the height of controls of plotter
    (setq text99 (XmCreateText form99 "text99" (X-arglist) 0))
    (set-values text99 :topAttachment XmATTACH_WIDGET :topWidget memo98
      :rightAttachment XmATTACH_WIDGET :rightWidget frame99
      :columns 18 :marginHeight 1);; equals the controls of the plotter!
    (dolist (n (list form99 frame99 memo99 memo98 text99))(manage n))
    (setq text98 (XmCreateText form99 "text98" (X-arglist) 0))
    (set-values text98
      :topAttachment   XmATTACH_WIDGET :topWidget text99 ;:leftAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_WIDGET :rightWidget text99)
    (dolist (n (list form99 frame99 memo99 memo98 text99 text98))(manage n))
    (if (G-widget "scan-disp" :quiet)(GtDeleteWidget (G-widget "scan-disp")))
    (setq scan-disp (GtMakeObject 'plotter :name "scan-disp" :point 0.0 :length 10 
      :display-parent form99  :scroll-parent form99 :ch-label-space 80 :no-controls nil))
    (put scan-disp :display-form form99)
    (GtPopupEditor scan-disp)
    (setq dispw (resource (G-widget "scan-disp") :display-widget))
    (set-values dispw :resize 1
     :topAttachment   XmATTACH_FORM  :bottomAttachment XmATTACH_FORM 
     :leftAttachment  XmATTACH_FORM
     :rightAttachment XmATTACH_POSITION :rightPosition 70)
    (setq frame98 (make-frame form99 "frame98" :resize 1
      :topAttachment XmATTACH_WIDGET :topWidget memo98 
      :leftAttachment XmATTACH_WIDGET :leftWidget text98 
      :rightAttachment XmATTACH_WIDGET :rightWidget frame99 
      :bottomAttachment XmATTACH_FORM))
    (manage frame98)
    (setq form98 (make-form frame98 "form98"))
    (manage form98)
    (setq text97 (XmCreateText form98 "text97" (X-arglist) 0))
    (set-values text97
      :bottomAttachment XmATTACH_FORM
      :leftAttachment   XmATTACH_POSITION :leftPosition 50
      :rightAttachment  XmATTACH_FORM)
    (manage text97)
    (setq button99 (make-button form98 "button99" :labelString (XmString " FIT ")
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text97))
    (manage button99)
    (if (G-widget "scan-disp2" :quiet)(GtDeleteWidget (G-widget "scan-disp2")))
    (setq scan-disp2 (GtMakeObject 'plotter :name "scan-disp2" :point 0.0 :length 0.1 
      :display-parent form98  :scroll-parent form98 :ch-label-space 0 :no-controls t))
    (put scan-disp2 :display-form form98)
    (GtPopupEditor scan-disp2)
    (setq dispw (resource (G-widget "scan-disp2") :display-widget))
    (set-values dispw :resize 1
      :topAttachment    XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM
      :bottomAttachment XmATTACH_WIDGET :bottomWidget button99)
  )
)

(defun delete-memo()
  (if (G-widget "scan-disp" :quiet)(GtDeleteWidget (G-widget "scan-disp")))
  (if (G-widget "scan-disp2" :quiet)(GtDeleteWidget (G-widget "scan-disp2")))
  (XtDestroyWidget form99)
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

(defun create-widgets()
  (let ((w)(widget-name)(n)(gw)(L1)(L2))
    (progn
    (setq widget-name (list "buf" "MEG" "EEGs" "EEG1" "EEG2" "fsub" "sel" "MEG-fil" "EEG-fil" "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (dolist (w widget-name)(if (G-widget w :quiet)(GtDeleteWidget (G-widget w))))
    (GtMakeObject 'ringbuffer :name "buf" :size 5000000)
    (GtMakeObject 'pick :name "MEG" :names '("MEG*"))
    (GtMakeObject 'fft-filter :name "MEG-fil" :pass-band '(band-pass 3 35))
    (setq L1 (list "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (setq L2 (list gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal))
    (dotimes (n 8)(progn
      (setq gw (GtMakeObject 'pick :name (nth n L1) :names (nth n L2)))
      (link (G-widget "MEG-fil") gw)
      (link gw (G-widget (format nil "disp00~d" (1+ n))))))
    (GtMakeObject 'pick :name "EEGs" :names '("EEG*" "ECG*" "EOG*"))
    (GtMakeObject 'pick :name "EEG1")
    (GtMakeObject 'pick :name "EEG2")
    (GtMakeObject 'binary :name "fsub" :function 'fsub)
    (GtMakeObject 'selector :name "sel")
    (GtMakeObject 'fft-filter :name "EEG-fil" :pass-band '(band-pass 0.5 50))
    (link (G-widget "file")(G-widget "buf"))
    (link (G-widget "buf")(G-widget "MEG"))
    (link (G-widget "MEG")(G-widget "ssp"))
    (link (G-widget "ssp")(G-widget "MEG-fil"))
    (link (G-widget "buf")(G-widget "EEGs"))
    (link (G-widget "EEGs")(G-widget "EEG1"))
    (link (G-widget "EEGs")(G-widget "EEG2"))
    (link (G-widget "EEG1")(G-widget "fsub"))
    (link (G-widget "EEG2")(G-widget "fsub"))
    (link (G-widget "fsub")(G-widget "sel"));tentative!
    (link (G-widget "sel")(G-widget "EEG-fil"))
    (link (G-widget "EEG-fil")(G-widget "disp009"))
    (GtOrganizePanel)
    )
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
)

(defun define-texts()
  (let ((n)(texts)(values))
    (setq texts  (list text001 text002 text003 text004 text005 text006 text007 text008 text009))
    (setq values (list "0.00" "10.00" "500" "3000" "(band-pass 3 35)" "100" "1000" "100" "(band-pass 0.5 50)"))
    (dotimes (n (length texts))(XmTextSetString (nth n texts)(nth n values)))
    (defparameter gra-scale text003)
    (defparameter mag-scale text004)
    (defparameter eeg-scale text006)
    (defparameter ecg-scale text007)
    (defparameter eog-scale text008)
  )
)

(defun initialize()
  (let ((x1 49)(x2 98)(n))
    (setq form001 (make-form *main-window* "form001"))
    (make-subplotter "disp001"   0  x1   0  20  "L-temporal")
    (make-subplotter "disp002"   0  x1  20  40  "L-parietal")
    (make-subplotter "disp003"   0  x1  40  60  "L-occipital")
    (make-subplotter "disp004"   0  x1  60  80  "L-frontal")
    (make-subplotter "disp005"  x1  x2   0  20  "R-temporal")
    (make-subplotter "disp006"  x1  x2  20  40  "R-parietal")
    (make-subplotter "disp007"  x1  x2  40  60  "R-occipital")
    (make-subplotter "disp008"  x1  x2  60  80  "R-frontal")
    (make-subplotter "disp009"   0   70  80 100  "EEG ECG EOG")  
    (set-values (resource (G-widget "disp001") :scroll-widget)
      "resizable" 1
      :topAttachment    XmATTACH_POSITION :topPosition     x2
      :bottomAttachment XmATTACH_POSITION :bottomPosition 100
      :leftAttachment   XmATTACH_POSITION :leftPosition     0
      :rightAttachment  XmATTACH_POSITION :rightPosition   80)
    (require 'ssp)
    (require 'xfit)
    (manage form001);;This must be here!
    (define-parameters)
    (create-widgets)
    (add-parameter 70 80)
    (define-texts)
    (assign-callback)
    (create-memo)
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

(defun rgb-color(r g b)
  (+ (* (+ (* r 256) g) 256) b)
)

(defun run() 
  ;!!SAMPLE Define target Fiff file inserting patient_name/date/epilepsy1.fif
  (initialize)
  (open-diskfile  "/data/neuro-data/ns/patient_name/date/epilepsy1.fif")
  (change-coil "gra")
  (change-leads "banana")
)

(defun scan-max()
  (let ((x-scale)(t0)(t1)(t2)(T1)(T2)(x)(mtx)(MTX nil))
    (setq x-scale (resource (G-widget "buf") :x-scale)) 
    (setq t0 (* (resource (G-widget "buf") :low-bound) x-scale))
    (setq tend (* (resource (G-widget "buf") :high-bound) x-scale))
    (setq nn (round (ceil (/ (- tend t0) stepwise))))
    ;(setq nn (1- nn))
    (setq swin (require-widget :data-window "swin"))
    (setq meg8 (list "LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (change-coil "gra")
    (dolist (seg  meg8)
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
        (setq mtx (append mtx (list (max (abs (first x))(abs (second x))))))
        (setq t1 t2))
      (setq MTX (append MTX (list mtx))))
    ;(print (matrix MTX))
    (GtDeleteWidget (G-widget "swin"))
    (setq src (require-widget :matrix-source "scan-source"))
    (set-resource src :matrix (matrix MTX))
    ;(setq scan-disp (require-widget :plotter "scan-disp"))
    (link src scan-disp)
    (GtPopupEditor scan-disp)
    (dotimes (n 8)(set-property scan-disp n :name (nth n meg8)))
    (set-resource scan-disp :ch-label-space 40 :offsets (make-matrix 8 1 0.9))
    (set-resource scan-disp :x-scale stepwise :x-unit "s")
    (set-resource scan-disp :default-color  (resource (G-widget "disp001") :default-color))
    (set-resource scan-disp :background     (resource (G-widget "disp001") :background))
    (set-resource scan-disp :highlight      (resource (G-widget "disp001") :highlight))
    (set-resource scan-disp :baseline-color (resource (G-widget "disp001") :baseline-color))
    (set-resource scan-disp :select-hook '(scan-select-hook))
  )
)

(defun scan-select-hook()
  (let ((w)(w1)(t0)(t1)(span)(gap))
    (setq w  (G-widget "scan-disp"))
    (setq w1 (G-widget "buf"))
    (setq t0 (+ (resource w :selection-start)(/ (resource w :selection-length) 2)))
    (setq span (read-from-string (XmTextGetString text002)))
    (setq t1 (- t0 (/ span 2)))
    (setq gap (* (resource w1 :low-bound)(resource w1 :x-scale)))
    (setq t1 (+ t1 gap))
    (XmTextSetString text001 (format nil "~0,2f" t1))
  )
)

(defun set-eegchname()
  (let ((n)(nch))
    (setq nch (resource (G-widget "EEGs") :channels))
    (dotimes (n nch)(set-property (G-widget "EEGs") n :name (nth n EEG-channels)))
  )
)

(defun sync-selection-3(disp)
  (let ((p0)(span)(disps (list "disp001" "disp002" "disp003" "disp004" "disp005" "disp006" "disp007" "disp008" "disp009"))(n))
    (setq p0   (resource (G-widget disp) :selection-start))
    (setq span (resource (G-widget disp) :selection-length))
    (dolist (n disps)(if (not (equal disp n))
      (set-resource (G-widget n) :selection-start p0 :selection-length span)))
  )
)

(defun sync-view-3(disp)
  (let ((p0)(span)(n)(disp001 (G-widget "disp001")))
    (setq p0   (resource (G-widget disp) :point))
    (setq span (resource (G-widget disp) :length))
    (setq p0   (/ (round (* p0 100)) 100))
    (setq span (/ (round (* span 100)) 100))
    (XmTextSetString text001 (format nil "~0,2f" p0))
    (XmTextSetString text002 (format nil "~0,2f" span))
    (dotimes (n 8)
      (set-resource (G-widget (format nil "disp00~d" (+ n 2))) :point p0 :length span))
  )
)

(progn
  (if (G-widget "display" :quiet)(GtDeleteWidget (G-widget "display")))
  ;(initialize);; it does not compatible with GtDeleteWidget & this code.  Execute separetely!
)
