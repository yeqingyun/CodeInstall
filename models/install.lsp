(if (not (= (length (main-args)) 3))
	(throw-error "use: cf install PACKAGE"))

(set 'package (main-args 2))
(set 'packdir (append cfhome "/package/" package))
(set 'packpath (append cfhome "/package/" package ".zip"))
(set 'remotepath (append remote "/package/" package ".zip"))
(set 'currdir (real-path))

(when (not (directory? packdir))
  (when (not (file? packpath))
	(set 'f (get-url remotepath))
	(if (not (starts-with f "ERR"))
		(write-file packpath f)))
  (if (not (file? packpath))
	  (throw-error (append "package [" package "] not exists.")))
  (! (append "7z x -o" cfhome "/package " packpath)))

(if (not (directory? packdir))
	(throw-error (append "package [" package "] not exists.")))

(change-dir packdir)
(set 'datadir (append cfhome "/data/"))
(set 'bindir (append cfhome "/bin/"))

(load (append cfhome "/package/" package "/install.lsp"))

(println "install successfully.")
;;(println remotepath)
