type
	value =
	| Atom of string
	| List of string list
	| Record of record
	| Array of (tag * record) list
	| Table of record list
and
	tag = string
and
	field = string * tag * value
and
	record = field list
