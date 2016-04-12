dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports

//test method declarations

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
testProgramOn "method foo[[T]](a) \{a; b; c\}" correctly "013c"
testProgramOn "method foo[[TER,MIN,US]](a, b, c) \{a; b; c\}" correctly "013c2"
testProgramOn "method foo[[TXE]](a : T) \{a; b; c\}" correctly "013c3"
testProgramOn "method foo[[T,U,V]](a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c4"
testProgramOn "method foo[[T,U]](a : T, b : T, c : T) foo(a : T, b : T, c : T) -> T \{a; b; c\}" correctly "013c6"
testProgramOn "method foo(a : T, b : T, c : T) foo[[T,U]](a : T, b : T, c : T) -> T \{a; b; c\}" wrongly "013c6"
testProgramOn "method foo[[]](a : T, b : T, c : T) foo[[T,U]](a : T, b : T, c : T) -> T \{a; b; c\}" wrongly "013c6"
testProgramOn "method foo[[]](a : T, b : T, c : T)  \{a; b; c\}" wrongly "013c6"
testProgramOn "method foo[[]] \{a; b; c\}" wrongly "013c6"

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


testProgramOn "method [](x) \{a; b; c\}" wrongly "013d1" //was correct
testProgramOn "method [](x, y, z) \{a; b; c\}" wrongly "013d1" //was correct
testProgramOn "method []=(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [=](x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []foo(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method foo[](x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [][]***&%&(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [](x: T) \{a; b; c\}" wrongly "013d2"  //was correct
testProgramOn "method [](x) -> T \{a; b; c\}" wrongly "013d3"  //was correct
testProgramOn "method [](x : T) -> T \{a; b; c\}" wrongly "013d3" //was correctly
testProgramOn "method [] -> T \{a; b; c\}" wrongly "013d5"
testProgramOn "method [](x,y) T \{a; b; c\}" wrongly "013d6"
testProgramOn "method [](x : T, y : T) -> T \{a; b; c\}" wrongly "013d7" //was correct
testProgramOn "method [](x) [](y) -> T \{a; b; c\}" wrongly "013d8"


testProgramOn "method []:=(x) \{a; b; c\}" wrongly "013d1" 
testProgramOn "method []:=(x, y, z) \{a; b; c\}" wrongly "013d1" //was correct
testProgramOn "method [] :=(x) \{a; b; c\}" wrongly "013d1" //was correct
testProgramOn "method [] :=(x, y, z) \{a; b; c\}" wrongly "013d1" //was correct
testProgramOn "method []:==(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method [=](x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []:=foo(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method foo[]:=(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []:=[]:=***&%&(x) \{a; b; c\}" wrongly "013d1"
testProgramOn "method []:=(x: T) \{a; b; c\}" wrongly "013d2" //was correct
testProgramOn "method []:=(x) -> T \{a; b; c\}" wrongly "013d3" //was correct
testProgramOn "method []:=(x : T) -> T \{a; b; c\}" wrongly "013d3" //was correct
testProgramOn "method []:= -> T \{a; b; c\}" wrongly "013d5"
testProgramOn "method []:=(x,y) T \{a; b; c\}" wrongly "013d6"
testProgramOn "method []:=(x : T, y : T) -> T \{a; b; c\}" wrongly "013d7" //was correct
testProgramOn "method []:=(x) []:=(y) -> T \{a; b; c\}" wrongly "013d8"



test (genericFormals) on "" correctly "gf1"
test (genericFormals) on "[[T]]" correctly "gf2"
test (genericFormals) on "  [[T]]  " correctly "gf3"
test (lBrace ~ genericFormals) on "\{[[T]]  " correctly "gf4"
test (lBrace ~ genericFormals) on "\{ [[T]]  " correctly "gf5"
test (lBrace ~ genericFormals ~ rBrace) on "\{[[T]]\}" correctly "gf4"
test (lBrace ~ genericFormals ~ rBrace) on "\{ [[T]]\}" correctly "gf5"

test (lBrace ~ genericFormals ~ arrow ~ rBrace)
  on "\{ -> \}"  correctly "013b0"
test (lBrace ~ genericFormals ~ arrow ~ rBrace)
  on "\{ [[A]] -> \}"  correctly "013b1"
test (lBrace ~ genericFormals ~ arrow ~ innerCodeSequence ~ rBrace)
  on "\{ -> foo\}"  correctly "013b2"
test (lBrace ~ genericFormals ~ arrow ~ innerCodeSequence ~ rBrace)
  on "\{ [[T]] -> foo\}"  correctly "013b3"

testProgramOn "\{ [[T]] -> foo\}" correctly "013gb1"
testProgramOn "\{ [[T]] x : A -> foo\}" correctly "013gb2"
test (blockFormals ~ arrow) on  "x : A, y:B->" correctly "013gb3preX"
test (blockFormals ~ arrow) on  "x : A, y:B ->" correctly "013gb3preY"
test (blockFormals ~ arrow) on  "x : A, y:B->" correctly "013gb3preYNS"

testProgramOn "\{ x : A, y:B -> foo\}" correctly "013gb3pre0"
testProgramOn "\{ x:A, y:B -> foo\}" correctly "013gb3pre2"
testProgramOn "\{x:A,y:B->foo\}" correctly "013gb3pre2NS"
testProgramOn "\{x,y->foo\}" correctly "013gb3pre2NT"
testProgramOn "\{x->foo\}" correctly "013gb3pre2NT1"
testProgramOn "\{x:A,y:B->foo\}" correctly "013gb3pre1T"


test (blockFormals ~ arrow) on  "   x : A, y:B ->" wrongly "013gb3preZ"
test (opt(ws) ~ blockFormals ~ arrow) on  "   x : A, y:B ->" correctly "013gb3preA"

test (genericFormals ~ blockFormals ~ arrow) on  "->" correctly "013gb3preB1"
test (genericFormals ~ blockFormals ~ arrow) on  "[[A]]->" correctly "013gb3preB2"
test (genericFormals ~ blockFormals ~ arrow) on  "a,b->" correctly "013gb3preB3"
test (genericFormals ~ blockFormals ~ arrow) on  "a:X,b:Y->" correctly "013gb3preB3"

test (genericFormals ~ blockFormals ~ arrow) on  "[[A,B]]->" correctly "013gb3preC1"
test (genericFormals ~ blockFormals ~ arrow) on  "[[A]]a->" correctly "013gb3preC2"
test (genericFormals ~ blockFormals ~ arrow) on  "[[A,B]]a,b->" correctly "013gb3preC3"
test (genericFormals ~ blockFormals ~ arrow) on  "[[A,B]]a:X,b:Y->" correctly "013gb3preC3"




testProgramOn "\{ [[T]] x : A, y:B -> foo\}" correctly "013gb3"
testProgramOn "\{ [[T]] foo\}" wrongly "013gb4" 
testProgramOn "\{ [[ T ]] foo \}" wrongly "013gb5" 
testProgramOn "\{ [[T]] foo -> \}" correctly "013gb6" 



testProgramOn "method foo:= [[T]] (x : T) \{ x \}" correctly "013g1"
testProgramOn "method foo:= [[T,U]] (x : T) \{ x \}" correctly "013g2"
testProgramOn "method foo:= [[T,U]] (x : T) -> T \{ x \}" correctly "013g3"
testProgramOn "method - [[T]] (x : T) -> T \{ x \}" correctly "O13g4"
testProgramOn "method prefix- [[T]] -> T \{ x \}" correctly "O13g5"
testProgramOn "method prefix- [[T]] \{ x \}" correctly "O13g6"





//evil list syntax (not quite sure why it ended up here)
testProgramOn "[]" correctly "014a"
testProgramOn "[1,2,3]" correctly "014b"
testProgramOn "[ \"a\", \"a\", \"a\", 1]" correctly "014c"
testProgramOn "[ \"a\", \"a\", \"a\", 1" wrongly "014d"
testProgramOn "[ \"a\" \"a\" \"a\" 1]" wrongly "014e"
test (lineupLiteral ~ semicolon) on "[][3][4][5];" wrongly "014f0" //was correct
test (lineupLiteral ~ semicolon) on "[];" correctly "014f1" //was correct
test (program ~ semicolon) on "[][3][4][5];" wrongly "014f2" //was correct
test (program ~ end) on "[][3][4][5];" wrongly "014f3" //was correct
testProgramOn "[][3][4][5]" wrongly "014f4" //was correct

