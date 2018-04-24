(set 'model (main-args 2))

(if (not model)
	(throw-error "use: cf remove MODEL"))

(set 'localpath (append cfhome "/models/" model ".lsp"))

(delete-file localpath)

(println "remove [" model "] sucessfully!")
