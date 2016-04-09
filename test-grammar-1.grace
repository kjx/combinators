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
test (codeSequence ~ end) on "var x := 4\nfoo\ndef b = 4\nbar\nbaz" correctly "013a2z"
