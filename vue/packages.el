;;; packages.el --- vue layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Goh Wei Wen <goweiwen@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `vue-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `vue/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `vue/pre-init-PACKAGE' and/or
;;   `vue/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst vue-packages
  '(vue-mode
    (prettier-js
     :location (recipe
                :fetcher github
                :repo "prettier/prettier-emacs"
                :branch "prettier-js-prettify-region"))))

(defun vue/init-vue-mode ()
  (add-hook 'before-save-hook 'prettier-vue))

(defun vue/post-init-prettier-js ()
  (use-package prettier-js
    :defer t
    :init
    (progn
      (add-hook 'vue-mode-hook
                (lambda ()
                  (prettier-js-mode)
                  (add-hook 'before-save-hook 'prettier-vue)))
      (setq prettier-js-args '("--trailing-comma" "es5"
                               "--no-semi"
                               "--single-quote")))))

;; https://github.com/prettier/prettier-emacs/issues/3
;; by giodamelio
(defun prettier-vue ()
  (interactive)
  (let ((original (point)))
    (goto-char 0)
    (let* ((script-start (re-search-forward "<script>" nil t))
           (start (+ script-start 1))
           (script-end (re-search-forward "</script>" nil t))
           (end (- script-end 9)))
      (prettier-js--prettify start end)
      (goto-char original)
      (vue-mode-reparse))))

;;; packages.el ends here
