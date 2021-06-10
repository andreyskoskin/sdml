open Ast

let rec
	print v =
		match v with
		| Atom   a  -> "=" ^ a
		| List   ss -> "(\n" ^ String.concat "\n" ss ^ "\n)"
		| Record fs -> "{\n" ^ print_fields fs ^ "}"
		| Array  xs -> "[\n" ^ String.concat "" (List.map print_array_item xs) ^ "]"
		| Table  rs -> "<\n" ^ String.concat "-\n" (List.map print_fields rs) ^ ">"
and
	print_field (name, tag, v) =
		name ^ (if tag = "" then "" else ":" ^ tag) ^ print v ^ "\n"
and
	print_fields fs = String.concat "" (List.map print_field fs)
and
	print_array_item (tag, fs) = tag ^ "{\n" ^ print_fields fs ^ "}\n"



let need_blank_line v =
	match v with
	| Atom _ -> false
	| _      -> true

let print_pretty indent v =
	let rec
		pp ind v =
			match v with
			| Atom   a  -> "= " ^ a
			| List   ss -> "(\n" ^ pp_list   (ind ^ indent) ss ^ ind ^ ")"
			| Record fs -> "{\n" ^ pp_fields (ind ^ indent) fs ^ ind ^ "}"
			| Array  xs -> "[\n" ^ pp_array  (ind ^ indent) xs ^ ind ^ "]"
			| Table  rs -> "<\n" ^ pp_table ind rs ^ ind ^ ">"
	and
		pp_list ind ss =
			ind ^ String.concat ("\n" ^ ind) ss ^ "\n"
	and
		pp_field ind (name, tag, v) =
			(if need_blank_line v then "\n" else "") ^
			ind ^ name ^ (if tag = "" then "" else " : " ^ tag) ^ " " ^ pp ind v ^ "\n"
	and
		pp_fields ind fs = fs
			|> List.map (pp_field ind)
			|> String.concat ""
	and
		pp_array ind xs = xs
			|> List.map (pp_array_item ind)
			|> String.concat ""
	and
		pp_array_item ind (tag, fs) =
			"\n" ^ ind ^ tag ^ " {\n" ^ pp_fields (ind ^ indent) fs ^ ind ^ "}\n"
	and
		pp_table ind rs = rs
			|> List.map (pp_fields (ind ^ indent))
			|> String.concat (ind ^ "-\n")
	in
		pp "" v
