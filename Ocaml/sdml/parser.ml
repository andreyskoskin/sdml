
exception Invalid_sdml of string

let syntax = ":=(){}[]<>\r\n \t"

let 

let parse s =
	let rec
		field pos = (pos, ())
			|> spaces
			|> label
			|> spaces
			|> tag_opt
			|> spaces
			|> value
			|> must endline
	and
		spaces = many space
	and
		label ctx = ctx
			|> must label_char
			|> many label_char
			|> str_from pos
	and
		tag_opt (pos, lbl) = (pos, lbl)
			|> colon
			|> fun (new_pos, _) ->
				if new_pos = pos then
					(pos, (lbl, ""))
				else
					let (final_pos, tag) = (new_pos, ())
						|> spaces
						|> label
					in (final_pos, (lbl, tag))
	and
		value (pos, lt) = (pos, lt)
			|> spaces
			|> must value_kind
			|> fun (val_pos, (lbl, tag, kind)) -> kind (val_pos, (lbl, tag))
	and
		value_kind (pos, (lbl, tag)) =
			let kind = 
				(match String.get s pos with
				| '=' -> atom
				| '(' -> list
				| '{' -> record
				| '[' -> array
				| '<' -> table
				| _   -> raise (Invalid_syntax "invalid value kind")
				) in (pos+1, (lbl, tag, kind))
	and
		atom (pos, (lbl, tag)) = (pos, ())
			|> spaces
			|> line
			|> fun (new_pos, content) -> (new_pos, (lbl, tag, Ast.Atom (String.trim content)))
	and
		list (pos, (lbl, tag)) = (pos, [])
			|> spaces
			|> must endline
			|> lines ')'
			|> fun (new_pos, lines) -> (new_pos, (lbl, tag, Ast.List lines))
	and
		record (pos, (lbl, tag)) = (pos, [])
			|> spaces
			|> must endline
			|> fields '}'
			|> fun (new_pos, fields) -> (new_pos, (lbl, tag, Ast.Record fields))
	and
		array (pos, (lbl, tag)) = (pos, [])
			|> spaces
			|> must endline
			|> tagged_values ']'
			|> fun (new_pos, items) -> (new_pos, (lbl, tag, Ast.Array items))
	and
		table (pos, (lbl, tag)) = (pos, [])
			|> spaces
			|> must endline
			|> records '-' '>'
			|> fun (new_pos, records) -> (new_pos, (lbl, tag, Ast.Table records))
	and
		line (pos, ctx) = (pos, ctx)
			|> many line_char
			|> str_from pos
	and
		endline = many endline_char
	and
		lines endchar (pos, ls) =
			
	and
		label_char (pos, ctx) =
			if String.contains syntax (String.get s pos)
				then (pos, ctx)
				else (pos+1, ctx)
	and
		line_char (pos, ctx) =
			match String.get s pos with
			| '\n' -> (pos, ctx)
			| '\r' -> (pos, ctx)
			| _    -> (pos+1, ctx)
	and
		endline_char (pos, ctx) =
			match String.get s pos with
			| '\n' -> (pos+1, ctx)
			| '\r' -> (pos+1, ctx)
			| _    -> (pos, ctx)
	and
		many parse (pos, ctx) =
			if pos = String.length s then
				(pos, ctx)
			else
				let (new_pos, new_ctx) = parse (pos, ctx) in
				if new_pos = pos
					then (pos+1, new_ctx)
					else many parse (new_pos, new_ctx)
	and
		must parse (pos, ctx) =
			if pos = String.length s then
				raise (Invalid_syntax "unexpected EOF")
			else
				let (new_pos, new_ctx) = parse (pos, ctx) in
				if new_pos = pos
					then raise (Invalid_syntax "invalid syntax")
					else (new_pos, new_ctx)
	and
		space (pos, ctx) =
			match String.get s pos with
			| ' '  -> (pos+1, ctx)
			| '\t' -> (pos+1, ctx)
			| _    -> (pos, ctx)
	and
		str_from start_pos (end_pos, ()) =
			(end_pos, String.sub s start_pos (end_pos - start_pos))

