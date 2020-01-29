dialect "parserTestDialect"

import "collections" as c
inherit c.abbreviations

test (digitStringParser) on "123" correctly "1"

test (graceIdentifierParser) on "abc" correctly "2"


test (opt(ws) ~ graceIdentifierParser) on "abc" correctly "3"

test (graceIdentifierParser ~ ws ~ digitStringParser ~ ws ~ graceIdentifierParser) on "abc 123 def" correctly "4"


class snocParser(left, right) { 
   inherit abstractParser
   def brand = "snocParser"
   method parse(in) {
      def leftResult = left.parse(in)
            .resultUnlessFailed {f -> return f}
      def rightResult = right.parse(leftResult.next)
            .resultUnlessFailed {f -> return f}
      parseSuccess(rightResult.next,  //return
             snoc(leftResult.result, rightResult.result))
   }
}

class snoc(l',r') {
  method l {l'}
  method r {r'}
  method asString {"snoc({l},{r})"}
  method asList {
    var left
    if (isSnoc(l)) then {
        left:= l.asList
    } else {
        left:=list(l)
    }
    if (isSnoc(r)) then {
        return left ++ (r.asList)
    } else {
        return left ++ list(r)
    }
  }

  method snocysnoc {error "called brand"}
}

method isSnoc(other) {
         match (other)
           case { _ : interface { snocysnoc } -> true }
           case { _ -> false }
}

print "false={isSnoc(42)}"
print "true={isSnoc(snoc(69,96))}"


def sp =  (graceIdentifierParser ~~ ws ~~ digitStringParser ~~ ws ~~ graceIdentifierParser)
def str = stringInputStream("abc 123 def",1)

def pr = (sp.parse(str))

print (pr.succeeded)
if (pr.succeeded) then {print "result:{pr.result}"}

def res = pr.result

print (snoc("a","b").asList)
print (snoc(snoc("a","b"),"c").asList)
print (snoc("a",snoc("b","c")).asList)

method apply(block) withArguments(a) {
      match (a.size)
        case { 0 -> block.apply}
        case { 1 -> block.apply(a.at(1))}
        case { 2 -> block.apply(a.at(1),a.at(2))}
        case { 3 -> block.apply(a.at(1),a.at(2),a.at(3))}
        case { 4 -> block.apply(a.at(1),a.at(2),a.at(3),a.at(4))}
        case { 5 -> block.apply(a.at(1),a.at(2),a.at(3),a.at(4),a.at(5))}
        case { _ -> error "CANT BE BOTHERED TO APPLY MORE VARARGS" }
}
 
apply {a,b,c,d,e -> print "parseNode({a},{c},{e})" }
 withArguments( pr.result.asList  )   
