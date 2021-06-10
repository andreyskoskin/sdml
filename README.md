# sdml
Structured (or Softly typed) data marjup language

Basic structure:

binding ::= <name> [":" <tag>] <value>

<name> is alphanumeric, basicly any character except :={[< and newline

<tag> is the same as <name>

<value> is:

"=" - an "atom", a sequence of characters until endline
"(" - a "list", a sequence of atoms, ending with single-line ")"
"{" - a "record" - a list of <binding> separated by newline and endin by "}"
"[" - an "array" - a list of (<tag> <value>)
"<" - a "table" - a list of "record"s, separated by single-line "-", ending by ">"

The document can be eiather a record or an array

The example (configuration file):

```
localhost : static {
  listen = 127.0.0.1
  port = 8080
}

dev : dynamic {
  registry = 1.2.3.4
  service_name = http
  default_ports = (
    8080
    8096
  )
}
```

tags are helpers, not restrictors

E.g. Ocaml data type:

```ocaml
type connection
  = Static of addr * port
  | Dinamyc of addr * string * port list
```

There is no difference between number and string and date/time/datetime in atoms:

```
foo = 123.4
```

the app should decide how to interprete it: as a number, as a float, as a string
No need to wrap 123.4 with double quotes if you want ot pass an exact value

All structure kinds example (with array as a root, see "location" and "place" at the root are tags, not names):

```
location {
  name   = St Pete
  coords = 12.34 56.78
}

place {
  name   = St Pete
  
  coords = {
    lat = 12.34
    lon = 56.78
  }
  
  places-of-interest <
    name   = foo
    coords = 1.2
  -
    name   = bar
    coords = 3.4
  -
    name   = gee
    coords = 5.6
  >
  
  subareas [
    unknown = 12.34
    known {
      name   = Some cool place
      coords = 56.78
    }
    by-user {
      desc = Best place
      coords = 90.01
    }
  ]
}
```
