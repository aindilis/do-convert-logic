(global-set-key "\C-cdvfs" 'do-convert-fanotify-quick-start)

(global-set-key "\C-cdvoP" 'do-convert-open-results)
(global-set-key "\C-cdvoM" 'do-convert-open-metadata)


(defun do-convert-after-save-hook ()
 ""
 (interactive)
 (if (derived-mode-p 'do-todo-list-mode)
  (let* ((buffer-name (buffer-file-name))
	 (chased-file (kmax-chase buffer-name)))
   (if (or
	(kmax-string-match-p "\.do$" chased-file)
	(kmax-string-match-p "\.notes$" chased-file))
    (if do-convert-check-parses
     (if (do-convert-approve-release buffer-name chased-file)
      (do-convert-logic-async-parsecheck-and-convert-to-prolog-and-git-commit chased-file)))))))
 
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

(provide 'do-convert-logic)
