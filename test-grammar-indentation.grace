dialect "parserTestDialect"

currentIndentation := 1
test (codeSequence) on " var x := 4\n foo\n def b = 4\n bar\n baz\nbarf" correctly "013a2"
test (codeSequence ~ end) on " var x := 4\n foo\n def b = 4\n bar\n baz\nbarf" wrongly "013b2"
test (codeSequence ~ identifier) on " var x := 4\n foo\n 3+4\n def b = 4\n bar\n 1+2\n baz\n" correctly "013a3"
currentIndentation := 0

testProgramOn "method foo \{a;\n b;\n c;\n\}" correctly "X17c1"
testProgramOn "     method foo \{a;\n b;\n c;\n\}" wrongly "X17c2"
testProgramOn "method foo \{\n     a;\n     b;\n     c;\n\}" correctly "X17c3"

testProgramOn "method foo[[T]](a) where T < Foo; \{a;\n b;\n c;\n\}" correctly "X17d1"
testProgramOn "method foo[[T]](a) where T < Foo; \{ a\n b\n c\n\}" wrongly "X17d2"      //hmm
testProgramOn "method foo[[T]](a) where T < Foo; \{\n a\n b\n c\n\}" correctly "X17d3" 

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




testProgramOn "call(params[1].value)" wrongly "100z1"
test (expression ~ end) on "call(params[1].value)" wrongly "100z1"


testProgramOn "method x1 \{foo(3)\n    bar(2)\n    bar(2)\n    foo(4)\n\}" correctly "101a1"
testProgramOn "method x1 \{foo(3)\n    bar(2)\n    bar(2)\n    foo(4)\n  \}" wrongly "101a1x"
testProgramOn "method x2 \{foo(3) bar(2) bar(2)\}" correctly "101a2"
testProgramOn "method x3 \{\n                 foo(3)\n                     bar(2)\n                     bar(2)\n                 foo(4)  \n \}" correctly "101a3"
testProgramOn "method x2 \{\nfoo\nfoo\nfoo\n}\n" wrongly "102a1"


testProgramOn "foo" correctly "008i1"
testProgramOn "   foo" wrongly "008i11"
testProgramOn "foo;  bar" correctly "008i11a"
testProgramOn "   foo;  bar" wrongly "008i11b"
testProgramOn "   foo\n   bar" wrongly "008i12"
testProgramOn "foo\nbar" correctly "008i13"
