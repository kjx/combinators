//inheritator.grace by James Noble
import "newcol" as nc
method circumfix[ *x ] { nc.seq(x) }
method printAll (x) {for (x) do { each -> print(each) }}

//declaration
type Dcl = type { 
     name -> String
     body -> String
     init -> String
     annotations -> nc.Sequence<String>
     asString -> String
}

//object / trait, class etc
type Obj = type { 
     structure -> nc.Sequence<Dcl> 
     initialise -> nc.Sequence<String> 
     annotations -> nc.Sequence<String> 
     name -> String
     asString -> String
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
        annot ( annotations' : nc.Seq<String> ) -> Dcl {

   //to make a method - dcl "foo" body "foo-body" init ""
   //to make a def - dcl "d" body "c-def-d" init "DEF c-def-d = exp"
   //to make a var - dcl "v" body "c-var-v" init "VAR c-var-v := exp"
   //and             dcl "v:=" body "c-var-v:=" init ""

   uses annotationsTrait
   uses equalityTrait
   def name is public = name'
   def body is public = body'
   def init is public = init'
   def annotations is public = nc.set(annotations')
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
   method maybeRename(aliases : nc.Dictionary<String,String>) -> Dcl {
     if (aliases.containsKey(name)) 
      then {dcl(aliases.at(name)) body (body) init (init) annot (annotations)}
      else {self}
   }
   method withAnnotation( ann : nc.seq<String> ) {
     dcl(name) body (body) init (init) annot (annotations ++ ann)
   }
}


//obj is a basic object (aka trait aka class)
class obj(name' : String)
        inherit ( supers : nc.Sequence<Obj> )  //should be zero or one :-)
        use ( traits : nc.Sequence<Obj> ) 
        declare ( locals : nc.Sequence<Dcl> )  //hmm...
        annot ( annotations' : nc.Sequence<String> ) {
   uses annotationsTrait
   def name is public = name' 
   def annotations is public = annotations' //provide hook for anotationsTrait  

   method structure  { //onceler?
     def superStructure = nc.list ([ ])
     for (supers) do { i -> superStructure.addAll(i.structure) }
     
     def traitStructure = nc.list ([ ])
     for (traits) do { i -> traitStructure.addAll(i.structure) }

     def supersAndTraits = override(superStructure) with(traitStructure) 
     
     def finalStructure = override(supersAndTraits) with(locals) 

     finalStructure
   }

   method override(low) with(high) {
     var lows := nc.seq(low)  //avoid side fx on low
     var highs := nc.seq ([ ])
     for (high) do { d ->
         if (!d.isaAbstract) 
           then { //concrete
                  lows := lows.filter { l -> ! ( l <-!-> d ) }
                  highs := highs ++ ([ d ])
           } else { //abstract, add only if nothing there
             if (! declaration(d) conflictsWith(low)) 
                    then { highs := highs ++ ([ d ]) }
         }
         if ((d.isaOverrides) && 
             (! declaration(d) conflictsWith(low)))
           then {Exception.raise "{d} in {name} does't override anything"} 
     }

     for (low) do { l -> 
         if (l.isaFinal && ! nc.seq(lows).contains(l))
           then {Exception.raise "{d} in {name} is FINAL but overridden"} 
     }
     nc.seq(lows ++ highs)
   }

   method declaration(d) conflictsWith( dlist ) {
      dlist.fold { result, elem -> result || (elem <-!-> d) } startingWith (false)
   }

   //conflicts within local definitions
   method localConflicts { declarationConflicts( locals ) } 

   //conflcts with overall structure
   method structureConflicts { 
             localConflicts || declarationConflicts ( structure ) }

   //helper method to check conflicts in a list of declarations
   method declarationConflicts ( dcls ) {
     for (dcls) do { a -> 
       for (dcls) do { b ->
          if (a <-!-> b) then {
             if (a != b) then {return true}}
     }}
     false
   }

   method initialise { 
     def initCode = nc.list ([ ])
     for (supers) do { i -> initCode.addAll(i.initialise) }
     for (traits) do { i -> initCode.addAll(i.initialise) }
     initCode.add "// from {name}"
     for (locals) do { i -> if ("" != i.init) then {
               initCode.add( i.init ) }}
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

//handle excludes as a decorater on objs
class obj (name' : String ) 
        from(base : Obj)
        excludes ( excls : nc.Sequence<String> ) -> Obj {
     inherits obj( name' )
        inherit ([ ])
        use ([ ]) 
        declare ([ ])  
        annot ([ ]) 
     method structure -> nc.Sequence<String> {
        base.structure.filter { each -> ! ( excls.contains(each.name)) }
     }
     method initialise -> nc.Sequence<String> {base.initialise}
     method annotations -> nc.Sequence<String> {base.annotations}
}

//handle aliases as a decorator on objs
class obj (name' : String ) 
        from(base : Obj)
        aliases ( aliases : Dictionary<String,String> ) -> Obj {
     inherits obj( name' )
        inherit ([ ])
        use ([ ]) 
        declare ([ ])  
        annot ([ ]) 

     method structure -> nc.Sequence<String> {
        def bs = base.structure
        def xtras = nc.list ([ ])
        for (bs) do { each -> 
          if (aliases.containsKey(each.name)) 
            then { xtras.add( each.maybeRename( aliases )
                                  .withAnnotation( "confidential" ) ) }
        }
        bs ++ xtras
     }
     method initialise -> nc.Sequence<String> {base.initialise}
     method annotations -> nc.Sequence<String> {base.annotations}
}
