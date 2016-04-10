dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports


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

testProgramOn "class Foo \{ inherits Foo; \}" wrongly "015ia"
testProgramOn "class Foo \{ inherit Foo; \}" correctly "015ia"
testProgramOn "class Foo \{ inherit Foo; a; b; c \}" correctly "015ib"
testProgramOn "class Foo \{ inherit Foo(3,4); method a \{\}; method b \{\}; method c \{\}\}" correctly "015ib"
testProgramOn "class Foo \{ inherit Foo(3,4); def x = 0; var x := 19; a; b; c \}" correctly "015ic"
testProgramOn "class Foo(a,b) \{ inherit Foo<X>(4); a; b; c;  \}" correctly "015id"
testProgramOn "class Foo(a : A, b : B) \{ inherit goobles; a; b; c;  \}" correctly "015ie"
testProgramOn "class Foo<A>(a : A, b : B) new(a : A, b : B) \{ inherit OttDtraid; a; b; c;  \}" correctly "015if"
testProgramOn "class Foo<A, B>(a : A, b : B) \{ inherit Foo(2) new(4); a; b; c;  \}" correctly "015ig"
testProgramOn "class Foo \{ inherit; a; b; c \}" wrongly "015ih"





