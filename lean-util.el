;; Copyright (c) 2014 Microsoft Corporation. All rights reserved.
;; Released under Apache 2.0 license as described in the file LICENSE.
;;
;; Author: Soonho Kong
;;

(require 'cl-lib)

(defun lean-line-offset (&optional pos)
  "Return the byte-offset of `pos` or current position, counting from the
  beginning of the line"
  (interactive)
  (let* ((pos (or pos (point)))
         (bol-pos
          (save-excursion
            (goto-char pos)
            (beginning-of-line)
            (point))))
    (- pos bol-pos)))

(defun lean-pos-at-line-col (l c)
  "Return the point of the given line and column."
  ;; http://emacs.stackexchange.com/a/8083
  (save-excursion
    (goto-char (point-min))
    (forward-line (- l 1))
    (move-to-column c)
    (point)))

(defun lean-whitespace-cleanup ()
    (when lean-delete-trailing-whitespace
      (delete-trailing-whitespace)))

(defun lean-in-comment-p ()
  "t if a current point is inside of comment block
   nil otherwise"
  (nth 4 (syntax-ppss)))

;; The following function is a slightly modified version of
;; f--collect-entries written by Johan Andersson
;; The URL is at https://github.com/rejeep/f.el/blob/master/f.el#L416-L435
(defun lean--collect-entries (path recursive)
  (let (result
        (entries
         (seq-remove
          (lambda (file)
            (or (file-equal-p file ".")
                (file-equal-p file "..")))
          (directory-files path t))))
    ;; The following line is the only modification that I made
    ;; It waits 0.0001 second for an event. This wait allows
    ;; wait-timeout function to check the timer and kill the execution
    ;; of this function.
    (sit-for 0.0001)
    (cond (recursive
           (mapc
            (lambda (entry)
              (if (file-regular-p entry)
                  (setq result (cons entry result))
                (when (file-directory-p entry)
                  (setq result (cons entry result))
                  (setq result (append result (lean--collect-entries entry recursive))))))
            entries))
          (t (setq result entries)))
    result))

;; The following function is a slightly modified version of
;; f-files function written by Johan Andersson The URL is at
;; https://github.com/rejeep/f.el/blob/master/f.el#L478-L481
(defun lean-find-files (path &optional fn recursive)
  "Find all files in PATH."
  ;; It calls lean--collect-entries instead of f--collect-entries
  (let ((files (seq-filter #'file-regular-p (lean--collect-entries path recursive))))
    (if fn (seq-filter fn files) files)))

(provide 'lean-util)
