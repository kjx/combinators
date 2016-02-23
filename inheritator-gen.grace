dialect "test"
import "newcol" as nc
method circumfix[ *x ] { nc.seq(x) }
import "inheritator" as i 
method sizeOfVariadicList( l ) { 
  var s := 0
  for (l) do { _ -> s := s + 1 } 
  return s
}
method printAll (x) {for (x) do { each -> print(each) }}

// from http://rosettacode.org/wiki/Combinations#Standard_ML

method comb (m : Number, s : nc.Seq) -> nc.Seq<nc.Seq<T>> {
  if (m == 0) then {return ([ ([ ]) ]) }
  if (s.size == 0) then {return ([ ]) }
  def x  = s.first
  def xsList = s.asList
  xsList.removeFirst
  def xs = xsList.asSequence
  return comb(m - 1, xs).map {y -> cons(x, y)} ++ comb(m, xs)
}

method cons(car, cdr) {nc.seq(nc.list(cdr).addFirst(car))}

def names =  ([ "a", "b", "c", "d" ]) 

assert (comb(0, names)) shouldBe ([ ([ ]) ])
assert (comb(1, names)) shouldBe ([ ([ "a" ]), ([ "b" ]), ([ "c" ]), ([ "d" ]) ])
assert (comb(2, names)) shouldBe ([ ([ "a", "b" ]), ([ "a", "c" ]), ([ "a", "d" ]), ([ "b", "c" ]), ([ "b", "d" ]), ([ "c", "d" ]) ])

method allCombinations ( s : Seq ) { 
  var answers := nc.seq ([ ])
  for (0 .. sizeOfVariadicList(s)) do { n ->
    answers := answers ++ comb(n, s)
  }
  answers
}

method allNonEmptyCombinations ( s : Seq ) { 
  var answers := nc.seq ([ ])
  for (1 .. sizeOfVariadicList(s)) do { n ->
    answers := answers ++ comb(n, s)
  }
  answers
}

assert (allCombinations ([ "a" ]) ) shouldBe ([ ([  ]), ([ "a" ]) ])
assert (allCombinations ([ "a", "b" ]) ) shouldBe  ([ ([  ]), ([ "a" ]),  ([ "b" ]),  ([ "a", "b" ]) ])
assert (allCombinations ([ "a", "b", "c" ]).size) shouldBe 8



method makeMethod(m : String) within(ct : String) annot(a : Seq<String>) {
  i.dcl(m) body "{m} from {ct}" init "" annot(a)  
}
assert ((makeMethod("m") within("c") annot ([ ])).asString) shouldBe "m \{m from c\}"

//given a method names, generate a list of all methods with all annotations
method allAnnotations(m :String) within(ct : String) annot(anns : Seq<String>) {
   allCombinations(anns).map { a -> makeMethod(m) within (ct) annot(a) }
}
assert( (allAnnotations "a" within "C" annot ([ "conf", "abst" ])).size ) shouldBe 4

//generate a list of structures with all combinations of methods and annotations
method allStructures(ms : Seq<String>) within(ct : String) annot(anns : Seq<String>) {
  def listOfStructures = nc.list ([ ])
  for (allNonEmptyCombinations(ms)) do { namesInStructure -> 
    print "namesInStructure = {namesInStructure}"
    printAll (allAnnotations(namesInStructure) within(ct) annot(anns))
  }
  return listOfStructures
}


printAll(allStructures ([ "a", "b" ]) within "C" annot ([ "x" ]))
