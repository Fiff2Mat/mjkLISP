;(require '/home/neurosurgery/lisp/setup-widgets)
;(graph:initializeWidgets)

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

(make-package "setup-widgets")
(in-package "setup-widgets")
(provide "setup-widgets")
(use-package "graph");; to use (G-widget...)
(use-package "X")

(defun calc-abs-average(mtx)
  "(calc-abs-average #m((1 -2 3)(-4 5 -6)))>3.5"
  (let ((xx)(elements)(func1))
    (setq xx 0)
    (defun func1(x)(setq xx (+ (abs x) xx)))
    (nmap-matrix mtx 'func1)
    (setq elements (apply #'* (array-dimensions mtx)))
    (/ xx elements)
))

(defun check-channel()
  (let ((file)(n)(kind nil)(ch-class nil)(subfunc1)(chname))
    (defun chname(num)
      (let ((xxx "other"))(case num
        (1 (setq xxx "MEG"))
        (2 (setq xxx "EEG"))
        (3 (setq xxx "STIM"))
        (201 (setq xxx "MCG"))
        (202 (setq xxx "EOG"))
        (302 (setq xxx "EMG"))
        (402 (setq xxx "ECG"))
        (502 (setq xxx "MISC"))
        (602 (setq xxx "RESP"))
        (900 (setq xxx "system"))
        (910 (setq xxx "ActiveShield"))
        (920 (setq xxx "Excitation"))
      )(return xxx)))

    (defun subfunc1(kind)
      (let ((n)(nch)(xx)(x -1)(xn 0)(x1 nil)(x2 nil))
        (setq nch (length kind))
        (setq xx (1- nch)) 
        (dotimes (n nch)
          (if (/= x (nth n kind))(progn 
            (if (> x 0)
              (setq x1 (cons (chname x) x1) x2 (cons xn x2)))
            (setq x (nth n kind) xn 1))
            (progn (setq xn (1+ xn)))) 
          (if (= n xx)(setq x1 (cons (chname x) x1) x2 (cons xn x2))))
        (return (list (reverse x1)(reverse x2))) ))
    (setq file (G-widget "file"))
    (dotimes (n (resource file :channels))
      (setq kind     (cons (get-property file n :kind) kind))
      (setq ch-class (cons (get-property file n :ch-class) ch-class)) )
    (return (subfunc1 (reverse kind)))
))

(defun change-lead1020(&optional (xx 20));;;not used
  (let ((n)(lead)(for10)(for20)(R)(str))
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

(defun changeTP(eeg1);(T3 T4 T5 T6)<>(T7 T8 P7 P8);; not used
  (let ((n)(ch)(TP nil)(funcTP))
    (defun funcTP(lead)
      (let ((R nil)(n)(ch))
        (setq ch (nth n lead))
        (cond
          ((string-equal ch "T3")(setq ch "T7"))
          ((string-equal ch "T4")(setq ch "T8"))
          ((string-equal ch "T5")(setq ch "P7"))
          ((string-equal ch "T6")(setq ch "P8"))
        )
        (setq R (cons ch R))
        (return (reverse R)) ))
    (defun funcTT(lead)
      (let ((R nil)(n)(ch))
        (setq ch (nth n lead))
        (cond
          ((string-equal ch "T7")(setq ch "T3"))
          ((string-equal ch "T8")(setq ch "T4"))
          ((string-equal ch "P7")(setq ch "P5"))
          ((string-equal ch "P8")(setq ch "P6"))
        )
        (setq R (cons ch R))
        (return (reverse R)) ))
    (catch 'exit (dotimes (n (length eeg1))
      (if (string-equal (nth n eeg1) "T7")
        (throw 'catch (setq TP t)))))
    (if TP (progn
      (setq banana1a (funcTP banana1a))
      (setq banana1b (funcTP banana1b))
      (setq banana2a (funcTP banana2a))
      (setq banana2b (funcTP banana2b))
      (setq transversea (funcTP transversea))
      (setq transverseb (funcTP transverseb))
      (setq mono1a (funcTP mono1a))
      (setq mono1b (funcTP mono1b))
      (setq mono2a (funcTP mono2a))
      (setq mono2b (funcTP mono2b))
      (setq average1a (funcTP average1a))
      (setq average1b (funcTP average1b))
      (setq average2a (funcTP average2a))
      (setq average2b (funcTP average2b)) )
    (progn
      (setq banana1a (funcTT banana1a))
      (setq banana1b (funcTT banana1b))
      (setq banana2a (funcTT banana2a))
      (setq banana2b (funcTT banana2b))
      (setq transversea (funcTT transversea))
      (setq transverseb (funcTT transverseb))
      (setq mono1a (funcTT mono1a))
      (setq mono1b (funcTT mono1b))
      (setq mono2a (funcTT mono2a))
      (setq mono2b (funcTT mono2b))
      (setq average1a (funcTT average1a))
      (setq average1b (funcTT average1b))
      (setq average2a (funcTT average2a))
      (setq average2b (funcTT average2b)) ))
))

(defun defchpos() 
  (let ((x)(y)(z)(dist)(ch-dist)(func1)(sort2)(sort-order)
    (make-chname)(calc-near-coil))
    (defun func1(i j k); k x/y/z
      (sqr (- (nth i k)(nth j k))))
    (defun make-chname()  
      (let ((x)(y)(ch nil))
        (dotimes (x 26)
          (dotimes (y 4)
            (setq n (+ (* x 10) y 11))
            (setq ch (append ch (list n)))))
        (setq ch (delete 83 ch))
        (setq ch (delete 84 ch))
        (return ch) ))
    (defun sort2(xlist)
      (let ((N)(xmin)(x nil)(xx nil))
        (dotimes (i (length xlist))(setq xx (append xx (list (nth i xlist)))))
          (setq N (length xx))
          (while (> N 0)
            (setq xmin (apply #'min xx))
            (setq xx (delete xmin xx))
            (setq N (length xx))
            (setq x (append x (list xmin))))
        (return x) ))
    (defun sort-order(xlist)
      (let ((xx (sort2 xlist))(x nil)(R nil))
        (dotimes (i (length xx) R)
          (setq x (nth i xx))
          (dotimes (j (length xlist))
            (if (equal x (nth j xlist))(setq R (append R (list j))))))
        (return R) ))
    (defun calc-near-coil()
      (let ((R nil)(dist)(x)(xx)(chname)(calc-near-coil))
        (setq chname (make-chname))
          (dotimes (i (length ch-dist))
            (setq dist (nth i ch-dist))
            (setq x (sort-order dist))
            (setq xx nil)
            (dolist (j x)
              (setq xx (append xx (list (nth j chname)))))
              (setq R (append R (list xx))))
            (return R) ))  
      
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
    (setq ch-dist nil)  
    (dotimes (j (length x))  
      (setq dist nil)
      (dotimes (i (length x))   
        (setq dist (append dist (list
          (+ (func1 i j x)(func1 i j y)(func1 i j z))  ))))
      (setq ch-dist (append ch-dist (list (mapcar #'sqrt dist)))) )  
       ;(setq chdist (append chdist (list (mapcar #'sqrt dist))))))
    (return (calc-near-coil));near-coil
))


(defun deleteWidgets()
  (let ((w))
    (dolist (w (list "buf" "MEG" "MEG-fil" "buf2" "gra" "mag" "meg" 
      "EEG" "EEG-fil" "ECG" "ECG-fil" "EOG" "EOG-fil" "EMG" "EMG-fil" 
      "eeg" "buf3" "disp000" "wingra" "winmag" "wineeg"
      "dispgra" "dispmag" "dispeeg" "MTX" "scandisp" "mxwin" "mxvcp"))
      (when (G-widget w :quiet)(GtDeleteWidget (G-widget w)))) 
))

(defun get-max-matrix(mtx);;not used. get-max-matrix2 in hns_meg6 is faster!
 "return max element
  (get-max-matrix #m((1 -2 3)(-4 5 -6)))>(6.0 1 2)"
  (let ((xx)(func1)(num)(rw))
    (setq xx 0 num 0 maxnum 0)
    (setq rw (array-dimension mtx 0))
    (defun func1(x)
      (if (> (abs x) xx)
        (setq xx (abs x) maxnum num)
        (setq xx xx maxnum maxnum))
      (setq num (1+ num)) )
    (map-matrix mtx 'func1)
    (list xx (mod maxnum rw)(div maxnum rw))
))

(defun get-max-matrix0(mtx) ;not used
 "return max element
  (get-max-matrix #m((1 -2 3)(-4 5 -6))>6.0"
  (let ((xx)(func1))
    (setq xx 0)
    (defun func1(x)
      (if (> (abs x) xx)
        (setq xx (abs x))
        (setq xx xx) ));this code is indispensable!!
    (nmap-matrix mtx 'func1)
    xx
))

(defun initializeWidgets()
  (let ((w)(names)(n)(names))
    (deleteWidgets)

    ;;MEG
    (require-widget :ringbuffer "buf" '("size" 5000000))
    (require-widget :pick "MEG" '("names" ("MEG*")))
    (require-widget :fft-filter "MEG-fil" '("pass-band" (band-pass 3 35)))
    (unless (G-widget "ssp" :quiet)(require 'ssp))
    (require-widget :ringbuffer "buf2" '(size 5000000))
    (setq w (require-widget :pick "gra"))
    (set-resource w :names '("MEG*2" "MEG*3"))
    ;(set-resource w :names (append ;;this code does not work!
    ;  gra-L-temporal  gra-R-temporal  gra-L-parietal gra-R-parietal
    ;  gra-L-occipital gra-R-occipital gra-L-frontal  gra-L-frontal))
    (setq w (require-widget :pick "mag"))
    (set-resource w :names '("MEG*1"))
    ;(set-resource w :names (append ;;this code does not work!
    ; mag-L-temporal  mag-R-temporal  mag-L-parietal mag-R-parietal
    ;  mag-L-occipital mag-R-occipital mag-L-frontal  mag-L-frontal)) 
    (set-resource w :names (eval names))
    (require-widget :pick "meg");; selected coils for xfit
    (linklink "file" "buf" "MEG" "MEG-fil" "ssp" "buf2" "gra")
    (linklink "buf2" "mag")
    (linklink "buf2" "meg")

    ;;EEG
    (dolist (n (list "EEG" "ECG" "EOG" "EMG"))
      (setq w (require-widget :pick n))
      (setq names (format nil "~a*" n))
      (set-resource w :names (list names))
      (setq w (require-widget :fft-filter (format nil "~a-fil" n)))
      (set-resource w :pass-band '(band-pass 0.5 50)) )
    (require-widget :pick "eeg"); sel*-eeg ;ignore ECG EOG EMG
    (set-resource (G-widget "eeg") :names '("*") :ignore '("ECG*" "EOG*" "EMG*"))
    (require-widget :ringbuffer "buf3" '(size 5000000))
    (require-widget :plotter "disp000");for EEG,ECG,EOG,EMG
    (set-resource (G-widget "disp000") :ch-label-space 80)
    (linklink "buf" "EEG" "EEG-fil")
    (linklink "buf" "ECG" "ECG-fil")
    (linklink "buf" "EOG" "EOG-fil")
    (linklink "buf" "EMG" "EMG-fil")
    (linklink "EEG-fil" "eeg" "buf3" "disp000")
    
    ;; selected GRA,MAG,EEG
    (require-widget :data-window "wingra")
    (require-widget :data-window "winmag")
    (require-widget :data-window "wineeg")
    (require-widget :plotter "dispgra")
    (require-widget :plotter "dispmag")
    (require-widget :plotter "dispeeg")
    (linklink "gra" "wingra" "dispgra")
    (linklink "mag" "winmag" "dispmag")
    (linklink "EEG-fil" "wineeg" "dispeeg")

    ;; MTX
    (require-widget :matrix-source "MTX")
    (require-widget :plotter "scandisp")
    (linklink "MTX" "scandisp")

    ;; vecop
    (require-widget :data-window "mxwin")
    (require-widget :vecop "mxvcp" '("mode" "abs-max"))
    (linklink "mxwin" "mxvcp") 
))

(defun linklink(&rest wlist)
  (let ((n))
    (dotimes (n (1- (length wlist)))
      (link (G-widget (nth n wlist))(G-widget (nth (1+ n) wlist))))
))

(defun make-random-matrix0(row column);; does not work property!
  (let ((R)(func1))
    (defun func1()(/ (rand)(pow 2 31)))
    (make-matrix (make-matrix row column 'func1))
))

(defun make-random-matrix(row column)
  (/ (random-matrix row column) (pow 2 31)))

(defun online()
  (let ((filename)(dirname "/neuro/dacq/raw/*aw*")(check nil))
    (setq filename (resource (G-widget "file") :filename))
    (setq dirname "/neuro/dacq/raw/*raw*")
    (if (not filename)(progn
      (setq filename (ask-filename "Select raw* file to load" :template dirname))
      (if filename (open-diskfile filename)))
      (if (not (string-equal (filename-extension filename) "fif"))
        (open-diskfile filename)))
))

(defun screen-capture(&optional (disp *main-window*))
  (let ((id)(str)(get-datetime))
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
        (return str) ))
     (system "xset b off");; bell off
     (if (G-widget-p disp)(progn
        (GtPopupEditor disp)
        (setq disp (resource disp :display-widget))))
     (setq str (get-datetime))
     (setq str (str-append (filename-directory 
       (resource (G-widget "file") :filename)) str))
     (setq id (window-id (XtWindow disp)))
     (system (format nil "xwd -id ~a >~a.xwd" id str))
     (system (format nil "convert ~a.xwd ~a.png" str str))
     (system (format nil "rm ~a.xwd" str))
     (system "xset b on");;bell on
))

(defun search-low-baseline()
  (let (())


))

(defun setup-EEG(eeg1);eeg1-triuxneo eeg1-vectorview etc..
  (let ((n)(ch)(channels)(w)(nch)(kind)(name))
    (setq w (G-widget "EEG"))
    (setq channels (resource w :channels))
    (setq nch (length eeg1))
    (dotimes (n (resource w :channels))
      (if (< n nch)(setq ch (nth n eeg1))
        (setq ch (get-property w n :name)))
      (set-property w n :name ch))
    (dolist (ch (list "ECG" "EOG" "EMG"))
      (cond 
        ((string-equal ch "ECG")(setq kind 402))
        ((string-equal ch "EOG")(setq kind 202))
        ((string-equal ch "EMG")(setq kind 302))
      )
      (setq nch (resource (G-widget ch) :channels))
      (if (> nch 0)(dotimes (n nch)
        (set-property (G-widget ch) n :kind kind)
        (setq name (format nil "~a~d" ch (1+ n)))
        (set-property (G-widget ch) n :name name)))
      (if (= nch 1)(set-property (G-widget ch) 0 :name ch)))
    (link (G-widget "EEG-fil")(G-widget "eeg"))
))
