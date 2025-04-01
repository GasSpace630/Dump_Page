extends SyntaxHighlighter

func _get_line_syntax_highlighting(line_text):
	var syntax = []
	
	var bold_regex = RegEx.new()
	bold_regex.compile(r"\*\*(,*?)\*\*")
	
	for i in bold_regex.search_all(line_text):
		syntax.append({
			"start" : i.get_start(0),
			"end" : i.get_end(0),
			"color" : Color(1,1,1),
			"bold" : true
		})
	
	return syntax
