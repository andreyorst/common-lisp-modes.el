;;; common-lisp-modes.el --- Minor mode for sharing hooks that are common between lisps -*- lexical-binding: t -*-
;;
;; Author: Andrey Listopadov
;; Homepage: https://gitlab.com/andreyorst/common-lisp-modes.el
;; Package-Requires: ((emacs "26.1"))
;; Keywords: tools
;; Prefix: common-lisp-modes-mode
;; Version: 0.0.1
;;
;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with common-lisp-modes.el.  If not, see
;; <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; `common-lisp-modes-mode' (clmm) is a minor mode that can be used to
;; enable functionality that is common across many lisps via a common
;; hook.  The idea is to set all common features via the
;; `common-lisp-modes-mode-hook' and then enable
;; `common-lisp-modes-mode' in a major mode hook for a given lisp
;; mode.  For REPL specific features that may not be wanted in source
;; code editing buffers this package also provides a
;; `common-repl-modes-mode'.
;;
;;; Rationale:
;;
;; Unfortunately, the `lisp-mode' is made specificaly for editing
;; Common Lisp code, so all other lisp modes mostly inherit from
;; `prog-mode'.  This makes it harder to enable common features,
;; because `prog-mode-hook' is too broad for enabling something like
;; `paredit', and other lisp-related packages.  There are also various
;; REPL-related modes that mostly inherit from comint, but comint is
;; used for non-lisp stuff as well, which makes the `comint-mode-hook'
;; not feasible as well.
;;
;; For example, one can set paredit and isayt to the
;; `common-lisp-modes-mode-hook', and then turn
;; `common-lisp-modes-mode' in a major mode hook for a given lisp:
;;
;; (add-hook 'common-lisp-modes-mode-hook 'paredit-mode)
;; (add-hook 'common-lisp-modes-mode-hook 'isayt-mode)
;;
;; Now these modes can be enabled by simply enabling clmm:
;;
;; (dolist (hook '(common-lisp-mode-hook
;;                 clojure-mode-hook
;;                 cider-repl-mode
;;                 racket-mode-hook
;;                 eshell-mode-hook
;;                 eval-expression-minibuffer-setup-hook))
;;   (add-hook hook 'common-lisp-modes-mode))
;;
;;; Code:

;;;###autoload
(define-minor-mode common-lisp-modes-mode
  "Mode for enabling all modes that are common for lisps.

For the reference, this is not a common-lisp modes mode, but a
common lisp-modes mode.

\\<common-lisp-modes-mode-map>"
  :lighter " clmm"
  :keymap (make-sparse-keymap))

;;;###autoload
(define-minor-mode common-repl-modes-mode
  "Mode for enabling all modes that are common for REPLs.

\\<common-repl-modes-mode-map>"
    :lighter " crmm"
    :keymap (make-sparse-keymap))

;;;###autoload
(defun common-lisp-modes-indent-or-fill-sexp ()
  "Indent s-expression or fill string/comment."
  (interactive)
  (let ((ppss (syntax-ppss)))
    (if (or (nth 3 ppss)
            (nth 4 ppss))
        (fill-paragraph)
      (save-excursion
        (mark-sexp)
        (indent-region (point) (mark))))))

(provide 'common-lisp-modes)
