dialect "test"
import "newcol" as nc
method circumfix[ *x ] { nc.seq(x) }
import "inheritator" as i 


suite "nc"  do {
  test "output" do {
    def s = nc.outputStream
    s.add "a"
    assert (s.asString) shouldBe "a"
    s.add "b"
    assert (s.asString) shouldBe "ab"
    s.addln "c"
    assert (s.asString) shouldBe "abc\n"
   
    def t = nc.outputStream
    
  }
}

suite "object" do {

  def o1 = i.obj "o"
    inherit ([ ]) 
    use ([ ])
    declare ([ ])
    annot ([ ])

  test "creator" do {
     assert(o) hasType( i.Obj )
     assert(0 == o1.annotations.size) 
     assert(0 == o1.structure.size)
     assert(0 == o1.initialise.size)  
     assert("" == o1.structureString)
     assert("" == o1.initialiseString)     
  }
}

//TODO
//define dcln
//define obj
//print out declarations - pp
//declare a module
//declare a class
//declare an attribute?

// Tuple like helper
// From (foo) aliasing [ [ "a", "b" ] ] excluding [ "a", "b", "c" ] 
//  Returns some thing very like a class/trait/object. 
// Or is this a method on traits?
// Or a set of methods? 


//overriding
//annotations and test
//more tests
//circular inheritance
//diamond inheritance
//overloading(?)


//excluding something that isn't there
//aliasin somethin that isn't there
//overriding somtehinf that is aliased
//required/abstract method is not provided


//automatic generation 
