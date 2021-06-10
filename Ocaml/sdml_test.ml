open Sdml

let print_t title t = print_endline title ; t
	|> Printer.print
	|> print_endline ;
	print_endline ""

let _ =
	let atom = Ast.Atom "Hello, World!" in
	let list = Ast.List ["foo"; "bar"] in
	let flds = ["atom","",atom; "list","of-atoms",list] in
	let rec0 = Ast.Record flds in
	let arr0 = Ast.Array ["foo",flds; "bar",flds] in
	let tbl0 = Ast.Table [flds; flds; flds] in
	let tbl1 = (let flds = ["list","of-atoms",list; "atom","",atom] in Ast.Table [flds; flds; flds]) in
	let cplx = Ast.Record [
		"lst0","list",list ;
		"rec0","",rec0 ;
		"arr0","",arr0 ;
		"tbl0","",tbl0 ;
		"argh","Valhalla!", Ast.Array [
			"point",["x","", Ast.Atom "1"; "y","", Ast.Atom "2"; "z","" ,Ast.Atom "3"] ;
			"trash",["tableu","",tbl1; "matrix","", Ast.List ["12 34";"56 78"] ]
		]
	]
	in
	atom |> print_t "---- atom ------\n" ;
	list |> print_t "---- list ------\n" ;
	rec0 |> print_t "---- rec0 ------\n" ;
	arr0 |> print_t "---- arr0 ------\n" ;
	tbl0 |> print_t "---- tbl0 ------\n" ;
	cplx |> print_t "---- cplx ------\n" ;
	print_endline   "================\n"

