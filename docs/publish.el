;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(require 'org-publish)
(setq org-publish-project-alist
      '(
	("org-notes"
	 :base-directory "~/ece2524/docs"
	 :base-extension "org"
	 :publishing-directory "~/ece2524/output"
	 :recursive t
	 :publishing-function org-publish-org-to-html
	 :headline-levels 4
	 :auto-preamble t
	 )
	
	("org-static"
	 :base-directory "~/ece2524/docs/assets"
	 :base-extension "css\\|png\\|jpg"
	 :publishing-directory "~/ece2524/output/static"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )
	("org" :components ("org-notes" "org-static"))
	))
