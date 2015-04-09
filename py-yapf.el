;;; py-yapf.el --- Use yapf to beautify a Python buffer

;; Copyright (C) 2015, Friedrich Paetzke <paetzke@fastmail.fm>

;; Author: Friedrich Paetzke <paetzke@fastmail.fm>
;; URL: https://github.com/paetzke/py-yapf.el
;; Version: 0.1

;;; Commentary:

;; Provides commands, which use the external "yapf"
;; tool to tidy up the current buffer according to Python's PEP8.

;; To automatically apply when saving a python file, use the
;; following code:

;;   (add-hook 'before-save-hook 'py-yapf-before-save)

;;; Code:


(require 'buftra)


(defgroup py-yapf nil
  "Use yapf to beautify a Python buffer."
  :group 'convenience
  :prefix "py-yapf-")


(defcustom py-yapf-options nil
  "Options used for yapf.

Note that `--in-place' is used by default."
  :group 'py-yapf
  :type '(repeat (string :tag "option")))


(defun py-yapf--call-executable (errbuf file)
  (zerop (apply 'call-process "yapf" nil errbuf nil
                (append py-yapf-options `("--in-place", file)))))


(defun py-yapf ()
  (buftra--apply-executable-to-buffer "yapf" 'py-yapf--call-executable))


;;;###autoload
(defun py-yapf-buffer ()
  "Uses the \"yapf\" tool to reformat the current buffer."
  (interactive)
  (py-yapf))


;;;###autoload
(defun py-yapf-before-save ()
  "Pre-save hooked to bse used before running py-yapf."
  (interactive)
  (when (eq major-mode 'python-mode)
    (condition-case err (py-yapf-buffer)
      (error (message "%s" (error-message-string err))))))


(provide 'py-yapf)


;;; py-yapf.el ends here
