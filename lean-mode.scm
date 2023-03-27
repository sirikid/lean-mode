(use-modules
 (gnu packages emacs-xyz)
 (guix build-system emacs)
 (guix git-download)
 (guix licenses)
 (guix))

(define %source-dir
  (dirname (current-filename)))

(package
  (name "lean-mode")
  (version "0.1.0")
  (source
   (local-file %source-dir
               #:recursive? #t
               #:select? (git-predicate %source-dir)))
  (build-system emacs-build-system)
  (inputs
   (list emacs-company
         emacs-dash
         emacs-f
         emacs-flycheck
         emacs-helm))
  (synopsis "Emacs mode for Lean 3")
  (description #f)
  (license expat)
  (home-page "https://github.com/leanprover/lean-mode"))
