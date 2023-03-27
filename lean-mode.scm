(use-modules
 (guix)
 (guix git-download)
 (guix build-system emacs)
 (gnu packages emacs-xyz))

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
         emacs-helm
         emacs-s))
  (synopsis #f)
  (description #f)
  (license #f)
  (home-page "https://github.com/leanprover/lean-mode"))
