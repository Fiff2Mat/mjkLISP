(GtDeleteWidget (G-widget "display"))

(defun subplot(form dispname left right top bottom no-controls)
  "Usage (subplot-parent-form subplot-name left right top bottom)
    creates subplot plotter."
  (let ((disp nil)(dispw nil))
    (setq disp  (GtMakeObject 'plotter 
                :name dispname
                :display-parent form 
                :scroll-parent form
                :no-controls no-controls))
    (GtPopupEditor disp)
    (setq dispw (resource disp :display-widget))
    (set-values dispw
      "resizable"        0
      "leftAttachment"   5
      "leftPosition"     left      
      "leftOffsett"      0
      "rightAttachment"  5
      "rightPosition"    right
      "topAttachment"    5
      "topPosition"      top      
      "bottomAttachment" 5
      "bottomPosition"   bottom))
);;This function must exist ahead of func CreateTwoWindows

(defun CreateScroll(dispname)
  (set-values (resource (G-widget dispname) :scroll-widget)
    "resizable" 0 
    "leftAttachment" 5
    "leftPosition" 0
    "rightAttachment" 5
    "rightPosition" 100
    "topAttachment" 5
    "topPosition" 95
    "bottomAttachment" 5
    "bottomPosition" 100)    
  (set-resource (G-widget dispname) :scroll-visible 1) 
)

(defun CreateTwoWindows()
  (manage *control-panel*)
  (setq newform (make-form *main-window* "newform"))
  (set-values *main-window* "workwindow" newform)
  (subplot newform "disp1" 0 45 0 95 t)
  (subplot newform "disp2" 45 100 0 95 nil)
)



(defun list-contain(x xlist)
  (let ((result nil))
    (dotimes (i (length xlist) result)
      (if (equal x (nth i xlist))
        (return t)
))))

(defun set_meg_scale()
   (setq nch (resource (G-widget "meg") :channels))
  


)

(defun set_scale()
  (define-parameter-group 'my-scale "miscellaneous scales")
  (defuserparameters my-scale
    (gra-scale 5e-13 "gradiometer scale [T/m]" 'number)
    (mag-scale 3e-10 "manetometer scale [T]" 'number)
    (stim-scale 1e-6 "stim scale [V]" 'number)
    (eeg-scale 1e-6 "EEG scale [V]" 'number)
    (my-comment "nothing" "default" 'string) 
  )
)

(defun settings()
  (require-widgets '(
    (ringbuffer "buf" ("size" 5000000))
    (fft-filter "band-pass1" ("pass-band" (band-pass 3 35)))
    (fft-filter "band-pass2" ("pass-band" (band-pass 3 35)))
    (pick "meg0")(pick "meg")(pick "gra")(pick "eeg")
  ))
  (require 'ssp)
  ;;(require 'std-selections)
  (set-resource (G-widget "gra") :names '("MEG*") :ignore '("MEG*1"))
  (set-resource (G-widget "meg") :names '("MEG*"))
  (set-resource (G-widget "meg0") :names '("MEG*"))
  (set-resource (G-widget "eeg") :names '("EEG*"))
  (set-resource (G-widget "disp1") :point 0.0 :length 10.0 :move-hook '(sync-view-2 *this* "disp2") :select-hook '(sync-selection *this* "disp2"))
  (set-resource (G-widget "disp2") :point 0.0 :length 10.0 :move-hook '(sync-view-2 *this* "disp1") :select-hook '(sync-selection *this* "disp1"))
  (link (G-widget "file")(G-widget "buf"))
  (link (G-widget "buf")(G-widget "meg0"))
  (link (G-widget "buf")(G-widget "eeg"))
  (link (G-widget "meg0")(G-widget "ssp"))
  (link (G-widget "ssp")(G-widget "band-pass1"))
  (link (G-widget "band-pass1")(G-widget "meg"))
  (link (G-widget "band-pass1")(G-widget "gra"))
  (link (G-widget "gra")(G-widget "disp1"))
  (link (G-widget "eeg")(G-widget "band-pass2"))
  (link (G-widget "band-pass2")(G-widget "disp2"))
  (GtOrganizePanel)
)

(defun TwoWin()
  (XtDestroyWidget my-menu)
  (CreateTwoWindows)
  (CreateScroll "disp1")
  (manage newform)
  (settings)
  (set_scale)
)

(progn
  (setq my-menu (add-button *user-menu* "execute" '(TwoWin)))
)
