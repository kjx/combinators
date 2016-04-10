dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports

//expressions (mostly)

test (expression) on "" wrongly "015zz"

testProgramOn("self") correctly("004-self")
testProgramOn("(self)") correctly("004p-self")
testProgramOn("(hello)") correctly("004p-hello")
test(expression ~ end) on("foo") correctly("005-foo")
test(expression ~ end) on("(foo)") correctly("005-foo")
test(primaryExpression ~ end) on("(foo)") correctly("005-pri(foo)")
test(argumentsInParens ~ end) on("(foo)") correctly("005-aIP(foo)")
test(requestArgumentClause ~ end) on("print(\"Hello\")") correctly("005-racqhello")

test(identifier ~ end) on("foo") correctly("006id")
test(expression ~ end) on("foo") correctly("006exp")
test(primaryExpression ~ end) on("foo") correctly("006primaryExp")
test(addOp ~ end) on("+") correctly("006plus is addOp")

test(expression ~ end) on("foo+foo") correctly("006exp")
test(expression ~ end) on("foo + foo") correctly("006exp")
test(addOp ~ end) on("+") correctly("006")
test(multExpression ~ end) on("foo") correctly("006mult")
test(addExpression ~ end) on("foo + foo") correctly("006add")
test(expression ~ end) on("foo + foo + foo") correctly("006expr")
test(expression ~ end) on("foo * foo + foo") correctly("006expr")
test(expression ~ end) on("((foo))") correctly("006expr")
test(parenExpression ~ end ) on("((foo))") correctly("006paren")
test(otherOp ~ end) on("%%%%%") correctly("006other")
test(opExpression ~ end) on("foo") correctly "006OpExprFOO"
test(opExpression ~ end) on("foo %%%%% foo") correctly("006OpExprTWO")
test(opExpression ~ end) on("foo %%%%% foo %%%%% foo") correctly("006OpExpr")
test(identifier ~ otherOp ~ identifier ~ otherOp ~ identifier ~ end) on("foo %%%%% foo %%%%% foo") correctly("006OpExprHACK")
test(identifier ~ otherOp ~ identifier ~ otherOp ~ identifier ~ end) on("foo%%%%%foo%%%%%foo") correctly("006OpExprHACKnows")
test(expression ~ end) on("foo %%%%% foo %%%%% foo") correctly("006expr")
test(parenExpression ~ end) on("(foo + foo)") correctly("006parenE")
test(lParen ~ identifier ~ addOp ~ identifier ~ rParen ~ end) on("(foo + foo)") correctly("006hack")
test(lParen ~ primaryExpression ~ addOp ~ primaryExpression ~ rParen ~ end) on("(foo + foo)") correctly("006hackPrimary")
test(lParen ~ multExpression ~ addOp ~ multExpression ~ rParen ~ end) on("(foo + foo)") correctly("006hackMult")
test(lParen ~ rep1sep(multExpression, addOp) ~ rParen ~ end) on("(foo + foo)") correctly("006hackRepSep")
test(lParen ~ repsep(multExpression, addOp) ~ rParen ~ end) on("(foo+foo)") correctly("006hackRepSep2")
test(lParen ~ multExpression ~ repsep(addOp, multExpression) ~ rParen ~ end) on("(foo+foo)") wrongly("006hackRepSep2F")
test(lParen ~ multExpression ~ repsep(addOp, multExpression) ~ rParen ~ end) on("(foo + foo)") wrongly("006hackRepSepF")
test(expression ~ end) on("(foo + foo)") correctly("006")
test(expression ~ end) on("(foo + foo) - foo") correctly("006")
test(expression ~ end) on("(foo + foo - foo)") correctly("006")
test(expression ~ end) on("(foo+foo)-foo") correctly("006")
test(expression ~ end) on("hello(foo+foo)") correctly("006")

testProgramOn "print(1)" correctly "006z1"
testProgramOn " print(1)" wrongly "006z2"
testProgramOn "print(  1     )" correctly "006z3"
testProgramOn "print(1 + 2)" correctly "006z4"
testProgramOn "print(1+2)" correctly "006z5"
testProgramOn "print(1     +2    )" correctly "006z6"
testProgramOn "print(10)" correctly "006z7"
testProgramOn "print (10)" correctly "006z8"
testProgramOn "print(10)  print(10)" correctly "006z9"
testProgramOn "print(10)print(10)" correctly "006z10"
testProgramOn "print(10)print(10)" correctly "006z11"
testProgramOn "print(1+2) print (3 * 4)" correctly "006z12"
testProgramOn "foo(10) foo(11)" correctly "006z13"
testProgramOn "print(foo(10) foo(11))" correctly "006z14"
testProgramOn "print   ( foo ( 10 ) foo   ( 11 ) )" correctly "006z15"
testProgramOn "print(foo(10) foo(11) foo(12))" correctly "006z16"
testProgramOn "print(foo(10) foo(11)) print (3)" correctly "006z17"
testProgramOn "3*foo" correctly "006z18"
testProgramOn " 3 * foo" correctly "006z19"
testProgramOn "print(3*foo)" correctly "006z20"
testProgramOn "print(3*foo) print(5*foo)" correctly "006z21"
testProgramOn "4;5;6" correctly "006z22"
testProgramOn " 4 ; 5 ; 6   " correctly "006z23"
testProgramOn "print(4,5,6)" correctly "006z24"
testProgramOn "print((4;5;6))" correctly "006z25"
testProgramOn "print ( 4   , 5 , 6 ) " correctly "006z26"
testProgramOn "print ( ( 4 ; 5 ; 6 ) ) " correctly "006z27"
testProgramOn " foo ; bar ; baz   " correctly "006z28"
testProgramOn "foo;bar;baz" correctly "006z29"
testProgramOn "foo := 3" correctly "006a30"
testProgramOn "foo:=3" correctly "006a31"
testProgramOn " foo := 3 " correctly "006a32"
testProgramOn " foo := (3) " correctly "006a33"
testProgramOn "foo:=(3)" correctly "006a34"
testProgramOn "foo := 3+4" correctly "006a35"
testProgramOn "foo := 3*4" correctly "006a36"
testProgramOn "foo := baz" correctly "006a37"
testProgramOn "foo := baz.bar" correctly "006ay"
testProgramOn "car.speed := 30.mph" correctly "006az"

testProgramOn "foo" correctly "007"
test (unaryRequest ~ end) on "foo" correctly "007unary"
test (rep1sep(unaryRequest,dot) ~ end) on "foo" correctly "007rep1sep unary"
test (implicitSelfRequest ~ end) on "foo.foo" correctly "007ISR"
test (expression ~ end) on "foo.foo" correctly "007Exp"
testProgramOn "foo.foo" correctly "007"
testProgramOn " foo . foo " correctly "007"
testProgramOn "foo.foo(10)" correctly "007"
testProgramOn "foo.foo.foo" correctly "007"

test (numberLiteral ~ multOp ~ trim(identifier) ~ lParen ~ numberLiteral ~ rParen) on "3*foo(50)" correctly "007hack"
test (numberLiteral ~ multOp ~ requestWithArgs ~ end) on "3*foo(50)" correctly "007hack"
test (implicitSelfRequest ~ end) on "foo(50)" correctly "007ISR"
testProgramOn "3*foo(50)" correctly "007"
testProgramOn " 3 * foo ( 50 )" correctly "007"
testProgramOn "(foo(50))*3" correctly "007"
testProgramOn "(foo ( 50 ) * 3)" correctly "007"
testProgramOn "foo(50)*3" correctly "007"
testProgramOn "foo ( 50 ) * 3" correctly "007"
testProgramOn "print(3*foo(50))" correctly "007"
testProgramOn "print ( 3 * foo ( 50 ) )" correctly "007"
testProgramOn "print(foo(10) foo(11)) print (3 * foo(50))" correctly "007"
testProgramOn "foo.foo(40).foo" correctly "007"
testProgramOn "3+4.i" correctly "015z"

testProgramOn "b(t(r(o)), not(re))" correctly "008x1" 
testProgramOn "\{ rep1(dot ~ unaryRequest) ~ rep(opRequestXXX) ~ opt(dot ~ keywordRequest) \}" correctly "008x2"
testProgramOn " if (endPosition > string.size) then \{endPosition := string.size\}" correctly "008x2"
testProgramOn "  if ((n + position) <= (string.size + 1)) then \{return stringInputStream(string, position + n)\}" correctly "008x4"
testProgramOn "return (((c >= \"A\") && (c <= \"Z\"))          | ((c >= \"a\") && (c <= \"z\")))" correctly "008x5"
testProgramOn "\{drop(opt(ws)) ~ p ~ drop(opt(ws))\}" correctly "008x6" // OK ok JS, crashes on C
testProgramOn "drop(opt(ws)) ~ doubleQuote ~ rep( stringChar ) ~ doubleQuote " correctly "008x7"
testProgramOn "" correctly "008"


test (token("return") ~ end) on "return" correctly "008xr1"
test (token("return") ~ end) on " return" wrongly "008xr2"
test (returnStatement ~ end) on "return" correctly "008xr3"
test (returnStatement ~ end) on " return" wrongly "008xr4"
test (returnStatement ~ end) on "return (subParser.parse(in))" correctly "008xr5"
test (returnStatement ~ end) on "return (subParser.parse(in) .resultUnlessFailed)" correctly "008xr9"
test (returnStatement ~ end) on " return (subParser.parse(in))" wrongly "008xr10"
test (returnStatement ~ end) on " return (subParser.parse(in) .resultUnlessFailed)" wrongly "008xr11"

testProgramOn "return (subParser.parse(in) .resultUnlessFailed)" correctly "008x12"
testProgramOn "return (subParser.parse(in))" correctly "008x8"
testProgramOn "return (subParser.parse(in) .resultUnlessFailed)" correctly "008x9"
testProgramOn " return (subParser.parse(in))" wrongly "008x10"
testProgramOn " return (subParser.parse(in) .resultUnlessFailed)" wrongly "008x11"
testProgramOn "return (subParser.parse(in) .resultUnlessFailed)" correctly "008x12"
testProgramOn "(subParser.parse(in) .resultUnlessFailed)" correctly "008x13"
testProgramOn " \{f ->  return parseSuccess(in, \"\")\}" wrongly "008x14"
testProgramOn " \{ return parseSuccess(in, \"\")\}" wrongly "008x15"
testProgramOn " return (subParser.parse(in) .resultUnlessFailed \{f ->  return parseSuccess(in, \"\")\})" wrongly "008x16"
testProgramOn "return (subParser.parse(in) .resultUnlessFailed \{f ->  return parseSuccess(in, \"\")\})" correctly "008x17"

testProgramOn "a" correctly "007x"
testProgramOn "a b" wrongly "007x"
testProgramOn "a b c" wrongly "007x"
testProgramOn "a b c d" wrongly "007x"



test (otherOp) on ".." correctly "008a"
test (trim(rep1(operatorChar))) on ".." correctly "008b"
testProgramOn "position .. endPosition" correctly "008c"
testProgramOn "for (position .. endPosition)" correctly "008d"
testProgramOn "for (position .. endPosition) do (42)" correctly "008e"
testProgramOn "\{ i : Number -> result \}" correctly "008f"
testProgramOn "\{ result ++ string.at(i); \}" correctly "008g"
testProgramOn "\{ result := result \}" correctly "008h"
testProgramOn "\{ result := result; \}" correctly "008h1"
testProgramOn "\{ result := result\n \}" correctly "008h2"
testProgramOn "\{ result := result ++ string.at(i); \}" correctly "008i"
testProgramOn "\{ result := result ++ string.at(i) \}" correctly "008i2"
testProgramOn "\{ result := result ++ string.at(i) \}" correctly "008i3"
testProgramOn "\{ result := result ++ string.at(i); \}" correctly "008i3"
testProgramOn "for (position .. endPosition) do \{ i : Number -> result := result ++ string.at(i); \}" correctly "008j"
testProgramOn " for (position .. endPosition) do \{ i : Number -> result := result ++ string.at(i); \}" wrongly "008j2"
testProgramOn " for (position .. endPosition) do \{  i : Number -> result := result ++ string.at(i); \}" wrongly "008j3"




