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
  def wsx = rule {rep1(whitespace | lineBreak("right"))}
  def wsn = rule {rep1(whitespace | newline)}

  def numberLiteral = digitStringParser
  def identifierString = (graceIdentifierParser ~ drop(opt(wsx)))

  //ENDGRAMMAR



  //we should all be very clear how satanic this is
  //once we get it working, then we work out somewhere
  //better to put this
  var tabStop := -1
  var tabLine := -1

  class tabParser(subParser) {
   inherit abstractParser
   def brand = "tabParser"
   method parse(in) {
     var current := in

     def oldTabStop = tabStop
     def oldTabLine = tabLine

     tabStop := in.indentation
     tabLine := in.line

     def res = subParser.parse(in)

     tabStop := oldTabStop
     tabLine := oldTabLine
     
     res
   }

  }


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


  method tab(p) {tabParser(p)}
  method offside {offsideWhitespaceParser}

}



