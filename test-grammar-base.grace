dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports

// basics: semicolons, spaces...

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

testProgramOn "0" correctly "99z1"
testProgramOn "\"NOT FAILED AND DONE\"" correctly "99z2"

testProgramOn "0x" wrongly "n1"
testProgramOn "0x1234" correctly "n1"
testProgramOn "2xDEADBEEF" correctly "n1"
testProgramOn "4xDEADBEEF" correctly "n1"

testProgramOn "0x" wrongly "n1"
testProgramOn "0x1234" correctly "n1"
testProgramOn "2xDEADBEEF" correctly "n1"
testProgramOn "4xDEADBEEF" correctly "n1"
