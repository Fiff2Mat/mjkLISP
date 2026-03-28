;;Released by Akira Hashizume, Hiroshima University Hospital
;;on 2026-March-23
;;
;;for details, see AboutMe
;;
(defuserparameter *hns-meg* "/home/neurosurgery/lisp/hns_meg6" 
 "fullname-extension" 'string 'misc-defaults)
(defuserparameter tick-interval 1.0 "tick-interval of plotter"
 'number 'misc-defaults)
(defvar text-start  nil "start")
(defvar text-length nil "length")
(defvar text-gra nil "scale of gradiometer")
(defvar text-mag nil "scale of magnetometer")
(defvar text-eeg nil "scale of EEG")
(defvar text-ecg nil "scale of ECG")
(defvar text-eog nil "scale of EOG")
(defvar text-emg nil "scale of EMG")
(defvar displabel nil "label of dispgra & dispmag & dispeeg")
(defvar gralabel nil "label of dispgra")
(defvar maglabel nil "label of dispmag")
(defvar eeglabel nil "label of dispeeg")
(defvar labels4 nil "copy of disp- gra- mag- eeglabels")
(defvar noisemenu nil "form of noise menu")
(defvar near-coil nil "nearest coils")
(defvar loadfiffname "" "loaded fiff file name")

(load (format nil "~asetup-widgets.lsp" (filename-directory *hns-meg*)))
(load (format nil "~asetup-eeg.lsp"     (filename-directory *hns-meg*)))

(defun AboutMe()
  (let ((str "")(strs)(n))
    (setq strs (list
    "About hns_meg6.lsp"
    ""
    "Released by Akira Hashizume, Hiroshima University Hospital"
    "on 2026-March-23,"
    "revised on 2026-March-28"
    "This code is designed for MEG epilepsy analysis"
    ""
    "This program hns_meg6.lsp requires other 4 files,"
    "setup-widgets.lsp, setup-eeg.lsp,read_bdip, and select_bdip."
    "The latter are compiled file from read_bdip5.c and select_bdip.c"
    "Those files are uploaded in GitHub.    "
    ""
    ""
    "DISCLAIMER"
    "Use this code at your own risk!"
    "The author is never responsible for any outcom after use of thie code"
    ))
    (dolist (n strs)
      (setq str (format nil "~a~%~a" str n)))
    (info str)
))

(defun add-layout()
  (make-menu *display-menu* "layout" nil
    '("2 display" (layout1 "gra-L-temporal" "banana1"))
    '("3 display" (layout1 "GRA204" "gra-L-temporal" "banana1"))
    '("4 display" (layout1 "MAG102" "GRA204" "gra-L-temporal" "banana1"))
    '("5 display" (layout1 
           "MAG102" "mag-L-temporal" "GRA204" "gra-L-temporal" "banana1"))
    '("paned 2 display" (layout2 "gra-L-temporal" "banana1"))
    '("paned 3 display" (layout2 "GRA204" "gra-L-temporal" "banana1"))
    '("paned 4 display" (layout2 "MAG102" "GRA204" "gra-L-temporal" "banana1"))
    '("paned 5 display" (layout2 
           "MAG102" "mag-L-temporal" "GRA204" "gra-L-temporal" "banana1"))
    '("8GRA 1MAG 1EEG"  (layout3 
           "gra-L-temporal" "gra-R-temporal" "gra-L-parietal" "gra-R-parietal"
           "gra-L-occipital" "gra-R-occipital" "gra-L-frontal" "gra-R-frontal"
           "MAG102" "banana1"))
    '("1GRA 8MAG 1EEG"  (layout3
           "mag-L-temporal" "mag-R-temporal" "mag-L-parietal" "mag-R-parietal"
           "mag-L-occipital" "mag-R-occipital" "mag-L-frontal" "mag-R-frontal"
           "GRA204" "banana1"))
    )
)

(defun add-sync()
  (let ((n)(name)(t0)(span)(st1)(st2)(disp)(R nil)(w))
    (setq t0 (read-from-string (XmTextGetString text-start)))
    (setq span (read-from-string (XmTextGetString text-length)))    
    (dotimes (n 10)
      (setq name (format nil "disp~d" (1+ n)))
      (if (G-widget name :quiet)(progn
        (setq w (G-widget name))
        (setq st1 (format nil "(sync-disp-move ~d)" (1+ n)))
        (setq st2 (format nil "(sync-disp-select ~d)" (1+ n)))
        (set-resource w
          :tick-interval tick-interval
          :point t0 :length span
          :x-unit "s"
          :move-hook (read-from-string st1)
          :select-hook (read-from-string st2))
        (if (string-member (nth n R) (list "GRA204" "MAG102"))
          (set-resource w :ch-label-space 0)
          (set-resource w :ch-label-space 80)) )))
))

(defun autoscale(chtype)
  (let ((mxwn)(mxvp)(w (G-widget "disp1"))(mx))
    (setq mxwn (require-widget :data-window "mxwn"))
    (set-resource mxwn :point (resource w :point)
      :start 0 :end (resource w :length))
    (setq mxvp (require-widget :vecop "mxvp" '("mode" "abs-max")))
    (link mxwn mxvp)
    (cond
      ((string-equal chtype "GRA")(progn
         (link (G-widget "gra") mxwn)
         (setq mx (get-widget-max mxvp))
         (setq mx (format nil "~0,0f" (* (first mx) 1e+13)))
         (XmTextSetString text-gra mx)))
      ((string-equal chtype "MAG")(progn
         (link (G-widget "mag") mxwn)
         (setq mx (get-widget-max mxvp))
         (setq mx (format nil "~0,0f" (* (first mx) 1e+15)))
         (XmTextSetString text-mag mx)))
      ((string-equal chtype "EEG")(progn
         (link (G-widget "eeg") mxwn)
         (if (> (resource mxwn :channels) 0)(progn
         (setq mx (get-widget-max mxvp))
         (setq mx (format nil "~0,0f" (* (first mx) 1e+6)))
         (XmTextSetString text-eeg mx)))))
      ((string-equal chtype "ECG")(progn
         (link (G-widget "ECG-fil") mxwn)
         (if (> (resource mxwn :channels) 0)(progn
         (setq mx (get-widget-max mxvp))
         (setq mx (format nil "~0,0f" (* (first mx) 1e+6)))
         (XmTextSetString text-ecg mx)))))
      ((string-equal chtype "EOG")(progn
         (link (G-widget "EOG-fil") mxwn)
         (if (> (resource mxwn :channels) 0)(progn
         (setq mx (get-widget-max mxvp))
         (setq mx (format nil "~0,0f" (* (first mx) 1e+6)))
         (XmTextSetString text-eog mx)))))
      ((string-equal chtype "EMG")(progn
         (link (G-widget "EMG-fil") mxwn)
         (if (> (resource mxwn :channels) 0)(progn
         (setq mx (get-widget-max mxvp))
         (setq mx (format nil "~0,0f" (* (first mx) 1e+6)))
         (XmTextSetString text-emg mx)))))
    )
  (dolist (w (list "mxwn" "mxvp"))(GtDeleteWidget (G-widget w)))
))

(defun buildC()
  (let ((dir)(str)(files)(n))
    (setq dir (filename-directory *hns-meg*))
    (dolist (n (list "read_bdip" "select_bdip"))
      (setq str (format nil "gcc ~a~a5.c -o ~a~a" dir n dir n))
      (system str)
      (setq str (format nil "chmod +x ~a~a" dir n))
      (system str))
    (info "Two files, read_bdip and select_bdip have been built!")
))

(defun button-no-edge(btn)
  (set-values btn :background (rgb 240 240 240)
    :shadowThickness 0 :detailShadowThickness 0)
)

(defun calc-noise-level()
  (let ((t0)(span)(disp)(mxwin)(mxvcp)(data)(func1)(x)(hb))
    (defun func1(mtx)
      (let ((n))
        (setq n (length mtx))
        (/(* mtx (make-matrix n 1 1))n) ))
    (setq disp (G-widget "disp1"))
    (setq span (resource disp :selection-length))
    (when (> span 0)(progn
      (setq mxwin (G-widget "mxwin"))
      (setq mxvcp (G-widget "mxvcp"))
      (setq t0 (resource disp :selection-start))
      (link (G-widget "gra")mxwin)
      (set-resource mxwin :point t0 :start 0 :end span)
      (setq hb (resource mxwin :high-bound))
      (link mxwin mxvcp)
      (set-resource mxvcp :mode "rms")
      (setq data (get-data-matrix mxvcp 0 hb))
      (setq x (* (func1 data) 1e+13))
      (XmTextSetString text-granoise (format nil "~0,1f" x))
      (link (G-widget "mag") mxwin)
      (set-resource mxwin :point t0 :start 0 :end span)
      (setq data (get-data-matrix mxvcp 0 hb))
      (setq x (* (func1 data) 1e+15))
      (XmTextSetString text-magnoise (format nil "~0,1f" x))
    ))
))

(defun change-color(&optional (ncol 0))
  (let ((col)(n)(disp)(dispname)(ch-class)(x))
    (if (= ncol 0)
      (if (= (get-integer-resource text-gra "foreground") 0)
        (setq ncol 1)(setq ncol 2)))
    (case ncol
      (1 (setq col (list (rgb 0 0   0)(rgb 0 0 0)  (rgb   0 0 0))))
      (2 (setq col (list (rgb 0 0 255)(rgb 0 128 0)(rgb 128 0 0))))
    )
    (set-values text-gra :foreground (first col))
    (set-values text-mag :foreground (second col))
    (dolist (n (list text-eeg text-ecg text-eog text-emg))
      (set-values n :foreground (third col)))
    (dotimes (n 10)
      (setq disp (G-widget (format nil "disp~d" (1+ n)) :quiet))
        (when disp
          (setq x "black")
          (if (= ncol 2)(progn
            (setq ch-class (get-property disp 0 :ch-class))
            (cond
              ((equal ch-class 'other)(setq x "darkred"))
              ((equal ch-class 'meg-planar)(setq x "blue"))
              ((equal ch-class 'meg-magmeter)(setq x "darkgreen"))
            )))
        (set-resource disp :default-color x)))
    (if (= ncol 2)(setq col (list "blue" "darkgreen" "darkred"))
                 (setq col (list "black" "black" "black")))
    (set-resource (G-widget "dispgra") :default-color (first col))
    (set-resource (G-widget "dispmag") :default-color (second col))
    (set-resource (G-widget "dispeeg") :default-color (third col))
    (set-resource (G-widget "scandisp"):default-color (first col))
))

(defun change-lead1020(eeg1)
  (let ((n)(lead)(for10)(for20)(R)(str)(xx))
    (defun for10(ch)(let ((x))
       (setq x ch)
       (cond
         ((string-equal ch "T3")(setq x "T7"))
         ((string-equal ch "T4")(setq x "T8"))
         ((string-equal ch "T5")(setq x "P7"))
         ((string-equal ch "T6")(setq x "P8"))
       )
       (return x)))
     (defun for20(ch)(let ((x))
       (setq x ch)
       (cond
         ((string-equal ch "T7")(setq x "T3"))
         ((string-equal ch "T8")(setq x "T4"))
         ((string-equal ch "P7")(setq x "T5"))
         ((string-equal ch "P8")(setq x "T6"))
       )
       (return x)))
    (if (string-member "T7" eeg1)(setq xx 10)(setq xx 20))
    (dolist (m (list "banana1a" "banana1b" "banana2a" "banana2b" 
       "transversea" "transverseb" "mono1" "mono2"))
       (setq R nil)
       (setq lead (eval (read-from-string m)))
       (dotimes (n (length lead))
         (if (= xx 20)
           (setq R (cons (for20 (nth n lead)) R))
           (setq R (cons (for10 (nth n lead)) R)) ))
       (print R)
       (setq str (format nil "(setq ~a R)" m))
       (eval (read-from-string str))  )  
))

(defun change-pane(str)
  (let ((x)(disp)(scales)(t0)(span))
    (if (string-member str (list "up" "down"))(progn
      (if (string-equal str "up")(setq x 0.8)(setq x 1.25))
      (dolist (disp (list "dispgra" "dispmag" "dispeeg"))
        (setq scales (resource (G-widget disp) :scales))
        (setq scales (* scales x))
        (set-resource (G-widget disp) :scales scales)  )))  
    (if (string-member str (list "left" "right"))(progn
      (setq disp (G-widget "disp1"))
      (setq t0   (resource disp :selection-start))
      (setq span (resource disp :selection-length))
      (if (> span 0)(progn
        (if (string-equal str "left")(setq span (- 0 span)))
        (set-resource disp :selection-start (+ t0 (/ span 4)))
        (sync-disp-select))) ))
))

(defun change-scale(str)
  (let ((n)(name)(disp)(ch-class nil)(ch)(scale)(nch)(w)(mtx)
    (eeg)(ecg)(eog)(emg))
    (cond 
      ((string-equal str "gra")(setq ch 'meg-planar))
      ((string-equal str "mag")(setq ch 'meg-magmeter))
      ((string-member str (list "eeg" "ecg" "eog" "emg"))
        (setq ch 'other))
    )
    (dotimes (n 20)
      (setq name (format nil "disp~d" (1+ n)))
      (when (G-widget name :quiet)
        (setq disp (G-widget name))
        (setq nch (resource disp :channels))
        (when (equal ch (get-property disp 0 :ch-class))(progn
          (if (equal ch 'meg-planar)(progn
            (setq scale (read-from-string (XmTextGetString text-gra)))
            (if (> nch 200)(setq scale (* scale 10)));GRA204
            (setq mtx (make-matrix nch 1 (* scale 1e-13)))
            (set-resource disp :scales mtx)))
          (if (equal ch 'meg-magmeter)(progn
            (setq scale (read-from-string (XmTextGetString text-mag)))
            (if (> nch 100)(setq scale (* scale 10)));MAG102
            (setq mtx (make-matrix nch 1 (* scale 1e-15)))
            (set-resource disp :scales mtx)))
          (if (equal ch 'other)(progn
            (setq eeg (read-from-string (XmTextGetString text-eeg)))
            (setq ecg (read-from-string (XmTextGetString text-ecg))) 
            (setq eog (read-from-string (XmTextGetString text-eog)))
            (setq emg (read-from-string (XmTextGetString text-emg)))
            (setq mtx nil)
            (dotimes (n nch)
              (case (get-property disp n :kind)
                (2   (setq mtx (append mtx (list eeg))))
                (402 (setq mtx (append mtx (list ecg))))
                (302 (setq mtx (append mtx (list emg))))
                (202 (setq mtx (append mtx (list eog))))
              ))
            (setq mtx (* (transpose (matrix (list mtx))) 1e-6))
            (set-resource disp :scales mtx))) 
      ))))
))

(defun change-scale-value(text x)
  (let ((val))
    (setq val (read-from-string (XmTextGetString text)))
    (setq val (* val (pow 0.8 x)))
    (XmTextSetString text (format nil "~0,0f" val))
))

(defun change-scandisp-scale()
  (let ((val)(mtx))
    (setq val (read-from-string (XmTextGetString text-scanscale)))
    (set-resource (G-widget "scandisp") :scales
      (make-matrix 8 1 (* val 1e-13)))
))

(defun change-time(&optional (w nil))
  (let ((n)(name)(tmin)(tmax)(buf)(t0)(span))
    (setq buf (G-widget "buf"))
    (setq tmin (sample-to-x buf (resource buf :low-bound)))
    (setq tmax (sample-to-x buf (resource buf :high-bound)))
    (setq t0 (read-from-string (XmTextGetString text-start)))
    (setq span (read-from-string (XmTextGetString text-length)))
    (if (< t0 tmin)(progn (setq t0 tmin)
      (XmTextSetString text-start (format nil "~0,2f" t0))))
    (if (> (+ t0 span) tmax)(progn (setq t0 (- tmax span))
      (XmTextSetString text-start (format nil "~0,2f" t0))))
    (if w
      (set-resource w :point t0 :length span)
      (dotimes (n 20)
        (setq name (format nil "disp~d" (1+ n)))
        (when (G-widget name :quiet)
          (set-resource (G-widget name) :point t0 :length span))))
))

(defun check-scale()
  (let ((R 0)(h 30)(gra)(mag)(eeg)(ecg)(eog)(emg))
    (setq gra (XtParent text-gra))
    (setq mag (XtParent text-mag))
    (setq eeg (XtParent text-eeg))
    (setq ecg (XtParent text-ecg))
    (setq eog (XtParent text-eog))
    (setq emg (XtParent text-emg))
    (when (XtIsManaged gra)(setq R (+ R h)));constantly managed
    (when (XtIsManaged mag)(set-values mag :topOffset R)(setq R (+ R h)))
    (when (XtIsManaged eeg)(set-values eeg :topOffset R)(setq R (+ R h)))
    (when (XtIsManaged ecg)(set-values ecg :topOffset R)(setq R (+ R h)))
    (when (XtIsManaged eog)(set-values eog :topOffset R)(setq R (+ R h)))
    (when (XtIsManaged emg)(set-values emg :topOffset R)(setq R (+ R h)))
    (return R)   
))

(defun clear-frame001()
  (let ((form)(name)(n)(m)(form0)(formn)(btn))
    (dotimes (n 10)
      (clear-widgets (1+ n))
      (setq name (format nil "disp~d" (1+ n)))
      (when (G-widget name :quiet)(GtDeleteWidget (G-widget name))))
    (setq form (XtNameToWidget frame001 "form"))
    (setq form0 (XtNameToWidget form "form0"))
    (create-bartext)
    (setq pane (XtNameToWidget form0 "pane"));layout2
    (if pane (progn (dotimes (n 5)
      (setq formn (XtNameToWidget pane (format nil "form0~d" (1+ n))))
      (when formn (progn (dotimes (m 8)
        (setq name (format nil "btn~d-~d" (1+ n)(1+ m)))
        (setq btn (XtNameToWidget formn name))
        (when btn (XtDestroyWidget btn)))
        (XtDestroyWidget formn))))
      (XtDestroyWidget pane)))

    (dotimes (n 10)(dotimes (m 8)
      (setq name (format nil "btn~d-~d" (1+ n)(1+ m)))
      (setq btn (XtNameToWidget form0 name))
      (when btn (XtDestroyWidget btn))))
    (gc)
))

(defun clear-widgets(n);integer or disp~d
  (let ((name)(dispw)(form0)(nn)(w))
    (gc)
    (if (stringp n)
      (setq n (read-from-string (string-left-trim "disp" n))))
    (setq name (format nil "disp~d" n))
    (when (G-widget name :quiet)
      (set-resource (G-widget name) :ch-label-space 80 :superpose nil)
      (setq dispw (resource (G-widget name) :display-widget))
      (set-values dispw :leftOffset -5))
    (setq form0 (XtNameToWidget (XtNameToWidget frame001 "form") "form0"))
    (when form0
      (dotimes (nn 8)
        (setq name (format nil "btn~d-~d" n (1+ nn)))
        (setq w (XtNameToWidget form0 name))
        (if w (XtDestroyWidget w)) ))
    (setq name (format nil "pick~d" n))
    (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
    (setq name (format nil "pick~ds" n))
    (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
    (setq name (format nil "fsub~d" n))
    (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
    (setq name (format nil "sel~d" n))
    (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
    (setq name (format nil "vecop~d" n))
    (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
    (gc) 
))

(defun create-bartext(&rest strlist);"GRA204" "gra-L-temporal" "banana1"...
  (let ((form)(form0)(n)(m)(dispname)(bar)(menu)(text)(rgb)(func1)(this)
    (str)(func2)(chlist))
    (defun func1(dispname type)
      (read-from-string (format nil "(dolink '~a '~a)"
        dispname type)))
    (defun func2(menu dispname chlist)
      (let ((this)(chs)(ch)(sch))
        (setq chs (list "L-temporal" "R-temporal" "L-parietal" "R-parietal"
            "L-occipital" "R-occipital" "L-frontal" "R-frontal"))
        (add-button menu "GRA204" (func1 dispname "GRA204"))
        (add-button menu "MAG102" (func1 dispname "MAG102"))
        (setq this (make-menu menu "gradiometer" nil))
        (dolist (ch chs)
          (setq sch (str-append "gra-" ch))
          (add-button this sch (func1 dispname sch)))
        (setq this (make-menu menu "magnetometer" nil))
        (dolist (ch chs)
          (setq sch (str-append "mag-" ch))
          (add-button this sch (func1 dispname sch)))
        (setq this (make-menu menu "EEG"  nil))
        (dolist (ch chlist)
          (add-button this ch (func1 dispname ch))) ))
    (defun rgb(r g b)(+ (* (+ (* r 256) g) 256) b))

    (setq chlist (list "banana1" "banana2" "banana3" 
            "transverse" "mono1" "mono2" "average1" "average2"))
    (setq form  (XtNameToWidget frame001 "form"))
    (setq form0 (XtNameToWidget form "form0")) 
    (dotimes (n 10)
      (setq bar (XtNameToWidget form0 (format nil "disp~d-menubar" (1+ n))))
      (if bar (progn
        (setq menu (XtNameToWidget bar "ch"))
        (when menu (XtDestroyWidget menu))
        (XtDestroyWidget bar)))
     (setq text (XtNameToWidget form0 (format nil "disp~d-text" (1+ n))))
     (when text (XtDestroyWidget text)) )
    (gc)
    (setq strlist (first strlist) ndisp (length strlist))
    (if (= ndisp 10)
      (dotimes (n 5)(dotimes (m 2)
        (setq dispname (format nil "disp~d" (+ (* n 2) m 1)))
        (setq bar (make-menu-bar form0 (str-append dispname "-menubar")
          :topAttachment XmATTACH_POSITION :topPosition (* m 50)
          :leftAttachment XmATTACH_POSITION :leftPosition (* n 20)
          :shadowThickness 0 :background (rgb 240 240 240)))
        (setq menu (make-menu bar "ch" nil :---- ))
        (apply 'manage (list menu bar))
        (func2 menu dispname)
        (setq text (make-textfield form0 (str-append dispname "-text")
          :topAttachment XmATTACH_POSITION :topPosition (* m 50)
          :leftAttachment XmATTACH_WIDGET :leftWidget bar
          :rightAttachment XmATTACH_POSITION :rightPosition (* (1+ n) 20)
          :shadowThickness 0 :background (rgb 224 224 224)
          :editable 0))
        (XmTextSetString text (nth n strlist))
        (manage text)   )) 
     (progn (dotimes (n ndisp)
       (setq dispname (format nil "disp~d" (1+ n)))
       (setq bar (make-menu-bar form0 (str-append dispname "-menubar")
          :topAttachment XmATTACH_FORM
          :leftAttachment XmATTACH_POSITION 
          :leftPosition (round (/ (* n 100) ndisp))
          :shadowThickness 0 :background (rgb 240 240 240)))
       (setq menu (make-menu bar "ch" nil :----))
       (func2 menu dispname chlist)
       (apply 'manage (list menu bar))
       (setq text (make-textfield form0 (str-append dispname "-text")
          :topAttachment XmATTACH_FORM
          :leftAttachment XmATTACH_WIDGET :leftWidget bar
          :shadowThickness 0 :background (get-backgroundcolor)
          :editable 0 :width 150))
        (XmTextSetString text (nth n strlist))
        (manage text) )) )     
    (dotimes (n ndisp)
      (setq dispname (format nil "disp~d" (1+ n)))
      (setq str (nth n strlist))
      (dolink dispname str)) 
))

(defun create-memos()
  (let ((form)(bar)(btn1)(btn)(pane)(memo)(n)(frame)(memo)(label)(str)(formn))
    (defvar form-memos nil "memos of epochs")
    (defvar memo1 nil "memo1 of epochs")
    (defvar memo2 nil "memo2 of epochs")
    (defvar memo3 nil "memo3 of epochs")
    (defvar memo4 nil "memo4 of dipoles")
    (defvar prompt nil "promptDialog")
    (setq form (make-form-dialog *application-shell* "memos"
      :autoUnmanage 0 :resizable 1 :title "memo of epochs"))
    (setq bar (make-menu-bar form "bar" :autoUnmanage 0
      :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM))
    (create-memos-menu bar)
    (setq btn1 (create-memos-btns form bar))
    (setq pane (XmCreatePanedWindow form "pane" (X-arglist) 0))
    (set-values pane :separatorOn 0 :sasIndent -1
      :topAttachment XmATTACH_WIDGET :topWidget btn1
      :bottomAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM)
    (dotimes (n 4)
      (setq formn (make-form pane (format nil "form~d" (1+ n))))
      (setq label (create-memos-labelbtn n formn))
      (setq frame (make-frame formn (format nil "frame~d" (1+ n)) 
        :resize 1 :leftAttachment XmATTACH_FORM 
        :leftOffset (if (= n 3)0 15) :rightAttachment XmATTACH_FORM
        :topAttachment XmATTACH_WIDGET :topWidget label 
        :bottomAttachment XmATTACH_FORM))
      (if (= n 3)(create-memos-add formn frame))
      (if (< n 3)
        (setq memo (XmjkLispList frame (format nil "memo~d" (1+ n))
          'list-of-epoch :width 500 :height 100
          :listSizePolicy XmCONSTANT :selectionPolicy XmEXTENDED_SELECT))
        (setq memo (XmjkLispList frame "memo4"
          'list-of-bdip  :height 200
          :listSizePolicy XmCONSTANT :selectionPolicy XmEXTENDED_SELECT)))
      (eval (read-from-string (format nil "(setq memo~d memo)" (1+ n))))
      (setq btn (make-button formn "btn" :labelString (XmString "  ")
        :topAttachment  XmATTACH_FORM :leftAttachment XmATTACH_FORM
        :leftOffset -5 :bottomAttachment XmATTACH_FORM :shadowThickness 0 
        :detailShadowThickness 0 :background (rgb 250 250 250)))
      (apply 'manage (list memo frame btn formn)) 
      (set-lisp-callback btn "activateCallback"
        (read-from-string (format nil "(memo-focus ~d)" n)))
       (if (= n 3)(XtDestroyWidget btn)) )  
    (apply 'manage (list pane form))
    (setq form-memos form)
    (memo-focus 0)
    (add-button *display-menu* "show memos" '(manage form-memos))
))

(defun create-memos-add(formn frame)
  (let ((btn1)(btn4)(btn5)(label1)(label2)(label3)
    (func1)(func2)(func3)(func4))
    (defun func1(btn)
      (set-values btn :background (rgb 245 245 245)))
    (defun func2(name title offset command)
      (let ((btn))
        (setq btn (make-button formn name :labelString (XmString title)
          :topAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM
          :leftOffset offset :height 30 :width 50))
        (set-lisp-callback btn "activateCallback" command)
        (manage btn) (return btn) ))
    (defun func3(name title Xw)
      (let ((label))
        (setq label (make-label formn name :labelString (XmString title)
          :topAttachment  XmATTACH_FORM :topOffset 5
          :leftAttachment XmATTACH_WIDGET :leftWidget Xw :leftOffset 5))
        (manage label) (return label)  ))
    (defun func4(name width Xw title)
      (let ((text))
        (setq text (make-textfield formn name
          :topAttachment XmATTACH_FORM :width width 
          :leftAttachment XmATTACH_WIDGET :leftWidget Xw))
        (XmTextSetString text title)(manage text)(return text)  ))
    (defvar text-gof nil "GOF %")
    (defvar text-cf  nil "confidence volume")
    (defvar text-khi nil "khi^2")
    (setq btn1 (func2 "btn1" "reload" 0 '(dipdata)))
    (func2 "btn2" "delete" 50 '(dipdelete))
    (func2 "btn3" "extract" 100 '(dipdelete t))
    (setq btn4 (func2 "btn4" "filter" 150 '(dipfilter)))
    (setq label1 (func3 "label1" "gof" btn4))
    (setq text-gof (func4 "text-gof" 40 label1 "70"))
    (setq label2 (func3 "label2" "cv" text-gof))
    (setq text-cv (func4 "text-cv" 40 label2 "-1"))
    (setq label3 (func3 "label3" "khi2" text-cv))
    (setq text-khi (func4 "text-khi" 60 label3 "-1"))
    (setq btn5 (make-button formn "btn5" 
      :topAttachment XmATTACH_FORM :height 30
      :rightAttachment XmATTACH_FORM 
      :labelString (XmString "apply to xfit")))
    (func1 btn1)(func1 btn5)
    (manage btn5)
    (set-lisp-callback btn5 "activateCallback" '(dipapply))
))

(defun create-memos-btns(form bar)
  (let ((btn1)(func1))
    (defun func1(name title offset command)
      (let ((btn))
        (setq btn (make-button form name :labelString (XmString title)
         :topAttachment XmATTACH_WIDGET :topWidget bar
         :leftAttachment XmATTACH_FORM :leftOffset offset
         :height 30 :width 50))
        (set-lisp-callback btn "activateCallback" command)
        (manage btn)(return btn) )) 
    (manage bar)
    (setq btn1 (func1 "btn1" "note" 0 '(memo-note)))
    (func1 "btn2" "goto" 50 '(memo-goto))
    (func1 "btn3" "fit" 100 '(memo-fit))
    (func1 "btn4" "delete" 150 '(memo-delete-epoch nil))
    (func1 "btn5" "extract" 200 '(memo-delete-epoch t))
    (func1 "btn6" "PNG" 250 '(memo-pngsave 2))
    (return btn1)
))

(defun create-memos-labelbtn(n formn)
  (let ((str)(offset)(label)(m)(btn1)(btn2)(btn3)(btn4)(func1))
    (defun func1(formn name topoffset leftoffset width)
      (let ((btn))
        (setq btn (make-button formn name 
          :foreground (rgb 0 0 255)
          :shadowThickness 0 :detailShadowThickness 0
          :topAttachment XmATTACH_FORM :topOffset topoffset
          :leftAttachment XmATTACH_FORM :leftOffset leftoffset
          :width width :labelString (XmString name)))))
    (dolist (m (list btn1 btn2 btn3 btn4))(setq m nil))
    (if (< n 3)
      (setq offset 0 str (format nil "~t  sec ~t span" 10 20))
      (setq offset 30 str (format nil 
      "~t x ~t y ~t z ~t Qx ~t Qy ~t Qz"
        18 30 40 48 55 65)))
    (setq label (make-label formn "label"
      :topAttachment XmATTACH_FORM :topOffset offset
      :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM
      :alignment XmALIGNMENT_BEGINNING :labelString (XmString str)))
    (manage label)
    (if (< n 3)(progn
      (setq btn1 (func1 formn "sns" offset 150 40))
      (setq btn2 (func1 formn "peak" offset 225 40))
      (setq btn3 (func1 formn "fT/cm" offset 280 40))
      (set-lisp-callback btn1 "activateCallback" '(memo-sort 2));coil
      (set-lisp-callback btn2 "activateCallback" '(memo-sort 3));time
      (set-lisp-callback btn3 "activateCallback" '(memo-sort 4));amp
      )(progn
      (setq btn1 (func1 formn "sec" offset 10 40))
      (setq btn2 (func1 formn "gof" offset 333 40))
      (setq btn3 (func1 formn "cv" offset 375 40))
      (setq btn4 (func1 formn "khi2" offset 430 40))
      (set-lisp-callback btn1 "activateCallback" '(dip-sort 0))
      (set-lisp-callback btn2 "activateCallback" '(dip-sort 7))
      (set-lisp-callback btn3 "activateCallback" '(dip-sort 8))
      (set-lisp-callback btn4 "activateCallback" '(dip-sort 9))
      ))   
    (dolist (m (list btn1 btn2 btn3 btn4))(if m (manage m)))
    (return label)
))

(defun create-memos-menu(bar)
  (let ((n)(this))
    (setq this (make-menu bar "file" nil))
    (add-button this "load *-wave.txt" '(memo-load))
    (add-button this "save *-wave.txt" '(memo-save))
    (add-separator this)
    (add-button this "save as PNG file" '(memo-pngsave))
    (add-button this "convert b*.png > epi*.png" '(rename-png "b" "epi"))
    (add-button this "convert epi*.png > b*.png" '(rename-png "epi" "b"))
    (add-separator this)
    (add-button this "clear all BDIP in XFIT" '(dipclear))
    (add-button this "add BDIP from BDIP file in XFIT" '(dipload))
    (add-button this "save BDIP file from XFIT" '(dipsave))
    (setq this (make-menu bar "epoch" nil))
    (add-button this "clear" '(memo-clear))
    (add-button this "clear all" '(memo-clear-all)) 
    (add-button this "create epoch from BDIP" '(dipepoch))
    (add-button this "extract epoch with dipoles" '(memo-extractepoch))
    (add-separator this)
    (make-menu this "waves" nil :tear-off
      '("discharge"   (memo-insert " discharge"))
      '("spike"       (memo-insert " spike"))
      '("polyspike"   (memo-insert " polyspike"))
      '("burst"       (memo-insert " burst"))
      '("ictal_onset" (memo-insert " ictal_onset"))
      '("EEG_spike"   (memo-insert " EEG_spike"))
      '("physiological_activities" (memo-insert " physiological_activities"))
      '("noise"       (memo-insert " noise"))
      :----
      '("free comment"(memo-insert2))
      :----
      '("delete comment" (memo-no-comment)))
    (make-menu this "copy" nil
      '("to memo1" (memo-copy 1))
      '("to memo2" (memo-copy 2))
      '("to memo3" (memo-copy 3)))
    (make-menu this "sort" nil
      '("time"      (memo-sort 3))
      '("coil"      (memo-sort 2))
      '("amplitude" (memo-sort 4)))   
    (setq this (make-menu bar "dipole" nil))
    (make-menu this "sort" nil
      '("time"      (dip-sort 0))
      '("Q nAm"     (dip-sort 4))
      '("gof"       (dip-sort 7))
      '("cv"        (dip-sort 8))
      '("khi2"      (dip-sort 9)))
    (add-button this "consecutive fit" '(memo-fit 0))
    (add-button this "create epoch from BDIP" '(dipepoch))
    (add-button this "extract epoch with dipoles" '(memo-extractepoch))
    (add-button this "extract dipoles with PNG file" '(dippng))
    (setq this (make-menu bar "routine" nil))
    (add-button this "scan > epochs > dipole > filter > PNG" '(routine 1))
    (add-button this "epochs > dipole > filter > PNG" '(routine 2))
    (add-button this "PNG > epoch & dipole > BDIP" '(routine 3))
    (setq this (make-menu bar "miscellaneous" nil))
    (make-menu this "line color" nil
      '("colored line" (change-color 2))
      '("black/white line" (change-color 1)))
    (add-button this "build C-files (only 1st use)" '(buildC))
      ))
))

(defun create-noisemenu()
  (let ((form)(btn1)(btn2)(label1)(label2)(rb)(tb1)(tb2)(tb3)(tbd)(form))
    (defvar text-granoise nil "noise level of gradiometer")
    (defvar text-magnoise nil "noise level of magnetoemter")
    (defvar text-baseline1 nil "noise estimation from")
    (defvar text-baseline2 nil "noise estimation to")
    (defvar long-baseline nil "noise estimation from long baseline") 
    (defvar rb-noise nil "noise estimation")
    (setq noisemenu (make-form-dialog *application-shell* "noisemenu"
      :autoUnmanage 0 :title "noise estimation method"))
    (setq btn1 (make-button noisemenu "btn1"
      :bottomAttachment XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM :rightAttachment XmATTACH_FORM
      :labelString (XmString "evaluate & close")))
    (set-lisp-callback btn1 "activateCallback" '(eval-noise-menu))
    (setq btn2 (make-button noisemenu "btn2"
      :bottomAttachment XmATTACH_FORM :bottomOffset 40
      :leftAttachment   XmATTACH_FORM :leftOffset 20
      :labelString (XmString "calc noise level from selected span")))
    (set-lisp-callback btn2 "activateCallback" '(calc-noise-level))
    (apply 'manage (list noisemenu btn1 btn2))
    (setq text-granoise (make-textfield noisemenu "text-granoise"
      :leftAttachment   XmATTACH_FORM   :leftOffset 20
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn2
      :bottomOffset 10 :width 60))
    (XmTextSetString text-granoise "5.0")
    (setq label1 (make-label noisemenu "label1"
      :leftAttachment   XmATTACH_WIDGET :leftWidget text-granoise
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn2 
      :bottomOffset 15 :labelString (XmString "fT/cm")))
    (setq text-magnoise (make-textfield noisemenu "text-magnoise"
      :leftAttachment   XmATTACH_WIDGET :leftWidget label1
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn2
      :bottomOffset 10 :width 60))
    (XmTextSetString text-magnoise "20.0")
    (setq label2 (make-label noisemenu "label2"
      :leftAttachment   XmATTACH_WIDGET :leftWidget text-magnoise
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn2
      :bottomOffset 15 :labelString (XmString "fT")))
    (apply 'manage (list text-granoise label1 text-magnoise label2))
    (setq rb (XmCreateRadioBox noisemenu "rb" (X-arglist) 0))
    (set-values rb 
      :leftAttachment   XmATTACH_FORM :leftOffset 1 
      :rightAttachment  XmATTACH_FORM :rightOffset 1
      :topAttachement   XmATTACH_FORM :topOffset 1
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text-granoise)
    (setq tb1 (make-toggle-button rb "tb1"
      :labelString (XmString "Compute from baseline (default)")))
    (setq tb2 (make-toggle-button rb "tb2"
      :labelString (XmString "Compute from baseline")))
    (setq tbd (make-toggle-button rb "tbd";dummy for spaceing in rb
      :labelString (XmString "") :indicatorOn 0))
    (setq form (make-form noisemenu "form"
      :topAttachment  XmATTACH_FORM :topOffset 60
      :leftAttachment XmATTACH_FORM :leftOffset 1
      :rightAttachment XmATTACH_FORM :rightOffset 1))
    (setq label1 (make-label form "label1" :labelString (XmString "peak from")
      :leftAttachment XmATTACH_FORM :leftOffset 20
      :topAttachment  XmATTACH_FORM :topOffset 5))
    (setq text-baseline1 (make-textfield form "text-baseline1"
      :leftAttachment XmATTACH_WIDGET :leftWidget label1
      :topAttachment  XmATTACH_FORM :width 60))
    (XmTextSetString text-baseline1 "-0.4")
    (setq label2 (make-label form "label2" :labelString (XmString "to")
      :leftAttachment XmATTACH_WIDGET :leftWidget text-baseline1
      :topAttachment  XmATTACH_FORM   :topOffset 5))
    (setq text-baseline2 (make-textfield form "text-baseline2"
      :leftAttachment XmATTACH_WIDGET :leftWidget label2 
      :topAttachment  XmATTACH_FORM   :width 60))
    (XmTextSetString text-baseline2 "-0.1")
    (setq tb3 (make-toggle-button rb "tb3" :set 1
      :labelString (XmString "Constant value for all channels"))) 
    (apply 'manage (list rb tb1 tb2 tbd tb3 form))
    (apply 'manage (list label1 text-baseline1 label2 text-baseline2))
    (unmanage noisemenu)
    (setq rb-noise rb)
))

(defun create-plotter(form0 name)
  (let ((disp)(dispw)(sc)(form))
    (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
    (setq form (XtNameToWidget frame001 "form"))
    (if (string-member name (list "dispgra" "dispmag" "dispeeg"))
      (setq form form0)) 
    (setq disp (GtMakeObject 'plotter :name name
      :display-parent form0  :scroll-parent form
      :no-controls t));not writable
    (put disp :display-form form0)
    (GtPopupEditor disp)
    (setq dispw (resource disp :display-widget))
    (set-values dispw :resizable 1
      :topAttachment XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM)
    (return (list disp dispw sc))
))

(defun create-scale(form)
  (let ((menubar)(menu)(text)(arU)(arD))
    (setq menubar (make-menu-bar form "bar" ;;XmRowColumn
      :shadowThickness 0 
      :topAttachment  XmATTACH_FORM :autoUnmanage 0
      :leftAttachment XmATTACH_FORM :leftOffset 20))
    (setq text (make-textfield form "text" 
      :topAttachment  XmATTACH_FORM 
      :leftAttachment XmATTACH_FORM :leftOffset 110))
    (XmTextSetString text "0")
    (setq arU (make-arrowbutton form "arU" 
      :arrowDirection XmARROW_UP :width 13
      :topAttachment  XmATTACH_OPPOSITE_WIDGET :topWidget text
      :leftAttachment XmATTACH_WIDGET :leftWidget text
      :topOffset 1))
    (setq arD (make-arrowbutton form "arD"
      :arrowDirection XmARROW_DOWN :width 13
      :bottomAttachment XmATTACH_OPPOSITE_WIDGET :bottomWidget text
      :leftAttachment XmATTACH_WIDGET :leftWidget text))
    (return (list menubar text arU arD)) 
))

(defun define-MEGsite()
  (let ((R1)(R2)(eeg1)(w))
     (setq R1 (setup-widgets::check-channel))
      ;VectorView
      ;MEG EEG STIM MISC
      ;Triux NEO 
      ;ECG EOG EEG Excitation ActiveShield MEG STIM system
      ;Cleaveland
      ;ECG EEG ActiveShield MEG STIM system
    (dolist (w (list "ECG" "EOG" "EMG"))
      (link (G-widget "buf")(G-widget w)))
    (setq R2 (second R1) R1 (first R1))
    (setq eeg1 eeg1-triuxneo);default
     (cond 
      ((string-equal (first R1) "MEG")(progn
        (setq eeg1 eeg1-vectorview)
        (dolist (w (list "ECG" "EOG" "EMG"))
          (link (G-widget "EEG")(G-widget w)) )))    
      ((and (not (string-member "Excitation" R1))
            (string-member "system" R1))(progn
        (if (> (second R2) 30)(setq eeg1 eeg1-cleaveland60)
                            (setq eeg1 eeg1-cleaveland))))
    )
    (change-lead1020 eeg1);(T7,T8,P7,P8)<>(T3,T4,T5,T6)
    (setup-widgets::setup-EEG eeg1)
 ))

(defun dipapply()
  (let ((R)(filename)(textfile)(bdipfile)(newbdip)(n)(fid)(str))
    (setq R (XmjkLispListGet memo4))
    (setq filename (resource (G-widget "file") :filename))
    (setq filename (filename-directory filename))
    (setq textfile (str-append filename "tmp6789.txt"))
    (setq bdipfile (str-append filename "tmp6789.bdip"))
    (setq newbdip  (str-append filename "loadbdip.bdip"))
    (setq fid (open textfile :direction :output :if-exists :supersede))
    (dotimes (n (length R))
      (princ (format nil "~a" (nth n R)) fid)
      (princ (format nil "~%") fid))
    (close fid)
    (graph::xfit-command (format nil "dipsave ~a" bdipfile))
    (graph::xfit-command "dipclear")
    (graph::xfit-command "dipclear");; this must be done twice
    (setq str (format nil "~a/select_bdip ~a ~a ~a"
      (filename-directory *hns-meg*) textfile bdipfile newbdip))
    (system str)
    (if R (dipload newbdip))    
    (system (format nil "rm ~a" textfile))
    (system (format nil "rm ~a" bdipfile))
    (system (format nil "rm ~a" newbdip))
))

(defun dipclear()
  (graph::xfit-command "dipclear")
  (graph::xfit-command "dipclear")
)

(defun dipdata()
  (let ((filename)(savename)(loadname)(str)(fid)(n)(L)(R nil))
    (setq filename (resource (G-widget "file") :filename))
    (setq filename (filename-directory filename))
    (setq savename (str-append filename "tmp12345.bdip"))
    (setq loadname (str-append filename "tmp12345.txt")) 
    (graph::xfit-command (format nil "dipsave ~a" savename))
    (setq str (format nil "~a/read_bdip ~a ~a" 
      (filename-directory *hns-meg*) savename loadname))
    (system str)
    (when (file-exists-p loadname)(progn
      (setq fid (open loadname :direction :input))
      (catch 'exit (dotimes (n 100000)
        (setq L (read-line-as-list fid))
        (when L (setq R (cons L R)))
        (if (not L)(throw 'exit t))))
        (XmjkLispListSet memo4 (reverse R)) ))
    (system (format nil "rm ~a" savename))
    (system (format nil "rm ~a" loadname))
))

(defun dipdelete(&optional (check nil))
  (let ((R)(S)(L)(n)(m 0)(Z nil))
    (setq R (XmjkLispListGet memo4))
    (setq S (XmjkLispListSelected memo4))
    (if (yes-or-no-p "Are you sure?") (progn
      (if check (XmjkLispListSet memo4 S)(progn
        (dotimes (n (length R))
          (if (equal (nth m S)(nth n R))
            (setq m (1+ m))
            (setq Z (cons (nth n R) Z))))
        (XmjkLispListSet memo4 (reverse Z)) ))))
))

(defun dipepoch()
  (let ((R)(D)(n)(span 0.5)(x)(t0))
    (setq x (/ span 2))
    (setq R (XmjkLispListGet memo4))
    (dotimes (n (length R))
      (setq t0 (/(first (nth n R))1000))
      (setq t0 (- t0 x))
      (set-resource (G-widget "disp1")
        :selection-start t0
        :selection-length span)
      (sync-disp-select 1)
      (memo-note))
))

(defun dipfilter()
  (let ((R)(n)(gov)(cv)(khi)(Z nil))
    (setq R (XmjkLispListGet memo4))
    (setq gof (read-from-string (XmTextGetString text-gof)))
    (setq cv  (read-from-string (XmTextGetString text-cv)))
    (setq khi (read-from-string (XmTextGetString text-khi)))
    (if (/= gof -1)(progn (dotimes (n (length R))
      (if (>= (nth 7 (nth n R))gof)(setq Z (cons (nth n R) Z))))
      (setq R (reverse Z) Z nil)))
    (if (/= cv -1)(progn (dotimes (n (length R))
      (if (<= (nth 8 (nth n R))cv)(setq Z (cons (nth n R) Z))))
      (setq R (reverse Z) Z nil)))
    (if (/= khi -1)(progn (dotimes (n (length R))
      (if (<= (nth 9 (nth n R))khi)(setq Z (cons (nth n R) Z))))
      (setq R (reverse Z))))
    (XmjkLispListSet memo4 R)
))

(defun dipload(&optional (loadname nil))
  (let ((folder)(filename)(ext))
    (setq folder (resource (G-widget "file") :directory))
    (setq folder (str-append (filename-directory folder) "*.bdip"))
    (if loadname 
      (graph::xfit-command (format nil "dipload ~a" loadname))  
    (progn
      (setq loadname (resource (G-widget "file") :filename))
      (setq loadname (format nil "~a.bdip" (filename-base loadname)))
      (setq filename (ask-filename "select BDIP file" 
        :template folder :default loadname))
      (when (file-exists-p filename)
        (graph::xfit-command (format nil "dipload ~a" filename)))))      
))

(defun dippng()
  (let ((n)(R)(L)(dir)(fid)(filename)(x)(tm nil))
    (setq R (XmjkLispListGet memo4))
    (setq filename (resource (G-widget "file") :filename))
    (setq dir (filename-directory filename))
    (system (format nil "ls ~ab*.png > ls.txt" dir));/home/ns/Documents
    (setq fid (open "ls.txt" :direction :input))
    (catch 'exit (dotimes (n 1000)
      (setq L (read-line fid))
      (unless L (throw 'exit t))
      (setq L (filename-base L))
      (setq L (string-trim "b.png" L))
      (setq tm (cons (read-from-string L) tm))))
    (close fid)
    (setq L nil)
    (setq R (XmjkLispListGet memo4))
    (dotimes (n (length R))
      (if (member (round (first (nth n R))) tm)
        (setq L (cons (nth n R) L))))
    (XmjkLispListSet memo4 (reverse L))   
))

(defun dipsave(&optional (newname nil))
  (let ((folder)(savename)(filename)(ext))
    (setq folder (resource (G-widget "file") :directory))
    (setq folder (str-append (filename-directory folder) "*.bdip"))
    (setq savename (resource (G-widget "file") :filename))
    (if newname (progn
      (if (string-equal (filename-extension newname) "")
        (setq newname (str-append newname ".bdip")))
      (unless (filename-directory newname)
        (setq savename (format nil "~a~a" 
          (filename-directory savename) newname)))
      (graph::xfit-command (format nil "dipsave ~a" savename)))
    (progn 
      (setq savename (format nil "~a.bdip" (filename-base savename)))
      (if (string-equal (filename-extension savename) "")
        (setq savename (str-append savename ".bdip")))
      (setq filename (ask-filename "Give new filename" :new t
        :template folder :default savename :if-exists :ask))    
      (when filename (progn
        (if (string-equal (filename-extension filename) "")
          (setq filename (format nil "~a~a.bdip" 
            (filename-directory filename)(filename-base filename))))
        (graph::xfit-command (format nil "dipsave ~a" filename))))))
))

(defun dip-sort(&optional (num 0));;under construction
  (let ((n)(R)(L nil)(order)(Z nil)(func1));0:time 4:Q 7:gof 8:cv 9:khi
    (defun func1(D)
      (sqrt (+ (sqr (nth 4 D))(sqr (nth 5 D))(sqr (nth 6 D)))))
    (setq R (XmjkLispListGet memo4))
    (if (= num 4)
      (dotimes (n (length R))
        (setq L (cons (func1 (nth n R)) L)))
      (dotimes (n (length R))
        (setq L (cons (nth num (nth n R)) L))) )
    (setq L (reverse L))
    (setq order (sort-order L))
    (setq Z nil)
    (dotimes (n (length R))
      (setq Z (cons (nth (nth n order) R) Z)))
    (unless (member num (list 4 7)) (setq Z (reverse Z)))
    (XmjkLispListSet memo4 Z)
))

(defun dolink(dispname str)
  (let ((n)(form0)(text))
    (setq dispname (format nil "~a" dispname))
    (setq str (format nil "~a" str))
    (setq n (read-from-string (string-left-trim "disp" dispname)))
    (setq text (first (get-disptext n)))
    (when text (progn 
      (if (and (string-equal str "banana3")(not (existFT)))(progn
        (setq str "banana1")
        (info "FT9 & FT10 DO NOT exit and banana1 is selected!")))      
      (XmTextSetString text str)
      (setq form0 (XtParent text))
      (unmanage form0)
      (cond 
        ((string-member str (list "banana1" "banana2" "banana3" "transverse"))
          (link3 str dispname))
        ((string-member str (list "mono1" "mono2" "average1" "average2"))
          (link4 str dispname))
        ((string-member str (list "GRA204" "MAG102"))
          (link1 str dispname))
        ( t (link2 str dispname))
      )
      (manage form0)  ))
))

(defun eval-noise-menu()
  (let ((n)(btn)(form)(label)(bs1)(bs2)(gra)(mag)(x)(cmd))
    (setq x (get-radiobox rb-noise))
    (case x
      (1 (progn
        (setq cmd "noise baseline") 
        (setq label "noise baseline default")))
      (2 (progn 
        (setq bs1 (XmTextGetString text-baseline1))
        (setq bs2 (XmTextGetString text-baseline2)) 
        (setq label (format nil "noise baseline ~a ~~ ~a" bs1 bs2))
        (setq cmd "noise baseline") ))
      (3 (progn 
        (setq gra (XmTextGetString text-granoise))
        (setq mag (XmTextGetString text-magnoise))
        (setq cmd (format nil "noise constant ~a ~a" gra mag))
        (setq label (format nil "GRA ~a  MAG ~a" gra mag))))
    )
    (graph::xfit-command cmd)
    (setq form (XtParent text-near))
    (setq btn (XtNameToWidget form "btn"))
    (set-values btn :labelString (XmString label))
    (unmanage noisemenu)
))

(defun existFT()
  (let ((n)(R nil)(buf3))
    (setq buf3 (G-widget "buf3"))
    (catch 'exit (dotimes (n (resource buf3 :channels))
      (if (string-equal "FT9" (get-property buf3 n :name))
        (throw 'exit (setq R t)))))
    (return R)
))

(defun get-gramag()
  (let ((n)(disp)(x nil)(gra nil)(mag nil)(func1))
    (defun func1(str string)
      (if (= (- (length string)(length (string-left-trim str string)))
        (length str)) t nil))
    (catch 'exit (dotimes (n 10)
      (setq disp (get-disptext (1+ n)))
      (unless (first disp) (throw 'exit t))
      (setq x (cons (second disp) x))))
    (setq x (reverse x))
    (catch 'exit (dotimes (n (length x))
      (if (func1 "gra-" (nth n x))(throw 'exit (setq gra (1+ n))))))
    (catch 'exit (dotimes (n (length x))
      (if (func1 "mag-" (nth n x))(throw 'exit (setq mag (1+ n))))))    
    (return (list gra mag))
))

(defun dispcolor(&optional (col 0))
  (let ((n)(disp)(func1)(func2))
    (defun func1(w cols)
      (set-resource w
        :default-color (first cols) :background (second cols)
        :highlight (third cols) :baseline-color (fourth cols)) )
    (defun func2(cols)
      (let ((n)(disp))
        (dotimes (n 10)
          (setq disp (format nil "disp~d" (1+ n)))
          (when (G-widget disp :quiet)
            (func1 (G-widget disp) cols)))
        (dolist (disp (list "dispgra" "dispmag" "dispeeg" "scandisp"))
          (when (G-widget disp :quiet)
            (func1 (G-widget disp) cols))) )) 
    (case col
      (0 (func2 (list "black" "white" "gray80" "gray80")))
      (1 (func2 (list "white" "black" "white" "white")))
    )
))

(defun get-backgroundcolor()
  (let ((form))
    (setq form (XtNameToWidget frame001 "form"))
    (get-integer-resource form "background")
))

(defun get-disptext(n)
  (let ((form)(form0)(text nil)(str nil))
    (setq form (XtNameToWidget frame001 "form"))
    (setq form0 (XtNameToWidget form "form0"))
    (setq text (XtNameToWidget form0
      (format nil "disp~d-text" n)))
    (if text (return (list text (XmTextGetString text)))
      (return (list nil nil)))
))

(defun get-label-list(label)
  (read-line-as-list (make-string-input-stream (XmString-to-string
    (get-XmString-resource label "labelString")))))

(defun get-max-matrix(mtx)
  (let ((maxval)(val))
    (setq val (matrix-extent mtx))
    (setq maxval (apply #'max (mapcar #'abs val)))
    (return maxval)
))

(defun get-max-matrix2(mtx)
  (let ((nch)(ntm)(maxval)(tmvec)(chvec)(vec)(ch)(tm)(k)(func1)(func2))
    (defun func1(x xx)
      (if (= x xx) 1.0 0.0))
    (defun func2(mtx nch ntm)
      (let ((ch tm)(r)(R nil))
        (catch 'exit
          (dotimes (tm ntm)
            (setq r (column tm mtx))
            (dotimes (ch nch)
              (if (= (vref r ch) 1.0)
                (throw 'exit (setq R (list ch tm)))))))
        (return R)))
    (setq mtx (map-matrix mtx #'abs))
    (setq maxval (second (matrix-extent mtx)))
    (setq mtx (map-matrix mtx #'func1 maxval))
    (setq nch (array-dimension mtx 0))
    (setq ntm (array-dimension mtx 1))
    (setq k  (* (make-matrix 1 nch 1) mtx (make-matrix ntm 1 1)))
    (if (> k 1.0)
      (progn (setq R (func2 mtx nch ntm))
         (setq ch (first R) tm (second R)))
    (progn
      (setq tmvec (ruler-vector 0 (1- ntm) ntm))
      (setq chvec (transpose (ruler-vector 0 (1- nch) nch)))
      (setq vec (* mtx tmvec))
      (setq tm (round (second (matrix-extent vec))))
      (setq vec (column tm mtx))
      (setq ch (round (* chvec vec)))))
    (return (list maxval ch tm))
))

(defun get-max-widget0(w);; vecop-widget sometimes provide error!
  (let ((maxval nil)(data)(val)(ch nil)(tm nil)(vcp))
    (setq vcp (G-widget "mxvcp"))
    (link w vcp)
    (setq data (get-data-matrix vcp 0 (resource vcp :high-bound)))
    (setq val (row 0 data))
    (setq maxval (second (matrix-extent val)))
    (setq ch  (row 1 data))
    (catch 'exit
      (dotimes (n (length val))
        (if (= (vref val n) maxval)
          (throw 'exit (setq ch (vref ch n) tm n)))))
    (return (list maxval ch tm))
))

(defun get-max-widget(w &rest t0);(get-max-widget (G-widget "wingra"))
  (let ((mtx)(hb)(R)(chname)(tm))
    (setq mtx (get-data-matrix w 0 (resource w :high-bound)))
    (setq R (get-max-matrix2 mtx))
    (setq chname (get-property w (second R) :name))
    (setq tm (sample-to-x w (third R)))
    (unless (null t0)(setq tm (+ tm (first t0))))
    (return (list (first R) chname tm))
))

(defun get-memop()
  (let ((memo)(val)(R))
     (setq val (rgb 255 255 255))
     (dolist (memo (list memo1 memo2 memo3))
       (if (= (get-integer-resource memo "background") val)
         (setq R memo)))
     (return R)
))

(defun get-mxvcp(t0 span w);w gra/mag sometimes show wrong value!!
  (let ((mxwin)(mxvcp)(val)(maxval)(ch)(mtx))
    (setq mxwin (G-widget "mxwin"))
    (setq mxvcp (G-widget "mxvcp"))
    (link w mxwin)
    (set-resource mxwin :point t0 :start 0 :end span)
    (set-resource mxvcp :mode "abs-max")
    (link mxwin mxvcp)
    (setq mtx (get-data-matrix mxvcp 0 (resource mxvcp :high-bound)))
    (setq val (row 0 mtx) mtx (row 1 mtx))
    (setq maxval (second (matrix-extent val)))
    (catch 'exit (dotimes (n (length val))
      (if (= (vref val n)maxval)(throw 'exit (setq ch n)))))
    (setq ch (get-property w (round (vref mtx ch)) :name))
    (return (list maxval ch))
))

(defun get-radiobox(rb)
  (let ((n)(R nil)(tb))
    (catch 'exit
      (dotimes (n 20)
        (setq tb (XtNameToWidget rb (format nil "tb~d" n)))
          (when tb (if (XmToggleButtonGetState tb)
            (throw' exit (setq R n))))))
    (return R) 
))

(defun get-radiobox_old(rb)
  (let ((nc 10)(n)(R)(x -1)(r)(tb))
    (while (= x -1)
      (setq R nil x -1)
      (dotimes (n nc)
        (setq tb (XtNameToWidget rb (format nil "tb~d" (1+ n))))
        (when tb (setq R (cons (get-integer-resource tb "set") R))))
      (setq R (reverse R))
      (setq nc (length R))
      (catch 'exit
        (dotimes (n nc)
          (setq r (nth n R))
          (if (= r 1)(throw 'exit (setq x n)))))
    ) 
    (return (1+ x))
))

(defun get-widget-max(w); w is supposed to be vecop of max-abs
  (let ((mtx)(val)(ch)(n)(nn nil)(maxval nil))
    (setq mtx (get-data-matrix w 
      (resource w :low-bound)(resource w :high-bound)))
    (setq val (row 0 mtx))
    (setq ch  (row 1 mtx))
    (setq maxval (second (matrix-extent val)))
    (catch 'exit
      (dotimes (n (length val))
        (if (= maxval (vref val n))(throw 'exit (setq nn n)))))
    (return (list maxval nn));;nn is sample not "s"
))


(defun get-xfitmenu()
  (let ((form)(R))
    (setq form (XtParent text-near))
    (setq R (list
      (get-radiobox (XtNameToWidget form "rb3"))
      (get-radiobox (XtNameToWidget form "rb2"))
      (get-radiobox (XtNameToWidget form "rb1"))
    ))
    (return R)
))
          
(defun initialize()
  (let ((w)(form)(bottomOffset 60)(rightOffset 200))
    (defvar frame001 nil "main window")
    (defvar frame002 nil "subwindow")
    (defvar frame003 nil "panel")
    (defvar frame004 nil "subpanel")
    (set-resource (G-widget "file") :directory "/data/neuro-data/ns/*.fif")
    (setq w (G-widget "display"))
    (set-resource w :geometry "1000x900+50+50")
    (GtDeleteWidget w)
    (setq w (make-form *main-window* "form000"))
    (set-values *main-window* :workWindow w)
    (setq frame001 (make-frame w "frame001"
      :shadowThickness  0
      :topAttachment    XmATTACH_FORM
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM :rightOffset rightOffset
      :bottomAttachment XmATTACH_FORM :bottomOffset bottomOffset))
    (setq frame002 (make-frame w "frame002"
      :shadowThickness  0
      :topAttachment    XmATTACH_WIDGET :topWidget frame001
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM :rightOffset rightOffset
      :bottomAttachment XmATTACH_FORM))
    (setq frame003 (make-frame w "frame003"
      :shadowThickness  1
      :topAttachment    XmATTACH_FORM
      :leftAttachment   XmATTACH_WIDGET :leftWidget frame001
      :rightAttachment  XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM :bottomOffset 60))
    (setq frame004 (make-frame w "form004"
      :shadowThickness  0
      :topAttachment    XmATTACH_WIDGET :topWidget  frame003
      :leftAttachment   XmATTACH_WIDGET :leftWidget frame002
      :rightAttachment  XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM))
    (apply 'manage (list frame001 frame002 frame003 frame004 w))
    (dolist (w (list frame001 frame002 frame003 frame003 frame004))
      (manage (make-form w "form")))
    (setup-widgets::initializeWidgets)
    (setq near-coil (setup-widgets::defchpos));;provide defvar near-coil
    (set-resource (G-widget "gra") :names (append
      gra-L-temporal  gra-R-temporal  gra-L-parietal gra-R-parietal
      gra-L-occipital gra-R-occipital gra-L-frontal  gra-L-frontal))
    (set-resource (G-widget "mag") :names (append
      mag-L-temporal  mag-R-temporal  mag-L-parietal mag-R-parietal
      mag-L-occipital mag-R-occipital mag-L-frontal  mag-L-frontal))
    (setframe001 frame001)
    (setframe002 frame002)
    (setframe003 frame003)
    (setframe004 frame004)
    (require 'xfit)
    (xfit)
    (add-layout)
    (add-button *file-menu* "load online" '(setup-widgets::online))
    (add-button *command-menu* "screen capture" 
      '(setup-widgets::screen-capture))
    (add-button *display-menu* "show noise-menu" '(manage noisemenu))
    (add-button *help-menu* "about hns_meg6.lsp" '(AboutMe))
    (create-memos)
    (unmanage form-memos)
    (layout1 "GRA204" "gra-L-temporal" "banana1")
    (change-color 2)
    
))

(defun layout1(&rest strlist);optional (ndisp 3))
  (let ((form)(form0)(n)(div)(name)(R)(chmenu)(disp)(dispw)(sc)(ndisp))
    (unmanage frame001)
    (clear-frame001)
    (setq form  (XtNameToWidget frame001 "form"))
    (setq form0 (XtNameToWidget form "form0"))
    (setq ndisp (length strlist))
    (setq div (round (/ 100 ndisp)))
    (dotimes (n ndisp)
      (setq name (format nil "disp~d" (1+ n)))
      (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
      (setq disp (GtMakeObject 'plotter :name name
        :display-parent form0 :scroll-parent form :no-controls t))
      (put disp :display-form form0)
      (GtPopupEditor disp) ;visualize
      (setq dispw (resource disp :display-widget))
      (set-values dispw
        :topAttachment XmATTACH_FORM :bottomAttachment XmATTACH_FORM
        :leftAttachment  XmATTACH_POSITION :leftPosition (* div n)
        :rightAttachment XmATTACH_POSITION :rightPosition (* div (1+ n))
        :topOffset 25 :leftOffset -5 :rightOffset -5)
      (setq sc (resource disp :scroll-widget))
      (set-values sc
        :topAttachment XmATTACH_WIDGET :topWidget form0
        :bottomAttachment XmATTACH_FORM
        :leftAttachment   XmATTACH_FORM
        :rightAttachment  XmATTACH_FORM))
    (layout-end strlist)
))

(defun layout2(&rest strlist)
  (let ((form)(form0)(formn)(pane)(n)(num)(name)(disp)(dispw)(w)(sc)(ndisp))
    (unmanage frame001)    
    (clear-frame001)
    (setq form (XtNameToWidget frame001 "form"))
    (setq form0 (XtNameToWidget form "form0"))
    (setq pane (XmCreatePanedWindow form0 "pane" (X-arglist) 0))
    (set-values pane :separatorOn 1 :sasIndent -1 :allowResize 1
      :topAttachment XmATTACH_FORM :bottomAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM :leftAttachment XmATTACH_FORM
      :topOffset 25 :bottomOffset 20)
    (manage pane)
    (setq ndisp (length strlist))
    (dotimes (n ndisp)
      (setq formn (make-form pane (format nil "form0~d" (1+ n))))
      (manage formn)
      (setq name (format nil "disp~d" (1+ n)))
      (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
      (setq disp (GtMakeObject 'plotter :name name
        :display-parent formn :scroll-parent form :no-controls t))
      (put disp :display-form formn)
      (GtPopupEditor disp)
      (setq dispw (resource disp :display-widget))
      (set-values dispw
        :topOffset -3  :bottomOffset -5
        :leftOffset -5 :rightOffset -5)
      (setq sc (resource disp :scroll-widget))
      (set-values sc
        :topAttachment XmATTACH_WIDGET :topWidget form0
        :bottomAttachment XmATTACH_FORM
        :leftAttachment XmATTACH_FORM
        :rightAttachment XmATTACH_FORM))
    (layout-end strlist)
))

(defun layout3(&rest strlist)
  (let ((form)(form0)(m)(n)(nn)(name)(disp)(dispw)(sc)(chs))
    (unmanage frame001)
    (clear-frame001)
    (setq form (XtNameToWidget frame001 "form"))
    (setq form0 (XtNameToWidget form "form0"))
    (dotimes (m 2)(dotimes (n 5)
      (setq nn (+ (* n 2) m))
      (setq name (format nil "disp~d" (1+ nn)))
      (when (G-widget name :quiet)(GtDeleteWidget (G-widget name)))
      (setq disp (GtMakeObject 'plotter :name name
        :display-parent form0 :scroll-parent form :no-controls t))
      (put disp :display-form form0)
      (GtPopupEditor disp)
      (setq dispw (resource disp :display-widget))
      (set-values dispw
        :topAttachment XmATTACH_POSITION    :topPosition     (* m 50)
        :leftAttachment XmATTACH_POSITION   :leftPosition    (* n 20) 
        :rightAttachment XmATTACH_POSITION  :rightPosition   (* (1+ n) 20)
        :bottomAttachment XmATTACH_POSITION :bottomPosition  (* (1+ m) 50)
        :topOffset 25 :bottomOffset -5
        :leftOffset -5 :rightOffset -5)
      (setq sc (resource disp :scroll-widget))
      (set-values sc
        :topAttachment XmATTACH_WIDGET :topWidget form0
        :bottomAttachment XmATTACH_FORM
        :leftAttachment XmATTACH_FORM
        :rightAttachment XmATTACH_FORM) ))
    (layout-end strlist)
))

(defun layout-end(strlist)
  (add-sync)
  (create-bartext strlist)
  (dispcolor)
  (change-color)
  (manage frame001)
)

(defun link1(str dispname);GRA204/MAG102
  (let ((n)(num)(names)(w)(meg)(formx)(dispw)(btn)(scales)(offsets)(x8))
    (setq num (string-left-trim "disp" dispname))
    (setq w (G-widget dispname))
    (setq dispw (resource w :display-widget))
    (setq formx (resource w :display-parent))
    (unmanage formx)
    (clear-widgets dispname)
    (set-values dispw :leftOffset 80)
    (if (string-equal str "GRA204")(setq meg 204)(setq meg 102))
    (if (first (get-disptext 6))(progn
      (if (string-member num (list "1" "3" "5" "7" "9"))
        (setq x8 (ruler-vector 3 40 8))   ;10disp 1,3,5,7,9
        (setq x8 (ruler-vector 53 90 8))));10disp 2,4,6,8,10
      (setq x8 (ruler-vector 7 85 8)));2~5 disp
    (setq names (list "L-temporal" "R-temporal" "L-parietal" "R-parietal"
      "L-occipital" "R-occipital" "L-frontal" "R-frontal"))
    (dotimes (n 8)
      (setq btn (make-button formx (format nil "btn~a-~d" num (1+ n))
        :labelString (XmString (nth n names))
        :rightAttachment XmATTACH_WIDGET :rightWidget dispw
        :topAttachment   XmATTACH_POSITION :topOffset 25 
        :topPosition (round (vref x8 n))
        :bottomOffset XmATTACH_FORM :bottomOffset 5
        :shadowThickness 0 :detailShadowThickness 0))
      (set-lisp-callback btn "activateCallback" (read-from-string
        (format nil "(select-meg ~d ~d )" meg n))) 
      (manage btn))
    (manage formx)
    (set-resource w :ch-label-space 0 :superpose t)
    (setq x8 (/ (ruler-vector -3.5 3.5 8) 4))
    (case meg
      (204 (progn
        (link (G-widget "gra") w)
        (setq offsets (mat-append
          (make-matrix 1 26 (vref x8 0))(make-matrix 1 26 (vref x8 1))
          (make-matrix 1 26 (vref x8 2))(make-matrix 1 26 (vref x8 3))
          (make-matrix 1 24 (vref x8 4))(make-matrix 1 24 (vref x8 5))
          (make-matrix 1 26 (vref x8 6))(make-matrix 1 26 (vref x8 7)))) ))
      (102 (progn
        (link (G-widget "mag") w)
        (setq offsets (mat-append
          (make-matrix 1 13 (vref x8 0))(make-matrix 1 13 (vref x8 1))
          (make-matrix 1 13 (vref x8 2))(make-matrix 1 13 (vref x8 3))
          (make-matrix 1 12 (vref x8 4))(make-matrix 1 12 (vref x8 5))
          (make-matrix 1 13 (vref x8 6))(make-matrix 1 13 (vref x8 7)))) ))
    )  
    (change-time w)
    (set-scale w)
    (set-resource w :offsets (transpose offsets)) 
))

(defun link2(str dispname);gra- mag-
  (let ((num)(w)(chs))
    (clear-widgets dispname)
    (setq w (G-widget dispname))
    ;(change-time w)
    (setq num (string-trim "disp" dispname))
    (setq pick (require-widget :pick (format nil "pick~a" num)))
    (setq chs (read-from-string str))
    (set-resource pick :names (eval chs))
    (link (G-widget "buf2") pick)
    (link pick w)
    (change-time w)
    (set-scale w)
))

(defun link3(lead dispname)
  (let ((num)(w)(chs)(str)(lead1)(lead2)(neeg)(necg)(neog)(nemg)(n)(st)(n))
    (clear-widgets dispname)
    (setq w (G-widget dispname))
    (change-time w)
    (setq num (string-trim "disp" dispname))
    (setq pick  (require-widget :pick (format nil "pick~a" num)))
    (setq picks (require-widget :pick (format nil "pick~as" num)))
    (cond
      ((string-equal lead "banana1")(setq lead1 banana1a lead2 banana1b))
      ((string-equal lead "banana2")(setq lead1 banana2a lead2 banana2b))
      ((string-equal lead "banana3")(setq lead1 banana3a lead2 banana3b))
      ((string-equal lead "transverse")
        (setq lead1 transversea lead2 transverseb))
    )
    (set-resource pick  :names lead1)
    (set-resource picks :names lead2)
    (setq sub (require-widget :binary (format nil "fsub~a" num)))
    (set-resource sub :function 'fsub)      
    (setq sel (require-widget :selector (format nil "sel~a" num)))
    (link (G-widget "EEG-fil")(G-widget "buf3"))
    (link (G-widget "buf3") pick)
    (link (G-widget "buf3") picks)
    (link pick  sub)
    (link picks sub)
    (dotimes (n (resource sub :channels))
      (set-property sub n :name 
        (format nil "~a-~a" (nth n lead1)(nth n lead2)))) 
    (link-eegsel (resource sub :name)(resource sel :name))
    (link sel (G-widget "eeg"))
))

(defun link4(lead dispname);mono1 mono2 average1 average 2
  (let ((ref)(w)(num)(mono)(pick)(picks)(n))
    (clear-widgets dispname)
    (setq w (G-widget dispname))
    (change-time w)
    (setq num (string-trim "disp" dispname))
    (setq pick  (require-widget :pick (format nil "pick~a" num)))
    (if (string-member lead (list "mono1" "average1"))
      (setq mono mono1)(setq mono mono2))
    (set-resource pick :names mono)
    (link (G-widget "EEG-fil")(G-widget "buf3"))
    (link (G-widget "buf3") pick)
    (setq sel (require-widget :selector (format nil "sel~a" num)))
    (if (string-member lead (list "average1" "average2"))(progn
      (setq av (require-widget :vecop (format nil "vecop~a" num)))
      (set-resource av :mode "average")
      (link pick av)
      (set-property av 0 :name "av")
      (setq picks (require-widget :pick (format nil "pick~as" num)))
      (set-resource picks :names '("av" "av" "av" "av" "av" "av" "av" 
        "av" "av" "av" "av" "av" "av" "av" "av" "av" "av" "av" "av"))
      (setq sub (require-widget :binary (format nil "fsub~a" num)))
      (set-resource sub :function 'fsub)
      (link av picks)
      (link pick sub)
      (link picks sub)
      (dotimes (n (resource pick :channels))
        (set-property sub n :name (format nil "~a-ave" (nth n mono))))
      (link-eegsel (resource sub :name)(resource sel :name)))(progn 
      (dotimes (n (resource pick :channels))
        (set-property pick n :name (format nil "~a-ref" (nth n mono))))
      (link-eegsel (resource pick :name)(resource sel :name))))
    (link sel (G-widget "eeg"))
))

(defun linkEEG()
  (let ((n)(w)(x)(text)(form)(str))
    (setq w (G-widget "EEG-fil"))
    (catch 'exit (dotimes (n 10)
      (setq x (get-disptext (1+ n)))
      (if (first x)(progn 
        (setq str (second x))
        (if (string-member str 
          (list "banana1" "banana2" "transverse" "mono1" "mono2"
          "average1" "average2"))
          (throw' exit (progn
            (setq w (G-widget "eeg"))
            (link (G-widget (format nil "sel~d" (1+ n))) w ))))))))
    (link w (G-widget "wineeg"))
))

(defun link-eegsel(wname selname)
  (let ((sel)(w)(neeg)(necg)(neog)(nemg)(st)(num))
    (setq sel (G-widget selname))
    (setq w   (G-widget wname))
     (setq neeg (1- (resource w :channels)))
    (setq necg (1- (resource (G-widget "ECG-fil") :channels)))
    (setq neog (1- (resource (G-widget "EOG-fil") :channels)))
    (setq nemg (1- (resource (G-widget "EMG-fil") :channels)))
    (setq st (format nil 
      (format nil "(select-to sel (~a 0 - ~d)" wname neeg)))
    (if (>= necg 0);...btn3 cover btn2's func;...btn3 cover btn2's functiontion
      (setq st (str-append st (format nil "(ECG-fil 0 - ~d)" necg))))
    (if (>= neog 0)
      (setq st (str-append st (format nil "(EOG-fil 0 - ~d)" neog))))
    (if (>= nemg 0)
      (setq st (str-append st (format nil "(EMG-fil 0 - ~d)" nemg))))
    (eval (read-from-string (str-append st ")")))
    (setq num (string-left-trim "sel" selname))
    (setq w (G-widget (format nil "disp~a" num)))
    (link sel w)
    (change-time w)
    (set-scale w)
))

(defun list-of-bdip(x)
  (let ((R))
    (setq R (format nil "~0,3f~t~0,1f~t~0,1f~t~0,1f~t~0,1f~t~0,1f~t~0,1f~t~0,1f~t~0,1f~t~0,2f"
      (* (first x)1e-3)10(second x)18(third x)26(fourth x)34(fifth x)
      42(sixth x)50(seventh x)60(eighth x)68(ninth x)76(tenth x)))
    (return R)
))

(defun list-of-epoch(x)
  (let ((R)(func1)(func2))
    (defun func1(x)
      (cond
        ((< x 10)(format nil "     ~0,3f" x))
        ((< x 100)(format nil "    ~0,3f" x)) 
        ((< x 1000)(format nil "   ~0,3f" x)) 
        (t          (format nil "  ~0,3f" x))
      ))
    (defun func2(x)
      (cond
        ((< x 10)(format nil "     ~0,0f" x))
        ((< x 100)(format nil "    ~0,0f" x)) 
        ((< x 1000)(format nil "   ~0,0f" x)) 
        (t          (format nil "  ~0,0f" x))
      ))
    (setq R (str-append (func1 (first x))(func1 (second x))
      (format nil "  ~a"(third x))(func1 (fourth x))(func2 (fifth x))))
    (if (> (length x) 5)
      (setq R (format nil "~a  ~a" R (sixth x))))
    (return R)
))

(defun make-arrowbutton(X::parent &optional (X::name "text") &rest X::args) 
  (let ((X::arglist))
    (setq X::args (append '(:foreground (rgb 0 100 0)
      :shadowThickness 0 :detailShadowThickness 0) X::args))
    (setq X:arglist (eval (cons 'X-arglist X::args)))
    (XmCreateArrowButtonGadget X::parent X::name X::arglist (length X::arglist))
))

(defun make-textfield(X::parent &optional (X::name "text") &rest X::args) 
  (let ((X::arglist))
    (setq X::args (append '(:width 70 :height 30) X::args))
    (setq X:arglist (eval (cons 'X-arglist X::args)))
    (XmCreateTextField X::parent X::name X::arglist (length X::arglist))
))

(defun memo-clear()
  (when (yes-or-no-p "are you sure?")
    (XmjkLispListSet (get-memop) nil)
))

(defun memo-copy(n)
  (let ((R))
    (setq R (XmjkLispListGet (get-memop)))
    (XmjkLispListSet (eval (read-from-string (format nil "memo~d" n))) R)
))

(defun memo-clear-all()
  (when (yes-or-no-p "Do you clear all memos?")(progn
    (XmjkLispListSet memo1 nil)
    (XmjkLispListSet memo2 nil)
    (XmjkLispListSet memo3 nil))
))

(defun memo-delete()
  (when (yes-or-no-p "are you sure?")
  (XmjkLispListDelete (get-memop)))
)

(defun memo-delete-epoch(&optional (extract nil))
  (let ((memo)(R1)(R2)(n)(m)(check)(L)(Z nil))
    (when (yes-or-no-p "Are you sure?")(progn
      (setq memo (get-memop))
      (setq R1 (XmjkLispListGet memo)) 
      (setq R2 (XmjkLispListSelected memo))
      (if extract (XmjkLispListSet memo R2)(progn
        (dotimes (n (length R1))
          (setq L (nth n R1) check t)
          (catch 'exit 
            (dotimes (m (length R2))
              (if (equal L (nth m R2))
                (throw 'exit (setq check nil)))))
        (if check (setq Z (cons L Z))))
      (XmjkLispListSet memo (reverse Z)))) ))
))

(defun memo-extractepoch()
  (let ((bdip)(D nil)(R)(n)(Z nil)(func1))
    (defun func1(x)
      (/ x 1000))
    (setq R (XmjkLispListGet memo4))
    (dotimes (n (length R))
      (setq D (cons (first (nth n R)) D)))
    (setq D (mapcar #'func1 (reverse D)))
    (setq R (XmjkLispListGet (get-memop)))
    (when R
      (dotimes (n (length R))
        (if (member (fourth (nth n R)) D)
          (setq Z (cons (nth n R) Z)))))
    (XmjkLispListSet (get-memop) (reverse Z)) 
))

(defun memo-fit(&optional (select 1))
  (let ((R)(n)(disp))
    (setq disp (G-widget "disp1"))
    (if (= select 1)
      (setq R (XmjkLispListSelected (get-memop)))
      (setq R (XmjkLispListGet (get-memop))))
    (dotimes (n (length R))
      (setq L (nth n R))
      (set-resource disp 
        :selection-start (first L)
        :selection-length (second L))
      (sync-disp-select 1)
      (xfit-transfer t))
))

(defun memo-focus(n)
  (let ((memo))
    (dolist (memo (list memo1 memo2 memo3))
      (set-values memo :background (rgb 200 200 200)))
    (set-values (eval (read-from-string (format nil "memo~d" (1+ n))))
       :background (rgb 255 255 255))
))

(defun memo-goto(&optional (L nil))
  (let ((t0)(span)(ch)(t1)(n)(disp)(w)(R)(scan)(x))
    (unless L (setq L (XmjkLispListSelected (get-memop))))
    (if (= (length L) 1)(progn
      (setq L (first L))
      (setq t0 (+ (first L)(/ (second L))) ch (third L))
      (setq span (read-from-string (XmTextGetString text-length)))
      (setq t0 (- t0 (/ span 2)))
      (XmTextSetString text-start (format nil "~0,2f" t0))
      (setq w (get-gramag))
      (if (first w)(progn
          (setq R (get-mxvcp t0 span (G-widget "gra")))
          (setq R (list (first w)(which-meg8 (second R)))))
        (if (second w)(progn
          (setq R (get-mxvcp t0 span (G-widget "mag")))
          (setq R (list (second w)(which-meg8 (second R)))) )) )
      (if R (progn
        (setq x (get-disptext (first R)))
        (XmTextSetString (first x)(second R))
        (link2 (second R)(format nil "disp~d" (first R)))
      ))
      (setq scan (G-widget "scandisp"))
      (if (= (resource scan :channels) 8)
        (set-resource scan  :selection-start (- t0 
          (sample-to-x (G-widget "buf") (resource (G-widget"buf") :low-bound)))
          :selection-length span))
      (change-time)
      (set-resource (G-widget "disp1")
        :selection-start (first L) :selection-length (second L))
      (sync-disp-select 1)
    ))
))

(defun memo-insert(str)
  (let ((R1)(R2)(n)(m)(L)(RR nil))
    (setq R1 (XmjkLispListGet (get-memop)))
    (setq R2 (XmjkLispListSelected (get-memop)))
    (setq m 0)  
    (setq L (nth m R2))   
    (dotimes (n (length R1))
      (if (equal L (nth n R1))(progn
        (setq L (list (first L)(second L)(third L)
         (fourth L)(fifth L) str))
        (setq RR (cons L RR))
        (setq m (1+ m))
        (if (= m (length R2))(setq L nil)
          (setq L (nth m R2))))
      (setq RR (cons (nth n R1) RR))))
    (XmjkLispListSet (get-memop) (reverse RR))
))

(defun memo-insert2()
  (let ((dialog)(ok)(help)(func1)(func2))
    (setq dialog (XmCreatePromptDialog *application-shell* 
      "inputDialog" (X-arglist) 0))
    (defun func1()
      (info (format nil "~a~%~a~%~a~%~a"
        "Insert free coment" "DO NOT USE SPACE"
        "spaces are NOT recognized" "as one atom in LISP syntax")))
    (defun func2()
      (let ((str)(text))
        (setq text (XtNameToWidget prompt "Text"))
        (setq str (XmTextGetString text))
        (XtDestroyWidget prompt)
        (gc)
        (memo-insert str)
      ))
    (set-values dialog :selectionLabelString 
      (XmString "free comment"))
    (setq ok (XtNameToWidget dialog "OK"))
    (setq help (XtNameToWidget dialog "Help"))
    (set-lisp-callback help "activateCallback" '(func1))
    (set-lisp-callback ok "activateCallback" '(func2))
    (manage dialog)
    (setq prompt dialog); global variant
))

(defun memo-load()
  (let ((filename)(folder)(loadname)(R nil)(fid)(n)(L))
    (setq filename (resource (G-widget "file") :filename))
    (setq folder (str-append (filename-directory filename) "*-wave.txt"))
    (setq loadname (str-append (filename-base filename) "-wave.txt"))
    (setq filename (ask-filename "select *-wave.txt" 
      :template folder :default loadname))
    (when (file-exists-p filename)(progn
      (setq fid (open filename :direction :input))
      (catch 'exit
        (dotimes (n 100000)
          (setq L (read-line-as-list fid))
          (when L (setq R (cons L R)))
          (if (not L)(throw 'exit t))))
      (XmjkLispListSet (get-memop) (reverse R))))
))

(defun memo-note()
  (let ((R)(L)(memo)(str1)(str2)(func1)(func2))
    (defun func1(label)
      (XmString-to-string (get-XmString-resource label "labelString")))
    (defun func2(str)
      (read-line-as-list (make-string-input-stream str)))
    (setq str1 (func1 displabel))
    (setq str2 (string-right-trim "fT/cm" (func1 gralabel)))
    (if (= (resource (G-widget "dispgra") :channels) 0)(return nil))
    (if (string-equal str1 "--")(return nil)(progn
      (setq L (func2 str1))
      (setq L (append (list (first L)(- (third L)(first L)))(func2 str2)))
      (setq memo (get-memop))
      (setq R (XmjkLispListGet memo))
      (XmjkLispListSet memo (append R (list L)))))
))

(defun memo-no-comment()
  (let ((n)(m 0)(R1)(R2)(RR nil)(L)(memo))
    (setq memo (get-memop))
    (setq R1 (XmjkLispListGet memo))
    (setq R2 (XmjkLispListSelected memo))
    (setq L (nth m R2))
    (dotimes (n (length R1))
      (if (equal L (nth n R1))(progn
        (setq L (list (first L)(second L)(third L)(fourth L)(fifth L)))
        (setq RR (cons L RR))
        (setq m (1+ m))
        (if (< m (length R2))(setq L (nth m R2))(setq L nil)))
      (setq RR (cons (nth n R1) RR))))
    (XmjkLispListSet memo (reverse RR))
))

(defun memo-pngsave(&optional (all 1))
  (let ((R)(D)(n)(tspan)(t0)(span)(t2)(w)(f)(dir)(id))
    (when (yes-or-no-p "Do you want to save waveforms as PNG files?")(progn           ;(setq id (window-id (XtWindow (XtParent frame001))))
      (setq id (window-id (XtWindow (XtNameToWidget *main-window* "form000"))))
      (if (= all 1)(setq R (XmjkLispListGet (get-memop)))
                   (setq R (XmjkLispListSelected (get-memop))))
      (setq D (XmjkLispListGet memo4))
      (info "The EEG peak is not shown because of MjkLISP bug!")
      (setq w (G-widget "disp1"))
      (unmanage form-memos)
      (setq tspan (read-from-string (XmTextGetString text-length)))
      (setq dir (filename-directory (resource (G-widget "file") :filename)))
      (system (format nil "rm ~a/b*.png" dir))
      (system "xset b off"); bell off
      (dotimes (n (length R))
        (setq L (nth n R)) 
        (memo-goto (list L))
        (setq f (format nil "~0,0f" (* (fourth L) 1e+3)))
        (setq f (str-append dir "b" (string-trim " " f)))
        (system (format nil "xwd -id ~a > ~a.xwd" id f))
        (system (format nil "convert ~a.xwd ~a.png" f f))
        (system (format nil "rm ~a.xwd" f))  )
      (system "xset b on");bell on
      (manage form-memos)
      (memo-pngsaveBDIP) ))
))

(defun memo-pngsaveBDIP(&optional (t00 nil))
  (let ((form)(label)(str)(t11)(D)(L))
    (setq form (XtParent displabel))
    (setq label (XtNameToWidget form "bdiplabel"))
    (unless label (setq label (make-label form "bdiplabel"
        :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget displabel
        :bottomAttachment XmATTACH_OPPOSITE_WIDGET :bottomWidget displabel 
        :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM)))
    (if t00 (progn
      (setq t11 (* t00 1e+3) D (XmjkLispListGet memo4))
      (setq str "no dipole")
      (catch 'exit (dotimes (n (length D))
        (setq L (nth n D))
        (if (< (abs (- t11 (first L))) 1.0)(throw 'exit 
          (setq str (format nil "~0,3f GOF ~0,1f CV ~0,1f"  
            t00 (eighth L)(ninth L) ))))))
      (set-values label :labelString (XmString str))
      (manage label)
      (unmanage displabel))
    (progn (unmanage label)(manage displabel)))
))

(defun memo-save()
  (let ((filename)(folder)(n)(m)(R)(fid))
    (setq filename (resource (G-widget "file") :filename))
    (setq folder (str-append (filename-directory filename) "*-wave.txt"))
    (setq filename (str-append (filename-base filename) "-wave.txt"))
    (setq filename (ask-filename "Give new filename *-wave.txt" :new t
      :new t :template folder :default filename :if-exists :ask))
    (when filename (progn
      (setq n (- (length filename)
        (length (string-right-trim "wave.txt" filename))))
      (when (= n 8)(progn
        (setq R (XmjkLispListGet (get-memop)))
        (setq fid (open filename :direction :output :if-exists :supersede))
        (dotimes (m (length R))
          (princ (format nil "~a" (nth m R)) fid)
          (princ (format nil "~%") fid)  )
        (close fid)
        (info (format nil "~a has been saved." filename))))))
))

(defun memo-sort(num)
  (let ((n)(R)(order)(L nil)(func1))
    (setq R (XmjkLispListGet (get-memop)))
    (dotimes (n (length R))
      (setq L (cons (nth num (nth n R)) L)))
    (setq L (reverse L))
    (if (= num 2)(progn
      (defun func1(xlist)
        (let ((K nil)(n)(xx)(str))
          (dotimes (n (length xlist))
            (setq str (format nil "~a" (nth n xlist)))
            (setq xx (string-left-trim "MEG" str))
            (setq K (cons (read-from-string xx) K)))
          (return (reverse K))
      ))
      (setq L (func1 L))))
    (setq order (sort-order L))
    (if (member num (list 2 3))(setq order (reverse order)))
    (setq L nil)
    (dotimes (n (length R))
      (setq L (cons (nth (nth n order) R) L)))
    (XmjkLispListSet (get-memop) L)
))

(defun redraw()
  (let ((eeg1)(n)(label)(pick)(prepickname)
    (disp)(dispname)(text)(func1)(R1)(R2))
    (defun func1(str disp)
      (let ((n)(amp))
        (link (G-widget str) disp)
        (setq n (resource disp :channels))
        (if (string-equal str "gra")
          (setq amp (* (read-from-string (XmTextGetString text-gra))1e-13))
          (setq amp (* (read-from-string (XmTextGetString text-mag))1e-15)))
        (set-resource disp :ch-label-space 0
                           :scales (make-matrix n 1 (* amp 10)))))

    (define-MEGsite));Triux neo? VectorView? Cleaveland?
    (unless (string-equal loadfiffname (resource (G-widget "file") :filename))
      (set-resource (G-widget "MTX") :matrix (make-matrix 0 0 0)))
    (dotimes (n 11) 
      (setq dispname (format nil "disp~d" n))
      (if (G-widget dispname :quiet)(progn
        (setq disp (G-widget dispname))
        (set-resource disp :tick-interval tick-interval)
        (setq label (second (get-disptext n)))
        (cond
          ((string-equal label "GRA204")(func1 "gra" disp))
          ((string-equal label "MAG102")(func1 "mag" disp))
        )))
      (if (G-widget (format nil "pick~d" n) :quiet)(progn
        (setq pick (G-widget (format nil "pick~d" n))) ;GRA204 is not use pick
        (link pick (G-widget (format nil "disp~d" n)))
        (setq prepickname (resource (widget-source pick) :name))
        (if (string-equal prepickname "buf2")(set-scale disp));gra-/mag-
        (if (string-equal prepickname "buf3")
          (cond 
            ((string-member label 
              (list "banana1" "banana2" "banana3" "transverse"))
              (link3 label dispname))
            ((string-member label (list "mono1" "mono2" "average1" "average2"))
              (link4 label dispname))))  )) )
    (setframe003mini)    
    (dolist (disp (list "dispgra" "dispmag" "dispeeg"))
      (GtUnlinkWidget (G-widget disp)))
    (change-time)
    (change-color)
))

(defun rename-png(a b)
  (let ((fid)(dir)(n)(L1)(L2)));a "a" b "ep"
    (setq dir (filename-directory (resource (G-widget "file") :filename)))
    (setq a (str-append dir a))
    (setq b (str-append dir b))
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

(defun rgb(r g b)(+ (* (+ (* r 256) g) 256) b))

(defun routine(num)
    (case num
      (1 (when (yes-or-no-p   
        "The centroid cooridination ~% and the noise level are OK?"))
          (progn (scan-record)(sort-scan)(dipclear)(memo-fit 0)(dipfilter)
            (memo-extractepoch)(memo-pngsave)))
      (2 (when (yes-or-no-p   
        "The centroid cooridination ~% and the noise level are OK?"))
          (progn (sort-scan)(dipclear)(memo-fit 0)(dipfilter)
            (memo-extractepoch)(memo-pngsave)))      
      (3 (progn (dipapply)(dipsave)(rename-png "b" "epi")))
    )
))

(defun scan-record(&optional (step 0.5));;under construction
  (let ((mtx)(s1)(s2)(s3)(s4)(s5)(s6)(s7)(s8)
    (n)(tm)(tm2)(tmax)(w)(R)(smp)(T)(chlist)(func1)(func2))
    (defun func1(selname num1 num2)
      (let ((ss)(gra (G-widget "gra")))
        (setq ss (require-widget :selector "ss"))
        (eval (read-from-string (format nil "(select-to ss (gra ~d - ~d))"
          num1 num2)))
        (if (G-widget selname :quiet)(GtDeleteWidget (G-widget selname)))
        (set-resource ss :name selname)
        (return ss)))
    (setq s1 (func1 "s1"   0  25))
    (setq s2 (func1 "s2"  26  51))
    (setq s3 (func1 "s3"  52  77))
    (setq s4 (func1 "s4"  78 103)) 
    (setq s5 (func1 "s5" 104 127))
    (setq s6 (func1 "s6" 128 151))
    (setq s7 (func1 "s7" 152 177))
    (setq s8 (func1 "s8" 178 203))
    (setq w (G-widget "gra"))
    (setq tm   (sample-to-x w (resource w :low-bound))
          tmax (sample-to-x w (resource w :high-bound)))
    (setq R nil)
    (setq smp (x-to-sample w step))

    (defun func2(sel T)
      (apply #'max (mapcar #'abs (matrix-extent (get-data-matrix sel T smp)))))

    (while (< tm tmax)
      (setq n (round (/ tm tmax 0.01)) T (x-to-sample w tm))
      (unless (longworking (format nil "scanning...~d%%." n) n 100)
        (progn (error "interrupted")(longworking "stopped" 100 100)))
      (setq mtx (list (list
        (func2 s1 T)(func2 s2 T)(func2 s3 T)(func2 s4 T)
        (func2 s5 T)(func2 s6 T)(func2 s7 T)(func2 s8 T))))
      (setq R (append R mtx) tm2 (+ tm step))
      (if (> tm2 tmax)(setq tm2 tmax smp (x-to-sample w step)))
      (setq tm tm2))
    (longworking "done" 100 100)
    (dolist (w (list s1 s2 s3 s4 s5 s6 s7 s8))(GtDeleteWidget w))
    (setq R (transpose (matrix R)) tm (* (length R) step))
    (setq w (second (matrix-extent R)))(setq w (/ w 2))
    (set-resource (G-widget "MTX") :matrix R :x-unit "t" :x-scale step)
    (setq chlist '("LT" "RT" "LP" "RP" "LO" "RO" "LF" "RF"))
    (dotimes (n 8)
      (set-property (G-widget "MTX") n :name (nth n chlist)))
    (link (G-widget "MTX")(G-widget "scandisp"))
    (set-resource (G-widget "scandisp") :point 0 :length tm
      :scales (make-matrix 8 1 w))
    (setq loadfiffname (resource (G-widget "file") :filename))
    (XmTextSetString text-scanscale (format nil "~0,0f" (* w 1e+13)))
))

(defun scan-select-hook()
  (let ((xt0)(xspan)(span)(t0)(t00)(buf)(w)(R nil)(x))
    (setq xspan (resource (G-widget "scandisp") :selection-length))
    (if (> xspan 0)(progn
      (setq xt0   (resource (G-widget "scandisp") :selection-start))
      (setq span (read-from-string (XmTextGetString text-length)))
      (setq buf (G-widget "buf"))
      (setq t00 (sample-to-x buf (resource buf :low-bound)))
      (setq t0 (+ (- (+ xt0 (/ xspan 2))(/ span 2)) t00))
      (XmTextSetString text-start (format nil "~0,2f" t0))
      (setq w (get-gramag))
      (if (first w)(progn
          (setq R (get-mxvcp t0 span (G-widget "gra")))
          (setq R (list (first w)(which-meg8 (second R)))))
        (if (second w)(progn
          (setq R (get-mxvcp t0 span (G-widget "mag")))
          (setq R (list (second w)(which-meg8 (second R)))) )) )
      (if R (progn
        (XmTextSetString (first (get-disptext (first R)))(second R))
        (link2 (second R)(format nil "disp~d" (first R)))
      ))
      (set-resource (G-widget "disp1") :selection-start -1 
                                       :selection-length -1)
      (sync-disp-select 1)
      (change-time)))
))

(defun select-meg(meg chs);GRA204/MAG102 L/R-temp/...
  (let ((n)(nn nil)(disp)(pick)(ch-class)(names)(menu))
    (if (= meg 204)
      (setq ch-class 'meg-planar)
      (setq ch-class 'meg-magmeter))
    (catch 'exit
      (dotimes (n 6)
        (setq disp (G-widget (format nil "disp~d" (1+ n)) :quiet))
        (when disp
          (when (equal (get-property disp 0 :ch-class) ch-class)
            (when (< (resource disp :channels) 30);
              (throw 'exit (setq nn (1+ n))))))))
    (unmanage frame001)
    (when nn
      (if (= meg 204)
        (setq names (nth chs (list 
          'gra-L-temporal 'gra-R-temporal 'gra-L-parietal 'gra-R-parietal
          'gra-L-occipital 'gra-R-occipital 'gra-L-frontal 'gra-R-frontal)))
        (setq names (nth chs (list 
          'mag-L-temporal 'mag-R-temporal 'mag-L-parietal 'mag-R-parietal
          'mag-L-occipital 'mag-R-occipital 'mag-L-frontal 'mag-R-frontal))))
      (setq pick (G-widget (format nil "pick~d" nn)))
      (set-resource pick :names (eval names))
      (link pick disp)
      (set-scale disp)
      (XmTextSetString (first (get-disptext nn)) (format nil "~a" names))
    )
    (manage frame001)
))

(defun setframe001(&optional (frame frame001)(nform 5))
  (let ((form)(form0))
    (unmanage frame)
    ;(clear-frame001)
    (setq form (XtNameToWidget frame "form"))
    (setq form0 (make-form form "form0"
      :topAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_FORM :bottomOffset 20))
    (create-bartext)
    (apply 'manage (list form0 form))
    (manage frame)
))

(defun setframe002(&optional (frame frame002))
  (let ((form)(disp)(dispw)(R))
    (unmanage frame);; to avoid edgy synchronization of XmForm
    (XtDestroyWidget (XtNameToWidget frame "form"))
    (setq form (make-form frame "form"))
    (manage form)
    (setq R (create-plotter form "scandisp"))
    (setq disp (first R) dispw (second R))
    (set-resource disp
      :superpose t 
      :scroll-visible 0 
      :x-unit "s"
      :offsets (make-matrix 8 1 0.9)
      :select-hook '(scan-select-hook))
    (link (G-widget "MTX") disp)
    (manage frame)
))

(defun setframe003(&optional (frame frame003))
  (let ((form)(label1)(label2)(label3)(btn1)(btn2)(n))
    (unmanage frame)
    (XtDestroyWidget (XtNameToWidget frame003 "form"))
    (setq form (make-form frame "form"));
    (manage form)
    (setq label1 (make-label form "label1"
      :labelString (XmString "Start & length")
      :topAttachment  XmATTACH_FORM
      :leftAttachment XmATTACH_FORM))
    (setq btn1 (make-button form "btn1" :labelString (XmString "ssp")
      :topAttachment   XmATTACH_FORM
      :leftAttachment XmATTACH_WIDGET :leftWidget label1
      :leftOffset 5))
    (set-lisp-callback btn1 "activateCallback" '(set-ssp))
    (setq btn2 (make-button form "btn2" :labelString (XmString "redraw")
      :topAttachment XmATTACH_FORM    :rightAttachment XmATTACH_FORM
      :leftAttachment XmATTACH_WIDGET :leftWidget btn1
      :leftOffset 5))
    (dolist (n (list btn1 btn2))(button-no-edge n))
    (set-lisp-callback btn2 "activateCallback" '(redraw))
    (setq text-start (make-textfield form "text-start" 
      :topAttachment  XmATTACH_WIDGET :topWidget label1 :width 80
      :leftAttachment XmATTACH_FORM :alignment XmALIGNMENT_END))
    (XmTextSetString text-start "0.00")
    (set-lisp-callback text-start "activateCallback" '(change-time))
    (setq label2 (make-label form "label2"
      :labelString (XmString "s")
      :topAttachment  XmATTACH_WIDGET :topWidget label1 
      :topOffset 10 
      :leftAttachment XmATTACH_FORM :leftOffset 80))
    (setq text-length (make-textfield form "text-length" :width 80
      :topAttachment  XmATTACH_WIDGET :topWidget label1
      :leftAttachment XmATTACH_FORM :leftOffset 100))
    (XmTextSetString text-length "10.00")
    (set-lisp-callback text-length "activateCallback" '(change-time))
    (setq label3 (make-label form "label3"
      :labelString (XmString "s")
      :topAttachment  XmATTACH_WIDGET :topWidget label1 
      :topOffset 10
      :leftAttachment XmATTACH_FORM :leftOffset 180))
    (apply 'manage (list label1 btn1 btn2 text-start label2 text-length label3))
    (set-scalemenu form)
    (set-xfitmenu form)
    (set-fitmenu form)
    (set-pane form)
    (manage frame)
))

(defun setframe003mini()
  (let ((form0)(form)(pane))
    (setq form0 (XtParent text-eeg))
    (setq form  (XtParent text-ecg))(unmanage form)
    (if (> (resource (G-widget "ECG-fil") :channels) 0)(progn
      (set-values form 
        :topAttachment XmATTACH_WIDGET :topWidget form0 :topOffset 0)
      (setq form0 form)(manage form)))
    (setq form  (XtParent text-eog))(unmanage form)
    (if (> (resource (G-widget "EOG-fil") :channels) 0)(progn
      (set-values form 
        :topAttachment XmATTACH_WIDGET :topWidget form0 :topOffset 0)
      (setq form0 form)(manage form))) 
    (setq form  (XtParent text-emg))(unmanage form)
    (if (> (resource (G-widget "EMG-fil") :channels) 0)(progn
      (set-values form 
        :topAttachment XmATTACH_WIDGET :topWidget form0 :topOffset 0)
      (setq form0 form)(manage form)))    
    (setq form (resource (G-widget "dispgra") :display-parent)) 
    (setq pane (XtParent form))
    (set-values pane :topWidget XmATTACH_WIDGET :topWidget form0)
))

(defun setframe004(&optional (frame frame004))
  (let ((form)(arU)(arD)(label)(func1)(dispmemo))
    (defvar text-scanscale nil)
    (defvar text-numpeak nil)
    (unmanage frame)
    (XtDestroyWidget (XtNameToWidget frame004 "form"))
    (setq form (make-form frame))
    (manage form)

    (defun func1(name title offset width command)
      (let ((btn))
        (setq btn (make-button form name :labelString (XmString title)
          :bottomAttachment XmATTACH_FORM :background (rgb 240 240 240)
          :leftAttachment XmATTACH_FORM :leftOffset offset
          :width width :shadowThickness 0 :detailShadowThickness 0))
        (set-lisp-callback btn "activateCallback" command)
        (manage btn)(return btn)  ))
    (defun dispmemo()(let ((x form-memos))
      (if (XtIsManaged x)(unmanage x)(manage x))))

    (setq text-scanscale (make-textfield form "text-scanscale"
      :leftAttachment XmATTACH_FORM :width 60
      :topAttachment  XmATTACH_FORM))
    (XmTextSetString text-scanscale "500")
    (set-lisp-callback text-scanscale "valueChangedCallback" 
      '(change-scandisp-scale))
    (setq arU (make-arrowbutton form "arD"
      :arrowDirection XmARROW_UP :width 13 :topOffset 1
      :topAttachment XmATTACH_OPPOSITE_WIDGET :topWidget text-scanscale
      :leftAttachment XmATTACH_WIDGET :leftWidget text-scanscale))
    (setq arD (make-arrowbutton form "arD"
      :arrowDirection XmARROW_DOWN :width 13
      :bottomAttachment XmATTACH_OPPOSITE_WIDGET :bottomWidget text-scanscale
      :leftAttachment XmATTACH_WIDGET :leftWidget text-scanscale))
    (set-lisp-callback arU "activateCallback" 
      '(change-scale-value text-scanscale 1))
    (set-lisp-callback arD "activateCallback" 
      '(change-scale-value text-scanscale -1))  
    (setq text-numpeak (make-textfield form "text-numpeak"
      :leftAttachment XmATTACH_WIDGET :leftWidget text-scanscale
      :leftOffset 40  :topAttachment  XmATTACH_FORM :width 40))
    (XmTextSetString text-numpeak "50")
    (setq label (make-label form "label"
      :topAttachment XmATTACH_FORM :topOffset 5 
      :rightAttachment XmATTACH_FORM :rightOffset 10
      :labelString (XmString "peaks") ))
    (apply 'manage (list text-scanscale arU arD text-numpeak label))
    (func1 "btn1" "8 waves" 0 60 '(widenScan))
    (func1 "btn2" "memos"   63 48 '(dispmemo))
    (func1 "btn3" "check"  114 45 '(sort-scan))
    (func1 "btn4" "scan"   162 38 '(scan-record))
    (manage frame)
))

(defun set-fitmenu(form)
  (let ((up)(down)(left)(right)(btn1)(btn2)(func1))
    (defun func1(name direction offset command)
      (let ((btn))
        (setq btn (make-arrowbutton form name
          :arrowDirection direction :width 15
          :bottomAttachment XmATTACH_WIDGET :bottomWidget text-near
          :bottomOffset 6
          :leftAttachment XmATTACH_FORM :leftOffset offset))
        (set-lisp-callback btn "activateCallback" command)
        (manage btn)(return btn)  ))
    (setq up    (func1 "arU" XmARROW_UP     0 '(change-pane "up")))
    (setq down  (func1 "arD" XmARROW_DOWN  15 '(change-pane "down")))
    (setq left  (func1 "arL" XmARROW_LEFT  30 '(change-pane "left")))
    (setq right (func1 "arR" XmARROW_RIGHT 45 '(change-pane "right")))

    (setq btn1 (make-button form "btn-transfer"
      :leftAttachment XmATTACH_WIDGET :leftWidget right
      :labelString (XmString "transfer")
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text-near
      :bottomOffset 2))
    (setq btn2 (make-button form "btn-fit"
      :leftAttachment XmATTACH_WIDGET :leftWidget btn1
      :rightAttachment XmATTACH_FORM  :labelString (XmString "fit")
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text-near
      :bottomOffset 2))
    (set-lisp-callback btn1  "activateCallback" '(xfit-transfer))
    (set-lisp-callback btn2  "activateCallback" '(xfit-transfer t)) 
    (apply 'manage (list btn1 btn2))
))

(defun set-near-coil(ch)
  (let ((nch)(str)(n)(m)(sns)(snss nil)(str "MEG["))
    (setq ch (read-from-string (string-trim "MEG " ch)))
    (setq ch (round (floor (/ ch 10))))
    (setq nch (read-from-string (XmTextGetString text-near)))
    (setq nch (round nch))
    (if (> nch 102)(setq nch 30))
    (if (< nch 4)(setq nch 30))
    (XmTextSetString text-near (format nil "~a" nch))
    (dotimes (n (length near-coil))
      (if (= ch (first (nth n near-coil)))(setq sns (nth n near-coil))))
    (dotimes (m nch)
      (setq snss (append snss (list (nth m sns)))))
    (dotimes (m nch)
      (setq n (nth m snss))
      (setq str (format nil "~a ~a1 ~a2 ~a3" str n n n)))
    (setq str (format nil "~a]" str));
    (set-resource (G-widget "meg") :names (list str))
))

(defun set-pane(form)
  (let ((n)(pane)(formn)(w)(name)(label)(disp)(dispw)(R)(sc))
    (setq displabel (make-label form "displabel"
      :leftAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_WIDGET :bottomWidget text-near
      :bottomOffset 30
      :labelString (XmString "--")))
    (manage displabel);;global variant    
    (setq pane (XmCreatePanedWindow form "pane" (X-arglist) 0))
    (dotimes (n 6)
      (setq formn (XtNameToWidget form (format nil "form~d" (1+ n))))
      (if (XtIsManaged formn)(setq w formn)))
    (set-values pane
      :separatorOn      1  :sasIndent -1  :allowResize 1
      :topAttachment    XmATTACH_WIDGET :topWidget w
      :bottomAttachment XmATTACH_WIDGET :bottomWidget displabel 
      :leftAttachment   XmATTACH_FORM
      :rightAttachment  XmATTACH_FORM)
    (dolist (name (list "eeg" "mag" "gra"))
      (when (G-widget (format nil "disp~a" name) :quiet)
        (GtDeleteWidget (G-widget (format nil "disp~a" name))))
      (setq formn (make-form pane (format nil "form-~a" name)))
      (setq label (make-label formn "label"
        :topAttachment  XmATTACH_FORM :alignment XmALIGNMENT_BEGINNING
        :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM
        :labelString (XmString (string-upcase name))))
      (if (string-equal name "gra")
        (set-values formn :panePreferred 100));invalid
      (apply 'manage (list formn label))
      (setq R (create-plotter formn (format nil "disp~a" name)))
      (setq disp (first R) dispw (second R))
      (set-values dispw :resizable 1
        :topAttachment XmATTACH_WIDGET :topWidget label
        :bottomAttachment XmATTACH_FORM :bottomOffset -5
        :leftAttachment  XmATTACH_FORM :leftOffset  -5
        :rightAttachment XmATTACH_FORM :rightOffset -5)
      (link (G-widget (format nil "win~a" name))
            (G-widget (format nil "disp~a" name)))
      (set-resource disp :superpose t)
      (set-resource disp :scroll-visible 0)
      ;(setq sc (resource disp :scroll-widget))
      ;(set-values sc :visible 0)
      (cond name
        ((string-equal name "gra")(progn
         (setq gralabel label)
         (set-resource disp :select-hook '(sync-select-mini "gra"))))
        ((string-equal name "mag")(progn
         (setq maglabel label)
         (set-resource disp :select-hook '(sync-select-mini "mag"))))
        ((string-equal name "eeg")(progn
         (setq eeglabel label)
         (set-resource disp :select-hook '(sync-select-mini "eeg"))))
      ))
  (manage pane)
))

(defun set-scale(&optional (disp (G-widget "disp1")))
  (let ((n)(chtype)(ch-class)(name)(nch)(scale)(eeg)(ecg)(eog)(emg))
    (setq chtype   (get-property disp 0 :kind))
    (setq ch-class (get-property disp 0 :ch-class))
    (setq nch (resource disp :channels))
    (set-resource disp :offsets (make-matrix nch 1 0))
    (cond 
      ((equal ch-class 'meg-planar)(progn
        (setq scale (* 1e-13 (read-from-string (XmTextGetString text-gra))))
        (if (> nch 90)(setq scale (* scale 8)))
        (set-resource disp :scales (make-matrix nch 1 scale))))
      ((equal ch-class 'meg-magmeter)(progn
        (setq scale (* 1e-15 (read-from-string (XmTextGetString text-mag))))
        (if (> nch 50)(setq scale (* scale 8)))
        (set-resource disp :scales (make-matrix nch 1 scale))))
      ((equal ch-class 'other)(progn (setq scale nil)
        (setq eeg (read-from-string (XmTextGetString text-eeg)))
        (setq ecg (read-from-string (XmTextGetString text-ecg)))
        (setq eog (read-from-string (XmTextGetString text-eog)))
        (setq emg (read-from-string (XmTextGetString text-emg)))     
        (dotimes (n nch)
          (case (get-property disp n :kind)
            (2   (setq scale (append scale (list eeg))))
            (402 (setq scale (append scale (list ecg))))
            (302 (setq scale (append scale (list emg))))
            (202 (setq scale (append scale (list eog))))
          ))
        (setq scale (* (transpose (matrix (list scale)))1e-6))
        (set-resource disp :scales scale) ))
    )    
))


(defun set-scalemenu(form)
  (let ((n)(formn)(R)(menu)(text)(arU)(arD)(fil "filter")(as "autoscale"))
    (dotimes (n 6);GRA MAG EEG ECG EOG EMG
      (setq formn (make-form form (format nil "form~d" (1+ n))
        :topAttachment XmATTACH_WIDGET :topWidget text-start
        :topOffset (* n 30) :height 20 
        :leftAttachment XmATTACH_FORM :rightAttachment XmATTACH_FORM))
      (setq R (create-scale formn))
      (apply 'manage (cons formn R))
      (setq menu (make-menu (first R)(nth n (list
        "GRA fT/cm" "MAG fT" "EEG uV" "ECG uV" "EOG uV" "EMG uV")) nil)) 
      (add-separator menu)
      (case n
        (0 (progn (add-button menu fil '(GtPopupEditor (G-widget "MEG-fil")))
                  (add-button menu as '(autoscale "GRA"))))
        (1 (progn (add-button menu fil '(GtPopupEditor (G-widget "MEG-fil")))
                  (add-button menu as '(autoscale "MAG"))))
        (2 (progn (add-button menu fil '(GtPopupEditor (G-widget "EEG-fil")))
                  (add-button menu as '(autoscale "EEG"))))
        (3 (progn (add-button menu fil '(GtPopupEditor (G-widget "ECG-fil")))
                  (add-button menu as '(autoscale "ECG"))))
        (4 (progn (add-button menu fil '(GtPopupEditor (G-widget "EOG-fil")))
                  (add-button menu as '(autoscale "EOG"))))
        (5 (progn (add-button menu fil '(GtPopupEditor (G-widget "EMG-fil")))
                  (add-button menu as '(autoscale "EMG"))))
      )
      (setq text (second R) arU (third R) arD (fourth R))
      (XmTextSetString text (format nil "~0,0f"
        (nth n (list 500 2500 60 300 100 500))))
      (case n
        (0 (progn (setq text-gra text))(set-lisp-callback text 
          "valueChangedCallback" '(change-scale "gra"))
          (set-lisp-callback arU "activateCallback" 
          '(change-scale-value text-gra 1))
          (set-lisp-callback arD "activateCallback"
          '(change-scale-value text-gra -1)))
        (1 (progn (setq text-mag text))(set-lisp-callback text
          "valueChangedCallback" '(change-scale "mag"))
          (set-lisp-callback arU "activateCallback" 
          '(change-scale-value text-mag 1))
          (set-lisp-callback arD "activateCallback"
          '(change-scale-value text-mag -1)))
        (2 (progn (setq text-eeg text))(set-lisp-callback text
          "valueChangedCallback" '(change-scale "eeg"))
          (set-lisp-callback arU "activateCallback" 
          '(change-scale-value text-eeg 1))
          (set-lisp-callback arD "activateCallback"
          '(change-scale-value text-eeg -1)))
        (3 (progn (setq text-ecg text))(set-lisp-callback text
          "valueChangedCallback" '(change-scale "ecg"))
          (set-lisp-callback arU "activateCallback" 
          '(change-scale-value text-ecg 1))
          (set-lisp-callback arD "activateCallback"
          '(change-scale-value text-ecg -1)))
        (4 (progn (setq text-eog text))(set-lisp-callback text
          "valueChangedCallback" '(change-scale "eog"))
          (set-lisp-callback arU "activateCallback" 
          '(change-scale-value text-eog 1))
          (set-lisp-callback arD "activateCallback"
          '(change-scale-value text-eog -1)))
        (5 (progn (setq text-emg text))(set-lisp-callback text
          "valueChangedCallback" '(change-scale "emg"))
          (set-lisp-callback arU "activateCallback" 
          '(change-scale-value text-emg 1))
          (set-lisp-callback arD "activateCallback"
          '(change-scale-value text-emg -1)))
      )
    )
    (if (> (resource (G-widget "buf") :channels) 0)(progn
      (if (= (resource (G-widget "EEG-fil") :channels) 0)
        (unmanage (XtNameToWidget form "form3")))
      (if (= (resource (G-widget "ECG-fil") :channels) 0)
        (unmanage (XtNameToWidget form "form4")))
      (if (= (resource (G-widget "EOG-fil") :channels) 0)
        (unmanage (XtNameToWidget form "form5")))
      (if (= (resource (G-widget "EMG-fil") :channels) 0)
        (unmanage (XtNameToWidget form "form6")))
    ))
))

(defun set-ssp()
  (let ((filename (resource (G-widget "file") :filename)))
    (if (not (string-equal (filename-extension filename) "fif"))
      (setq filename "/neuro/dacq/setup/ssp/online-0.fif"))
    (graph::ssp-popup)
    (graph::ssp-load-file filename)
    (setq graph::ssp-vectors graph::ssp-vector-pool)
    (graph::ssp-rebuild-space)
    (graph::ssp-on)
))

(defun set-xfitmenu(form)
  (let ((btn)(rb1)(rb2)(rb3)(tb1)(tb2)(tb3)(label)(w))
    (defvar text-prepeak nil "at n% of peak")
    (defvar text-near    nil "number of nearest ? sensors")
    (defvar rb-near      nil "102/nearest ? sensors ")
    (defvar rb-coil      nil "GRA/MAG/BOTH")
    (defvar rb-peak      nil "peak/at ?% of peak")
    (setq btn (make-button form "btn"
      :labelString (XmString "GRA 5.0 MAG 20.0")
      :bottomAttachment XmATTACH_FORM
      :rightAttachment XmATTACH_FORM
      :leftAttachment  XmATTACH_FORM)) 
    (set-lisp-callback btn "activateCallback" '(manage noisemenu))
    (manage btn)
    (setq rb1 (XmCreateRadioBox form "rb1" (X-arglist) 0))
    (set-values rb1
      :leftAttachment   XmATTACH_FORM   :numColumns 2
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn)
    (setq tb1 (make-toggle-button rb1 "tb1" 
      :labelString (XmString "peak") :set 1))
    (setq tb2 (make-toggle-button rb1 "tb2" :labelString (XmString "at")))
    (setq text-prepeak (make-textfield form "text-prepeak"
      :leftAttachment   XmATTACH_FORM :leftOffset 105 :width 40
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn))
    (setq label (make-label form "prepeaklabel"
      :leftAttachment   XmATTACH_WIDGET :leftWidget text-prepeak
      :bottomAttachment XmATTACH_WIDGET :bottomWidget btn :bottomOffset 5
      :labelString (XmString "of peak")))
    (XmTextSetString text-prepeak "80")
    (apply 'manage (list rb1 tb1 tb2 text-prepeak label))
    (setq rb2 (XmCreateRadioBox form "rb2" (X-arglist) 0))
    (set-values rb2 :numColumns 3
      :leftAttachment   XmATTACH_FORM   :rightAttachment XmATTACH_FORM
      :bottomAttachment XmATTACH_WIDGET :bottomWidget rb1)
    (setq tb1 (make-toggle-button rb2 "tb1" :labelString (XmString "GRA")))
    (setq tb2 (make-toggle-button rb2 "tb2" :labelString (XmString "MAG")))
    (setq tb3 (make-toggle-button rb2 "tb3" :labelString (XmString "both")
      :set 1))
    (apply 'manage (list rb2 tb1 tb2 tb3))
    (setq rb3 (XmCreateRadioBox form "rb3" (X-arglist) 0))
    (set-values rb3 :numColumns 2
      :leftAttachment   XmATTACH_FORM
      :bottomAttachment XmATTACH_WIDGET :bottomWidget rb2)
    (setq tb1 (make-toggle-button rb3 "tb1" :set 1 
      :labelString (XmString "all 102")))
    (setq tb2 (make-toggle-button rb3 "tb2" 
      :labelString (XmString "nearest")))
    (setq text-near (make-textfield form "text-near" :width 40
      :leftAttachment   XmATTACH_FORM :leftOffset 155
      :bottomAttachment XmATTACH_WIDGET :bottomWidget rb2))
    (XmTextSetString text-near "30")
    (apply 'manage (list rb3 tb1 tb2 text-near))
    (setq rb-near rb3 rb-coil rb2 rb-peak rb1)
    (if (not noisemenu)(create-noisemenu))
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

(defun sort-scan()
  (let ((filename))
    (setq filename (resource (G-widget "file") :filename))
    (if (not (string-equal filename loadfiffname))
      (info "The filename is not compatible!! ~% Scan again!")
      (if (yes-or-no-p "You must wait for a while.~% Are you sure?")
        (sort-scan-core)))
))

(defun sort-scan-core()
  (let ((n)(t0)(mtx)(x nil)(x1)(x2)(R nil)(MTX)(func1)(xscale)(num)(gra)
    (buf)(L)(maxf)(w)(xscale2)(nn))
    (setq MTX (G-widget "MTX") xscale (resource MTX :x-scale))
    (setq buf (G-widget "buf") gra (G-widget "gra"))
    (setq w (G-widget "mxwin"))
    (setq mtx (resource MTX :matrix))
    (setq t0 (* (resource buf :low-bound)(x-scale buf 0)))
    (defun func1(x)(+ (* x xscale) t0))
    (dotimes (n (array-dimension mtx 1))
      (setq x (cons (second (matrix-extent (column n mtx))) x)) )
    (setq x (reverse x))  
    (setq x1 (reverse (sort x)))      ;amplitude
    (setq x2 (reverse (sort-order x)));time (smp)
    (setq x2 (mapcar #'func1 x2))     ;time (sec)
    (setq num (read-from-string (XmTextGetString text-numpeak)))
    (link gra w)(GtUnlinkWidget (G-widget "mxvcp"))
    (set-resource w :point 0 :start 0 :end xscale)
    (setq xscale2 (/ xscale 2))
    (manage form-memos)
    (catch 'exit
      (dotimes (n (length x2))
        (setq nn (round (/ (* n 100) num)))
        (unless (longworking (format nil "sorting...~d%%" nn) 
          n num)(progn (error "interrupted")(longworking "stopped" 100 100)))
        (setq t0 (nth n x2))(set-resource w :point t0)
        (setq L (get-max-widget w t0));max fT MEGxxxx xxxsec
        (setq maxf (first L))
        (setq t0 (- (third L) xscale2))
        (set-resource w :point t0)
        (setq L (get-max-widget w t0))
        (if (= maxf (first L))(setq R (append R (list 
          (list t0 xscale (second L)(third L)(* (first L) 1e+13))))))
        (if (= (length R) num)(throw 'exit nil))  ))  
    (longworking "done" num num)
    (XmjkLispListSet (get-memop) R)
    (memo-sort 3)
))

(defun string-member(str str-list)
  (let ((R nil))
    (dolist (st str-list)
      (if (string-equal str st)(setq R t)))
    (return R)
))

(defun sync-disp-move(&optional (num 1))
  (let ((w)(disp)(n)(t0)(span)(xt0)(xspan))
    (setq w (G-widget (format nil "disp~d" num)))
    (setq t0    (resource w :point)
          span  (resource w :length))
    (XmTextSetString text-start  (format nil "~0,2f" t0))
    (XmTextSetString text-length (format nil "~0,2f" span))
    (change-time)
))

(defun sync-disp-select(&optional (num 1))
  (let ((w)(disp)(n)(t0)(span)(xt0)(xspan)(win)(disp)(R)(str))
    (set-values displabel :labelString (XmString "--"))
    (set-values gralabel  :labelString (XmString "GRA"))
    (set-values maglabel  :labelString (XmString "MAG"))
    (set-values eeglabel  :labelString (XmString "EEG"))   
     (setq w (G-widget (format nil "disp~d" num)))
    (setq xt0   (resource w :selection-start)
          xspan (resource w :selection-length))
    (dotimes (n 10)
      (setq w (G-widget (format nil "disp~d" (1+ n)) :quiet))
      (when w (when (/= (1+ n) num)(set-resource w 
           :selection-start xt0 :selection-length xspan))))  
    (dolist (n (list "wingra" "winmag" "wineeg"))
      (GtUnlinkWidget (G-widget n)))       
    (if (> xspan 0)(progn
      (setq str (format nil "~0,3f - ~0,3f sec" xt0 (+ xt0 xspan)))
      (setq labels4 (list str))
      (set-values displabel :labelString (XmString str))
      (link (G-widget "gra")(G-widget "wingra"))
      (link (G-widget "mag")(G-widget "winmag"))
      (linkEEG)
      ;(link (G-widget "EEG-fil")(G-widget "wineeg"))      
      (dolist (n (list "wingra" "winmag" "wineeg"))
        (set-resource (G-widget n) :point xt0 :start 0 :end xspan))
      (link (G-widget "wingra")(G-widget "dispgra"))
      (link (G-widget "winmag")(G-widget "dispmag"))
      (link (G-widget "wineeg")(G-widget "dispeeg"))
      (dolist (n (list "dispgra" "dispmag" "dispeeg"))
        (set-resource (G-widget n) :point 0 :length xspan))
      (setq R (get-max-widget (G-widget "wingra")))
      (set-resource (G-widget "dispgra") :scales
        (make-matrix (resource (G-widget "wingra") :channels) 1 (first R)))
      (setq str (format nil "~a ~0,3f ~0,0ffT/cm" 
        (second R)(+ (third R) xt0)(* (first R) 1e+13)))
      (setq labels4 (append labels4 (list str)))
      (set-values gralabel :labelString (XmString str))
      (setq R (get-max-widget (G-widget "winmag")))
      (set-resource (G-widget "dispmag") :scales
        (make-matrix (resource (G-widget "winmag") :channels) 1 (first R)))
      (setq str (format nil "~a  ~0,3f  ~0,0ffT" 
        (second R)(+ (third R) xt0)(* (first R) 1e+15)))
      (setq labels4 (append labels4 (list str)))
      (set-values maglabel :labelString (XmString str))
      (setq R (get-max-widget (G-widget "wineeg")))
      (set-resource (G-widget "dispeeg") :scales
        (make-matrix (resource (G-widget "wineeg") :channels) 1 (first R)))
      (setq str (format nil "~a  ~0,3f  ~0,0fuV" 
        (second R)(+ (third R) xt0)(* (first R) 1e+6)))
      (setq labels4 (append labels4 (list str)))
      (set-values eeglabel :labelString (XmString str))
    ))
))

(defun sync-select-mini(chkind)
  (let ((disp)(t0)(xt0)(xspan)(mxwin)(R)(str))
    (setq disp (G-widget (format nil "disp~a" chkind)))
    (setq xt0   (resource disp :selection-start))
    (setq xspan (resource disp :selection-length))
    (dolist (n (list "gra" "mag" "eeg"))
      (if (not (string-equal chkind n))(progn
        (set-resource (G-widget (format nil "disp~a" n))
          :selection-start xt0 :selection-length xspan))))
    (set-values displabel :labelString (XmString (first  labels4)))
    (set-values gralabel  :labelString (XmString (second labels4)))
    (set-values maglabel  :labelString (XmString (third  labels4)))
    (set-values eeglabel  :labelString (XmString (fourth labels4)))   
    (if (> xspan 0)(progn      
      (setq t0 (resource (G-widget "wingra") :point))
      (setq str (format nil "~0,3f - ~0,3f sec"
        (+ t0 xt0)(+ t0 xt0 xspan)))
      (set-values displabel :labelString (XmString str))
      (setq mxwin (G-widget "mxwin")) 
      (link (G-widget "wingra")mxwin)
      (set-resource mxwin :point xt0 :start 0 :end xspan)
      (setq R (get-max-widget mxwin))
      (setq str (format nil "~a ~0,3f ~0,0ffT/cm" (second R)
        (+ (third R) t0 xt0)(* (first R)1e+13)))
      (set-values gralabel :labelString (XmString str))
      (link (G-widget "winmag")mxwin)
      (set-resource mxwin :point xt0 :start 0 :end xspan)
      (setq R (get-max-widget mxwin))
      (setq str (format nil "~a ~0,3f ~0,0ffT" (second R)
        (+ (third R) t0 xt0)(* (first R)1e+15)))
      (set-values maglabel :labelString (XmString str))  
      (link (G-widget "wineeg")mxwin)
      (set-resource mxwin :point xt0 :start 0 :end xspan)
      (setq R (get-max-widget mxwin))
      (setq str (format nil "~a ~0,3f ~0,0fuV" (second R)
        (+ (third R) t0 xt0)(* (first R)1e+6)))
      (set-values eeglabel :labelString (XmString str))   
    ))
))

(defun widenScan()
  (let ((check)(w (G-widget "scandisp")))
    (apply 'unmanage (list frame001 frame002))
    (setq check (resource w :superpose))
    (if check (progn
      (set-values frame001 :bottomOffset 200)
      (set-resource w :superpose nil
                      :ch-label-space 30))
    (progn 
      (set-values frame001 :bottomOffset 60)
      (set-resource w :superpose t
                      :ch-label-space 0)))
    (apply 'manage (list frame001 frame002))
))

(defun which-meg8(sns)
  (let ((n)(ch)(nn nil)(str))
    (setq ch (read-from-string (string-left-trim "MEG" sns)))
    (setq ch (- ch (* (floor (/ ch 10)) 10)))
    (if (> ch 1.0)(progn
      (catch 'exit (dotimes (n 204)
        (if (string-equal sns (get-property (G-widget "gra") n :name))
          (throw' exit (setq nn n)))))
      (cond 
        ((< nn  26)(setq str "gra-L-temporal"))
        ((< nn  52)(setq str "gra-R-temporal"))
        ((< nn  78)(setq str "gra-L-parietal"))
        ((< nn 104)(setq str "gra-R-parietal"))
        ((< nn 128)(setq str "gra-L-occipital"))
        ((< nn 152)(setq str "gra-R-occipital"))
        ((< nn 178)(setq str "gra-L-frontal"))
        ((< nn 204)(setq str "gra-R-frontal"))
      ))(progn
      (catch 'exit (dotimes (n 102)
        (if (string-equal sns (get-property (G-widget "mag") n :name))
          (throw' exit (setq nn n)))))
      (cond 
        ((< nn  13)(setq str "mag-L-temporal"))
        ((< nn  26)(setq str "mag-R-temporal"))
        ((< nn  39)(setq str "mag-L-parietal"))
        ((< nn  52)(setq str "mag-R-parietal"))
        ((< nn  64)(setq str "mag-L-occipital"))
        ((< nn  76)(setq str "mag-R-occipital"))
        ((< nn  89)(setq str "mag-L-frontal"))
        ((< nn 102)(setq str "mag-R-frontal"))
       )))
))

(defun xfit-prepeak()
  (let ((pre)(L)(t0)(span)(w)(peak)(tpeak)(mtx)(n)(tt nil)(R)(val))
    (setq pre (read-from-string (XmTextGetString text-prepeak)))
    (setq L (get-label-list displabel))
    (setq w (G-widget "buf2"))
    (setq t0   (x-to-sample w (first L)))
    (if (= (get-radiobox rb-coil)2)
      (setq L (get-label-list maglabel) w (G-widget "mag") val 1e-15)
      (setq L (get-label-list gralabel) w (G-widget "gra") val 1e-13))
    (setq peak (read-from-string 
      (string-right-trim "fT/cm" (format nil "~a" (third L)))))
    (setq tpeak (x-to-sample w (second L)))
    (setq span (- tpeak t0))
    (setq pre (* (* peak pre 0.01) val))
    (setq mtx (get-data-matrix w t0 span))
    (setq mtx (map-matrix mtx #'abs))
    (catch 'exit
      (dotimes (n span)
        (setq L (column (- span n 1) mtx))
        (if (< (second (matrix-extent L)) pre)
          (throw 'exit (setq tt (- span n)))))) 
          ;;  (setq tt (- span n) L (column tt mtx))))))
          ;;(if (not tt)(setq tt 0 mtx (column tt  mtx)))
    (if (not tt)(setq tt 0))  
    (setq tt (* (sample-to-x w (+ t0 tt)) 1e+3))
    (graph::xfit-command (format nil "fit ~0,3f" tt))    
))

(defun xfit-selection()
  (let ((names)(ignore)(L))
    (setq meg (G-widget "meg"))
    (case (get-radiobox rb-coil)
      (1 (setq ignore '("MEG*1")))
      (2 (setq ignore '("MEG*2" "MEG*3")))
      (3 (setq ignore nil))
    )
    (if (= (get-radiobox rb-near) 1)
      (set-resource meg :names '("MEG*"))
      (progn
        (setq L (get-label-list gralabel))
        (set-near-coil (format nil "~a" (first L)))
      ))
    (set-resource (G-widget "meg"):ignore ignore)
))

(defun xfit-transfer(&optional (fit nil))
  (let ((names)(L)(str)(t0)(tend)(tpeak)(ch)(bs1)(bs2)(cmd))
    (setq L (get-label-list displabel))
    (if (= (length L) 4)(progn
      (setq t0 (first L) tend (third L))
      (xfit-selection)
      (if (= (get-radiobox rb-coil) 2)
        (setq L (get-label-list maglabel))
        (setq L (get-label-list gralabel)))
      (setq ch (format nil "~a" (first L)))
      (setq tpeak (second L))
      (if (= (get-radiobox rb-noise)2)(progn
        (setq bs1 (read-from-string (XmTextGetString text-baseline1)))
        (setq bs2 (read-from-string (XmTextGetString text-baseline2)))
        (if (< (+ bs1 tpeak)t0)(setq t0 (+ bs1 tpeak))) ))
      (graph::xfit-transfer-data (G-widget "meg")(list t0 (- tend t0)))
      (graph::xfit-command (format nil "samplech ~a" 
        (string-left-trim "MEG" ch)))
      (setq tpeak (* tpeak 1e+3))
      (graph::xfit-command (format nil "pick ~0,3f" tpeak))
      (if fit (progn
        (case (get-radiobox rb-noise)
          (1 (setq cmd (format nil "baseline ~0,1f ~0,1f"
            (* t0 1e+3)(* tend 1e+3))))
          (2 (setq cmd (format nil "baseline ~0,1f ~0,1f"
            (* t0 1e+3)(+ (* bs2 1e+3) tpeak))))
          (3 (setq cmd "baseline off"))
        )
        (graph::xfit-command cmd)
        (if (= (get-radiobox rb-peak) 1)
          (graph::xfit-command (format nil "fit ~0,3f" tpeak))
          (xfit-prepeak))
      )) ))   
    (dipdata)
))

(defun XmTextGetNumber(XmText)
  (return (read-from-string (XmTextGetString XmText)))
)
(if (G-widget "display" :quiet)(initialize))

