dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports

//test generics 

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

testProgramOn "method foo \{a; b; c\}" correctly "013b"
testProgramOn "method foo \{a; b; c; \}" correctly "013b"
testProgramOn "method foo -> \{a; b; c\}" wrongly "013b2"
testProgramOn "method foo -> T \{a; b; c\}" correctly "013b3"
testProgramOn "method foo<T> \{a; b; c\}" correctly "013b4"
testProgramOn "method foo<T,V> \{a; b; c; \}" correctly "013b5"
testProgramOn "method foo<T> -> \{a; b; c\}" wrongly "013b6"
testProgramOn "method foo<T,V> -> T \{a; b; c\}" correctly "013b7"
