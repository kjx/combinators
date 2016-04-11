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

//can't redefine reserveed words

method circumfix[ *x ] { x }

testProgramOn "method foo \{\}" correctly "id1"
testProgramOn "method super \{\}" correctly "id1"
def reservedIDs = [ "class", "def", "dialect", "exclude", "import", "inherit", "interface", "is", "method", "object", "outer", "prefix", "required", "return", "trait", "type", "use", "var", "where" ]

for (reservedIDs) do { id -> 
  testProgramOn ("method " ++ id ++ " \{\}") wrongly "id1"
}


// module headers 
print "mdoule headers"
test (hashLine) on "" wrongly "hl0"
test (hashLine) on "#" correctly "hl1"
test (hashLine) on "#\n" correctly "hl1"
test (hashLine) on "#\n#\n" correctly "hl2"
test (hashLine) on "#a bc b" correctly "hl3"
test (hashLine) on "#!/bin/grace\n#\n#\n" correctly "hl4"

test (rep(hashLine)) on "" correctly "hl5"

test (importStatement) on "import \"foo\" as nickname;" correctly "mhi3"
test (reuseClause) on "inherit narf" wrongly "mhi31"
test (reuseClause) on "inherit narf;" correctly "mhi32"

test (importStatement) on "" wrongly "mhi4"
test (reuseClause) on "" wrongly "mhi5"

test (rep(importStatement | reuseClause)) on "import \"foo\" as nickname;" correctly "mhi3"
test (rep(importStatement | reuseClause)) on "inherit narf" correctly "mhi3"

test (moduleHeader) on "#!/bin/grace\n" correctly "mh1"
test (moduleHeader ~ end) on "#!/bin/grace\n" correctly "mh1"
test (moduleHeader ~ end) on "#\n#\n#\n" correctly "mh2"
test (moduleHeader ~ end) on "import \"foo\" as nickname;" correctly "mh3"
test (moduleHeader ~ end) on "import \"foo\" as nickname\nimport \"foo\" as nickname;" correctly "mh4" 
test (moduleHeader ~ end) on "inherit bar;" correctly "mh5"
test (moduleHeader ~ end) on "import \"foo\" as nickname\ninherit bar\n" correctly "mh6" 
test (moduleHeader) on "" correctly "mh0"

