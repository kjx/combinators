import "simple" as grammar
inherit grammar.exports
  alias baseAbstractParser = abstractParser

//we are family!!
class abstractParser {
  inherit baseAbstractParser

  method ~~(other) {snocParser(self,other)}
}


var printPassedTests := false

method test(parser : Parser) on(s : String) correctly(comment : String) {
  def res = parser.parse(stringInputStream(s,1))
  resetTabstops 
  if (res.succeeded) 
    then {if (printPassedTests) then {print  ("------: " ++ comment ++ " " ++  res.result)}  else {}} //print "."}}
    else {
       if (!printPassedTests) 
          then {print ""}
       print  ("FAILED: " ++ comment ++ " " ++  s)
     }
}

method test(parser) on (s:String) {
  test(parser) on(s) correctly("")
}


method test(s:String) {
  test(program) on(s) correctly("")
}

print"offside2========================================"


def semiNL = ( semicolon | newline )
def abcd = opt(offside) ~ token "a" ~
             tab( offside ~ token "b" ~ offside ~ token "c" ) ~
             semiNL ~ opt(offside) ~ token "d"

def wso = rule { rep(whitespace) ~ opt(line("right" | "same") ~ rep1(whitespace)) ~ onside }
def abc1 = opt(wso) ~ token "a" ~
             tab( wso ~ token "b" ~ wso ~ token "c" ) ~ rep(whitespace) ~
             semiNL ~ opt(wso) ~ token "d"



test (wso) on " a b c\nd"
test (opt(wso)) on " a b c\nd"
test (opt(wso)) on "a b c\nd"
test (abc1) on "a b c\nd"
test (abc1) on "a b c;d"


test (not(abc1)) on "a b c d"
test (not(abc1)) on "a b\n c d"
test (not(abc1)) on "a\n\nb c; d"
test (abc1) on "a\n b c; d"

test (opt(wso)) on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a") on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ) on "a\n  b\n  c\nd"


def XdebugParser = empty //switch off debugging

test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ XdebugParser) on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ wso ~ XdebugParser) on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ rep(whitespace) ~ XdebugParser) on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ rep(whitespace) ~ opt(line("right" | "same") ~ rep1(whitespace)) ~ XdebugParser) on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ rep(whitespace) ~ opt(line("right" | "same") ~ rep1(whitespace)) ~ onside ~ XdebugParser) on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ rep(whitespace) ~ opt(line("right" | "same") ~ rep1(whitespace)) ~ onside ~ token "c" ~ XdebugParser) on "a\n  b\n  c\nd"


test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ wso ~ token "c") on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ wso ~ token "c" ~ rep(whitespace)) on "a\n  b\n  c\nd"
test (opt(wso) ~ token "a" ~ wso ~ token "b" ~ wso ~ token "c" ~ rep(whitespace) ~ semiNL) on "a\n  b\n  c\nd"

//portrayOffside "T\n  b\n  c\nd"
test (abc1) on "a\n  b\n  c\nd"
test (abc1) on "  a\n    b\n    c\n  d"
test (not(abc1)) on "a\n    b\n  c;d"   //should be OK, needs margin



print"expression2========================================"

def program2 = rule {codeSequence2 ~  end}
def codeSequence2 = rule { repdel(( tab( expression2 ) | empty), ( semicolon | line("same" | "left"))) }

def expression2 = rule { opt(wso) ~ (requestWithArgs2 | numberLiteral) ~ opt(wso)}
def requestWithArgs2 = rule { tag(rep1sep(requestArgumentClause2,opt(wso))) }
def requestArgumentClause2 = rule { tag( identifierString ~ opt(wso) ~ argumentsInParens2 ) }
def argumentsInParens2 = rule { lParen ~ tab( rep1sep(drop(opt(wso)) ~ expression2, comma)) ~ rParen  }  


method test2(s:String) {
  test(program2) on(s) correctly("")
}


//tests copied in from earlier section above


test(numberLiteral ~ wso ~ numberLiteral ~ end) on "1 1"
test(numberLiteral ~ wso ~ numberLiteral ~ end) on "1\n 2"
test(not(numberLiteral ~ wso ~ numberLiteral ~ end)) on "    1\n 3"
test(wso ~ numberLiteral) on "    1\n      4"
test(wso ~ numberLiteral ~ wso) on "    2\n      4"
test(wso  ~ numberLiteral ~ wso ~ numberLiteral ~ end) on "    3\n      4"
test(not(numberLiteral ~ wso ~ numberLiteral ~ end)) on "      1\n    5"
test(not (numberLiteral ~ wso ~ numberLiteral ~ end)) on "1\n600   "
test(numberLiteral ~ wso ~ numberLiteral) on "1\n 60"
test(not(numberLiteral ~ wso ~ numberLiteral)) on "1\n60"
test(numberLiteral ~ wso ~ numberLiteral ~ end) on "1\n 7"

test(not(expression ~ end)) on "1\n(1)"

test(requestArgumentClause2) on "hello\n (1)"
test(expression2) on "hello\n (1)"
test(codeSequence2) on "hello\n (1)"
print "prog..."
test(program2) on "hello\n (1)"
test2 "hello\n (1)" 
test2 "hello(1,\n   2)"
test2 "hello(1)\n   world(1)"
test2 "hello\n    (1)\n          world(1)" 
test2 "hello\n    (9)\n    world(9)"   
test2 "1"
test2 "     2"

test2 ";;hello(1,2) world(1,2)" 
test2 "hello(1,2) error(1,2)"
test2 "\n\nhello(1,2) error(1,2)" //need to eat whole blank lines...?
test2 "\n     hello(1);" 
test2 "hello(1,\n   2);"
test(not(program)) on "   hello(1,\n2);"
test(not(program)) on "   hello(1)\nworld(1);"
test(( expression ~ end)) on "hello(2)\n   vworld(2)"
test(not( expression ~ end)) on "   hello(2)\nworld(2)"
test(not ( wso ~ requestArgumentClause ~ wso ~ requestArgumentClause ~ end)) on "   hello(3)\nworld(31)"
test(expression ~ end) on "hello(1)\n   world(1)"
test2 "1\n ;"
test2 "hello(1,2) world(1,2);"
test2 "hello(1,2) world(1,2);hello(1,2) world(1,2);"
test2 "hello(1,2) world(1,2)\nhello(1,2) world(1,2);"
test2 "hello(1,2)\n   world(1,2)\nhello(1,2)\n world(1,2);"
test2 "hello(1);hello(2);hellow(3);"
test2 "hello(1);   hello(2);   hellow(3);"
test2 ";;"
test2 "helllo(hello(1))"
test2 "hello(a(1) b(2) c(3))world(d(e(4))); reset(brexit(10,11)) boris(69);foo(42);"

printPassedTests := true

test2 "hello(1)\nhello(2)\nhello(3)"
test2 "hello(1)\nhello(2)\nhello(3)"
test2 "  hello(1)\n  hello(2)\n  hello(3)"  //fails"
test2 "hello(1)\n  world(2)\n  world(3)"  //fails"

test2 "hello(1)\n  world(2)\nhello(3)" 

test2 "hello(1)"
test2 "hello(\n         1);\nhello(2)"
test(not(program2)) on "     hello(\n 1)"
test2 "hello(\n 1)"


print "last========================================"


test2 "hello(1,2,3)"
test2 "hello(1,\n       2,\n             3)"
test2 "hello(\n          1,\n          2,\n          3)"

//portray "     hello(\n          1,\n          2,\n          3)"
//portray "     Tello(\n          1,\n          2,\n          3)"
test2 "hello(\n          1,\n          2,\n          3)"

print "errr"
tabStop := -1
tabLine := -1
def hw123 =  "     hello(\n          1,\n          2,\n          3)"
test (not(requestArgumentClause2)) on (hw123) //no leading whitespace
test (opt(wso) ~ tab( requestArgumentClause2)) on (hw123)
test (opt(wso) ~ ( requestArgumentClause2)) on (hw123)
test (opt(wso) ~ requestWithArgs2) on (hw123)
test (expression2) on (hw123)
test (codeSequence2) on (hw123)
test (program2) on (hw123)
print "rrre"

test2 "     hello(\n          1,\n          2,\n          3)"

test(not(program2)) on "     hello(\n          1,\n 2,\n          3)"
test2 "hello( 1,\n  2,\n  3,\n  4)"
test2 "hello( 1,\n  2,3,\n  4)"
test2 "hello( 1,\n  2,3,\n  4); foo(5)"

test2 "  hello(1,2)\n    world(3,4)\ngoodbye(1,2)"
