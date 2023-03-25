;;
;;   hns_meg  for epilepsy analysis
;;   
;;   Coding since 2023-Jan-5 by Akira Hashizume
;;   Releaesd on 2023-Mar-25
;;   This code shall be reloaded twice for establish xfit or ssp functions. 
;;
;;  /opt/neuromag/setup/cliplab/Deflayouts.xxx should be devised for comfortable use.

(defvar this-filename "/home/neurosurgery/lisp/hns_meg3"); "rewrite tihs value for each site)
(defvar this-directory "neuro/data/ns/*.fif" "default file directory to be load fif file")
(defvar waves-name (list "discharge" "spike" "polyspike" "burst" "ictal onset" "EEG spike" "physiological activities" "noise" "???"));; add terms accoriding to user's analysis policy


(defun calc_near_coil()
  (let ((R nil)(dist)(x)(xx))
    (dotimes (i (length ch_dist))
      (setq dist (nth i ch_dist))
      (setq x (sort-order dist))
      (setq xx nil)
      (dolist (j x)
        (setq xx (append xx (list (nth j chname)))))
      (setq R (append R (list xx))))
    (return R))
)

(defun calc-noise-level()
  (let ((x (x-selection))(w (G-widget "meg"))(name)(data)(plannoise)(magnoise)(str)(pos))
    (if (not x)(error "select span!"))
    (setq pos (XmTextGetInsertionPosition my-text903))
    (if (> (resource (third x) :x-scale) 0.1)(error "select span!"));;to avoid scanning of (G-widget "plotter")
    (setq name (resource w :names))
    (set-resource w :names '("MEG*3" "MEG*2"))
    (setq data (get-data-matrix w (x-to-sample w (first x))(x-to-sample w (second x))))
    (setq data (map-matrix data #'abs))
    (setq planoise (/ (matrix-element-sum data)(* (array-dimension data 0)(array-dimension data 1))))
    (set-resource w :names '("MEG*1"))
    (setq data (get-data-matrix w (x-to-sample w (first x))(x-to-sample w (second x))))
    (setq data (map-matrix data #'abs))
    (setq magnoise (/ (matrix-element-sum data)(* (array-dimension data 0)(array-dimension data 1))))
    (set-resource w :names name)
    (XmTextSetInsertionPosition my-text903 99999)
    (setq planoise (* planoise 1e+13) magnoise (* magnoise 1e+15))
    (setq str (format nil "~%average noise level  ~0,1f fT/cm,  ~0,1f fT" planoise magnoise))
    (XmTextSetInsertionPosition my-text903 pos)
    (my-text-insert2 str)
    (return str))
)

(defun change-disp-color(num)
  (let ((disps)(default-color)(background)(highlight)(baseline-color))
    (setq disps (list (G-widget "disp1")(G-widget "disp2")(G-widget "disp3")(G-widget "disp4")(G-widget "disp5")))
    (when (G-widget "plotter" :quiet)(setq disps (append disps (list (G-widget "plotter")))))
    (if (= num 1)
      (setq default-color "white" background "black" highlight "white" baseline-color "white")
      (setq default-color "black" background "white" highlight "gray80" baseline-color "white"))
    (dolist (w disps)(set-resource w :default-color default-color :background background
                                     :highlight highlight :baseline-color baseline-color)))
)

(defun change-disp-color-menu()
  (let ((col (resource (G-widget "disp3") :default-color)))
    (if (string-equal col "white")(change-disp-color 2)(change-disp-color 1)))
)

(defun change-sensor-selection(sns)
  (let ((coil)(coils)(chname "abc")(snssets)(chnames)(n1)(n2))
    (setq snssets (list gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal 
                        gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal))
    (setq chnames (list "L-temporal" "R-temporal" "L-parietal" "R-parietal" 
                        "L-occipital" "R-occipital" "L-frontal" "R-frontal"))
    (setq coil (read-from-string (string-trim "MEG" sns)))
     (dotimes (i (length snssets))
      (setq coils (convert-gra-selections (nth i snssets)))
      (setq n1 (length coils))
      (setq n2 (length (delete coil coils)))
      (if (< n2 n1)(setq chname (nth i chnames))))
    (select-megch chname))
)

(defun change-start(x)
  (let ((w (G-widget "disp3"))(t0)(span))
    (setq t0 (resource w :point))
    (setq span (resource w :length))
    (setq t0 (+ t0 (* span x)))
    (set-resource w :point t0)
    (set-resource (G-widget "disp1") :point t0)
    (set-resource (G-widget "disp4") :point t0)
    (set-resource (G-widget "disp5") :point t0))
)

(defun convert-gra-selections(gras)
  (let ((str1)(str2)(x))
    (setq str1 (first gras))
    (setq str2 (second gras))
    (setq str1 (string-trim "]" (string-trim "MEG[" str1)))
    (setq str2 (string-trim "]" (string-trim "MEG[" str2)))
    (setq x (read-from-string (strm-append "(" str1 " " str2 ")")))
    (return x))
)

(defun create-disp903(dispname)
  (let ((w)(w1)(disp1 t))
    (setq w1 (G-widget dispname))
    (if (equal dispname "disp1")(setq disp1 nil))
    (when (not (G-widget "disp903" :quiet))(require-widget :plotter "disp903"))
    (setq w (G-widget "disp903"))
    (link (widget-source w1) w)
    (set-resource w :point (resource w1 :point) :length (resource w1 :length)
                    :scales (resource w1 :scales) :offsets (resource w1 :offsets)
                    :default-color (resource w1 :default-color) :background (resource w1 :background)
                    :highlight (resource w1 :highlight) :baseline-color (resource w1 :baseline-color)
                    :selection-start (resource w1 :selection-start)   :show-scales disp1
                    :selection-length (resource w1 :selection-length) :show-x-span t
                    :superpose (resource w1 :superpose) :ch-label-space (resource w1 :ch-label-space))
    (GtPopupEditor w))
)

(defun create-main-form()
  (let ((paneL)(paneR)(LR 45)(x 5)(xx 98))
    (manage *control-panel*)
    (setq form901 (make-form *main-window* "form901"));;<-global variants
    (set-values *main-window* "workwindow" form901)
    ;;LEFT WINDOW
    (setq paneL (XmCreatePanedWindow form901 "paneL" (X-arglist) 0))
    (set-values paneL
      "separatorOn"      0
      "sasHndent"        -1 "resize"          1
      "topAttachment"    x  "topPosition"     0
      "bottomAttachment" x  "bottomPosition" xx "bottomOffset"  0
      "leftAttachment"   x  "leftPosition"    0
      "rightAttachment"  x  "rightPosition"  LR)
    ;;RIGHT WINDOW
    (setq paneR (XmCreatePanedWindow form901 "paneR" (X-arglist) 0))
    (set-values paneR
      "separatorOn"      0
      "sasHndent"        -1 "resize"          1
      "topAttachment"    x  "topPosition"     0
      "bottomAttachment" x  "bottomPosition" xx "bottomOffset"  0
      "leftAttachment"   x  "leftPosition"   LR
      "rightAttachment"  x  "rightPosition" 100) 
    (create-subdisp paneL form901 "disp1" nil t)
    (create-subdisp paneL form901 "disp2" nil t) 
    (create-subdisp paneR form901 "disp3" nil nil)
    (create-subdisp paneR form901 "disp4" nil nil)
    (create-subdisp paneR form901 "disp5" nil nil);nil control panel
    (set-values (resource (G-widget "disp1") :scroll-widget)
      "resizable"        1
      "leftAttachment"   x "leftPosition"     0 
      "rightAttachment"  x "rightPosition"  100
      "topAttachment"    x "topPosition"     xx
      "bottomAttachment" x "bottomPosition" 100  "bottomOffset" -5)
    (set-resource (G-widget "disp1") :scroll-visible 1)
    (manage paneL)
    (manage paneR)  
    (manage form901)
    (XmjkUnmanageChild *control-panel*))
)

(defun create-my-memo()
  (let ((my-menu-bar903)(my-button903)(my-button904)(my-button905)(mybutton906)(mybutton907)(my-button908)
        (my-button909)(my-button910)(my-button911)(my-frame903)(my-frame-label903))
    (setq my-memo903 (make-form-dialog *application-shell* "my-memo" :autoUnmanage 0))
    (setq my-menu-bar903 (make-menu-bar my-memo903 "my-menu" 
                         :rightAttachment 1 :leftAttachment 1 :topAttachment 1))
    (setq my-button903 (make-button my-memo903 "btn1" :labelString (XmString " << ")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_FORM :leftWidget my-memo903 ))
    (setq my-button904 (make-button my-memo903 "btn2" :labelString (XmString " < ")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button903))
    (setq my-button905 (make-button my-memo903 "btn3" :labelString (XmString "goto")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button904))
    (setq my-button906 (make-button my-memo903 "btn4" :labelString (XmString " > ")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button905))
    (setq my-button907 (make-button my-memo903 "btn5" :labelString (XmString " >> ")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button906))
    (setq my-button908 (make-button my-memo903 "btn6" :labelString (XmString "full view")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button907))
    (setq my-button909 (make-button my-memo903 "btn7" :labelString (XmString " note ")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button908))
    (setq my-button910 (make-button my-memo903 "btn8" :labelString (XmString " fit ")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button909))
    (setq my-button911 (make-button my-memo903 "btn9" :labelString (XmString "note & fit")
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 0
                         :leftAttachment XmATTACH_WIDGET :leftWidget my-button910))
    (setq my-frame903 (make-frame my-memo903 "my-frame903"
                         :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903 :topOffset 20
                         :bottomAttachment 1 :leftAttachment XmATTACH_FORM
                         :rightAttachment 5 :rightPosition 100))
    (setq my-frame-label903 (make-label my-frame903 "my-frame-label903"
                         :labelString (XmString "")
                         :childType XmFRAME_TITLE_CHILD))   
    (setq my-text903 (make-scrolled-text my-frame903 "my-text903" 
                         :editMode XmMULTI_LINE_EDIT 
                         :rows 5 :columns 50))
    (XmTextSetString my-text903 "Hello World")
    (add-lisp-callback my-button903 "activateCallback" '(change-start -1))
    (add-lisp-callback my-button904 "activateCallback" '(change-start -0.5))
    (add-lisp-callback my-button905 "activateCallback" '(my-text-selection-go))
    (add-lisp-callback my-button906 "activateCallback" '(change-start 0.5))
    (add-lisp-callback my-button907 "activateCallback" '(change-start 1)) 
    (add-lisp-callback my-button908 "activateCallback" '(full-view))
    (add-lisp-callback my-button909 "activateCallback" '(data-selection))
    (add-lisp-callback my-button910 "activateCallback" '(fit-at-max))  
    (add-lisp-callback my-button911 "activateCallback" '(progn (data-selection)(fit-at-max))) 
    (setq my-menu903 (create-my-memo-menu1 my-menu-bar903 "menu"))
    (setq my-menu903 (create-my-memo-menu2 my-menu-bar903 "waves"))
    (setq my-menu903 (create-my-memo-menu3 my-menu-bar903 "dislay"))
    (setq my-menu903 (create-my-memo-menu4 my-menu-bar903 "assorted"))
    (setq my-menu903 (create-my-memo-menu5 my-menu-bar903 "scan"))
    ;(add-button my-menu-bar903 "AboutMe" '(error "Developed by Akira Hashizume on 2023-March-9th")) 
    (manage my-text903)
    (manage my-frame-label903)
    (manage my-frame903)
    (manage my-button903)(manage my-button904)(manage my-button905)
    (manage my-button906)(manage my-button907)(manage my-button908)
    (manage my-button909)(manage my-button910)(manage my-button911)
    (manage my-menu-bar903)
    (manage my-menu903)
    (manage my-memo903))
)

(defun create-my-memo-menu1(bar title)
  (let ((menu))
    (setq menu (make-menu bar title nil
      '("start hns_meg" (initialize-hnsmeg-check));; how delete this menu?
      '("open FIF file" (if (G-widget "disp1" :quiet)
        (progn (open-fiff-file)(set-MEG-EEG-default))
        (progn (initialize-hnsmeg-check)(open-fiff-file)(set-MEG-EEG-default))))
      '("save as *-wave.txt" (my-text-save))
      '("load *-wave.txt" (my-text-load))
      '("set SSP" (setSSP))
      '("activate xfit" (require this-filename))))
    (return menu))
)

(defun create-my-memo-menu2_old(bar title);;obsolete
  (let ((menu))   
    (setq menu (make-menu bar title nil :tear-off
      '("discharge"   (my-text-insert2 "  discharge"))
      '("spike"       (my-text-insert2 "  spike"))
      '("polyspike"   (my-text-insert2 "  polyspike"))
      '("burst"       (my-text-insert2 "  burst"))
      '("ictal onset" (my-text-insert2 "  ictal onset"))
      '("EEG spike"   (my-text-insert2 "  EEG spike"))
      '("physiological activities" (my-text-insert2 "physiological activities"))
      '("noise"       (my-text-insert2 "  noise"))
      '("???"         (my-text-insert2 "  ???"))))
    (return menu)) 
)

(defun create-my-memo-menu2(bar title)
  (let ((menu)(str)(y)(menus 
    (list "discharge" "spike" "polyspike" "burst" "ictal onset" "EEG spike" "physiological activities" "noies" "???")))
    (setq menu (make-menu bar title nil :tear-off))
    (setq y 0)
    (dolist (x menus)
      (setq y (string-rep-char x " " "^"))
      (setq str (format nil "(my-text-insert2-symbol '~a)" y))
      (add-button menu x (read-from-string str)))
    (return menu))
)

(defun create-my-memo-menu2(bar title);; in the furture, loading /home/neurosurgey/lisp/wave-type.txt will substitute
  (let ((menu)(str)(y))
    (setq menu (make-menu bar title nil :tear-off))
    (setq y 0)
    (dolist (x waves-name)
      (setq y (string-rep-char x " " "^"))
      (setq str (format nil "(my-text-insert2-symbol '~a)" y))
      (print str)
      (add-button menu x (read-from-string str)))
    (return menu))
)

(defun create-my-memo-menu3(bar title);dislay
  (let ((menu))      
    (setq menu (make-menu bar title nil))
    (add-button menu "set default lead" '(set-MEG-EEG-default))
    (add-button menu "set default scale" '(set-MEG-EEG-default-scale))
    (add-button menu "change line color" '(change-disp-color-menu))
    (make-menu menu "for clipboard copy" nil :tear-off
      '("MEG 8 stacks" (create-disp903 "disp1"))
      '("MEG" (create-disp903 "disp3"))
      '("EEG" (create-disp903 "disp4"))
      '("MISC" (create-disp903 "disp5"))
      '("delete" (GtDeleteWidget (G-widget "disp5"))))
    (make-menu menu "clear" nil 
      '("all text" (XmTextSetString my-text903 ""))
      '("noise epoch" (my-text-delete "noise"))
      '("ignored epoch" (my-text-delete "ignored"))
      '("near epochs" (my-text-delete-near 0.005))
      '("routine" (progn (my-text-delete "noise")(my-text-delete "ignored")(my-text-delete-near 0.005))))
    (return menu))
)

(defun create-my-memo-menu4(bar title);assorted
  (let ((menu)(btn))
    (setq menu (make-menu bar title nil))
    (add-button menu "show filename" '(show-info))
    (add-button menu "calc average noise" '(calc-noise-level))
    (make-menu menu "selected span" nil 
      '("with 0.2 sec" (my-text-peak-range 0.2))
      '("with 0.3 sec" (my-text-peak-range 0.3))
      '("with 0.4 sec" (my-text-peak-range 0.4))
      '("with 0.5 sec" (my-text-peak-range 0.5))
      '("with 1.0 sec" (my-text-peak-range 1.0)))
    (make-menu menu "sort" nil ;;3 ch 4;time 5;amplitude
      '("according to channel" (progn (my-text-load-as-lisp 4)(my-text-load-as-lisp 3)))
      '("according to time" (progn (my-text-load-as-lisp 5)(my-text-load-as-lisp 4)))
      '("according to amplitude" (progn (my-text-load-as-lisp 4)(my-text-load-as-lisp 5))))
    (add-button menu "fit dipoles again" '(reestimate-dipoles))
    (add-button menu "memory info" '(memory-info-dialog))
    (return menu))
)

(defun create-my-memo-menu5(bar title)
  (let ((menu)(btn))
    (setq menu (make-menu bar title nil))
    (setq btn (make-menu menu "calc" nil
      '("with 0.5 sec step" (scan-max-show 0.5))
      '("with 1 sec step" (scan-max-show 1))
      '("with 2 sec step" (scan-max-show 2))))
    (setq btn (make-menu menu "scan-menu" "p" :tear-off 
      '("goto              " (scan-max-go))
      :---- 
      '("zoom in           " (scan-max-x5 5))
      '("zoom out          " (scan-max-x5 0.5))
      :----
      '("peak 20 selection    " (scan-max-selection 20))
      '("peak 50 selection    " (scan-max-selection 50))
      '("peak 100 selection    " (scan-max-selection 100))))
    (return menu))  
)

(defun create-my-scan(dispname);;difficult to manage after destroy this X-widgets and caues much troublesome....
  (let ((my-scan-window)(my-form)(my-menu-bar903)(disp)(dispw))
    (when (G-widget dispname :quiet)(GtDeleteWidget (G-widget dispname)))
    (setq my-scan-window (make-form-dialog *application-shell* "scan-window" :autoUnmanage 0))
    (setq my-menu-bar903 (make-menu-bar my-scan-window  "my-menu-bar"
      :rightAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM :topAttachment XmATTACH_FORM))
    ;(add-button my-menu-bar903 "GOTO" '(scan-max-go)); it does not work properly
    (make-menu my-menu-bar903 "menu" nil
      '("goto" (scan-max-go)))
    (setq my-form (make-form my-scan-window "my-form" :topAttachment XmATTACH_WIDGET :topWidget my-menu-bar903   
     :bottomAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM))
    (setq disp (GtMakeObject 'plotter :name dispname :display-parent my-form :scroll-parent my-form :no-controls nil))
    (GtPopupEditor disp)
    (setq dispw (resource disp :display-widget))
    (set-values dispw "resizable" 0 
      "topAttachment"  XmATTACH_POSITION "topPosition"  0 "bottomATTACHMENT" XmATTACH_POSITION "bottomPosition" 90
      "leftAttachment" XmATTACH_POSITION "leftPosition" 0 "rightATTACHMENT"  XmATTACH_POSITION "rightPosition" 100)
    (set-values(resource (G-widget dispname) :scroll-widget)
      "resizable"        1
      "leftAttachment"   XmATTACH_POSITION  "leftPosition"     0 
      "rightAttachment"  XmATTACH_POSITION  "rightPosition"  100
      "topAttachment"    XmATTACH_POSITION  "topPosition"     98
      "bottomAttachment" XmATTACH_POSITION  "bottomPosition" 100  "bottomOffset" -5)
    (set-resource (G-widget dispname) :scroll-visible 1)
    (manage my-form)
    (manage my-menu-bar903)
    (manage my-scan-window))
)

(defun create-subdisp(pane form dispname title no-controls)
  (let ((dform nil)(disp nil)(dispw nil)(label nil))
    (when (G-widget dispname :quiet)(GtDeleteWidget (G-widget dispname)))
    (setq dform (make-form pane "displayForm"))
    (setq disp  (GtMakeObject 'plotter :name dispname
       :display-parent dform  :scroll-parent  form
       :ch-label-space 80 :no-controls no-controls))
    (put disp :display-form dform)
    (GtPopupEditor disp)
    (when title 
      (setq label (put disp :label (XmCreateLabel dform "label" (X-arglist) 0)))
    )
    (setq dispw (resource disp :display-widget))
    (set-values dispw
      "resizable"        1
      "leftAttachment"   XmATTACH_FORM     "leftOffset"       (if title 80 0)
      "rightAttachment"  XmATTACH_FORM
      "topAttachment"    XmATTACH_FORM
      "bottomAttachment" XmATTACH_FORM)
      (when title
        (set-values label
          "resizable"        0
          "leftAttachment"   XmATTACH_FORM    
          "rightAttachment"  XmATTACH_WIDGET   "rightWidget"      dispw      
          "rightOffset"      0
          "topAttachment"    XmATTACH_FORM
          "bottomAttachment" XmATTACH_FORM)
        (set-values label "labelString" (XmString title))
        (manage label))
    (manage dform))
)

(defun cumsum(x)
  (let ((xx)(y nil))
    (setq xx (reverse x))
    (dotimes (i (length x))
      (setq y (append y (list (eval (cons '+ xx)))))
      (setq xx (cdr xx)))
    (return (reverse y)))
)

(defun data-selection(&optional (check t))
  (let ((tm (x-selection))(t1)(t2)(w)(data)(x)(ch)(t0)(str))
    (setq t1 (first tm) t2 (second tm))
    (setq w (widget-source (G-widget "disp1")))
    (setq data (get-data-matrix w (x-to-sample w t1)(x-to-sample w t2)))
    (setq x (get-matrix-max data))
    (setq ch (get-property w (1- (second x)) :name)); 0 1 2 3 ...
    (setq t0 (+ t1 (sample-to-x w (1- (third x)))))
    (setq x (* (first x) 1e+13));T/m -> fT/cm
    (setq str (format nil "~%~0,4f   ~0,4f   ~a   ~0,4f   ~0,2f  " t1 t2 ch t0 x))
    (if check (my-text-insert2 str)(return (list t1 t2 ch t0 x))))
)

(defun data-selection2(ratio)
;; one channel with big noise should be ignored
  (let ((tm (x-selection))(t1)(t2)(w)(data)(x)(datcol)(datcol2 nil)(ch)(t0)(str)(d1)(d2)(str))
    (setq t1 (first tm) t2 (second tm))
    (setq w (widget-source (G-widget "disp1")))
    (setq data (get-data-matrix w (x-to-sample w t1)(x-to-sample w t2)))
    (setq x (get-matrix-max data))
    (setq ch (get-property w (1- (second x)) :name)); 0 1 2 3 ...
    (setq t0 (+ t1 (sample-to-x w (1- (third x)))))
    (setq datcol (column (1- (third x)) data))
    (setq x (* (first x) 1e+13));T/m -> fT/cm
    (setq str (format nil "~%~0,4f   ~0,4f   ~a   ~0,4f   ~0,2f  " t1 t2 ch t0 x))
    (setq datcol (map-matrix datcol #'abs))
    (dotimes (i (length datcol))(setq datcol2 (append datcol2 (list (vref datcol i)))))
    (setq datcol (reverse (sort datcol2)))
    (setq d1 (first datcol) d2 (second datcol)) 
    (if (> (* d1 ratio) d2)(setq str (strm-append str "  noise")))
    (my-text-insert2 str))
)

(defun defchs()
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
  (defparameter eeg-mono
    '("EEG[6 7 8 1 2 3 4 5 17 18 19 9 10 11 12 13 14 15 16]"))
  (defparameter eeg-banana1
    '("EEG[1 6 7 8 1 2 3 4 17 18 9 10 11 12 9 14 15 16]"))
  (defparameter eeg-banana2
    '("EEG[6 7 8 5 2 3 4 5 18 19 10 11 12 13 14 15 16 13]"))
  (defparameter eeg-coronal1
    '("EEG[6 1 9 6 2 17 10 7 3 18 11 8 4 19 12 8 5 13]"))
  (defparameter eeg-coronal2
    '("EEG[1 9 14 2 17 10 14 3 18 11 15 4 19 12 16 5 13 16]"))
  (defparameter eeg-misc
    '("EEG[20 21]"))
  ;(defparameter eegchname '("Fp1" "F3" "C3" "P3" "O1" "F7" "T3" "T5" "Fp2" "F4" "C4" "P4" "O2" "F8" "T4" "T6" "Fz" "Cz" "Pz" "ECG" "EOG"))
  (defparameter eeg-banana-name '("Fp1-F7" "F7-T3" "T3-T5" "T5-O1" "Fp1-F3" "F3-C3" "C3-P3" "P3-O1" "Fz-Cz" "Cz-Pz" "Fp2-F4" "F4-C4" "C4-P4" "P4-O2" "Fp2-F8" "F8-T4" "T4-T6" "T6-O2"))
  (defparameter eeg-coronal-name '("Fp1-F7" "Fp2-Fp1" "F8-Fp2" "F3-F7" "Fz-F3" "F4-Fz" "F8-F4" "C3-T3" "Cz-C3" "C4-Cz" "T4-C4" "P3-T5" "Pz-P3" "P4-Pz" "T6-P4" "O1-T5" "O2-O1" "T6-O2"))
  (defparameter eeg-coronal-name '("F7-Fp1" "Fp1-Fp2" "Fp2-Fp2" "F7-F3" "F3-Fz" "Fz-F4" "F4-F8" "T3-C3" "C3-Cz" "Cz-C4" "C4-T4" "T5-P3" "P3-Pz" "Pz-P4" "T4-T6" "T5-O1" "O1-O2" "O2-T6"))
  (defparameter eeg-mono-name '("F7" "T3" "T5" "Fp1" "F3" "C3" "P3" "O1" "Fz" "Cz" "Pz" "Fp2" "F4" "C4" "P4" "O2" "F8" "T4" "T6"))
  (defparameter eeg-misc-name '("ECG" "EOG"))
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
    (defparameter chname '(11 12 13 14  21 22 23 24  31 32 33 34  41 42 43 44  51 52 53 54  61 62 63 64  71 72 73 74 81 82  
      91 92 93 94  101 102 103 104  111 112 113 114  121 122 123 124  131 132 133 134  141 142 143 144  151 152 153 154  
      161 162 163 164  171 172 173 174  181 182 183 184  191 192 193 194  201 202 203 204  211 212 213 214  221 222 223 224   
      231 232 233 234  241 242 243 244  251 252 253 254  261 262 263 264))
    (defparameter near_coil (calc_near_coil))
    (defparameter my-memo902-exist nil))
)

(defun define-my-parameter()
  (define-parameter-group 'my-parameter "my-parameters")
  (defuserparameters my-parameter 
    (my-gradiometer-scale 3e-11 "gradometer scale" 'number)
    (my-magnetometer-scale 3e-12 "magnetometer scale" 'number)
    (my-eeg-scale 1e-4 "EEG scale" 'number)
    (my-sensor-number 102 "sensor numbers for estimation (9~102)" 'number))
)

(defun execute1()
  (if (G-widget "display" :quiet)(GtDeleteWidget (G-widget "display")))
  (create-my-memo)
  (add-button *user-menu* "show my-memo" '(manage my-memo903))
  ;(initialize-hnsmeg-check); Why it does not work?
)

(defun execute2()
  (if (> (resource (G-widget "file") :channels) 200)
    (progn
      (setq default-data-source "meg-select")
      (xfit);;start xfit
      (if (not (x-selection))(set-x-selection (G-widget "disp1") 0 0.1))
      (xfit-transfer-data nil (x-selection))
    ))
)

(defun fit-at-max()
  (let ((x))
    (setq x (data-selection nil))
    (select-near-coil (third x))
    (xfit-transfer-data nil (x-selection))
    (xfit-command (format nil "fit ~0,4f" (* (fourth x) 1000))))
)

(defun full-view()
  (let ((x)(ch))
    (if (x-selection)
      (progn
        (set-resource (G-widget "meg-select") :names '("MEG*") :ignore nil)
        (xfit-transfer-data nil (x-selection))
        (setq x (data-selection nil))
        (setq ch (string-left-trim "MEG" (third x)))
        (xfit-command "fullview on")
        (xfit-command (strm-append "samplech " ch))
        (xfit-command (format nil "pick ~0,4f" (* (fourth x) 1000))))))
)

(defun get-matrix-max(mtx)
  (let ((rcmax)(x)(y))
    (setq mtx (map-matrix mtx #'abs))
    (setq rcmax (matrix-extent mtx))
    (setq rcmax (eval (cons 'max rcmax)))
    (setq mtx (map-matrix mtx #'/ rcmax));<1
    (setq mtx (map-matrix mtx #'floor));< 1 or 0
    (setq y (array-dimension mtx 0));channel
    (setq y (transpose (ruler-vector 1 y y)))
    (setq y (second (matrix-extent (* y mtx))))
    (setq x (array-dimension mtx 1));time
    (setq x (ruler-vector 1 x x))
    (setq x (second (matrix-extent (* mtx x))))
    (return (list rcmax (round y) (round x))))
)

(defun get-matrix-max2(mtx)
  (let ((rcmax)(x)(y))
    (setq mtx (map-matrix mtx #'abs))
    (setq rcmax (matrix-extent mtx))
    (setq rcmax (eval (cons 'max rcmax)))
    (setq mtx (map-matrix mtx #'/ rcmax));<1
    (setq mtx (map-matrix mtx #'floor));< 1 or 0
    (setq y (array-dimension mtx 0));channel
    (setq y (transpose (ruler-vector 1 y y)))
    (setq y (second (matrix-extent (* y mtx))))
    (setq x (array-dimension mtx 1));time
    (setq x (ruler-vector 1 x x))
    (setq x (second (matrix-extent (* mtx x))))
    (setq x (round x) y (round y))
    (return (list rcmax (round y) (round x))))
)

(defun get-matrix-max-from-x-selection(w)
  (let ((mtx)(x)(w2))
    (setq x (x-selection w))
    (setq w2 (widget-source w));;point!!!
    (if x (progn
      (setq mtx (get-data-matrix w2 (x-to-sample w (first x))(x-to-sample w (second x))))
      (return (get-matrix-max mtx))) nil
    ))
)

(defun get-widget-max(w1); G-widget
  (let ((point (resource w1 :point))(span (resource w1 :length))(nch (resource w1 :channels))(M)(x)(y)(w2))
    (setq w2 (widget-source w1))
    (setq M (get-data-matrix w2 (x-to-sample w1 point)(x-to-sample w1 span)))
    (setq x nil)
    (dotimes (i nch)
      (setq y (matrix-extent (row i M)))
      (setq y (mapcar #'abs y));; calculation of list
      (setq y (eval (cons 'max y)));;calculation of list 
      (setq x (append x (list y))))
    (return x))
)

(defun initialize-hnsmeg()
  (if (not (resource (G-widget "file") :directory))
    (set-resource (G-widget "file") :directory "/neuro/data/ns/*.fif"))
  (create-main-form)
  (require 'ssp)
  (require 'xfit)
  (require-widgets '(
  (ringbuffer "buf" ("size" 5000000))
  (fft-filter "band-pass1" ("pass-band" (band-pass 3 35)))
  (fft-filter "band-pass2" ("pass-band" (band-pass 3 35)))
  (fft-filter "band-pass3" ("pass-band" (band-pass 3 35)))
  (pick "meg0")(pick "meg")(pick "meg1")(pick "eeg1")(pick "eeg2")(pick "misc")
  (pick "meg8G")(pick "meg8M")(pick "meg-select")
  (binary "fsub" ("function" fsub)))) 
  (set-resource (G-widget "meg0") :names '("MEG*"))
  (set-resource (G-widget "meg") :names '("MEG*"))
  (set-resource (G-widget "meg-select") :names '("MEG*"))
  (set-resource (G-widget "eeg1") :names '("EEG*") :ignore '("EEG20" "EEG21"))
  (set-resource (G-widget "eeg2") :names '("EEG*") :ignore '("EEG20" "EEG21"))
  (set-resource (G-widget "misc") :names '("EEG20" "EEG21"))
  (linklink '("file" "buf" "meg0" "ssp" "band-pass1" "meg" "meg8G" "disp1"))
  (linklink '("meg" "meg8M" "disp2"))
  (linklink '("meg" "meg-select"))
  (linklink '("meg" "meg1" "disp3"))
  (linklink '("buf" "band-pass2" "eeg1" "fsub"))
  (linklink '("band-pass2" "eeg2" "fsub" "disp4"))
  (linklink '("buf" "band-pass3" "misc" "disp5"))
  (set-resource (G-widget "disp1") :ch-label-space -1)
  (set-resource (G-widget "disp2") :ch-label-space -1)
  (set-resource (G-widget "disp1") :move-hook '(sync-view-2 "disp1" "disp2" "disp3" "disp4" "disp5"))
  (set-resource (G-widget "disp1") :select-hook '(sync-selection "disp1" "disp2" "disp3" "disp4" "disp5"))
  (set-resource (G-widget "disp2") :move-hook '(sync-view-2 "disp2" "disp1" "disp3" "disp4" "disp5"))
  (set-resource (G-widget "disp2") :select-hook '(sync-selection "disp2" "disp1" "disp3" "disp4" "disp5"))
  (set-resource (G-widget "disp3") :move-hook '(sync-view-2 "disp3" "disp1" "disp2" "disp4" "disp5"))
  (set-resource (G-widget "disp3") :select-hook '(sync-selection "disp3" "disp1" "disp2" "disp4" "disp5"))
  (set-resource (G-widget "disp4") :move-hook '(sync-view-2 "disp4" "disp1" "disp2" "disp3" "disp5"))
  (set-resource (G-widget "disp4") :select-hook '(sync-selection "disp4" "disp1" "disp2" "disp3" "disp5"))
  (set-resource (G-widget "disp5") :move-hook '(sync-view-2 "disp5" "disp1" "disp2" "disp3" "disp4"))
  (set-resource (G-widget "disp5") :select-hook '(sync-selection "disp5" "disp1" "disp2" "disp3" "disp4"))
  (dolist (w (list "disp1" "disp2" "disp3" "disp4" "disp5"))
    (set-resource (G-widget w) :point 0 :length 10))
  (defchs)
  (defchpos)
  (set-resource (G-widget "meg1") :names gra-L-temporal)
  (setq ch (append gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal 
                   gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal))
  (set-resource (G-widget "meg8G") :names ch)
  (setq ch (append mag-L-temporal mag-R-temporal mag-L-parietal mag-R-parietal 
                   mag-L-occipital mag-R-occipital mag-L-frontal mag-R-frontal))
  (set-resource (G-widget "meg8M") :names ch)  
  (select-megch "menu")
  (select-eegch "menu")
  (GtOrganizePanel);;popup control-panel
  (define-my-parameter)
)

(defun initialize-hnsmeg-check()
  (if (not (G-widget "dislay" :quiet))(initialize-hnsmeg))
)

(defun intersect(a b)
  (let ((x nil))
    (if (not (listp a))(setq a (list a)))
    (if (not (listp b))(setq b (list b)))
    (dolist (i a)
      (dolist (j b)
        (if (equal i j)(setq x (append x (list j))))))
    (return x))
)

(defun linklink(gws)
  (dotimes (i (- (length gws) 1))
    ;(print (nth i gws))
    (link (G-widget (nth i gws))(G-widget (nth (+ i 1) gws)))) 
)

(defun make-random-matrix(nrow ncolumn)
  (map-matrix (random-matrix nrow ncolumn) #'/ (pow 2 31))
)

(defun make-random-matrix2(nrow ncolumn)
  (map-matrix (map-matrix (random-matrix nrow ncolumn) #'/ (pow 2 30)) #'- 1)
)

(defun matrix-extent-max(mtx)
  (let ((x nil))
    (setq x (matrix-extent mtx))
    (setq x (mapcar #'abs x))
    (setq x (eval (cons 'max x)))
    (return x))
)

(defun matrix-max(mtx);;negative number is not regarded
  (let ((R nil)(col)(x))
    (dotimes (i (length mtx))
      (setq col (column i mtx))
      (setq R (append R (list (second (matrix-extent col))))))
    (return R))
)

(defun member-string(lista listb)
;;eg (member-string (list "a" "d")(list "a" "b" "c"))->(t nil)
  (let ((R nil)(z)) 
    (if (not (listp lista))(setq lista (list lista)))
    (dolist (a lista)
      (setq z nil)
      (dolist (b listb)
        (if (equal b a)(setq z t)))
      (setq R (append R (list z))))
    (return R))
)

(defun my-text-add(str)
  (let ((str0 (XmTextGetString my-text903)))
    (if (equal str0 "")(XmTextSetString my-text903 str)
      (XmTextSetString my-text903 (strm-append str0 str))))
)

(defun my-text-delete(str)
  (let ((str0)(str1 "zzz")(str2)(strm)(nL)(L)(k))
    (setq str0 (XmTextGetString my-text903))
    (setq strm (make-string-input-stream str0))
    (dotimes (i (length (my-text-line)))
      (setq k t)
      (setq str2 (read-line strm))
      (if str2 (progn
        (setq L (read-line-as-list (make-string-input-stream str2)))
        (dolist (i L)
          (if (symbolp i)
            (if (equal str (format nil "~a" i))(setq k nil))))
        (if k (setq str1 (strm-append str1 str2 (format nil "~%")))))))
    (setq str1 (string-left-trim "zzz" str1))
    (XmTextSetString my-text903 str1))
)

(defun my-text-delete-near(span)
  (let ((strm)(str)(Lnear nil)(L)(L4a nil)(L4b nil)(x))
    (my-text-load-as-lisp 4);;sort according to time 
    (setq strm (make-string-input-stream (XmTextGetString my-text903)))
    (dotimes (i (length (my-text-line2)));; not (my-text-line)
      (setq L (read-line-as-list strm))
      (if (and (> (length L) 4)(numberp (first L))(numberp (second L))(numberp (fourth L))(numberp (fifth L)))
        (progn  (if L4b (setq L4a L4b))
                (setq L4b (fourth L))
               (if L4a (setq x (- L4b L4a))(setq x span))
               (print (list L4a L4b))
               (if (< x span)(setq Lnear (append Lnear (list i)))))))
    (setq Lnear (reverse Lnear))
    (dolist (i Lnear)
      (setq L (my-text-line))
      (XmTextSetInsertionPosition my-text903 (nth i L))
      (my-text-insert2 " near")))
  ;(my-text-delete "near"))
)

(defun my-text-insert-old(str);;obsolete
  (let ((str0 (XmTextGetString my-text903))(pos)(stream)(str1 "zzz")(str2 "zzz"))
    (setq pos (XmTextGetInsertionPosition my-text903))
    (setq stream (make-string-input-stream str0))
    (dotimes (i pos)(setq str1 (strm-append str1 (format nil "~a" (read-char stream)))))
    (dotimes (i (- (length str0) pos))(setq str2 (strm-append str2 (format nil "~a" (read-char stream)))))
    (setq str1 (string-left-trim "zzz" str1))
    (setq str2 (string-left-trim "zzz" str2))
    (if (equal str2 "")(setq str (strm-append str1 str))(setq str (strm-append str1 str str2)))
    (XmTextSetString my-text903 str))
)

(defun my-text-insert(str)
  (let ((str0)(str1)(str2)(pos))
    (setq pos (XmTextGetInsertionPosition my-text903))
    (setq str0 (XmTextGetString my-text903))
    (if (equal str0 "")(XmTextSetString my-text903 str)(progn
      (setq str1 (substring str0 :start 0 :end pos))
      (setq str2 (substring str0 :start pos :end (length str0)))
      (XmTextSetString my-text903 (strm-append str1 str str2))
      (XmTextSetInsertionPosition my-text903 pos))))
)

(defun my-text-insert2-old(str);;obsolete 
  (let ((str0)(nline)(nn)(i 0)(n)(pos))
    (setq str0 (XmTextGetString my-text903))
    (if (equal str0 "")(my-text-insert str)
      (progn
        (setq nline (my-text-line))
        ;(setq nline (mapcar #'1- (cumsum (my-text-line2))))
        ;(setq nline (append nline (list (length str0))))
        (setq pos (XmTextGetInsertionPosition my-text903))
        (setq n (first nline))
        (while (>  pos n)
          (progn 
            (setq i (+ i 1))
            (setq n (nth i nline))))
        (if (> n (length str0))(setq pos (length str0))(setq pos n))
        (XmTextSetInsertionPosition my-text903 pos)
        (my-text-insert str)
        (XmTextSetInsertionPosition my-text903 999999999))))
)

(defun my-text-insert2(str)
  (let ((str0)(str1)(str2)(pos)(lf)(x))
    (setq str0 (XmTextGetString my-text903))
    (if (equal str0 "")(XmTextSetString my-text903 str)(progn
      (setq pos (XmTextGetInsertionPosition my-text903))
      (setq lf (my-text-line) x 0)
      (dolist (n lf)
        (if (>= n pos)(setq x n pos 9999999)))
      (XmTextSetInsertionPosition my-text903 x)
      (my-text-insert (format nil " ~a" str)))))
)

(defun my-text-insert2-symbol(symb)
  (my-text-insert2 (string-rep-char (string symb) "^" " "))
)

(defun my-text-line()
  (let ((str0)(n)(nline)(stream))
    (setq str0 (XmTextGetString my-text903))
    (if (equal str0 "")(return -1)
      (progn
        (setq n (list -1))
        (setq nline (length str0))
        (setq stream (make-string-input-stream str0))
        (dotimes (i nline)
          (if (equal (read-char stream) #\Linefeed)
            (setq n (append n (list i)))))
        (if (< (car (last n)) nline)(setq n (append n (list nline))))
        (return (cdr n)))))
)

(defun my-text-line2()
  (let ((strm)(str)(x nil)(y nil)(z nil)(nline 0))
    (setq strm (make-string-input-stream (XmTextGetString my-text903)))
    (while (read-line strm)(setq nline (1+ nline)))
    (setq strm (make-string-input-stream (XmTextGetString my-text903)))
    (setq str (read-line strm))
    (dotimes (i nline)
      (setq x (append x (list (length str))))
      (setq str (read-line strm))) 
    (return (mapcar #'1+ x)))
)

(defun my-text-load()
  (let ((filename)(fid)(strm (make-string-output-stream))(str "mg")(x)(Nnil 0))
    (setq filename (resource (G-widget "file"):filename))
    (if (not filename)(format nil "No file is selected")
      (progn
        (setq filename (strm-append (string-right-trim ".fif" filename) "-wave.txt"))
        (if (file-exists-p filename)
          (progn
            (setq fid (open filename :direction :input))
            (dotimes (i 1000)
              (setq x (read-line fid))
              (if (> (length x) 0)
                (setq str (strm-append str x (format nil "~%")))))          
            (close fid)
            (setq str (string-left-trim "mg" str))
            (XmTextSetString my-text903 str))))))
)

(defun my-text-load-as-lisp(item);; item 3: MEG 4:time 5:amplitude
  (let ((strm)(str)(strm0)(str0)(strx)(Lstr nil)(x nil)
       (x3 nil)(x4 nil)(x5 nil)(y nil)(z)(CR (format nil "~%")))
    (setq str (XmTextGetString my-text903))
    (setq nL (length (my-text-line2)))
    (setq strm (make-string-input-stream str))
    (setq strm0 (make-string-input-stream str))
    (setq str0 "zzz")
    (dotimes (i nL)
      (setq L (read-line-as-list strm))
      (setq strx (read-line strm0))
      (if (and (> (length L) 4)(floatp (first L))(floatp (fourth L))(floatp (fifth L)))
          (progn
            (setq x (string-left-trim "MEG" (string-left-trim " " (string (third L)))))
            (setq x3 (append x3 (list (read-from-string x))));;according to MEG
            (setq x4 (append x4 (list (fourth L))));;according to time
            (setq x5 (append x5 (list (fifth L))));according to amplitude
            (setq y (append y (list i))))
          (setq str0 (strm-append str0 strx CR))))
    (setq strm (make-string-input-stream str))
    (if (= item 3)(setq x x3))
    (if (= item 4)(setq x x4))
    (if (= item 5)(setq x x5))
    (dotimes (i nL)
      (setq Lstr (append Lstr (list (read-line strm)))))
    (setq z (sort-order x))
    (if (= item 5)(setq z (reverse z)))
    (dotimes (i (length z))
      (setq str0 (strm-append str0 (nth (nth (nth i z) y) Lstr) CR)))
    (XmTextSetString my-text903 (string-left-trim "zzz" str0)))
)

(defun my-text-peak-range(span)
  (let ((nL)(str)(strm)(strm2)(str2)(x)(x4)(y)(p0)(strs)(check))
    (setq nL (length (my-text-line2)))
    (setq str (XmTextGetString my-text903))
    (if (not (equal str ""))(progn
      (setq strm (make-string-input-stream str))
      (setq strm2 (make-string-input-stream str))
      (setq strs "zzz")
      (dotimes (i nL)
        (setq x (read-line-as-list strm))
        (setq str2 (read-line strm2))
        (if (and (numberp (first x))(> (length x) 4))(progn
          (setq x4 (fourth x))
          (if (numberp x4)(progn
            (setq p0 (- x4 (/ span 2)))
            (set-resource (G-widget "disp1") :selection-start p0 :selection-length span)
            (setq y (data-selection nil))
            (setq str2 (format nil (format nil "~%~0,4f   ~0,4f   ~a   ~0,4f   ~0,2f  " 
              (first y)(second y)(third y)(fourth y)(fifth y))))
            (if (> (length x) 5)
              (dotimes (ii (- (length x) 5))
                (setq str2 (strm-append str2 (format nil " ~a" (nth (+ ii 5) x))))))
            (if (> (abs (- x4 (fourth y))) 0.005)(setq str2 (strm-append str2 "..should be ignored")))))))
        (setq strs (strm-append strs str2)))
      (XmTextSetString my-text903 (string-left-trim "zzz" strs)))))
)

(defun my-text-save()
  "save my-memo as filename-wave.txt"
  (let ((filename)(fid)(str))
    (setq filename (resource (G-widget "file"):filename))
    (if (> (length filename) 4)
      (progn
        (setq filename (strm-append (string-right-trim ".fif" filename) "-wave.txt"))
        (setq fid (open filename :direction :output :if-exists :supersede))
        (princ (XmTextGetString my-text903) fid)
        (close fid)
        (setq str (format nil "~a has been saved." filename))
        (print str))))
)

(defun my-text-selection-go()
;; Never use ":" which is reagard as package of LISP! and read-line-as-list does NOT work properly!
  (let ((pos)(str)(strm)(Linefeed)(nL)(L)(LL '((1)))(n 0)(t0)(span)(t1)(t2)(disps))
    (setq pos (XmTextGetInsertionPosition my-text903))
    (setq str (XmTextGetString my-text903))
    (setq strm (make-string-input-stream str))
    (setq Linefeed (my-text-line))
    (setq nL (length Linefeed))
    (dotimes (i nL)(progn (setq L (read-line-as-list strm))(setq LL (append LL (list L)))))
    (setq LL (cdr LL))
    (while (< (nth n Linefeed) pos)(inc n))
    (setq L (nth n LL))
    (if (and (> (length L) 4)(numberp (first L)))
      (progn
        (setq t0 (first L) span (second L))
        (setq t1 (+ t0 (/ span 2)))
        (setq t2 (- t1 (/ (resource (G-widget "disp3") :length) 2)))
        (change-sensor-selection (string (third L)))
        (setq disps (list "disp1" "disp2" "disp3" "disp4" "disp5"))
        (dolist (disp disps)
          (set-resource (G-widget disp ) :point t2 :selection-start t0 :selection-length span))
        (return t))(return nil)))
)

(defun open-fiff-file()
 (let ((filename))
   (setq filename (ask-filename "Select FIF file to load" :template "/neuro/data/ns/*.fif"))
   (if filename (open-diskfile filename)))
)

(defun reestimate-dipoles()
  (let ((nL)(str)(count 0)(nnL))
    (setq nL (my-text-line))
    (setq nnL (length nL))
    (dolist (i nL)
      (unless (longworking "fitting..." count nnL)(error "interrupted"))
      (XmTextSetInsertionPosition my-text903 i)
      (if (my-text-selection-go)(fit-at-max))
      (inc count))
    (longworking "done" 1 1))
)

(defun scan-max-go()
  (let ((x)(w4)(t0)(t1)(span)(meg8))
    (when (G-widget "src" :quiet)(progn
      (setq x (x-selection (G-widget "plotter")))
      (if x 
        (progn
          (setq t0 (+ (first x)(/ (second x) 2)))
          (setq span (resource (G-widget "disp3") :length))
          (setq t1 (- t0 (/ span 2)))
          (setq w4 (list "disp1" "disp2" "disp3" "disp4" "disp5"))
          (dolist (w w4)(set-resource (G-widget w) :point t1))))
      (setq x (get-matrix-max-from-x-selection (G-widget "plotter")))
      (setq x (second x))
      (setq meg8 (list "L-temporal" "R-temporal" "L-parietal" "R-parietal" "L-occipital" "R-occipital" "L-frontal" "R-frontal"))
      (select-megch (nth (1- x) meg8)))))
)

(defun scan-max-peak(span)
  (let ((tmax)(tm)(t1)(t2)(names)(ignore)(meg8)(X)(k nil)(k8 nil)(kall nil)(w)(w1)(count 0)(ncount))
    (when (G-widget "meg" :quiet)(progn
      (setq w (G-widget "meg"))
      (setq w1 (require-widget :pick "scan-meg-peak"))
      (set-resource w1 :names '("MEG*") :ignore '("MEG*1"))
      (link w w1)
      (setq meg8 (list gra-L-temporal gra-R-temporal gra-L-parietal gra-R-parietal 
                       gra-L-occipital gra-R-occipital gra-L-frontal gra-R-frontal))
      (setq ncount (length meg8))
      (setq tmax (sample-to-x w (resource w :high-bound)))
      (dolist (i meg8)
        (unless (longworking (format nil "scanning...~0,1f %%" (/ (* count 100) ncount)) count ncount)
          (error "interrupted"))
        (inc count)
        (setq tm 0 k nil)
        (set-resource w1 :names i)
        (link w w1)
        (while (< tm tmax)
          (setq t1 (x-to-sample w tm))
          (setq tm (+ tm span))
          (if (> tm tmax)(setq tm tmax))
          (setq t2 (x-to-sample w tm))
          (setq X (matrix-extent (get-data-matrix w1 t1 (- t2 t1))))
          (setq X (mapcar #'abs X))
          (setq X (eval (append (list 'max) X)))
          (setq k (append k (list X))))
          (if (equal i gra-L-temporal)
            (setq k8 (transpose (matrix (list k))))
            (setq k8 (mat-append k8 (transpose (matrix (list k)))))))
      (longworking "done" 1 1)
      (GtDeleteWidget w1)
      (return (transpose k8)))))
)

(defun scan-max-peak-EEG(span)
  (let ((tmax)(tm 0)(t1)(t2)(X)(k nil)(w)(count 0))
    (setq w (widget-source (G-widget "disp4")))
    (setq tmax (sample-to-x w (resource w :high-bound)))
    (while (< tm tmax)
      (setq t1 (x-to-sample w tm))
      (setq  tm (+ tm span))
      (if (> tm tmax)(setq tm tmax))
      (setq t2 (x-to-sample w tm))
      (setq X (get-data-matrix w t1 (- t2 t1)))
      (setq k (append k (list (matrix-extent-max X)))))
    (return (matrix (list k))))
)

(defun scan-max-selection(ndip)
  (let ((mtx)(x)(tm)(smp)(t0)(bnd)(span)(w))
    (if (not (G-widget "src" :quiet))(error "Scan first!"))
    (setq w (G-widget "disp1"))
    (setq smp (resource (G-widget "plotter") :x-scale))
    (setq span (/  (resource w :length) 2))
    (setq mtx (resource (G-widget "src") :matrix))
    (if (> (resource (G-widget "src") :channels) 8)
      (setq mtx (truncate-rows mtx 8)))
    (setq x (matrix-max mtx))
    (setq tm (sort-order x))
    (setq tm (reverse tm))
    (dotimes (i ndip)
      (unless (longworking "checking..." i ndip)(error "interrupted"))
      (setq t0 (* (nth i tm) smp))
      (set-resource w :point (- t0 span) :selection-start t0 :selection-length smp)
      (data-selection2 0.5));;large noise at one ch should be deleted...
    (longworking "done" 1 1))
)

(defun scan-max-show(span)
  (let ((X)(Y)(scale)(x)(y)(names)(wmeg)(wsrc)(wplt)(w (G-widget "disp1"))(EEGch nil))
    (setq X (scan-max-peak span))
    (if (> (resource (G-widget "disp4") :channels) 0)
      (progn (setq EEGch t)(setq Y (scan-max-peak-EEG span))))
    (setq wsrc (require-widget :matrix-source "src"))
    (setq wplt (require-widget :plotter "plotter"))
    ;(create-my-scan "plotter"); hard to handle & cause meny trouble as to Xt
    (setq wplt (G-widget "plotter"))
    (if EEGch 
      (set-resource wsrc :matrix (transpose (mat-append (transpose X)(transpose Y)))) 
      (set-resource wsrc :matrix X))
    (set-resource wsrc :x-scale span :x-unit "s")
    (setq names (list "L-temp" "R-temp" "L-pari" "R-pari" "L-occi" "R-occi" "L-fron" "R-fron"))
    (if EEGch (setq names (append names (list "EEG"))))
    (dotimes (i (length names))(set-property wsrc i :name (nth i names)))
    (link wsrc wplt)
    (GtOrganizePanel)
    (GtPopupEditor wplt)
    (setq scale (get-matrix-max X))
    (setq x (/ (first scale) 1.9))
    (setq x (make-matrix 1 8 x) y (make-matrix 8 1 0.99))
    (if EEGch (progn 
      (setq x (mat-append x (matrix (list (list (matrix-extent-max Y))))))
      (setq y (make-matrix 9 1 0.99))))
    (set-resource wplt :scales (transpose x) :offsets y)
    (set-resource wplt :ch-label-space 80 :point 0 :length 99999)
    (set-resource wplt :default-color (resource w :default-color))
    (set-resource wplt :background (resource w :background))
    (set-resource wplt :highlight (resource w :highlight))
    (set-resource wplt :baseline-color (resource w :baseline-color)))
)

(defun scan-max-x5(num)
  (let ((x)(t0)(t1)(span)(w))
    (when (G-widget "src" :quiet)(progn
      (setq w (G-widget "plotter"))
      (setq x (x-selection w))
      (when (not x)(return nil))
      (setq span (/ (resource w :length) num))
      (setq t0 (+ (first x)(/ (second x) 2)))
      (setq t1 (- t0 (/ span 2)))
      (set-resource w :point t1 :length span)
      (set-resource w :selection-start (first x) :selection-length (second x)))))
)

(defun select-coil(coilname)  
"Usage (select-coil MEG0112)"
  (let ((sns)(k 0)(xx)(R0 "MEG")(R "mg")(st))
    (if (> my-sensor-number 60)
      (progn (setq my-sensor-number 102)(return "MEG*"))
      (progn
        (if (< my-sensor-number 9)(setq my-sensor-number 9))
        (setq sns (read-from-string (string-trim "MEG" coilname)))
        (setq sns (round (floor (/ sns 10))))
        (while (/= sns (nth k chname))(setq k (+ k 1)))
        (setq xx (nth k near_coil))
        (dotimes (i my-sensor-number)
          (setq R (strm-append R (sensor-name (nth i xx))))) 
        (setq R (string-trim "mg" R))
        (setq R (strm-append "MEG[" R "]")))))
)

(defun select-eegch(chname)
  (if (equal chname "mono")
    (progn
      (set-resource (G-widget "eeg1") :names eeg-mono)
      (link (G-widget "band-pass2")(G-widget "eeg1"))
      (dotimes (ch (resource (G-widget "eeg1") :channels))
        (set-property (G-widget "eeg1") ch :name (nth ch eeg-mono-name)))
      (link (G-widget "eeg1")(G-widget "disp4"))))
  (if (equal chname "banana")
    (progn
      (set-resource (G-widget "eeg1") :names eeg-banana1)
      (set-resource (G-widget "eeg2") :names eeg-banana2)
      (link (G-widget "eeg1")(G-widget "fsub"))
      (link (G-widget "eeg2")(G-widget "fsub"))
      (dotimes (ch (resource (G-widget "fsub") :channels))
        (set-property (G-widget "fsub") ch :name (nth ch eeg-banana-name)))
      (link (G-widget "fsub")(G-widget "disp4"))))
  (if (equal chname "coronal")
    (progn
      (set-resource (G-widget "eeg1") :names eeg-coronal1)
      (set-resource (G-widget "eeg2") :names eeg-coronal2)
      (link (G-widget "eeg1")(G-widget "fsub"))
      (link (G-widget "eeg2")(G-widget "fsub"))
      (dotimes (ch (resource (G-widget "fsub") :channels))
        (set-property (G-widget "fsub") ch :name (nth ch eeg-coronal-name)))
      (link (G-widget "fsub")(G-widget "disp4"))))
  (if (equal chname "menu")
    (progn
      (make-menu *display-menu* "EEG chs" "e"
        :tear-off
        '("banana lead" (select-eegch "banana"))
        '("coronal lead" (select-eegch "coronal"))
        '("mono lead"   (select-eegch "mono"))
        '("misc lead"   (select-eegch "misc"))
        '("MEG EEG default scale" (set-MEG-EEG-default)))))
  (if (equal chname "misc")
    (progn
      (set-resource (G-widget "misc") :names eeg-misc)
      (link (G-widget "band-pass2")(G-widget "misc"))
      (set-property (G-widget "misc") 0 :name "ECG")
      (set-property (G-widget "misc") 1 :name "EOG")
      (link (G-widget "misc")(G-widget "disp5"))))
)

(defun select-megch(chname)
  (let ((w1 (G-widget "meg1"))(w2 (G-widget "disp3")))
    (if (equal chname "L-temporal")(progn (set-resource w1 :names gra-L-temporal)(link w1 w2)))
    (if (equal chname "R-temporal")(progn (set-resource w1 :names gra-R-temporal)(link w1 w2)))
    (if (equal chname "L-parietal")(progn (set-resource w1 :names gra-L-parietal)(link w1 w2)))
    (if (equal chname "R-parietal")(progn (set-resource w1 :names gra-R-parietal)(link w1 w2)))
    (if (equal chname "L-occipital")(progn (set-resource w1 :names gra-L-occipital)(link w1 w2)))
    (if (equal chname "R-occipital")(progn (set-resource w1 :names gra-R-occipital)(link w1 w2)))
    (if (equal chname "L-frontal")(progn (set-resource w1 :names gra-L-frontal)(link w1 w2)))
    (if (equal chname "R-frontal")(progn (set-resource w1 :names gra-R-frontal)(link w1 w2)))
    (if (equal chname "L-temporal-mags")(progn (set-resource w1 :names mag-L-temporal)(link w1 w2)))
    (if (equal chname "R-temporal-mags")(progn (set-resource w1 :names mag-R-temporal)(link w1 w2)))
    (if (equal chname "L-parietal-mags")(progn (set-resource w1 :names mag-L-parietal)(link w1 w2)))
    (if (equal chname "R-parietal-mags")(progn (set-resource w1 :names mag-R-parietal)(link w1 w2)))
    (if (equal chname "L-occipital-mags")(progn (set-resource w1 :names mag-L-occipital)(link w1 w2)))
    (if (equal chname "R-occipital-mags")(progn (set-resource w1 :names mag-R-occipital)(link w1 w2)))
    (if (equal chname "L-frontal-mags")(progn (set-resource w1 :names mag-L-frontal)(link w1 w2)))
    (if (equal chname "R-frontal-mags")(progn (set-resource w1 :names mag-R-frontal)(link w1 w2)))
    (if (equal chname "menu")(make-menu *display-menu* "MEG chs" "m" :tear-off 
      '("L-temporal" (select-megch "L-temporal"))
      '("R-temporal" (select-megch "R-temporal"))
      '("L-parietal" (select-megch "L-parietal"))
      '("R-parietal" (select-megch "R-parietal"))
      '("L-occipital" (select-megch "L-occipital"))
      '("R-occipital" (select-megch "R-occipital"))
      '("L-frontal" (select-megch "L-frontal"))
      '("R-frontal" (select-megch "R-frontal"))
      '("L-temporal-mags" (select-megch "L-temporal-mags"))
      '("R-temporal-mags" (select-megch "R-temporal-mags"))
      '("L-parietal-mags" (select-megch "L-parietal-mags"))
      '("R-parietal-mags" (select-megch "R-parietal-mags"))
      '("L-occipital-mags" (select-megch "L-occipital-mags"))
      '("R-occipital-mags" (select-megch "R-occipital-mags"))
      '("L-frontal-mags" (select-megch "L-frontal-mags"))
      '("R-frontal-mags" (select-megch "R-frontal-mags")))))
)

(defun select-near-coil(coilname)
  (let ((coil)(str)(i 0))
    ;(setq coil (read-from-string (string-trim "MEG" coilname))
    ;(setq coil (round (floor (/ coil 10))));integer!
    (setq str (select-coil coilname))
    (set-resource (G-widget "meg-select") :names (list str)))
)

(defun sensor-name(num)
  (let ((R))
    (if (> num  99)
      (setq R (format nil "~d1 ~d2 ~d3 " num num num))
      (setq R (format nil "0~d1 0~d2 0~d3 " num num num))))
)

(defun set306amp()
  (let ((grascale)(nch)(magscale)(w (G-widget "meg8G"))(data)(x))
    ;;204 planar
    (set-resource (G-widget "disp1") :superpose t)
    (link (G-widget "meg8G")(G-widget "disp1"))
    (setq grascale (resource (G-widget "disp3") :scales))
    (setq grascale (vref grascale 0)) ;gra-scale(1,1)
    (setq nch (resource (G-widget "disp1") :channels))
    (setq grascale (* grascale 20))
    (set-resource (G-widget "disp1") :scales (make-matrix nch 1 grascale))
    ;;102 magnetometer
    (set-resource (G-widget "disp2") :superpose t)
    (setq nch (resource w :channels))
    (link (G-widget "meg8M")(G-widget "disp2"))  
    (setq data (get-data-matrix w (x-to-sample w (resource (G-widget "disp3") :point))
                                  (x-to-sample w (resource (G-widget "disp3") :length))))
    (setq x (matrix-extent data))
    (setq magscale (eval (cons 'max (mapcar #'abs x))))
    (setq magscale (* magscale 0.5));thumb's rule
    (set-resource (G-widget "disp2") :scales (make-matrix nch 1 magscale)))
)

(defun set306offset()
  (let ((x)(xx))
    (setq xx (ruler-vector -0.85 0.85 8))
    ;;204 planar
    (setq x (mat-append 
      (make-matrix 1 26 (vref xx 0))(make-matrix 1 26 (vref xx 1))(make-matrix 1 26 (vref xx 2))(make-matrix 1 26 (vref xx 3))
      (make-matrix 1 24 (vref xx 4))(make-matrix 1 24 (vref xx 5))(make-matrix 1 26 (vref xx 6))(make-matrix 1 26 (vref xx 7))))
    (set-resource (G-widget "disp1") :offsets (transpose x))
    ;;102 magnetometer
    (setq xx (ruler-vector -0.85 0.85 8))
    (setq x (mat-append 
      (make-matrix 1 13 (vref xx 0))(make-matrix 1 13 (vref xx 1))(make-matrix 1 13 (vref xx 2))(make-matrix 1 13 (vref xx 3))
      (make-matrix 1 12 (vref xx 4))(make-matrix 1 12 (vref xx 5))(make-matrix 1 13 (vref xx 6))(make-matrix 1 13 (vref xx 7))))
    (set-resource (G-widget "disp2") :offsets (transpose x))
    (return x)
)    
  
)

(defun setdiff(a b)
  (let ((x nil)(y))
    (if (not (listp a))(setq a (list a)))
    (if (not (listp b))(setq b (list b)))
    (dolist (i a)
      (setq y t)
      (dolist (j b)
        (if (equal i j)(setq y nil)))
      (if y (setq x (append x (list i)))))
    (dolist (i b)
      (setq y t)
      (dolist (j a)
        (if (equal i j)(setq y nil)))
      (if y (setq x (append x (list i)))))
    (return x))
)

(defun set-max-scale(w each);each:nil->all t:->each ch
  (let ((x)(nch))
    (setq x (get-widget-max w))
    (if (not each)
      (progn
        ;(setq x (eval (cons 'max x)));; function same to the above code
        (setq x (apply #'max x))
        (setq nch (resource w :channels))
        (if (> (second (matrix-extent (resource w :offsets))) 0)(setq x (* x 20)))
        (setq x (make-matrix nch 1 x)))
      (setq x (transpose (matrix (list x)))))
    (set-resource w :scales x))
)

(defun set-MEG-EEG-default()
  (let ((x))
    (set306offset)
    (select-megch "L-temporal")
    (select-eegch "banana")
    (select-eegch "misc")
    (set-max-scale (G-widget "disp3") nil)
    (set-resource  (G-widget "disp1") :superpose t)
    (link (G-widget "meg8G")(G-widget "disp1"))
    (set306amp)
    ;(set-max-scale (G-widget "disp1") nil)
    (set-max-scale (G-widget "disp4") nil)
    (set-max-scale (G-widget "disp5") t))
)

(defun set-MEG-EEG-default-scale()
  (let ((nch)(xx)(str)(ch))
    (setq nch (resource (G-widget "disp1") :channels))
    (set-resource (G-widget "disp1") :scales (make-matrix nch 1 (*  my-gradiometer-scale 20)))
    (setq nch (resource (G-widget "disp2") :channels))
    (set-resource (G-widget "disp2") :scales (make-matrix nch 1 (*  my-magnetometer-scale 20)))
    (set306offset)
    (setq nch (resource (G-widget "disp3") :channels))
    (setq str (get-property (G-widget "disp3") 0 :name))
    (setq ch (read-from-string (string-trim "MEG" str)))
    (if (= 1 (mod ch 10))
      (set-resource (G-widget "disp3") :scales (make-matrix nch 1 my-magnetometer-scale))
      (set-resource (G-widget "disp3") :scales (make-matrix nch 1 my-gradiometer-scale)))
    (setq nch (resource (G-widget "disp4") :channels))
    (set-resource (G-widget "disp4") :scales (make-matrix nch 1 my-eeg-scale)))
)

(defun setSSP()
  (let ((filename (resource (G-widget "file") :filename)))
    (graph::ssp-popup)
    (graph::ssp-load-file filename)
    (setq graph::ssp-vectors graph::ssp-vector-pool)
    (graph::ssp-rebuild-space)
    (graph::ssp-on))  
)

(defun show-info()
  (let ((str)(filename (resource (G-widget "file"):filename)))
    (if (not filename)(setq str "No fiff file is loaded")(setq str (format nil "~a is loaded." filename)))
    (XmTextSetInsertionPosition my-text903 999999999)
    (my-text-insert (format nil "~%~a" str)))
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

(defun sort-order-check(x xlist)
  (let ((xx nil))
    (dolist (i xlist)
      (setq xx (append xx (list (nth i x)))))
    (return xx))
)

(defun strm-append(str  &rest L)
  "Returns string as well as str-append but expanded using stream"
  (let ((strm (make-string-output-stream)(i)))
    (write-string str strm)
    (dotimes (i (length L))
      (write-string (nth i L) strm))
    (get-output-stream-string strm))
)

(defun string-check(str)
  (let ((strm)(x nil))
    (setq strm (make-string-input-stream str))
    (dotimes (i (length str))
      (setq x (append x (list (read-char strm)))))
    (return x))
)

(defun string-rep-char(str old new)
;(string-repl-char "1234567123" "1" "0")->"0234567023"
  (let ((str0 "zzz")(strm)(x)(oldchar)(newchar))
    (setq oldchar (character old) newchar (character new))
    (setq strm (make-string-input-stream str))
    (dotimes (i (length str))
      (setq x (read-char strm))
      (if (equal x oldchar)(setq x newchar))
      (setq str0 (strm-append str0 (format nil "~a" x))))     
    (return (string-left-trim "zzz" str0)))
) 

(progn
  (if (not (resource (G-widget "file") :directory))(execute1)(execute2))
)
