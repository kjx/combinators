dialect "test"
import "newcol" as nc
method circumfix[ *x ] { nc.seq(x) }
import "inheritator" as i 

method dump(s) {}

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
    t.newlinetab:=2
    t.addln "a"
    assert (t.asString) shouldBe "  a\n"    
  }
}

suite "object" do {

  def o1 = i.obj "o"
    inherit ([ ]) 
    use ([ ])
    declare ([ ])
    annot ([ ])


  def d1 = i.dcl "name1" body "body1" init "init1" annot ([ "confidential" ])
  def d2 = i.dcl "name2" body "body2" init "" annot ([  ])
  def d3 = i.dcl "name3" body "" init "init3" annot ([  ])
  def d4 = i.dcl "name4" body "" init "" annot ([ "confidential", "stupid" ])
  def d11 = i.dcl "name1" body "body11" init "init11" annot ([ "confidential" ])

  test "declname" do {
     assert (d1.asString) shouldBe ("name1 is confidential \{body1\} = init1")
     assert (d2.asString) shouldBe ("name2 \{body2\}")
     assert (d3.asString) shouldBe ("name3 = init3")
     assert (d4.asString) shouldBe ("name4 is confidential, stupid")
     assert (d11.asString) shouldBe ("name1 is confidential \{body11\} = init11")
  }
  
  test "declannot" do {
     assert (d1.isaConfidential) shouldBe (true)
     assert (d2.isaAbstract) shouldBe (false)
     assert (d1 == d1) description "d1==d1"
     assert (d1 != d2) description "d1!=d2"
     assert (d1 <-!-> d1) description "d1 conflicts d1"
     assert (!(d1 <-!-> d2)) description "d1 NOT conflicts d2"
     assert (d1 <-!-> d11) description "d1 conflicts d11"
     assert (d11 <-!-> d1) description "d11 conflicts d1"
     assert (!(d2 <-!-> d3)) description "d2 NOT conflicts d3"

  }


  test "creator" do {
     assert(o1) hasType( i.Obj )     
     assert(o1.annotations.size) shouldBe 0
     assert(o1.structure.size) shouldBe 0
     assert(o1.initialise.size) shouldBe 1
     assert(o1.asString) shouldBe "method o returning object \{\n\}\n"
     assert(! o1.structureConflicts) description "o1 structureConflicts"
  }

 
  def o2 = i.obj "o2"
    inherit ([ o1 ]) 
    use ([ ])
    declare ([ ])
    annot ([ ])

  def t1 = i.obj "t1"
    inherit ([ ]) 
    use ([ ])
    declare ([ d2, d4 ])
    annot ([ ])

  def t12 = i.obj "t12"
    inherit ([ ]) 
    use ([ ])
    declare ([ d1, d2 ])
    annot ([ ])

  def t113 = i.obj "t113"
    inherit ([ ]) 
    use ([ ])
    declare ([ d11, d3 ])
    annot ([ ])


  def c1 = i.obj "c1"
    inherit ([ ]) 
    use ([ ])
    declare ([ d1, d3 ])
    annot ([ ])



  test "creator2" do {
     assert(o2) hasType( i.Obj )     
     assert(o2.annotations.size) shouldBe 0
     assert(o2.structure.size) shouldBe 0
     assert(o2.initialise.size) shouldBe 2
     assert(o2.asString) shouldBe "method o2 returning object \{\n  inherits o\n\}\n"
     assert(! o2.structureConflicts) description "o2 structureConflicts"


     assert(t1) hasType( i.Obj )     
     assert(t1.asString) shouldBe "method t1 returning object \{\n  name2 \{body2\}\n  name4 is confidential, stupid\n\}\n"
     assert(t1.annotations.size) shouldBe 0
     assert(t1.structure.size) shouldBe 2
     assert(t1.initialise.size) shouldBe 1
     assert(! t1.structureConflicts) description "t1 structureConflicts"

     assert(! c1.structureConflicts) description "c1 structureConflicts"
  }

  def x1 = i.obj "x1"
    inherit ([ ]) 
    use ([ ])
    declare ([ d1, d11 ])
    annot ([ ])

  def x2 = i.obj "x2"
    inherit ([ c1 ]) 
    use ([ ])
    declare ([ d11 ])
    annot ([ ])

  def x3 = i.obj "x3"
    inherit ([ c1 ]) 
    use ([ ])
    declare ([ d11 ])
    annot ([ ])

  def x4 = i.obj "x4"
    inherit ([ ]) 
    use ([ t12 ])
    declare ([ d11 ])
    annot ([ ])

  def x5 = i.obj "x5"
    inherit ([ ]) 
    use ([ t12, t113 ])
    declare ([ ])
    annot ([ ])


  test "flatconflicts" do { 
    assert (x1.structureConflicts) description "x1 structureConficts"
    assert (x2.structureConflicts) description "x2 structureConficts"
    assert (x3.structureConflicts) description "x3 structureConficts"
    assert (x4.structureConflicts) description "x4 structureConficts"
    assert (x5.structureConflicts) description "x5 structureConficts"
  }

  print ""
  i.printAll(x1.initialise)
  print ""
  i.printAll(x2.initialise)
  print ""
  i.printAll(x3.initialise)
  print ""
  i.printAll(x4.initialise)
  print ""
  i.printAll(x5.initialise)

}

//TODO
// Tuple like helper
// From (foo) aliasing [ [ "a", "b" ] ] excluding [ "a", "b", "c" ] 
//  Returns some thing very like a class/trait/object. 
// Or is this a method on traits?
// Or a set of methods? 


//overriding annotation
//circular inheritance?
//diamond inheritance
//overloading(?)
//trait requirements

//excluding something that isn't there
//aliasin somethin that isn't there
//overriding somtehinf that is aliased
//required/abstract method is not provided
//alaising only half of a var (is that all it does)     

//automatic generation 
