import "parsers2" as parsers

//////////////////////////////////////////////////
// Simple Grammar
//////////////////////////////////////////////////

// currently supports nice left-flowing continution lines
// plus statement sequences where immediate things are at the same indentation
//
// but DOES NOT support proper margins

class exports {
  inherit parsers.exports 
  //BEGINGRAMMAR


  // top level
  def program = rule {codeSequence ~ rep(wsx) ~ end}
  def codeSequence = rule { repdel((expression | empty), ( semicolon | lineBreak("same"))) }

  def expression = rule { opt(wsx) ~ (requestWithArgs | numberLiteral) ~ opt(wsx)}
  def requestWithArgs = rule { rep1sep(requestArgumentClause,opt(wsx)) }
  def requestArgumentClause = rule { identifierString ~ opt(wsx) ~ argumentsInParens }
  def argumentsInParens = rule { lParen ~ rep1sep(drop(opt(wsx)) ~ expression, comma) ~ rParen  }  


  def whitespace = symbol " "
  def newline = symbol "\n"
  def semicolon = symbol ";"
  def comma = symbol ","
  def lParen = symbol "("
  def rParen = symbol ")" 

  def wsp = rule {rep1(whitespace)}
  def wsx = rule {rep1(whitespace | line("right"))}
  def wsn = rule {rep1(whitespace | newline)}

  def numberLiteral = digitStringParser
  def identifierString = (graceIdentifierParser ~ drop(opt(wsx)))

  //ENDGRAMMAR



  //we should all be very clear how satanic this is
  //once we get it working, then we work out somewhere
  //better to put this
  var tabStop := -1
  var tabLine := -1

  method resetTabstops {
    tabStop := -1
    tabLine := 1
    } 

  class tabParser(subParser) {
   inherit abstractParser
   def brand = "tabParser"
   method parse(in) {
     var current := in

     def oldTabStop = tabStop
     def oldTabLine = tabLine

     tabStop := in.indentation
     tabLine := in.line

     //print "tabsett {tabStop}@{tabLine}"
     def res = subParser.parse(in)

     tabStop := oldTabStop
     tabLine := oldTabLine

     //print "tabundo {tabStop}@{tabLine}"
     
     res
   }

  }




  //need to only go left!
  class offsideWhitespaceParser {
   inherit abstractParser 
   def brand = "offsideWhitespaceParser"
   method parse(in) {
     var current := in

     while {(current.take(1) == " ") ||
             (current.take(1) == "\n") ||
             (current.take(2) == "//")} do {
       //print "outer while {in.position} *{current.take(1)}*"
       //def c1s = (current.take(1) == " ")
       //def c1n = (current.take(1) == "\n" )
       //def cl = (current.line == tabLine)
       //def ci = (current.indentation > tabStop)
       //print "{c1s} {c1n} {cl} {ci}"
       //print ((c1s || c1n) && (cl || ci))
       //print "cindent={current.indentation} ts={tabStop}"
       while {((current.take(1) == " ") || (current.take(1) == "\n" )) &&
               ((current.line == tabLine) || (current.indentation >= tabStop))} 
         do {current := current.rest(1)}
       if (current.take(2) == "//")
         then {
           current := current.rest(2)
           while {current.take(1) != "\n"} 
             do {current := current.rest(1)}
           current := current.rest(1)
         }
     }

     if (current != in) then {
        return parseSuccess(current, " ")
       } else {
        return parseFailure(
          "expected w/s got {in.take(5)} at {in.position}")
     }
   }
  }

  class tabAssertionParser(xTab,xLine) {
   inherit abstractParser
   def brand = "tabAssertionParser"
   method parse(in) {
     if ((tabStop == xTab) && (tabLine == xLine ))
      then {return parseSuccess(in,"")}
      else { print  "***Asserted tab=={xTab}@{xLine}, actual=={tabStop}@{tabLine}"
             return parseFailure "***Asserted tab=={xTab}@{xLine}, actual=={tabStop}@{tabLine}"}
   }
  }

  //succeed if current position is onside wrt global variables tabStop and tabLine
  class onsideParser {
   inherit abstractParser
   def brand = "onsideParser"
   method parse(in) {
     if ((in.line == tabLine) ||
         ((in.line >  tabLine) && (in.indentation > tabStop)))
      then {return parseSuccess(in,"")}
      else {return parseFailure "offside!"}
   }
  }

  class underParser {
   inherit abstractParser
   def brand = "underParser"
   method parse(in) {
     print "under pos{in.position} {in.column}@{in.line} ind{in.indentation} tab{tabStop}@{tabLine}"
     if ((in.line == tabLine) ||
         ((in.line >  tabLine) && (in.indentation == tabStop)))
      then {return parseSuccess(in,"")}
      else {return parseFailure "under!"}
   }
  }


  //always succeed, print stuff
  class debugParser {
   inherit abstractParser
   def brand = "debugParser"
   method parse(in) {
      var side := "nosuchside"
      if (onsideParser.parse(in).succeeded)
                   then {side := "onside"}
                   else {side := "offside" }
      print ("pos={in.position} {in.column}@{in.line} ind={in.indentation}" ++
         "tab={tabStop}@{tabLine} {side} 5chars=<<{in.take(5)}")
      
      parseSuccess(in,"")
   }
  }

  method portray(string) {
    def portrayParser = underParser ///onsideParser
    print "warning trashes global tabstops"
    var res := ""
    tabStop := -1
    tabLine := -1
    var in := stringInputStream(string,1)
    while {!in.atEnd} do {
        match (in.take(1))
           case { "T" ->
                  tabStop := in.indentation
                  tabLine := in.line
                  res := res ++ "T"
                  print "setting tab {tabStop}@{tabLine}" }
           case { " " ->
                if (portrayParser.parse(in).succeeded)
                   then {res := res ++ "."}
                   else {res := res ++ "_"} }
           case { "\n" ->
                if (portrayParser.parse(in).succeeded)
                   then {res := res ++ "!.\n"}
                   else {res := res ++ "!_\n"} }
           case { _ ->
                if (portrayParser.parse(in).succeeded)
                   then {res := res ++ "X"}
                   else {res := res ++ "o"} }
           
        in := in.rest(1)
    }
    print "{res}\n"
  }


  class lineBreakParser2(direction) { 
   inherit abstractParser
   def brand = "lineBreakParser2"
   method parse(in) {

    if (in.take(1) != "\n") 
      then {return parseFailure "looking for a LineBreak-{direction}, got \"{in.take(1)}\" at {in.position}"}

    def rest = in.rest(1) 

    def actualDirection = 
      if (rest.atEnd) then { "left" }
        elseif {rest.indentation <  in.indentation} then { "left" }
        elseif {rest.indentation == in.indentation} then { "same" }
        elseif {rest.indentation >  in.indentation} then { "right" }
        else {Error.raise "Tricotomy failure"}


    if (direction.match(actualDirection))  then {
         return parseSuccess(in.rest(1), "<<{direction}>>\n" ) 
       }

    parseFailure "looking for a LineBreak-{direction}, got {actualDirection} at {in.position}" 


    // Error.raise "Shouldn't happen"
   }
  }


  method tag(p) {phraseParser("",tabParser(p))}
  method tab(p) {tabParser(p)}
  method offside {offsideWhitespaceParser}
  method onside  {onsideParser}
  method line(d) {lineBreakParser2(d)}
  method col {underParser}
}



