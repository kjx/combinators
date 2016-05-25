dialect "parserTestDialect"
import "parsers2" as parsers
inherit parsers.exports 
import "grammar" as grammar
inherit grammar.exports


testProgramOn "class Foo \{ \}" correctly "015a"
testProgramOn "class Foo \{ a; b; c \}" correctly "015b"
testProgramOn "class Foo \{ method a \{\}; method b \{\}; method c \{\}\}" correctly "015b"
testProgramOn "class Foo \{ def x = 0; var x := 19; a; b; c \}" correctly "015c"
testProgramOn "class Foo(a,b) \{ a; b; c;  \}" correctly "015d"
testProgramOn "class Foo(a : A, b : B) \{ a; b; c;  \}" correctly "015e"
testProgramOn "class Foo[[A]](a : A, b : B) new(a : A, b : B) \{ a; b; c;  \}" correctly "015f"
testProgramOn "class Foo[[A, B]](a : A, b : B) \{ a; b; c;  \}" correctly "015g"
testProgramOn "class Foo " wrongly "015h"
testProgramOn "class Foo a; b; c" wrongly "015i"
testProgramOn "class Foo[[A]] \{ def x = 0; var x := 19; a; b; c \}" correctly "015j"
testProgramOn "class Foo [[A]] \{ def x = 0; var x := 19; a; b; c \}" correctly "0151j"
testProgramOn "class Foo \{ -> a; b; c;  \}" wrongly "015k"
testProgramOn "class Foo \{ a : [[A]], b : [[B]] -> a; b; c;  \}" wrongly "015l"
testProgramOn "class Foo \{ -> [[A]] a : A, b : B  a; b; c;  \}" wrongly "015m"

testProgramOn "class Foo \{ inherit Foo; \}" wrongly "015ia"
testProgramOn "class Foo \{ inherit Foo; \}" correctly "015ia"
testProgramOn "class Foo \{ inherit Foo; a; b; c \}" correctly "015ib"
testProgramOn "class Foo \{ inherit Foo(3,4); method a \{\}; method b \{\}; method c \{\}\}" correctly "015ib"
testProgramOn "class Foo \{ inherit Foo(3,4); def x = 0; var x := 19; a; b; c \}" correctly "015ic"
testProgramOn "class Foo(a,b) \{ inherit Foo[[X]](4); a; b; c;  \}" correctly "015id"
testProgramOn "class Foo(a : A, b : B) \{ inherit goobles; a; b; c;  \}" correctly "015ie"
testProgramOn "class Foo[[A]](a : A, b : B) new(a : A, b : B) \{ inherit OttDtraid; a; b; c;  \}" correctly "015if"
testProgramOn "class Foo[[A, B]](a : A, b : B) \{ inherit Foo(2) new(4); a; b; c;  \}" correctly "015ig"
testProgramOn "class Foo \{ inherit; a; b; c \}" wrongly "015ih"


test (aliasClause) on "alias x;" wrongly "alias1"
test (excludeClause) on "exclude x = y;" wrongly "alias1"
test (aliasClause) on "alias x = y;" correctly "alias1"
test (aliasClause) on "alias x(a) = y(a);" correctly "alias2"
test (aliasClause) on "alias x(a) x(a) = y(a) y(a);" correctly "alias3"
test (aliasClause) on "alias x(_) x(_) = y(_) y(_);" correctly "alias4"

testProgramOn "trait Foo \{ \}" correctly "trait1"
testProgramOn "trait Foo \{  a; b; c; \}" correctly "trait2"
testProgramOn "trait Foo \{ inherit Bar; a; b; c; \}" correctly "trait2"
testProgramOn "trait Foo \{ use Bar; a; b; c; \}" correctly "trait3"
testProgramOn "trait Foo \{ inherit Bar; use Baz; a; b; c; \}" correctly "trait4"
testProgramOn "trait Foo \{ use Bar; use Baz; a; b; c; \}" correctly "trait5"
testProgramOn "trait Foo \{ use Bar; exclude a;  ; a; b; c; \}" correctly "trait6"
testProgramOn "trait Foo \{use Bar; exclude a; exclude b; a; b; c; \}" correctly "trait7"
testProgramOn "trait Foo \{use Bar; alias a = oldXXXXXa; \}" correctly "trait9"
testProgramOn "trait Foo \{use Bar; alias a(XXXXX) = oldXXXXXa(XXXXX); \}" correctly "trait10"
testProgramOn "trait Foo \{use Bar; alias a = old_a; a; b; c; \}" correctly "trait11"
testProgramOn "trait Foo \{use Bar; alias a(_) = oldXXXXXa(_); a; b; c; \}" correctly "trait12"





