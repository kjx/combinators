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
   ms.map { each ->  allAnnotations(each) within(ct) annot(anns) }
}
assert ((allMethods ([ "a", "b" ]) within "C" annot ([ "x" ])).size) shouldBe 2
assert ((allMethods ([ "a", "b", "c" ]) within "C" annot ([ "x", "y" ])).size) shouldBe 3


//generate a list of structures with all combinations of methods and annotations
method allStructures(ms : nc.Seq<String>) within(ct : String) annot(anns : nc.Seq<String>) {
  concat(allNonEmptyCombinations(ms).map { ns -> dumbo(allMethods(ns) within(ct) annot(anns)) })
}
assert ((allStructures ([ "a", "b" ]) within "C" annot ([ "x" ])).size) shouldBe 8
//would like to do better but



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

assert (dumbo ([ ([ "ax", "ay" ]) ]) )  shouldBe( ([ ([ "ax" ]), ([ "ay"  ]) ]) )
assert (dumbo ([ ([ "ax" ]),  ([ "bx" ]) ]) ) shouldBe( ([ ([ "ax", "bx" ]) ]) ) 
assert (dumbo ([ ([ "ax", "ay" ]),  ([ "bx", "by" ]) ]) )
  shouldBe( ([ ([ "ax", "bx" ]),  ([ "ax", "by" ]), ([ "ay", "bx" ]),  ([ "ay", "by" ]) ]) )
assert ((dumbo ([ ([ "ax", "ay" ]),  ([ "bx", "by" ]), ([ "cx", "cy" ]) ]) ).size) 
   shouldBe 8



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

assert((allStructures ([ "m", "n" ]) within "C" annot ([ "confidential", "abstract", "final", "overrides" ])).size) shouldBe 288
assert((allStructures ([ "m" ]) within "C" annot ([ "confidential", "abstract", "final", "overrides" ])).size) shouldBe 16

def l1structures = nc.seq ([ ([ ]) ]) ++ (allStructures ([ "m" ]) within "L" annot ([ "confidential", "abstract", "final", "overrides" ])) 
def c1structures = (allStructures ([ "m" ]) within "C" annot ([ "confidential", "abstract", "final", "overrides" ]))
def t1structures = (allStructures ([ "m" ]) within "T1" annot ([ "confidential", "abstract", "final", "overrides" ]))

//should be in a unicode module, a whole bunch of public defs! 
//so we can write u.formFeed to get a form feed
def formfeed = "\u000c"
def formfeedsymbol = "\u240C"
def ff = "\n\n\n\n\n"

for (t1structures) do { traits -> 
  for (l1structures) do { locals -> 
    print "-------------------------"    
    def t1 = i.obj "T1"
              inherit ([ ]) 
              use ([ ])
              declare ( traits ) 
              annot ([ ]) 
    def l = i.obj "L"
              inherit ([ ]) 
              use ([ t1 ])
              declare ( locals ) 
              annot ([ ]) 
    print(t1)
    print(l)
    var fs 
    var fsValid := false
    try { fs := l.flatAsString
          fsValid := true } 
      catch { ie : i.InheritanceError -> print (ie) }
    if (fsValid) then { 
              print "flattens into"
              print (fs) 
             }
    print "-------------------------"
  }
}

