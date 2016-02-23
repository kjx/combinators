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

method allCombinations ( s : nc.Seq ) { 
  var answers := nc.seq ([ ])
  for (0 .. sizeOfVariadicList(s)) do { n ->
    answers := answers ++ comb(n, s)
  }
  answers
}

method allNonEmptyCombinations ( s : nc.Seq ) { 
  var answers := nc.seq ([ ])
  for (1 .. sizeOfVariadicList(s)) do { n ->
    answers := answers ++ comb(n, s)
  }
  answers
}

assert (allCombinations ([ "a" ]) ) shouldBe ([ ([  ]), ([ "a" ]) ])
assert (allCombinations ([ "a", "b" ]) ) shouldBe  ([ ([  ]), ([ "a" ]),  ([ "b" ]),  ([ "a", "b" ]) ])
assert (allCombinations ([ "a", "b", "c" ]).size) shouldBe 8



method makeMethod(m : String) within(ct : String) annot(a : nc.Seq<String>) {
  i.dcl(m) body "{m} from {ct}" init "" annot(a)  
}
assert ((makeMethod("m") within("c") annot ([ ])).asString) shouldBe "m \{m from c\}"

//given a method name, generate a list of methods annotated in all possible ways
method allAnnotations(m :String) within(ct : String) annot(anns : nc.Seq<String>) {
  allCombinations(anns).map { a -> makeMethod(m) within (ct) annot(a) }
}
assert( (allAnnotations "a" within "C" annot ([ "conf", "abst" ])).size ) shouldBe 4

//given a list of method names, generate all declaration strutures for those names
method allMethods(ms : nc.Seq<String>) within(ct : String) annot(anns : nc.Seq<String>) {
}

// print "AMab"
// print( allMethods ([ "a", "b" ]) within "C" annot ([ "x" ])  )

// print "AMabc"
// print( allMethods ([ "a", "b", "c" ]) within "C" annot ([ "x", "y" ])  )


//generate a list of structures with all combinations of methods and annotations
method allStructures(ms : nc.Seq<String>) within(ct : String) annot(anns : nc.Seq<String>) {
  def listOfStructures = nc.list ([ ])
  for (allNonEmptyCombinations(ms)) do { namesInStructure -> 
    // print "namesInStructure = {namesInStructure}"
    // printAll (allAnnotations(namesInStructure) within(ct) annot(anns))
  }
  return listOfStructures
}


// printAll(allStructures ([ "a", "b" ]) within "C" annot ([ "x" ]))


//calculate list product
//code from Ruby from http://c2.com/cgi/wiki?EveryCombinationInManyProgrammingLanguages
//in Haskell this is apparently just "squence"
method dumbo( n ) {
  def in = nc.seq(n)
  def list1 = in.first
  def junko = in.asList
  junko.removeFirst
  def more_lists = junko.asSequence

  def crest = if (more_lists.size == 0) 
               then { ([ ([ ]) ]) } 
               else { dumbo(more_lists) }

  list1.fold { combs, i -> 
                  combs ++ crest.map { comb -> ([ i ]) ++ comb }  }
        startingWith ([ ])
}



method concat (ll) {
  def res = nc.list ([ ])
  for (ll) do { l -> 
    res.addAll(l)
  }
  res.asSequence
}
assert( concat ([ ([ 1, 2 ]), ([ 3, 4 ]) ]) ) shouldBe ([ 1, 2, 3, 4 ])
assert( concat ([ ([ 1, 2 ]), ([ 3, 4, 5, 6 ]), ([ 7, 8 ]) ]) ) 
   shouldBe ([ 1, 2, 3, 4, 5, 6, 7, 8 ])

method cons (car, cdr) { (nc.list ([ car ])).addAll(cdr).asSequence }
assert (cons("a", nc.seq ([ "b", "c" ]) )) shouldBe ( nc.seq ([ "a", "b", "c" ]) )
assert (cons("a", nil)) shouldBe ( nc.seq ([ "a" ]) )
method nil {nc.seq ([ ]) }
assert(nil.size) shouldBe 0


assert (dumbo ([ ([ "ax", "ay" ]) ]) )  shouldBe( ([ ([ "ax" ]), ([ "ay"  ]) ]) )
assert (dumbo ([ ([ "ax" ]),  ([ "bx" ]) ]) ) shouldBe( ([ ([ "ax", "bx" ]) ]) ) 
assert (dumbo ([ ([ "ax", "ay" ]),  ([ "bx", "by" ]) ]) )
  shouldBe( ([ ([ "ax", "bx" ]),  ([ "ax", "by" ]), ([ "ay", "bx" ]),  ([ "ay", "by" ]) ]) )
assert ((dumbo ([ ([ "ax", "ay" ]),  ([ "bx", "by" ]), ([ "cx", "cy" ]) ]) ).size) 
   shouldBe 8

