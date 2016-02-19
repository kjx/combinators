//dialect to fake new colletiosn etc in Kernan
//client should say: method circumfix[ *x ] { nc.seq(x) }

import "collections" as oldcol

method list(x) {oldcol.list.withAll(x)}
method seq(x) {oldcol.sequence.withAll(x)}
method set(x) {oldcol.set.withAll(x)}
method dictionary(x) {oldcol.dictionary.withAll(x)}

type Sequence<T> = col.Sequence<T>
type Collection<T> = col.Collection<T>
type Enumerable<T> = col.Enumerable<T>
type Sequence<T> = col.Sequence<T>
type Seq<T> = col.Sequence<T>
type List<T> = col.List<T>
type Set<T> = col.Set<T> 


class outputStream { 
  def buffer = list([ ])
  var newlinetab is public := 0 
  var atNewline := true
  method add (s : String) {if (atNewline) then {addSpaces(newlinetab)}
                           atNewline := false
                           buffer.add(s)}
  method addln (s : String) {add(s)
                             cr}
  method cr {buffer.add "\n"
             atNewline := true}                      
  method addSpaces(n) { 
         if (n > 0) then {
             for (1 .. n) do { _ -> buffer.add " "}}} //hate _ -> here
                             
  method asString {
    var str := ""
    for (buffer) do { each -> str := str ++ each } 
    return str
  }
}
