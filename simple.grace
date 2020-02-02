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

  class tabParser(subParser) {
   inherit abstractParser
   def brand = "tabParser"
   method parse(in) {
     var current := in

     def oldTabStop = tabStop

     def res = subParser.parse(in)

     tabStop := oldTabStop
     
     res
   }

  }


  class offsideWhitespace {
     var current := in

     while {(current.take(1) == " ") || (current.take(1) == "\n")} do {
       //catch is: current line's indentation will (presumanly) be < tabStop

       while {current.take(1) == " "} 
         do {current := current.rest(1)}
       if (current.take(2) == "//")
         then {
           current := current.rest(2)
           while {current.take(1) != "\n"} 
             do {current := current.rest(1)}

           current := current.take(1)
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



