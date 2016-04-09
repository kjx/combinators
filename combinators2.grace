dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports


//////////////////////////////////////////////////
// Grace Parser Tests

print "------: starting parser tests defs"

def t001 = stringInputStream("print(\"Hello, world.\")",1)
def t001s = stringInputStream("print(\"Hello, world.\")",7)
def t001c = stringInputStream("print(\"Hello, world.\")",8)
def t001ss = stringInputStream("print \"Hello, world.\"",1)
def t001b = stringInputStream("print \{ foo; bar; \}",1)

def t002 = stringInputStream("hello",1)
def t003 = stringInputStream("print(\"Hello, world.\") print(\"Hello, world.\")" ,1)
def t003a = stringInputStream("print(\"Hello, world.\")print(\"Hello, world.\")" ,1)

print "------: starting parser tests"

//testing semicolon insertion

test ( semicolon ~ end ) on ";" correctly "XS1"
test ( semicolon ~ end ) on "\n" correctly "XS2"
test ( semicolon ~ end ) on "\n " correctly "XS3"
test ( semicolon ~ end ) on " \n" correctly "XS3a"
test ( semicolon ~ end ) on " \n " correctly "XS4"
test ( semicolon ~ end ) on ";\n" correctly "XS5"

test ( repsep( methodHeader ~ methodReturnType, newLine)) on "foo\n" correctly "X16d1"
test ( repsep( methodHeader ~ methodReturnType, newLine)) on "foo\nbar\n" correctly "X16d2"
test ( repsep( methodHeader ~ methodReturnType, newLine)) on "foo\nbar\nbaz" correctly "X16d3"

test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo\n" correctly "X16d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo\nbar\n" correctly "X16d2"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo\nbar\nbaz" correctly "X16d3"

test (codeSequence ~ end) on "foo\n" correctly "X13a1"
test (codeSequence ~ end) on "foo(\n" wrongly "X13x1"
test (codeSequence ~ end) on "foo\nbar\n" correctly "X13a11"
test (codeSequence ~ end) on "foo\nbar\nbaz" correctly "X13a12"
test (codeSequence ~ end) on "foo(x)\n  bar(x)\n" correctly "X13a13"
test (ws ~ identifier ~ end) on "\n x" correctly "X13a13.1"
test (ws ~ identifier ~ ws ~ identifier ~ end) on "\n   x\n   x" correctly "X13a13.2"
test (ws ~ end) on " " correctly "X13a13.3"
test (ws ~ end) on "  " correctly "X13a13.4"
test (ws ~ identifier ~ end) on "   \n     x" correctly "X13a13.5"
test (ws ~ identifier ~ end) on "   \n       x" correctly "X13a13.6"
test (ws ~ identifier ~ end) on "\n xx" correctly "X13a13.7"
test (codeSequence ~ end) on "foo(x)\n  bar(x)\n  baz(x)" correctly "X13a14"
test (codeSequence ~ identifier) on "var x := 4\nfoo\ndef b = 4\nbar\nbaz" correctly "013a2z"

currentIndentation := 1
test (codeSequence ~ identifier) on " var x := 4\n foo\n def b = 4\n bar\n baz" correctly "013a2"
test (codeSequence ~ identifier) on " var x := 4\n foo\n 3+4\n def b = 4\n bar\n 1+2\n baz\n" correctly "013a3"
currentIndentation := 0

testProgramOn "method foo \{a;\n b;\n c;\n\}" correctly "X17c1"
testProgramOn "     method foo \{a;\n b;\n c;\n\}" wrongly "X17c2"
testProgramOn "method foo \{\n     a;\n     b;\n     c;\n\}" correctly "X17c3"

testProgramOn "method foo<T>(a) where T < Foo; \{a;\n b;\n c;\n\}" correctly "X17d1"
testProgramOn "method foo<T>(a) where T < Foo; \{ a\n b\n c\n\}" wrongly "X17d2"      //hmm
testProgramOn "method foo<T>(a) where T < Foo; \{\n a\n b\n c\n\}" correctly "X17d3" 

//index          123 45678 90123
//indent         111 22222 0000" 
def indentStx = " 11\n  22\nnone"

test (ws ~ (token "1") ~ indentAssert(1)) on (indentStx) correctly "I20t1"
test (ws ~ (token "11") ~  (token "\n") ~ ws ~ indentAssert(2)) on (indentStx) correctly "I20t2"
test (ws ~ (token "11") ~ (token "\n") ~ ws ~ (token("22")) ~ (token "\n") ~ (token("no")) ~ indentAssert(0)) on (indentStx) correctly "I20t3"
test (ws ~ (token "11") ~  semicolon ~ indentAssert(2)) on (indentStx) wrongly "I20t4"
test (ws ~ (token "11") ~  semicolon ~ symbol("22")) on (indentStx) wrongly "I20t4a"
test (ws ~ (token "11") ~  semicolon ~ symbol("22") ~ semicolon) on (indentStx) wrongly "I20t4b"
test (ws ~ (token "11") ~ semicolon ~ (symbol("22")) ~ semicolon ~ (symbol("no")) ~ indentAssert(0)) on (indentStx) wrongly "I20t5"


print "done"

// return

test {symbol("print").parse(t001).succeeded}
    expecting(true)
    comment "symbol print"    
test {newLine.parse(t001).succeeded}
    expecting(false)
    comment "newLine"    
test {rep(anyChar).parse(t001c).succeeded}
    expecting(true)
    comment "anyChar"    
test {rep(anyChar).parse(t001c).next.position}
    expecting(14)
    comment "anyChar posn"    
test {rep(stringChar).parse(t001c).succeeded}
    expecting(true)
    comment "stringChar"    
test {rep(stringChar).parse(t001c).next.position}
    expecting(21)
    comment "stringChar posn"    
test {stringLiteral.parse(t001s).succeeded}
    expecting(true)
    comment "stringLiteral"    
test {program.parse(t001).succeeded}
     expecting(true)
     comment "001-print"
test(requestWithArgs ~ end) on("print(\"Hello World\")") correctly("001-RWA")
test(requestWithArgs ~ end) on("print \"Hello World\"") correctly("001-RWA-noparens")
test(implicitSelfRequest ~ end) on("print(\"Hello World\")") correctly("001-ISR")
test(implicitSelfRequest ~ end) on("print \"Hello World\"") correctly("001-ISR-noparens")
test(expression ~ end) on("print(\"Hello World\")") correctly("001-Exp")
test(expression ~ end) on("print \"Hello World\"") correctly("001-Exp-noparens")

test {program.parse(t002).succeeded}
     expecting(true)
     comment "002-helloUnary"
test {program.parse(t003).succeeded}
     expecting(true)
     comment "003-hello hello"
test {program.parse(t003).succeeded}
     expecting(true)
     comment "003a-hellohello"
test {program.parse(t001ss).succeeded}
     expecting(true)
     comment "001ss-stringarg"
test {program.parse(t001b).succeeded}
     expecting(true)
     comment "001b-blockarg"



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

print "      : woot" 

test (typeExpression) on "  " correctly "008type1"
test (typeExpression ~ end) on "   " correctly "008type1"
test (typeExpression ~ end) on "Integer" correctly "008type2"
test (typeExpression ~ end) on "  Integer  " correctly "008type3"

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
testProgramOn "foo" correctly "008i1"
testProgramOn "   foo" wrongly "008i11"
testProgramOn "foo;  bar" correctly "008i11a"
testProgramOn "   foo;  bar" wrongly "008i11b"
testProgramOn "   foo\n   bar" wrongly "008i12"
testProgramOn "foo\nbar" correctly "008i13"
testProgramOn "\{ result := result ++ string.at(i) \}" correctly "008i2"
testProgramOn "\{ result := result ++ string.at(i) \}" correctly "008i3"
testProgramOn "\{ result := result ++ string.at(i); \}" correctly "008i3"
testProgramOn "for (position .. endPosition) do \{ i : Number -> result := result ++ string.at(i); \}" correctly "008j"
testProgramOn " for (position .. endPosition) do \{ i : Number -> result := result ++ string.at(i); \}" wrongly "008j2"
testProgramOn " for (position .. endPosition) do \{  i : Number -> result := result ++ string.at(i); \}" wrongly "008j3"
testProgramOn "a * * * * * * * * * b" correctly "008k"

test (genericActuals ~ end) on "" correctly "009"
test (genericActuals ~ end) on "<T>" correctly "009"
test (genericActuals ~ end) on "<T,A,B>" correctly "009"
test (genericActuals ~ end) on "<T,A<B>,T>" correctly "009"
test (genericActuals ~ end) on "<T, A<B> , T>" correctly "009"
test (genericActuals ~ end) on "<A & B>" correctly "009"
test (genericActuals ~ end) on "<A&B>" correctly "009"
test (lGeneric ~ opt(ws) ~ stringLiteral ~ opt(ws) ~ comma ~ opt(ws) ~ stringLiteral ~ opt(ws) ~ rGeneric ~ end) on "< \"foo\", \"bar\" >" correctly "009b"
test (lGeneric ~ opt(ws) ~ stringLiteral ~ opt(ws) ~ comma ~ opt(ws) ~ stringLiteral ~ opt(ws) ~ rGeneric ~ end) on "<\"foo\",\"bar\">" correctly "009b"
test (lGeneric ~ stringLiteral ~ opt(ws) ~ comma ~ opt(ws) ~ stringLiteral ~ rGeneric ~ end) on "<\"foo\" , \"bar\">" correctly "009b"
test (lGeneric ~ stringLiteral ~ opt(ws) ~ comma ~ opt(ws) ~ stringLiteral ~ rGeneric ~ end) on "<\"foo\",\"bar\">" correctly "009b"
test (genericActuals ~ end) on "< \"foo\", \"bar\" >" correctly "009c"
test (genericActuals ~ end) on "<\"foo\",\"bar\">" correctly "009c"
test (genericActuals ~ end) on "< A , B >" correctly "009c"
test (genericActuals ~ end) on "<A ,B >" correctly "009c"
test (genericActuals ~ end) on "< A, B>" correctly "009c"
test (genericActuals ~ end) on "    < A, B>" wrongly "009d"

testProgramOn "foo(34)" correctly "009"
testProgramOn "foo<T>" correctly "009"
testProgramOn "foo<T>(34)" correctly "009"
testProgramOn "foo<T,A,B>(34)" correctly "009"
testProgramOn "foo<T>(34) barf(45)" correctly "009"
testProgramOn "foo<T,A,B>(34) barf(45)" correctly "009"
testProgramOn "foo<T>" correctly "009"
testProgramOn "foo<T,A,B>" correctly "009"
testProgramOn "run(a < B, C > 1)" wrongly "009tim-a"
testProgramOn "a < B, C > 1" wrongly "009tim-b"
testProgramOn "a<B,C>(1)" correctly "009tim-c"
testProgramOn "run(a < B, C >(1))" correctly "009tim-d"

testProgramOn "a<B,C>" correctly "009eelco-a"
testProgramOn "a<B>" correctly "009eelco-b"
testProgramOn "m(a<B,C>(3))" correctly "009eelco-c"  /// particularly evil and ambiguous

testProgramOn "m((a<B),(C>(3)))" correctly "009eelco-d"  /// disambiguated
testProgramOn "m((a<B,C>(3)))" correctly "009eelco-e"  /// disambiguated

testProgramOn "1*2+3" correctly "010"
testProgramOn "1+2*3" correctly "010"
testProgramOn "1+2-3+4" correctly "010"
testProgramOn "5*6/7/8" correctly "010"
testProgramOn "1*3-3*4" correctly "010"
testProgramOn "!foo.bar" correctly "010"
testProgramOn "!foo.bar * zarp" correctly "010"
testProgramOn "1 %% 2 * 3 %% 4 + 5" correctly "010"
testProgramOn "1 %% 2 ** 3 %% 4 ++ 5" wrongly "010"
testProgramOn "1 ?? 2 !! 3 $$ 4" wrongly "010"

print "need tests for unary methods calls, stopping nesting"

testProgramOn "1*2+3" correctly "010a"
testProgramOn "1+2*3" correctly "010a"
testProgramOn "1 @ 2+3" correctly "010a"
testProgramOn "1 + 2 @ 3" correctly "010a"
testProgramOn "1 @ 2*3" correctly "010a"
testProgramOn "1 * 2 @ 3" correctly "010a"
testProgramOn "1 @ 2*3 + 4" correctly "010a"
testProgramOn "1 * 2 @ 3 + 4" correctly "010a"


testProgramOn "foo[10]" correctly "010"
testProgramOn "foo[10,20]" correctly "010"
testProgramOn "foo[\"10\"]" correctly "010"
testProgramOn "foo[14+45]" correctly "010"
testProgramOn "foo[bar]" correctly "010"
testProgramOn "foo[bar.baz]" correctly "010"
testProgramOn "foo[10][20][30]" correctly "010"
testProgramOn "foo[bar(1) baz(2)]" correctly "010"
testProgramOn "foo[bar[10]]" correctly "010"
testProgramOn "foo[bar[10].baz[e].zapf]" correctly "010"

testProgramOn "super" wrongly "011"
testProgramOn "return super" wrongly "011"
testProgramOn "super.foo" correctly "011"
testProgramOn "super.foo.bar" correctly "011"
testProgramOn "super.foo(1) bar(2)" correctly "011"
testProgramOn "super + 3" correctly "011"
testProgramOn "super +&^#%$ 3" correctly "011"
testProgramOn "super[3]" correctly "011"
testProgramOn "!super" correctly "011"

testProgramOn "def" wrongly "012"
testProgramOn "def x" wrongly "012"
testProgramOn "def x = " wrongly "012"
testProgramOn "def x := " wrongly "012"
testProgramOn "def x : T =" wrongly "012"
testProgramOn "def x : T := 4" wrongly "012"

testProgramOn "var" wrongly "012"
testProgramOn "var x = " wrongly "012"
testProgramOn "var x := " wrongly "012"
testProgramOn "var x : T :=" wrongly "012"
testProgramOn "var x : T = 4" wrongly "012"

testProgramOn "def x : T = 4" correctly "012"
testProgramOn "var x : T := 4" correctly "012"
testProgramOn "def x = 4" correctly "012"
testProgramOn "var x := 4" correctly "012"
testProgramOn "var x:=4" correctly "012"
test (varId ~ identifier ~ assign ~ numberLiteral) on "var x := 4" correctly "012"
test (varId ~ identifier ~ assign ~ expression) on "var x := 4" correctly "012"
test (varId ~ identifier ~ opt(assign ~ expression)) on "var x := 4" correctly "012"
test (varDeclaration) on "var xVarDec := 4" correctly "012"
test (declaration) on "var xDec := 4" correctly "012"
test (codeSequence) on "var xCodeSeq := 4" correctly "012"
test (program) on "var xParenProg := 4" correctly "012"
testProgramOn "var xProg := 4" correctly "012"
testProgramOn "var x : TTT := foobles.barbles" correctly "012"
testProgramOn "var x := foobles.barbles" correctly "012"

test (defId ~ identifier) on "def x" correctly "012d"
test (defId ~ identifier) on "def typeExpression" correctly "012d"
test (defId ~ identifier ~ equals) on "def typeExpression =" correctly "012d"
test (defId ~ identifier) on "def typeExpression = rule \{ trim(identifier) | opt(ws) \}" correctly "012d1"
test (defId ~ identifier ~ equals) on "def typeExpression = rule \{ trim(identifier) | opt(ws) \}" correctly "012d2"
test (defId ~ identifier ~ equals ~ expression) on "def typeExpression = rule \{ trim(identifier) | opt(ws) \}" correctly "012d3"
test (defDeclaration) on "def typeExpression = rule \{ trim(identifier) | opt(ws) \}" correctly "012d4"
test (declaration) on "def typeExpression = rule \{ trim(identifier) | opt(ws) \}" correctly "012d5"
testProgramOn "def typeExpression = rule \{ trim(identifier) | opt(ws) \}" correctly "012d6"
testProgramOn "rule \{ trim(identifier) | opt(ws) \}" correctly "012d7"
testProgramOn "rule ( trim(identifier) | opt(ws) )" correctly "012d8"

test (identifier) on "typeExpression" correctly "012d9"
test (identifier) on "superThing" correctly "012d9"
test (identifierString) on "typeExpression" correctly "012d10"
test (identifierString) on "superThing" correctly "012d10"

testProgramOn "var x := 4; foo; def b = 4; bar; baz" correctly "013a"
test (objectLiteral) on "object \{ \}" correctly "013a"
test (objectLiteral) on "object \{ var x := 4; foo; def b = 4; bar; baz \}" correctly "013a"
test (codeSequence) on "var x := 4; foo; def b = 4; bar; baz" correctly "013a"
test (codeSequence) on "var x := 4; foo; 3+4; def b = 4; bar; 1+2; baz;" correctly "013a"
testProgramOn "method foo \{a; b; c\}" correctly "013b"
testProgramOn "method foo \{a; b; c; \}" correctly "013b"
testProgramOn "method foo -> \{a; b; c\}" wrongly "013b2"
testProgramOn "method foo -> T \{a; b; c\}" correctly "013b3"
testProgramOn "method foo<T> \{a; b; c\}" correctly "013b4"
testProgramOn "method foo<T,V> \{a; b; c; \}" correctly "013b5"
testProgramOn "method foo<T> -> \{a; b; c\}" wrongly "013b6"
testProgramOn "method foo<T,V> -> T \{a; b; c\}" correctly "013b7"

test (methodHeader ~ end) on "foo" correctly "013c1"
test (firstArgumentHeader ~ end) on "foo(a)" correctly "013c11"
test (methodWithArgsHeader ~ end) on "foo(a)" correctly "013c11"
test (methodHeader ~ end) on "foo(a)" correctly "013c11"
test (firstArgumentHeader ~ end) on "foo(a,b)" correctly "013c12"
test (methodWithArgsHeader ~ end) on "foo(a,b)" correctly "013c12"
test (methodHeader ~ end) on "foo(a,b)" correctly "013c12"
test (methodWithArgsHeader ~ end) on "foo(a,b) foo(c,d)" correctly "013c13"
test (methodHeader ~ end) on "foo(a,b) foo(c,d)" correctly "013c13"
test (methodHeader ~ end) on "foo(a,b) foo " wrongly "013c14"

testProgramOn "method foo(a) \{a; b; c\}" correctly "013c"
testProgramOn "method foo(a, b, c) \{a; b; c\}" correctly "013c2"
testProgramOn "method foo(a : T) \{a; b; c\}" correctly "013c3"
testProgramOn "method foo(a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c4"
testProgramOn "method foo(a, b, c) -> T \{a; b; c\} " correctly "013c5"
testProgramOn "method foo(a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c6"
testProgramOn "method foo(a : T, b : T, c : T) foo(a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c6"
testProgramOn "method foo(a, b, c) \{a; b; c\}" correctly "013c7"
testProgramOn "method foo(a, b, c) bar(d,e)\{a; b; c\}" correctly "013c7"
testProgramOn "method foo(a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c8"
testProgramOn "method foo(a, b : T, c) -> F \{a; b; c\}" correctly "013c9"
testProgramOn "method foo<T>(a) \{a; b; c\}" correctly "013c"
testProgramOn "method foo<TER,MIN,US>(a, b, c) \{a; b; c\}" correctly "013c2"
testProgramOn "method foo<TXE>(a : T) \{a; b; c\}" correctly "013c3"
testProgramOn "method foo<T,U,V>(a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c4"
testProgramOn "method foo<T,U>(a : T, b : T, c : T) foo(a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c6"
testProgramOn "method foo(a : T, b : T, c : T) foo<T,U>(a : T, b : T, c : T) -> T \{a; b; c\}" wrongly "013c6"
testProgramOn "method foo<>(a : T, b : T, c : T) foo<T,U>(a : T, b : T, c : T) -> T \{a; b; c\}" wrongly "013c6"
testProgramOn "method foo<>(a : T, b : T, c : T)  \{a; b; c\}" wrongly "013c6"
testProgramOn "method foo<> \{a; b; c\}" wrongly "013c6"

testProgramOn "method +(x) \{a; b; c\}" correctly "013d1"
testProgramOn "method ==(x) \{a; b; c\}" correctly "013d1"
testProgramOn "method =(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method :=(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method ++***&%&(x) \{a; b; c\}" correctly "013d1"
testProgramOn "method +(x: T) \{a; b; c\}" correctly "013d2"
testProgramOn "method +(x) -> T \{a; b; c\}" correctly "013d3"
testProgramOn "method +(x : T) -> T \{a; b; c\}" correctly "013d3"
test (methodHeader) on "+ -> T" wrongly "013d5a"
testProgramOn "method + -> T \{a; b; c\}" wrongly "013d5"
testProgramOn "method +(x,y) T \{a; b; c\}" wrongly "013d6"
testProgramOn "method +(x : T, y : T) -> T \{a; b; c\}" wrongly "013d7"
testProgramOn "method +(x) +(y) -> T \{a; b; c\}" wrongly "013d8"

testProgramOn "method prefix+ \{a; b; c\}" correctly "013e1"
testProgramOn "method prefix + \{a; b; c\}" correctly "013e1"
testProgramOn "method prefix++***&%& \{a; b; c\}" correctly "013e1"
testProgramOn "method prefix ! \{a; b; c\}" correctly "013e1"
testProgramOn "method prefix+ -> \{a; b; c\}" wrongly "013e2"
testProgramOn "method prefix+(x) -> T \{a; b; c\}" wrongly "013e3"
testProgramOn "method prefix+(x : T) -> T \{a; b; c\}" wrongly "013e3"
testProgramOn "method prefix+ -> T \{a; b; c\}" correctly "013e5"
testProgramOn "method prefix+(x,y) T \{a; b; c\}" wrongly "013e6"
testProgramOn "method prefix+(x : T, y : T) -> T \{a; b; c\}" wrongly "013e7"
testProgramOn "method prefix+(x) +(y) -> T \{a; b; c\}" wrongly "013e8"
testProgramOn "method prefix(x) -> T \{a; b; c\}" wrongly "013e9"
testProgramOn "method prefix:= \{a; b; c\}" wrongly "013e1"
testProgramOn "method prefix := \{a; b; c\}" wrongly "013e1"
testProgramOn "method prefix[] \{a; b; c\}" wrongly "013e1"

//what should the *grammar* say about assignment op return values
test (assignmentMethodHeader) on "foo:=(a)" correctly "013a1"
test (assignmentMethodHeader) on "foo := ( a : T )" correctly "013a1"
test (assignmentMethodHeader) on "foo" wrongly "013a1"
test (assignmentMethodHeader) on "foobar:=" wrongly "013a1"
testProgramOn "method foo:=(a) \{a; b; c\}" correctly "013f"
testProgramOn "method bar :=(a) \{a; b; c\}" correctly "013f2"
testProgramOn "method foo:=(a : T) \{a; b; c\}" correctly "013f3"
testProgramOn "method foo :=(a : T) -> T \{a; b; c\}" correctly "013f4"
testProgramOn "method foo:=(a) -> T \{a; b; c\} " correctly "013f5"
testProgramOn "method foo:=(a : T, b : T, c : T) -> T \{a; b; c\}" wrongly "013f6"
testProgramOn "method foo:=(a : T, b : T, c : T) foo(a : T, b : T, c : T) -> T \{a; b; c\}" wrongly "013f6"
testProgramOn "method foo:=(a, b, c) \{a; b; c\}" wrongly "013f7"
testProgramOn "method foo:=(a, b, c) bar(d,e)\{a; b; c\}" wrongly "013f7"
testProgramOn "method foo:=(a : T, b : T, c : T) -> T \{a; b; c\}" wrongly "013f8"
testProgramOn "method foo:=(a, b : T, c) -> F \{a; b; c\}" wrongly "013f9"


testProgramOn "method [](x) \{a; b; c\}" correctly "013d1"
testProgramOn "method [](x, y, z) \{a; b; c\}" correctly "013d1"
testProgramOn "method []=(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [=](x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []foo(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method foo[](x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [][]***&%&(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [](x: T) \{a; b; c\}" correctly "013d2"
testProgramOn "method [](x) -> T \{a; b; c\}" correctly "013d3"
testProgramOn "method [](x : T) -> T \{a; b; c\}" correctly "013d3"
testProgramOn "method [] -> T \{a; b; c\}" wrongly "013d5"
testProgramOn "method [](x,y) T \{a; b; c\}" wrongly "013d6"
testProgramOn "method [](x : T, y : T) -> T \{a; b; c\}" correctly "013d7"
testProgramOn "method [](x) [](y) -> T \{a; b; c\}" wrongly "013d8"


testProgramOn "method []:=(x) \{a; b; c\}" correctly "013d1"
testProgramOn "method []:=(x, y, z) \{a; b; c\}" correctly "013d1"
testProgramOn "method [] :=(x) \{a; b; c\}" correctly "013d1"
testProgramOn "method [] :=(x, y, z) \{a; b; c\}" correctly "013d1"
testProgramOn "method []:==(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [=](x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []:=foo(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method foo[]:=(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []:=[]:=***&%&(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []:=(x: T) \{a; b; c\}" correctly "013d2"
testProgramOn "method []:=(x) -> T \{a; b; c\}" correctly "013d3"
testProgramOn "method []:=(x : T) -> T \{a; b; c\}" correctly "013d3"
testProgramOn "method []:= -> T \{a; b; c\}" wrongly "013d5"
testProgramOn "method []:=(x,y) T \{a; b; c\}" wrongly "013d6"
testProgramOn "method []:=(x : T, y : T) -> T \{a; b; c\}" correctly "013d7"
testProgramOn "method []:=(x) []:=(y) -> T \{a; b; c\}" wrongly "013d8"

//evil list syntax
testProgramOn "[]" correctly "014a"
testProgramOn "[1,2,3]" correctly "014b"
testProgramOn "[ \"a\", \"a\", \"a\", 1]" correctly "014c"
testProgramOn "[ \"a\", \"a\", \"a\", 1" wrongly "014d"
testProgramOn "[ \"a\" \"a\" \"a\" 1]" wrongly "014e"
testProgramOn "[][3][4][5]" correctly "014f"

//  "Old" Class syntax
//
// testProgramOn "class Foo \{ \}" correctly "015a"
// testProgramOn "class Foo \{ a; b; c \}" correctly "015b"
// testProgramOn "class Foo \{ def x = 0; var x := 19; a; b; c \}" correctly "015c"
// testProgramOn "class Foo \{ a, b -> a; b; c;  \}" correctly "015d"
// testProgramOn "class Foo \{ a : A, b : B -> a; b; c;  \}" correctly "015e"
// testProgramOn "class Foo \{ <A> a : A, b : B -> a; b; c;  \}" correctly "015f"
// testProgramOn "class Foo \{ <A, B> a : A, b : B -> a; b; c;  \}" correctly "015g"
// testProgramOn "class Foo " wrongly "015h"
// testProgramOn "class Foo a; b; c" wrongly "015i"
// testProgramOn "class Foo \{ <A> def x = 0; var x := 19; a; b; c \}" wrongly "015j"
// testProgramOn "class Foo \{ -> a; b; c;  \}" correctly "015k"
// testProgramOn "class Foo \{ a : <A>, b : <B> -> a; b; c;  \}" wrongly "015l"
// testProgramOn "class Foo \{ -> <A> a : A, b : B  a; b; c;  \}" wrongly "015m"


// "new" aka "Alt" Class syntax
testProgramOn "class Foo \{ \}" correctly "015a"
testProgramOn "class Foo \{ a; b; c \}" correctly "015b"
testProgramOn "class Foo \{ method a \{\}; method b \{\}; method c \{\}\}" correctly "015b"
testProgramOn "class Foo \{ def x = 0; var x := 19; a; b; c \}" correctly "015c"
testProgramOn "class Foo(a,b) \{ a; b; c;  \}" correctly "015d"
testProgramOn "class Foo(a : A, b : B) \{ a; b; c;  \}" correctly "015e"
testProgramOn "class Foo<A>(a : A, b : B) new(a : A, b : B) \{ a; b; c;  \}" correctly "015f"
testProgramOn "class Foo<A, B>(a : A, b : B) \{ a; b; c;  \}" correctly "015g"
testProgramOn "class Foo " wrongly "015h"
testProgramOn "class Foo a; b; c" wrongly "015i"
testProgramOn "class Foo<A> \{ def x = 0; var x := 19; a; b; c \}" wrongly "015j"
testProgramOn "class Foo \{ -> a; b; c;  \}" wrongly "015k"
testProgramOn "class Foo \{ a : <A>, b : <B> -> a; b; c;  \}" wrongly "015l"
testProgramOn "class Foo \{ -> <A> a : A, b : B  a; b; c;  \}" wrongly "015m"

testProgramOn "class Foo \{ inherits Foo; \}" correctly "015ia"
testProgramOn "class Foo \{ inherits Foo; a; b; c \}" correctly "015ib"
testProgramOn "class Foo \{ inherits Foo(3,4); method a \{\}; method b \{\}; method c \{\}\}" correctly "015ib"
testProgramOn "class Foo \{ inherits Foo(3,4); def x = 0; var x := 19; a; b; c \}" correctly "015ic"
testProgramOn "class Foo(a,b) \{ inherits Foo<X>(4); a; b; c;  \}" correctly "015id"
testProgramOn "class Foo(a : A, b : B) \{ inherits goobles; a; b; c;  \}" correctly "015ie"
testProgramOn "class Foo<A>(a : A, b : B) new(a : A, b : B) \{ inherits OttDtraid; a; b; c;  \}" correctly "015if"
testProgramOn "class Foo<A, B>(a : A, b : B) \{ inherits Foo(2) new(4); a; b; c;  \}" correctly "015ig"
testProgramOn "class Foo \{ inherits; a; b; c \}" wrongly "015ih"

testProgramOn "3+4.i" correctly "015z"
test (expression) on "" wrongly "015zz"

test (typeId) on "type" correctly "16aa1"
test (typeId ~ end) on "type" correctly "16aa2"

test (typeLiteral) on "type \{ \}" correctly "016cl"
test (typeLiteral) on "type \{ foo \}" correctly "016cl1"
test (typeLiteral) on "type \{ foo; bar; baz; \}" correctly "016cl2"
test (typeLiteral) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016cl3"

test (typeExpression ~ end) on "type \{ \}" correctly "016cx1"
test (typeExpression ~ end) on "type \{ foo \}" correctly "016cx2"
test (typeExpression ~ end) on "type \{ foo; bar; baz; \}" correctly "016cx3"
test (typeExpression ~ end) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016cx4"
test (typeExpression ~ end) on "\{ \}" correctly "016cx5"
test (typeExpression ~ end) on "\{ foo \}" correctly "016cx5"
test (typeExpression ~ end) on "\{ foo; bar; baz; \}" correctly "016cx7"
test (typeExpression ~ end) on "\{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016cx8"

test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo -> T" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "prefix!" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "+(x : T)" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo;" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo; bar;" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo; bar; baz" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo<T> -> T" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo<T>" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "prefix<T> !" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "+(x : T)" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo<T>;" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo<T>; bar<T>;" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo; bar<T>; baz<T>" correctly "016d1"
test (typeId ~ lBrace ~ repdel( methodHeader ~ methodReturnType, semicolon) ~ rBrace) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016e"
test (repdel( methodHeader ~ methodReturnType, semicolon)) on "prefix!; +(other : SelfType); baz(a,b) baz(c,d)" correctly "016e"
test (typeExpression ~ end) on "T" correctly "016c"
test (lGeneric ~ typeExpression ~ rGeneric ~ end) on "<T>" correctly "016c"
test (typeExpression ~ end) on "type \{ \}" correctly "016c"
test (typeExpression ~ end) on "type \{ foo \}" correctly "016c"
test (typeExpression ~ end) on "type \{ foo; bar; baz; \}" correctly "016d"
test (typeExpression ~ end) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016e"
test (typeExpression ~ end) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016e"
test (typeExpression ~ end) on "" correctly "016a"
test (typeExpression ~ end) on "T" correctly "016a"
test (typeExpression ~ end) on "=T" wrongly "016a"
test (typeExpression ~ end) on "!T" wrongly "016a"
test (typeExpression ~ end) on "T<A,B>" correctly "016c"
test (typeExpression ~ end) on "T<B>" correctly "016c"
test (typeExpression ~ end) on "A & B" correctly "016c"
test (typeExpression ~ end) on "A & B & C" correctly "016c"
test (typeExpression ~ end) on "A & B<X> & C" correctly "016ct"
test (typeExpression ~ end) on "A | B<X> | C" correctly "016ct"
test (expression ~ end) on "A & B(X) & C" correctly "016cx"
test (expression ~ end) on "A | B(X) | C" correctly "016cx"
test (expression ~ end) on "A & B<X> & C" correctly "016cx"
test (expression ~ end) on "A | B<X> | C" correctly "016cx"
test (typeExpression ~ end) on "A & B | C" wrongly "016c"
test (typeExpression ~ end) on "A & type \{ foo(X,T) \}" correctly "016c"
test (typeExpression ~ end) on " \"red\"" correctly "016t1"
test (typeExpression ~ end) on " \"red\" | \"blue\" | \"green\"" correctly "016t1"
test (typeExpression ~ end) on " 1 | 2 | 3 " correctly "016t1"
test (expression ~ end) on "\"red\"|\"blue\"|\"green\"" correctly "016t1"
test (expression ~ end) on " \"red\" | \"blue\" | \"green\"" correctly "016t1"
test (expression ~ end) on " 1 | 2 | 3 " correctly "016t1"
test (typeExpression ~ end) on "super.T<A,B>" correctly "016pt"
test (typeExpression ~ end) on "super.A & x.B" correctly "016pt"
test (typeExpression ~ end) on "super.A & a.B & a.C" correctly "test"
test (typeExpression ~ end) on "super.A & B<super.X> & C" correctly "016ptt"
test (typeExpression ~ end) on "A | B<X> | C" correctly "016ptt"
test (typeExpression ~ end) on "T<super.A.b.b.B.c.c.C,super.a.b.c.b.b.B>" correctly "016pt"
test (typeExpression ~ end) on "a<X,super.Y,z.Z>.a.A & b.b.B" correctly "016pt"
test (typeExpression ~ end) on "a<X,super.Y,z.Z>.a.A & b.b.B & c.c.C" correctly "016pt"
test (typeExpression ~ end) on "a<X,super.Y,z.Z>.a.A & b.b.B<X> & c.c.C" correctly "016ptt"
test (typeExpression ~ end) on "a<X,super.Y,z.Z>.a.A | b.b.B<X> | c.c.C" correctly "016ptt"
test (typeDeclaration ~ end) on "type A = B;" correctly "016td1"
test (typeDeclaration ~ end) on "type A=B;" correctly "016td2"
test (typeDeclaration ~ end) on "type A<B,C> = B & C;" correctly "016td3"
test (typeDeclaration ~ end) on "type A<B> = B | Noo | Bar;" correctly "016td4"
test (typeDeclaration ~ end) on "type Colours = \"red\" | \"green\" | \"blue\";" correctly "016td5"
test (typeDeclaration ~ end) on "type FooInterface = type \{a(A); b(B); \};" correctly "016td6"
test (typeDeclaration ~ end) on "type FooInterface = \{a(A); b(B); \};" correctly "016td7"
test (typeDeclaration ~ end) on "type PathType = super.a.b.C;" correctly "016td8"
test (typeDeclaration ~ end) on "type GenericPathType<A,X> = a.b.C<A,X>;" correctly "016td9"

test (whereClause ~ end) on "where T <: Sortable;" correctly "017a1"
test (whereClause ~ end) on "where T <: Foo<A,B>;" correctly "017a2"
test (whereClause ~ end) on "where T <: Foo<A,B>; where T <: Sortable<T>;" correctly "017a3"
testProgramOn "method foo<T>(a) where T < Foo; \{a; b; c\}" correctly "017c1"
testProgramOn "method foo<TER,MIN,US>(a, b, c) where TERM <: MIN <: US; \{a; b; c\}" correctly "017c2"
testProgramOn "method foo<TXE>(a : T) where TXE <: TXE; \{a; b; c\}" correctly "017c3"
testProgramOn "method foo<T,U,V>(a : T, b : T, c : T) -> T where T <: X<T>; \{a; b; c\}" correctly "017c4"
testProgramOn "method foo<T,U>(a : T, b : T, c : T) foo(a : T, b : T, c : T) -> T where T <: T; \{a; b; c\}" correctly "017c6"
testProgramOn "class Foo<A>(a : A, b : B) new(a : A, b : B) where T <: X; \{ a; b; c;  \}" correctly "017f"
testProgramOn "class Foo<A, B>(a : A, b : B) where A <: B; \{ a; b; c;  \}" correctly "017g"
testProgramOn "class Foo<A, B>(a : A, b : B) where A <: B; where A <: T<A,V,\"Foo\">; \{ a; b; c;  \}" correctly "017g"
testProgramOn "class Foo<A, B>(a : A, b : B) where A <: B; where A <: T<A,V,\"Foo\">; \{ method a where T<X; \{ \}; method b(a : Q) where T <: X; \{ \}; method c where SelfType <: Sortable<Foo>; \{ \} \}" correctly "017g"

test (matchBinding ~ end) on "a" correctly "018a1"
test (matchBinding ~ end) on "_" correctly "018a1"
test (matchBinding ~ end) on "0" correctly "018a1"
test (matchBinding ~ end) on "(a)" correctly "018a1"
test (matchBinding ~ end) on "\"Fii\"" correctly "018a1"
test (matchBinding ~ end) on "a : Foo" correctly "018a1"
test (matchBinding ~ end) on "a : Foo(bar,baz)" correctly "018a1"
test (matchBinding ~ end) on "a : Foo(_ : Foo(a,b), _ : Foo(c,d))" correctly "018a1"

test (blockLiteral ~ end) on "\{ _ : Foo -> last \}" correctly "018b1"
test (blockLiteral ~ end) on "\{ 0 -> \"Zero\" \}" correctly "018b"
test (blockLiteral ~ end) on "\{ s:String -> print(s) \}" correctly "018b"
test (blockLiteral ~ end) on " \{ (pi) -> print(\"Pi = \" ++ pi) \}" correctly "018c"
test (blockLiteral ~ end) on " \{ _ : Some(v) -> print(v) \}" correctly "018d"
test (blockLiteral ~ end) on " \{ _ : Pair(v : Pair(p,q), a : Number) -> print(v) \}" correctly "018e"
test (blockLiteral ~ end) on " \{ _ -> print(\"did not match\") \}" correctly "018f"

testProgramOn "\{ _ : Foo -> last \}" correctly "018b1"
testProgramOn "\{ 0 -> \"Zero\" \}" correctly "018b"
testProgramOn "\{ s:String -> print(s) \}" correctly "018b"
testProgramOn " \{ (pi) -> print(\"Pi = \" ++ pi) \}" correctly "018c"
testProgramOn " \{ _ : Some(v) -> print(v) \}" correctly "018d"
testProgramOn " \{ _ : Pair(v : Pair(p,q), a : Number) -> print(v) \}" correctly "018e"
testProgramOn " \{ _ -> print(\"did not match\") \}" correctly "018f"


testProgramOn "call(params[1].value)" correctly "100z1"
test (expression ~ end) on "call(params[1].value)" correctly "100z1"


testProgramOn "method x1 \{foo(3)\n    bar(2)\n    bar(2)\n    foo(4)\n\}" correctly "101a1"
testProgramOn "method x1 \{foo(3)\n    bar(2)\n    bar(2)\n    foo(4)\n  \}" wrongly "101a1x"
testProgramOn "method x2 \{foo(3) bar(2) bar(2)\}" correctly "101a2"
testProgramOn "method x3 \{\n                 foo(3)\n                     bar(2)\n                     bar(2)\n                 foo(4)  \n \}" correctly "101a3"
testProgramOn "method x2 \{\nfoo\nfoo\nfoo\n}\n" wrongly "102a1"


testProgramOn "0" correctly "99z1"
testProgramOn "\"NOT FAILED AND DONE\"" correctly "99z2"

testProgramOn "print (true && \{truemeth\} && \{true\})" correctly "Eelco1"



print "Done tests"


