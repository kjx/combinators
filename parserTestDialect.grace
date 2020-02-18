import "grammar" as grammar
inherit grammar.exports

////////////////////////////////////////////////////////////
// "tests" 


method assert  (assertion : Block) complaint (name : String) {
  if (!assertion.apply) 
    then {print "ASSERTION FAILURE"}
}


print("start")

var passedTests := 0
var failedTests := 0

var printPassedTests := false

method test (block : Block, result : Object, comment : String) {
  def rv = block.apply
  if  (rv == result) 
    then {if  (printPassedTests) then {print  ("------: " ++ comment)} else {print "."}}
    else {if (!printPassedTests) then {print ""}
          print  ("FAILED: " ++ comment)}
}

method test(block : Block) expecting(result : Object) comment(comment : String) {
   test(block,result,comment)
}


// method test (block : Block, result : Object, comment : String) {
//  def rv = block.apply
//  if  (rv == result) 
//    then {print  ("------: " ++ comment)}
//    else {print  ("FAILED: " ++ comment)} 
// }

method test(parser : Parser) on(s : String) correctly(comment : String) {
  def res = parser.parse(stringInputStream(s,1))
  if (res.succeeded) 
    then {if (printPassedTests) then {print  ("------: " ++ comment ++ " " ++  res.result)}  else {print "."}}
    else {
       if (!printPassedTests) 
          then {print ""}
       print  ("FAILED: " ++ comment ++ " " ++  s)
     }
}

method test(parser : Parser) on(s : String) wrongly(comment : String) {
  def rv = parser.parse(stringInputStream(s,1)).succeeded
  if  (!rv) 
    then {if (printPassedTests) then {print  ("------: " ++ comment ++ " " ++  s)}  else {print "."}}
    else {
       if (!printPassedTests) then {print ""}
       print  ("FAILED: " ++ comment ++ " " ++  s)
    } 
}


method testProgramOn(s : String) correctly(comment : String) {
  test(program) on(s) correctly(comment)
}

method testProgramOn(s : String) wrongly(comment : String) {
  test(program) on(s) wrongly(comment)
}
