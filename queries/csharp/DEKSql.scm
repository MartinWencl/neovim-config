;; DEKSQL
;; Query for selecting the sql string literal from:
;; 	-> Using statement with type DEKQuery
;;	-> Assignment expression where:
;;		-> left: name = CommandText
;;		-> right: string literal
(using_statement
    (variable_declaration
     type: (identifier) @_name (#eq? @_name "DEKQuery")
    )
    (block (expression_statement ( assignment_expression 
	 left: (member_access_expression name: (identifier) @_text (#eq? @_text "CommandText"))
	 right: (verbatim_string_literal) @sql_str)
    ))
)
