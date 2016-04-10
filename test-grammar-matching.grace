dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports


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
