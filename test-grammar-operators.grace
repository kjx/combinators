dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports

//test expressions with operators, vars, defs...


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

testProgramOn "a * (* (* (* (* (* (* (* (* b))))))))" correctly "008k"
testProgramOn "a * * * * * * * * * b" wrongly "008k"


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

testProgramOn "!super" correctly "011"
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

testProgramOn "print (true && \{truemeth\} && \{true\})" correctly "Eelco1"
