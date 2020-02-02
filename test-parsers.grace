dialect "parserTestDialect" 

def strm   = stringInputStream("Hello World",1)
def strm2  = stringInputStream("   Hello World",1)
def strmus = stringInputStream("_",1)
def strmab  = stringInputStream("abc4de'a123",1)
def strmas  = stringInputStream("a bcb", 1)
def strmnn  = stringInputStream("1234  ",1)
def strmnx  = stringInputStream("1234",1)
def strmxx  = stringInputStream("xxxxx",1)
def strmxc  = stringInputStream("xcxcxf",1)
def strmcx  = stringInputStream("xcxcf",1)
def strmx  = stringInputStream("xf",1)
def strmxcx  = stringInputStream("xcxf",1)

//index          123 45678 90123
//indent         111 22222 0000" 
def indentStx = " 11\n  22\nnone"

currentIndentation := 0
test { stringInputStream(indentStx, 1 ).indentation } expecting (1) comment "ix indent at start of line"
test { stringInputStream(indentStx, 3 ).indentation } expecting (1) comment "Indentation 2"
test { stringInputStream(indentStx, 4 ).indentation } expecting (1) comment "ix EOL belongs to previous line"
test { stringInputStream(indentStx, 5 ).indentation } expecting (2) comment "Indentation 5"
test { stringInputStream(indentStx, 10 ).indentation } expecting (0) comment "Indentation 10"
test { stringInputStream(indentStx, 7 ).indentation } expecting (2) comment "Indentation 1"
test { stringInputStream(indentStx, indentStx.size + 1 ).indentation } expecting (0) comment "Indentation Line end"
test { stringInputStream(indentStx, indentStx.size + 1 ).indentation } expecting (0) comment "Indentation Line end"
test { stringInputStream("print(1)", 3 ).indentation } expecting (0) comment "print(0)"

currentIndentation := 0
test { lineBreak("left").parse(stringInputStream(indentStx, 1)).succeeded } expecting (false) comment "cnl1"
test { lineBreak("left").parse(stringInputStream(indentStx, 2)).succeeded } expecting (false) comment "cnl2"
test { lineBreak("left").parse(stringInputStream(indentStx, 4)).succeeded } expecting (false) comment "cnl4"
test { lineBreak("left").parse(stringInputStream(indentStx, 5)).succeeded } expecting (false) comment "cnl5"
test { lineBreak("left").parse(stringInputStream(indentStx, 7)).succeeded } expecting (false) comment "cnl7"
test { lineBreak("left").parse(stringInputStream(indentStx, 9)).succeeded } expecting (false) comment "cnl9"
test { lineBreak("left").parse(stringInputStream(indentStx, 10)).succeeded } expecting (false) comment "cnl10"

currentIndentation := 1
test { lineBreak("left").parse(stringInputStream(indentStx, 4)).succeeded } expecting (false) comment "cnl4-1"
test { lineBreak("left").parse(stringInputStream(indentStx, 9)).succeeded } expecting (true) comment "cnl9-1"

currentIndentation := 2
test { lineBreak("left").parse(stringInputStream(indentStx, 4)).succeeded } expecting (false) comment "cnl4-2"
test { lineBreak("left").parse(stringInputStream(indentStx, 9)).succeeded } expecting (true) comment "cnl9-2"

currentIndentation := 0
test { lineBreak("right").parse(stringInputStream(indentStx, 4)).succeeded } expecting (true) comment "cnl4-3"
test { lineBreak("right").parse(stringInputStream(indentStx, 9)).succeeded } expecting (false) comment "cnl9-3"

currentIndentation := 1
test { lineBreak("right").parse(stringInputStream(indentStx, 4)).succeeded } expecting (true) comment "cnl4-4"
test { lineBreak("right").parse(stringInputStream(indentStx, 9)).succeeded } expecting (false) comment "cnl9-4"

currentIndentation := 2
test { lineBreak("right").parse(stringInputStream(indentStx, 4)).succeeded } expecting (false) comment "cnl4-5"
test { lineBreak("right").parse(stringInputStream(indentStx, 9)).succeeded } expecting (false) comment "cnl9-5"


currentIndentation := 0
test { lineBreak("same").parse(stringInputStream(indentStx, 4)).succeeded } expecting (false) comment "cnl4-6"
test { lineBreak("same").parse(stringInputStream(indentStx, 9)).succeeded } expecting (true) comment "cnl9-6"

currentIndentation := 1
test { lineBreak("same").parse(stringInputStream(indentStx, 4)).succeeded } expecting (false) comment "cnl4-7"
test { lineBreak("same").parse(stringInputStream(indentStx, 9)).succeeded } expecting (false) comment "cnl9-7"

currentIndentation := 2
test { lineBreak("same").parse(stringInputStream(indentStx, 4)).succeeded } expecting (true) comment "cnl4-8"
test { lineBreak("same").parse(stringInputStream(indentStx, 9)).succeeded } expecting (false) comment "cnl9-8"

currentIndentation := 0




    
def hello = (tokenParser("Hello"))
def dsp   = digitStringParser
def ini   = sequentialParser(
                graceIdentifierParser,
                sequentialParser(
                        whiteSpaceParser,
                        graceIdentifierParser))
def ini2  = (graceIdentifierParser) ~ 
                        (whiteSpaceParser) ~
                                                graceIdentifierParser
def alt   = alternativeParser(hello,dsp)
def alt2  = hello | dsp
def rpx   = repetitionParser(tokenParser("x"))
def rpx2  = rep(tokenParser("x"))
def rpx1  = rep1(tokenParser("x"))
def rs    = repsep(tokenParser("x"),tokenParser("c"))
def r1s   = rep1sep(tokenParser("x"),tokenParser("c"))
def rd    = repdel(tokenParser("x"),tokenParser("c"))
//////////////////////////////////////////////////
// test!

test {strm.take(5)} 
    expecting "Hello" 
    comment "strm.take(5)"
test {strm.rest(6).take(5)} 
    expecting "World" 
    comment "strm.rest(6).take(5)"
test {tokenParser("Hello").parse(strm).succeeded}
    expecting(true)
    comment "tokenParser(\"Hello\")"
test {tokenParser("Hellx").parse(strm).succeeded}
    expecting(false)
    comment "tokenParser(\"Hellx\")"
test {whiteSpaceParser.parse(strm).succeeded}
    expecting(false)
    comment "whiteSpaceParser"
test {whiteSpaceParser.parse(strm2).succeeded}
    expecting(true)
    comment "whiteSpaceParser"
test {whiteSpaceParser.parse(strm2).next.position}
    expecting(4)
    comment "whiteSpaceParser - eating 4"

//mistakenly though whiteSpaceParser did \n
//it doesn't it just does spaces and comments to eol
test (whiteSpaceParser ~ token "x") on " x"  correctly "ws1"
test (whiteSpaceParser ~ token "x") on "     x"  correctly "ws2"
test (whiteSpaceParser ~ token "x") on " x"  correctly "ws3"
test (whiteSpaceParser ~ token "x") on "          x"  correctly "ws4"
test (whiteSpaceParser ~ token "x") on "     xiuyaeriu"  correctly "ws5"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on " x y"  correctly "ws6"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on "    x      y"  correctly "ws7"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on "  x       yzzzz"  correctly "ws8"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on " x y"  correctly "ws9"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on "//foo\n  x  y"  correctly "ws10"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on "   //foo\nx   y    "  correctly "ws11"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on " x  //foo\n//foo\n    y"  correctly "ws12"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on "//foo\n x  //foo\n   y"  correctly "ws13"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on " x//foo\n //foo\ny"  correctly "ws14"
test (whiteSpaceParser ~ token "x" ~ whiteSpaceParser ~ token "y") on "//foo\n//foo\n//foo\n x y"  correctly "ws15"


test {isletter "A"} expecting (true) comment "isletter A"
test {isletter "F"} expecting (true) comment "isletter F"
test {isletter "Z"} expecting (true) comment "isletter Z"
test {isletter "a"} expecting (true) comment "isletter a"
test {isletter "f"} expecting (true) comment "isletter f"
test {isletter "z"} expecting (true) comment "isletter z"
test {isletter "$"} expecting (false) comment "isletter $"
test {isletter "0"} expecting (false) comment "isletter 0"
test {isletter "1"} expecting (false) comment "isletter 1"
test {isletter "9"} expecting (false) comment "isletter 9"
test {isdigit "A"} expecting (false) comment "isdigit A"
test {isdigit "F"} expecting (false) comment "isdigit F"
test {isdigit "Z"} expecting (false) comment "isdigit A"
test {isdigit "a"} expecting (false) comment "isdigit a"
test {isdigit "f"} expecting (false) comment "isdigit f"
test {isdigit "z"} expecting (false) comment "isdigit z"
test {isdigit "$"} expecting (false) comment "isdigit $"
test {isdigit "0"} expecting (true) comment "isdigit 0"
test {isdigit "1"} expecting (true) comment "isdigit 1"
test {isdigit "9"} expecting (true) comment "isdigit 9"
test {whiteSpaceParser.parse(strm2).next.position}
    expecting(4)
    comment "whiteSpaceParser - eating 4"
test {graceIdentifierParser.parse(strmus).next.position}
    expecting(2)
    comment "graceIdentifierParser  us - eating 2"
test {graceIdentifierParser.parse(strmus).succeeded}
    expecting(true)
    comment "graceIdentifierParser us OK"
test {graceIdentifierParser.parse(strmus).result}
    expecting("_")
    comment "graceIdentifierParser. us _"
test {graceIdentifierParser.parse(strmab).next.position}
    expecting(12)
    comment "graceIdentifierParser ab12 "
test {graceIdentifierParser.parse(strmab).succeeded}
    expecting(true)
    comment "graceIdentifierParser ab OK"
test {graceIdentifierParser.parse(strmab).result}
    expecting("abc4de'a123")
    comment "graceIdentifierParser.ab - eating 2"
test {graceIdentifierParser.parse(strmas).next.position}
    expecting(2)
    comment "graceIdentifierParser as pos"
test {graceIdentifierParser.parse(strmas).succeeded}
    expecting(true)
    comment "graceIdentifierParser as"
test {graceIdentifierParser.parse(strmas).result}
    expecting("a")
    comment "graceIdentifierParser as OK"
test {graceIdentifierParser.parse(strmnn).succeeded}
    expecting(false)
    comment "graceIdentifierParser nn - eating 1"
test {digitStringParser.parse(strmnn).next.position}
    expecting(5)
    comment "digitStringParser as pos"
test {digitStringParser.parse(strmnn).succeeded}
    expecting(true)
    comment "digitStringParser as"
test {digitStringParser.parse(strmnn).result}
    expecting("1234")
    comment "digitStringParser as OK"
test {digitStringParser.parse(strmnx).next.position}
    expecting(5)
    comment "digitStringParser as pos"
test {digitStringParser.parse(strmnx).succeeded}
    expecting(true)
    comment "digitStringParser as"
test {digitStringParser.parse(strmnx).result}
    expecting("1234")
    comment "digitStringParser as OK"
test {sequentialParser(ws,hello).parse(strm2).succeeded}
    expecting(true)
    comment "sequentialParser strm2 OK"    
test {sequentialParser(ws,hello).parse(strm).succeeded}
    expecting(false)
    comment "sequentialParser strm OK"    
test {sequentialParser(ws,hello).parse(strmab).succeeded}
    expecting(false)
    comment "sequentialParser strm3 OK"    
test {ini.parse(strmas).succeeded}
    expecting(true)
    comment "sequentialParser ini OK"    
test {ini.parse(strmas).result}
    expecting("a bcb")
    comment "sequentialParser a bcb OK"    
test {sequentialParser(ws,hello).parse(strm2).succeeded}
    expecting(true)
    comment "sequentialParser strm2 OK"    
test {(ws ~ hello).parse(strm2).succeeded}
    expecting(true)
    comment "sequentialParser strm2 OK"    
test {ini2.parse(strmas).succeeded}
    expecting(true)
    comment "sequentialParser ini2 OK"    
test {ini2.parse(strmas).result}
    expecting("a bcb")
    comment "sequentialParser a bcb2 OK"    
test {opt(hello).parse(strm).succeeded}
    expecting(true)
    comment "optionalParser opt(hello) OK"    
test {opt(hello).parse(strmab).succeeded}
    expecting(true)
    comment "optionalParser opt(hello) abOK"    
test {alt.parse(strm).succeeded}
    expecting(true)
    comment "alt Hello OK"    
test {alt.parse(strmnn).succeeded}
    expecting(true)
    comment "alt nn OK"    
test {alt2.parse(strm).succeeded}
    expecting(true)
    comment "alt2 Hello OK"    
test {alt2.parse(strmnn).succeeded}
    expecting(true)
    comment "alt2 nn OK"
test {rpx.parse(strm).succeeded}
    expecting(true)
    comment "rpx Hello OK"    
test {rpx.parse(strmxx).succeeded}
    expecting(true)
    comment "rpx xx OK"    
test {rpx.parse(strmxx).result}
    expecting("xxxxx")
    comment "rpx xxxxx OK"    
test {rpx2.parse(strm).succeeded}
    expecting(true)
    comment "rpx2 Hello OK"    
test {rpx2.parse(strmxx).succeeded}
    expecting(true)
    comment "rpx2 xx OK"    
test {rpx2.parse(strmxx).result}
    expecting("xxxxx")
    comment "rpx2 xxxxx OK"    
test {rpx1.parse(strm).succeeded}
    expecting(false)
    comment "rpx1 Hello OK"    
test {rpx1.parse(strmxx).succeeded}
    expecting(true)
    comment "rpx1 xx OK"    
test {rpx1.parse(strmxx).result}
    expecting("xxxxx")
    comment "rpx1 xxxxx OK"    
test {rpx1.parse(strmxx).next.atEnd}
    expecting(true)
    comment "rpx1 atEnd OK"    
test {dropParser(hello).parse(strm).succeeded}
    expecting(true)
    comment "dropParser(\"Hello\")"
test {dropParser(hello).parse(strm).result}
    expecting("")
    comment "dropParser(\"Hello\") result"
test {dropParser(tokenParser("Hellx")).parse(strm).succeeded}
    expecting(false)
    comment "dropParser(tokenParser(\"Hellx\"))"
test {drop(hello).parse(strm).result}
    expecting("")
    comment "drop(hello) result"
test {trim(hello).parse(strm2).succeeded}
     expecting(true)
     comment "trim(hello) result"
test {trim(hello).parse(strm2).next.position}
     expecting(10) 
     comment "trim(hello) next"
test {trim(symbol("Hello")).parse(strm2).result}
     expecting("Hello")
     comment "trim(symbol(hello)) (not taking trailing space)"
test {rs.parse(strmxc).succeeded}
     expecting(true)
     comment "rs xc"
test {rs.parse(strmxc).next.position}
     expecting(6)
     comment "rs xc p   "
test {rs.parse(strmnn).succeeded}
     expecting(true)
     comment "rs nn"
test {rs.parse(strmnn).next.position}
     expecting(1)
     comment "rs nn p"
test {rs.parse(strmxcx).succeeded}
     expecting(true)
     comment "rs xcx"
test {rs.parse(strmxcx).next.position}
     expecting(4)
     comment "rs xcx p"
test {r1s.parse(strmx).succeeded}
     expecting(true)
     comment "r1s x f"
test {r1s.parse(strmx).next.position}
     expecting(2)
     comment "r1s x f"
test {r1s.parse(strmxc).succeeded}
     expecting(true)
     comment "r1s xc"
test {r1s.parse(strmxc).next.position}
     expecting(6)
     comment "r1s xc p"
test {r1s.parse(strmx).succeeded}
     expecting(true)
     comment "r1s x f"
test {r1s.parse(strmx).next.position}
     expecting(2)
     comment "r1s x f"
test {r1s.parse(strmnn).succeeded}
     expecting(false)
     comment "r1s nn"
test {rd.parse(strmxc).succeeded}
     expecting(true)
     comment "rd xc"
test {rd.parse(strmxc).next.position}
     expecting(6)
     comment "rd xc p   "
test {rd.parse(strmnn).succeeded}
     expecting(true)
     comment "rd nn"
test {rd.parse(strmnn).next.position}
     expecting(1)
     comment "rd nn p"
test {rd.parse(strmcx).succeeded}
     expecting(true)
     comment "rd cx"
test {rd.parse(strmcx).next.position}
     expecting(5)
     comment "rd cx p   "
test {rs.parse(strmcx).succeeded}
     expecting(true)
     comment "rs cx"
test {rs.parse(strmcx).next.position}
     expecting(4)
     comment "rs cx p   "
test {rule {tokenParser("Hello")}.parse(strm).succeeded}
    expecting(true)
    comment "rule tokenParser(\"Hello\")"
test {rule {tokenParser("Hellx")}.parse(strm).succeeded}
    expecting(false)
    comment "rule tokenParser(\"Hellx\")"
test {atEndParser.parse(rpx1.parse(strmxx).next).succeeded}
    expecting(true)
    comment "atEnd OK"    
test {atEndParser.parse(strmxx).succeeded}
    expecting(false)
    comment "not atEnd OK"    
test {characterSetParser("Helo Wrd").parse(strm).succeeded}
    expecting(true)
    comment "CSP OK"    
test {rep(characterSetParser("Helo Wrd")).parse(strm).next.position}
    expecting(12)
    comment "CSP next OK"    
test (not(hello)) on "Hello" wrongly "not(hello)"
test (not(hello)) on "Bood" correctly "not(hello)"
test (not(not(hello))) on "Hello" correctly "not(not(hello)) Hello"
test (both(hello,dsp)) on "Hello" wrongly "both1"
test (both(hello,hello)) on "Hello" correctly "both2"
test (both(hello,not(dsp))) on "Hello" correctly "both3"
test (empty) on "Hello" correctly "empty1"
test (empty) on "12345" correctly "empty2"
test (empty) on "" correctly "empty3"
test (empty ~ hello) on "Hello" correctly "e~h"
test (hello ~ empty) on "Hello" correctly "h~e"
test (hello | empty) on "Hello" correctly "h|e H"
test (empty | hello) on "Hello" correctly "e|h H"
test (hello | empty) on "  " correctly "h|e ws"
test (empty | hello) on "  " correctly "h|e ws"
test (guard(dsp,{ s -> true})) on "1234" correctly "guard t"
test (guard(dsp,{ s -> false})) on "1234" wrongly "guard f"
test (guard(dsp, { s -> s == "1234" } )) on "1234" correctly "guard 1234"
test (guard(dsp, { s -> s == "1234" } )) on "1235" wrongly "guard f"

test (characterSetNotParser("\n")) on "\nabc" wrongly "cSNP"
test (characterSetNotParser("\n")) on "abc" correctly "cSNP"
 
print "------: done combinator tests"
