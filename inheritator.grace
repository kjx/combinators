//inheritator.grace by James Noble
import "newcol" as nc
method circumfix[ *x ] { nc.seq(x) }

//declaration
type Dcl = type { 
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
   def name is public = name'
   def body is public = body'
   def init is public = init'
   def annotations is public = annotations'  
   method in(context:Obj) do(block) {
          block.apply( self, context )
   }
   method asString {
      def strs = nc.outputStream
      strs.add "    "
      strs.add( name ) 
      if (annotations.size > 0) then {
         strs.add " is"
         annotations.do { each -> 
            strs.add " "
            strs.add(each)
            if (annotations.size > 1) then {strs.add ","}}}
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
}

print (dcl "name" body "body" init "init" annot ([ "confidential" ]))
print (dcl "name" body "body" init "" annot ([  ]))
print (dcl "name" body "" init "init" annot ([  ]))
print (dcl "name" body "" init "" annot ([ "confidential", "stupid" ]))

//obj is a basic object (aka trait aka class)
class obj(name' : String)
        inherit ( supers : Obj )  //should be zero or one :-)
        use ( traits : Obj ) 
        declare ( locals : Obj )  //hmm...
        annot ( annotations' : nc.Seq<String> ) {
   uses annotationsTrait
   def name is public = name' 
   def annotations is public = annotations' //provide hook for anotationsTrait  
   method structure  { ([ ]) }
   method initialise { ([ ]) }   
   method structureString { nc.outputStream.asString }
   method initialiseString { nc.outputStream.asString }
   method in(_:Obj) do(_: type { apply(_:Obj) -> Done } ) {
      Execption.raise "unimplemented" 
   }
}





//method obj "name" 
//    inherit ( using [ohelper] declare [locals] annotating [annots]. ?












