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

"========================================"
test (digitStringParser) on "123" correctly "1"

test (graceIdentifierParser) on "abc" correctly "2"


test (opt(wsp) ~ graceIdentifierParser) on "abc" correctly "3"

test (graceIdentifierParser ~ wsp ~ digitStringParser ~ wsp ~ graceIdentifierParser) on "abc 123 def" correctly "4"

test (wsp) on " 1"
test (wsp ~ numberLiteral) on " 1 "
test (wsp ~ numberLiteral) on " 1 1"
test (not (wsp ~ numberLiteral ~ end)) on " 1 1" 
test (wsp) on "   "
test (numberLiteral) on "1"
test (numberLiteral ~ end) on "15"
test (numberLiteral) on "1 1"
test (numberLiteral ~ wsp ~ numberLiteral ~ end) on "6 6"
test (numberLiteral ~ wsp ~ numberLiteral ~ opt(wsp) ~ end) on "7 7"
test (numberLiteral ~ wsx ~ numberLiteral ~ end) on "8 8"
test (numberLiteral ~ wsx ~ numberLiteral ~ opt(wsx) ~ end) on "9 9"
test (wsx) on " \n \n       \n    \n10"
test (wsx ~ numberLiteral) on "\n \n  \n   \n    2xxxxx"

print "subtests ========================================"
test (argumentsInParens) on "(1)"
test (argumentsInParens) on "(1,2)"
test (argumentsInParens) on "(1, 2)"
test (argumentsInParens) on "(1, 2, 3)"

test(numberLiteral ~ end) on "1"
test(not(numberLiteral ~ end)) on "1 2" 
test(not(numberLiteral ~ end)) on "1\n2"

test( requestArgumentClause) on "hello(3)   world(30)"
test( requestArgumentClause) on "hello(3)world(30)"
test( requestArgumentClause ~ requestArgumentClause) on "hello(3)   world(31)"
test( requestArgumentClause ~ requestArgumentClause ~ end) on "hello(3)   world(32)"
test( requestArgumentClause ~ opt(wsx) ~ requestArgumentClause ~ end) on "hello(3)\n \n   world(33)"
test(wsx ~ requestArgumentClause ~ opt(wsx) ~ requestArgumentClause) on "   hello(3)\n      world(34)"


print "indetation ========================================"
test (indentAssert(0)) on ""
test (numberLiteral ~ indentAssert(0)) on "1xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(1)) on " 12xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(2)) on "  13xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(3)) on "   14xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(1)) on "\n 15xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(2)) on "\n  16xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(3)) on "\n   17xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(4)) on "  \n   \n    18xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(2)) on "\n  \n       \n    \n  19xxxxx"
test (rep(symbol " " | symbol "\n") ~ numberLiteral ~ indentAssert(3)) on "      \n         \n   20xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(3)) on "\n   21xxxxx"
test (wsx ~ numberLiteral ~ indentAssert(16)) on "                22xxxxx"

test (wsx ~ numberLiteral ~ indentAssert(2)) on "\n  \n       \n    \n  23xxxxx"





print "exper sem ========================================"
test "hello(1)" 
test "hello(1,2)"
test "hello(1) world(1)"
test "hello(1)world(1)"
test "1"
test "hello(1,2) world(1,2)"
test "hello(1);" 
test "hello(1,2);"
test "hello(1)world(1);"
test "1;"
test "hello(1,2) world(1,2);"
test "hello(1);hello(2);hellow(3);"
test "hello(1);   hello(2);   hellow(3);"
test ";;"
test "helllo(hello(1))"
test "hello(a(1) b(2) c(3))world(d(e(4))); reset(brexit(10,11)) boris(69);foo(42);"

print "exper linebreakright ========================================"

test(numberLiteral ~ wsx ~ numberLiteral ~ end) on "1 1"
test(numberLiteral ~ wsx ~ numberLiteral ~ end) on "1\n 2"
test(not(numberLiteral ~ wsx ~ numberLiteral ~ end)) on "    1\n 3"
test(wsx ~ numberLiteral) on "    1\n      4"
test(wsx ~ numberLiteral ~ wsx) on "    2\n      4"
test(wsx  ~ numberLiteral ~ wsx ~ numberLiteral ~ end) on "    3\n      4"
test(not(numberLiteral ~ wsx ~ numberLiteral ~ end)) on "      1\n    5"
test(not (numberLiteral ~ wsx ~ numberLiteral ~ end)) on "1\n600   "
test(numberLiteral ~ wsx ~ numberLiteral) on "1\n 60"
test(not(numberLiteral ~ wsx ~ numberLiteral)) on "1\n60"
test(numberLiteral ~ wsx ~ numberLiteral ~ end) on "1\n 7"

test(not(expression ~ end)) on "1\n(1)"
test "hello\n (1)" 
test "hello(1,\n   2)"
test "hello(1)\n   world(1)"
test "hello\n    (1)\n          world(1)" 
//test "hello\n    (9)\n    world(9)"   //BREAKS
test "1"
test "     2"

test ";;hello(1,2) world(1,2)" 
test "\n\nhello(1,2) error(1,2)" //need to eat whole blank lines...?
test "\n     hello(1);" 
test "hello(1,\n   2);"
test(not(program)) on "   hello(1,\n2);"
test(not(program)) on "   hello(1)\nworld(1);"
test(( expression ~ end)) on "hello(2)\n   vworld(2)"
test(not( expression ~ end)) on "   hello(2)\nworld(2)"
test(not ( wsx ~ requestArgumentClause ~ wsx ~ requestArgumentClause ~ end)) on "   hello(3)\nworld(31)"
test(expression ~ end) on "hello(1)\n   world(1)"
test "1\n ;"
test "hello(1,2) world(1,2);"
test "hello(1);hello(2);hellow(3);"
test "hello(1);   hello(2);   hellow(3);"
test ";;"
test "helllo(hello(1))"
test "hello(a(1) b(2) c(3))world(d(e(4))); reset(brexit(10,11)) boris(69);foo(42);"


test "hello(1)\nhello(2)\nhello(3)"
test "hello(1)\nhello(2)\nhello(3)"
test "  hello(1)\n  hello(2)\n  hello(3)"

test "hello(1)\n  world(2)\nhello(3)" // not sure why this one works


test(requestArgumentClause ~
        opt(wsx) ~
        requestArgumentClause ~
        ( semicolon | line("same" | "left")) ~
        requestArgumentClause ~ end)
   on "hello(1)\n  world(2)\nhello(3)" // not sure why this one works

test "hello(1)\n  world(2)\n   world(3)"


print "line ========================================"

test( lineAssertionParser(0) ) on ""
test((token "x") ~ lineAssertionParser(1) ) on "xyz"
test((token "xy") ~ lineAssertionParser(1) ) on "xyz"
test((token "xyz") ~ lineAssertionParser(1) ) on "xyz"

test(wsn ~ (token "x") ~ lineAssertionParser(1) ) on "      x"
test(wsn ~ (token "x") ~ wsn ~ (token "y") ~ lineAssertionParser(1) ) on "      x   y"
test(wsn ~ (token "x") ~ lineAssertionParser(2) ) on "\nx"
test(wsn ~ (token "x") ~ lineAssertionParser(3) ) on " \n \nx"
test(wsn ~ (token "x") ~ wsn ~ (token "y") ~ lineAssertionParser(5) ) on "\n\nx\n\ny"
test(wsn ~ (token "x") ~ wsn ~ (token "y") ~ lineAssertionParser(1) ) on " x y"


print "lout ========================================"

test( token "x" ~ token "y" ~ token "z" ~ end ) on "xyz"
test( token "x" ~ tab( token "y" ~ token "z" ~ end )) on "xyz"
test( token "x" ~ tab( token "y") ~ token "z" ~ end ) on "xyz"
test( tabAssertionParser(-1,-1) ~
      token "x" ~ tab( token "y") ~ token "z" ~ end ~
      tabAssertionParser(-1,-1)) on "xyz"
test( tabAssertionParser(-1,-1) ~
      token "x" ~ tab( tabAssertionParser(0,1) ~ token "y") ~
      token "z" ~ end ~
      tabAssertionParser(-1,-1)) on "xyz"
test( tabAssertionParser(-1,-1) ~
      token "x" ~ token "y" ~ tab( tabAssertionParser(0,1)) ~
      token "z" ~ end ~
      tabAssertionParser(-1,-1)) on "xyz"

test( token "   " ~ 
      token "x" ~ token "y" ~ 
      token "z" ~ end ~
      tabAssertionParser(-1,-1)) on "   xyz"
test( tabAssertionParser(-1,-1) ~ token "   " ~
      token "x" ~ tab( tabAssertionParser(3,1) ~ token "y") ~
      token "z" ~ end ~
      tabAssertionParser(-1,-1)) on "   xyz"
test( tabAssertionParser(-1,-1) ~ token "   " ~
      token "x" ~ token "y" ~ tab( tabAssertionParser(3,1)) ~
      token "z" ~ end ~
      tabAssertionParser(-1,-1)) on "   xyz"
test( tabAssertionParser(-1,-1) ~ tab( tabAssertionParser(3,1)) ~
      token "   " ~ 
      token "x" ~ token "y" ~ 
      token "z" ~ end ~
      tabAssertionParser(-1,-1)) on "   xyz"

test( token "aa" ~ token "\n " ~ token "b" ~ token "\n " ~ token "c" ~
       end ) on "aa\n b\n c"
test( token "aa" ~ token "\n " ~ tabAssertionParser(-1,-1) ~
       token "b" ~ token "\n " ~ token "c" ~ tabAssertionParser(-1,-1) ~
       end ) on "aa\n b\n c"
test( token "aa" ~ tab( token "\n " ~ tabAssertionParser(0,1) ~
       token "b" ~ token "\n " ~ token "c" ~ tabAssertionParser(0,1) ~
       end ) ) on "aa\n b\n c"
test( token "aa" ~ tab( token "\n " ~ tabAssertionParser(0,1) ~
       token "b" ~ tab( token "\n " ~ token "c" ~ tabAssertionParser(1,2)) ~
       end ) ) on "aa\n b\n c"

test( offside ~ token "o" ~ end ) on " o"
test( offside ~ token "o" ~ end ) on "     o"
test( offside ~ token "o" ~ end ) on "\n o"
test( offside ~ token "o" ~ end ) on " \no"
test( offside ~ token "o" ~ end ) on "\n \n o"
test( offside ~ token "o" ~ end ) on "\n   \n \n     \n\n o"
test( offside ~ token "o" ~ end ) on "\n \n \n     o"
test( offside ~ token "o" ~ end ) on "     \n\no"




def semiNL = ( semicolon | newline )
def abcd = opt(offside) ~ token "a" ~
             tab( offside ~ token "b" ~ offside ~ token "c" ) ~
             semiNL ~ opt(offside) ~ token "d"

test (offside) on " a b c\nd"
test (opt(offside)) on " a b c\nd"
test (opt(offside)) on "a b c\nd"
test (abcd) on "a b c\nd"
test (abcd) on "a b c;d"
test (abcd) on "a\n  b\n  c\nd"
test (abcd) on "  a\n    b\n    c\nd"
test (not(abcd)) on "a b c d"
test (not(abcd)) on "a b\n c d"
test (not(abcd)) on "a b c d"
test (not(abcd)) on "a\n\nb c d"
test (abcd) on "a\n   b\n   c\nd"


def evil1 = "a\nb\nc d"

test (not(abcd)) on (evil1)
test (opt(offside)) on (evil1)
test (opt(offside) ~ token "a") on (evil1)
test (opt(offside) ~ token "a" ~ offside ~ token "b") on (evil1)
test (not(opt(offside) ~ token "a" ~ offside ~ token "b" ~ semicolon)) on (evil1)
test ((opt(offside) ~ token "a" ~ offside ~ token "b" ~ semiNL)) on (evil1)
test (opt(offside) ~ token "a" ~ offside ~ token "b" ~ offside) on (evil1)
test (opt(offside) ~ token "a" ~ offside ~ token "b" ~ offside ~ token "c") on (evil1)

//print"portrayal========================================"

//portray "a\n  b\n  b\n"
//portray "a\n  T\n    c\n    c\nd     \n          c"
//portray "  a\n    T  t  t\n      c\n    c\nd\n"
//portray "   Taa\n   bbb\ncccccc"
