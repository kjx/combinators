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
  method add (s : String) {buffer.add(s)}
  method addln (s : String) {add(s)
                             add("\n")} 
  method asString {
    var str := ""
    for (buffer) do { each -> str := str ++ each } 
    return str
  }
  method pp {print(asString)}
}
