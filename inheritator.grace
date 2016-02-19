//inheritator.grace by James Noble
import "newcol" as nc
method circumfix[ *x ] { nc.seq(x) }
method printAll (x) {for (x) do { each -> print(each) }}

//declaration
type Dcl = type { 
     name
     body
     init
     annotations
     asString     
     in(_:Obj) do(_: type { apply(_:Obj) -> Done } ) -> Done        
}

//object / trait, class etc
type Obj = type { 
     structure -> nc.Sequence<String> 
     initialise -> nc.Sequence<String> 
     annotations -> nc.Sequence<String> 
     name -> String
     in(_:Obj) do(_: type { apply(_:Obj) -> Done } ) -> Done
}


//equalityTrait
trait equalityTrait {
  method ==(other) { abstract }
  method !=(other) { ! (self == other) }  //KERNAN
}




//this trait defines shorthand accessors for the annotations slot.
trait annotationsTrait { 
  method annotations is confidential { abstract } 
  method isaConfidential { annotations.contains "confidential" }
  method isaPublic       { ! isaConfidential }
  method isaAbstract     { annotations.contains "abstract" }
  method isaReadable     { isaPublic || annotations.contains "readable" }
  method isaWriteable    { isaPublic || annotations.contains "writeable" }
  method isaFinal        { annotations.contains "final" }
  method isaOverrides    { annotations.contains "overrides" }
  method isaComplete     { annotations.contains "complete" }
}

//dcl is a basic declaration
class dcl(name' : String)          //name being defined
        body ( body' : String )    //retro thing for methods
        init ( init' : String )    //init string for defs/vars
        annot ( annotations' : nc.Seq<String> ) {

   uses annotationsTrait
   uses equalityTrait
   def name is public = name'
   def body is public = body'
   def init is public = init'
   def annotations is public = annotations'  
   method in(context:Obj) do(block) {
          block.apply( self, context )
   }
   method asString {
      def strs = nc.outputStream
      strs.add( name ) 
      if (annotations.size > 0) then {
         strs.add " is "
         annotations.do { each -> 
            strs.add(each) } separatedBy { strs.add ", " }}
      if ("" != body) then {
         strs.add " \{"
         strs.add(body)
         strs.add "\}"
         }
      if ("" != init) then {
         strs.add " = " 
         strs.add(init) 
         }
      return strs.asString
   }
   method ==(other) {//functional
     match (other)
       case { od : Dcl -> od.asString == asString } //cheats
       case { _ -> false }
   }
   method <-!-> (other) {
     match (other)
       case { od : Dcl -> od.name == name } //cheats
       case { _ -> Error.raise "<-!-> should only be called on Dcls" }
   }
}

//obj is a basic object (aka trait aka class)
class obj(name' : String)
        inherit ( supers : Obj )  //should be zero or one :-)
        use ( traits : Obj ) 
        declare ( locals : Obj )  //hmm...
        annot ( annotations' : nc.Seq<String> ) {
   uses annotationsTrait
   def name is public = name' 
   def annotations is public = annotations' //provide hook for anotationsTrait  
   method structure  { //onceler?
     def struc = nc.list ([ ])
     for (supers) do { i -> struc.addAll(i.structure) }
     for (traits) do { i -> struc.addAll(i.structure) }
     for (locals) do { i -> struc.add(i) }
     return struc
   }

   method structureConflicts {
     def s = structure
     for (s) do { a -> 
       for (s) do { b ->
          if (a <-!-> b) then {
             if (a != b) then {return true}}
     }}
     false
   }
   method initialise { 
     def initCode = nc.list ([ ])
     for (supers) do { i -> initCode.addAll(i.initialise) }
     for (traits) do { i -> initCode.addAll(i.initialise) }
     initCode.add( "// from {name}" ) 
     for (locals) do { i -> if ("" != i.init) then {
                                initCode.add( "init {i.name} as ({i.init})" ) }}
     return initCode
   }
   
   method in(_:Obj) do(_: type { apply(_:Obj) -> Done } ) {
      Execption.raise "unimplemented" 
   }

   method asString {
      def strs = nc.outputStream
      strs.add("method {name} returning object ") 
      if (annotations.size > 0) then {
         strs.add "is "
         annotations.do { each -> 
            strs.add(each) } separatedBy { strs.add ", " }
         strs.add " "}
      strs.addln "\{"
      strs.newlinetab := 2
      for (supers) do { each ->
         strs.addln("inherits " ++ each.name)
      }
      for (traits) do { each ->
         strs.addln("uses " ++ each.name)
      }
      for (locals) do { each -> strs.addln(each.asString) }
      strs.newlinetab := 0
      strs.addln "}"
      return strs.asString
   }
}

