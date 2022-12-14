(global-set-key "\C-cdvfs" 'do-convert-fanotify-quick-start)

(global-set-key "\C-cdvoP" 'do-convert-open-results)
(global-set-key "\C-cdvoM" 'do-convert-open-metadata)
(global-set-key "\C-cdvoK" 'do-convert-open-kb)
(global-set-key "\C-cdpp" 'do-todo-list-convert-to-prolog-and-view)
(global-set-key "\C-cdpvp" 'do-todo-list-view-prolog)
(global-set-key "\C-cdpvm" 'do-todo-list-view-metadata)
(global-set-key "\C-cdpvk" 'do-todo-list-view-kb)
(global-set-key "\C-cdpu" 'do-todo-list-update-metadata-for-file)

(defvar do-convert-assert nil)

(defun do-convert-after-save-hook (&optional override)
 ""
 (interactive)
 (setq do-convert-assert nil)
 (if (derived-mode-p 'do-todo-list-mode)
  (let* ((buffer-name (buffer-file-name))
	 (chased-file (kmax-chase buffer-name)))
   (if (or
	(kmax-string-match-p "\.do$" chased-file)
	(kmax-string-match-p "\.notes$" chased-file))
    (if do-convert-check-parses
     (if
      (or
       (non-nil override)
       (do-convert-approve-release buffer-name chased-file))
      (progn
       (do-convert-logic-async-parsecheck-and-convert-to-prolog-and-git-commit chased-file)
       (setq do-convert-assert t)
       ))))))
 do-convert-assert)

(add-hook 'after-save-hook 'do-convert-after-save-hook)
;; (remove-hook 'after-save-hook 'do-convert-after-save-hook)

(defun do-convert-logic-async-parsecheck-and-convert-to-prolog-and-git-commit (chased-file)
 ""
 (interactive)
 (see
  (read
   (freekbs2-get-result
    (uea-query-agent-raw "" "Do-Convert-Logic"
     (freekbs2-util-data-dumper
      (list
       (cons "_DoNotLog" 1)
       (cons "Command" "ProcessChasedFile")
       (cons "ChasedFile" chased-file))))))))

;; (defun do-convert-open-prolog-encoded-todo-file-for-this-todo-file ()
;;  ""
;;  (interactive)
;;  ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun do-convert-parsecheck-and-convert-to-prolog (chased-file)
 (shell-command-to-string
  (concat
   ;; /var/lib/myfrdcsa/codebases/minor/do-convert/scripts/do-convert-parsecheck-and-convert-to-prolog.pl
   "cd /var/lib/myfrdcsa/codebases/minor/do-convert/scripts && ./do-convert-parsecheck-and-convert-to-prolog.pl -f "
   (shell-quote-argument chased-file))))

(defun do-convert-fanotify-quick-start ()
 ""
 (interactive)
 (if (kmax-buffer-exists-p do-convert-fanotify-buffer-name)
  (switch-to-buffer do-convert-fanotify-buffer-name)
  (run-in-shell
   "cd /var/lib/myfrdcsa/codebases/minor/do-convert/scripts && sudo ./fanotify-system-wide.pl"
   do-convert-fanotify-buffer-name
   'shell-mode)
  (sit-for 10)
  (run-in-shell
   "cd /var/lib/myfrdcsa/codebases/minor/do-convert/scripts && ./do-convert-sentinel.pl"
   do-convert-fanotify-sentinel-buffer-name
   'shell-mode)
  ;; (do-convert-start)
  )
 )

(defun do-convert-open-results ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/results"))

(defun do-convert-open-metadata ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/metadata"))

(defun do-convert-open-k ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/kb"))

(defun do-todo-list-view-prolog (&optional arg)
 ""
 (interactive "P")
 (do-todo-list-view-file-type "prolog" arg))

(defun do-todo-list-view-metadata (&optional arg)
 ""
 (interactive "P")
 (do-todo-list-view-file-type "metadata" arg))

(defun do-todo-list-view-kb (&optional arg)
 ""
 (interactive "P")
 (do-todo-list-view-file-type "kb" arg))

(defun do-todo-list-view-file-type (file-type &optional arg)
 ""
 (interactive "P")
 (assert (do-todo-list-view-file-type-helper arg) t "Getting Prolog source failed for some reason.")
 (let* ((buffer-name (buffer-file-name))
	(chased-file (kmax-chase buffer-name))
	(prolog-file (replace-regexp-in-string "[^a-zA-Z0-9_]" "_" chased-file))
	(file (concat "/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/" file-type "/" prolog-file ".pl"))
	)
  (assert (kmax-file-exists-p file))
  (ffap file)))

(defun do-todo-list-view-file-type-helper (&optional override)
 ""
 (interactive)
 (if (derived-mode-p 'do-todo-list-mode)
  (let* ((buffer-name (buffer-file-name))
	 (chased-file (kmax-chase buffer-name)))
   (if (or
	(kmax-string-match-p "\.do$" chased-file)
	(kmax-string-match-p "\.notes$" chased-file))
    t))))

(defun do-todo-list-convert-to-prolog-and-view (&optional arg)
 ""
 (interactive "P")
 (assert (do-convert-after-save-hook arg) t "Conversion failed for some reason.")
 (let* ((buffer-name (buffer-file-name))
	(chased-file (kmax-chase buffer-name))
	(prolog-file (replace-regexp-in-string "[^a-zA-Z0-9_]" "_" chased-file))
	(file (concat "/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/results/" prolog-file ".pl"))
	)
  (ffap file)))

(defun do-todo-list-update-metadata-for-file (&optional arg)
 ""
 (interactive "P")
 (assert (do-convert-after-save-hook arg) t "Conversion failed for some reason.")
 (let* ((buffer-name (buffer-file-name))
	(chased-file (kmax-chase buffer-name))
	(prolog-file (replace-regexp-in-string "[^a-zA-Z0-9_]" "_" chased-file))
	(file (concat "/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/metadata/" prolog-file ".pl"))
	(command (concat "/var/lib/myfrdcsa/codebases/minor/do-convert-logic/scripts/update-metadata.sh " (shell-quote-argument chased-file))))
  (see command)
  (see (shell-command-to-string command))
  (ffap file)))

(defun do-convert-logic-save-entry-id-pair (entry id)
 ""
 (save-excursion
  (do-todo-list-view-metadata)
  (goto-char (point-max))
  (insert (do-todo-list-importexport-convert (list "entryHasIdFn" entry id) "Interlingua" "Prolog"))))

(provide 'do-convert-logic)

