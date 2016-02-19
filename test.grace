//test.grace dialect by Andrew Black, destroyed by James Noble
//based on minitest and gUnit by Andrew Black 

//KERNAN begin
method valof (block) { block.apply }

def myDone = valof { var x
                     x := 0 } // to get a done 

method done {myDone} 

class singleton(printString) {
        method match(other) {
            if (self == other) then {
                _SuccessfulMatch.new(other, [])
            } else {
                _FailedMatch.new(other)
            }
        }
        method asString { printString }
}
//KERNAN end

def nullSuite = singleton "nullSuite"
def nullBlock = singleton "nullBlock"

var currentTestSuiteForDialect := nullSuite
var currentSetupBlockForTesting := nullBlock
var currentTestBlockForTesting := 0  
var currentTestInThisEvaluation := 0 


method suite (name) do (tests) { 
    print "suite: {name}" 
    tests.apply
}

method test (name) do (body) {
    print "    {name}"
    try {body.apply} 
      catch { e -> print "THREW {e}" }
}


def AssertionFailure is readable = Exception.refine "AssertionFailure"

method countOneAssertion {  } //KERNAN was abstract
    
method failBecause(str) {
        assert (false) description (str)
}
method assert(bb: Boolean)description(str) {
        countOneAssertion
        if (! bb) then { AssertionFailure.raise(str) }
}
method deny(bb: Boolean) description (str) {
        assert (! bb) description (str)
}
method assert(bb: Boolean) {
        assert (bb) description "Assertion failed!"
}
method deny(bb: Boolean) {
        assert (! bb)
}
method assert(s1:Object) shouldBe (s2:Object) {
        assert (s1 == s2) description "‹{s1}› should be ‹{s2}›"
}
method assert(s1:Object) shouldntBe (s2:Object) {
        assert ((s1 == s2).not) description "‹{s1}› should not be ‹{s2}›"
}
method deny(s1:Object) shouldBe (s2:Object) {
        assert ((s1 == s2).not) description "‹{s1}› should not be ‹{s2}›"
}
method assert(n1:Number) shouldEqual (n2:Number) within (epsilon:Number) {
        assert (math.abs(n1 - n2) <= epsilon) description "‹{n1}› should be approximatly ‹{n2}›"
}
method assert(block0) shouldRaise (desiredException) {
        var completedNormally
        countOneAssertion
        try {
            block0.apply
            completedNormally := true
        } catch { raisedException:desiredException ->
            completedNormally := false
        } catch { raisedException ->
            failBecause("code raised exception {raisedException.exception}" ++
                ": \"{raisedException.message}\" instead of {desiredException}")
        }
        if (completedNormally) then {failBecause "code did not raise an exception"}
    }
    method assert(block0) shouldntRaise (undesiredException) {
        countOneAssertion
        try {
            block0.apply
        } catch { raisedException:undesiredException ->
            failBecause "code raised exception {raisedException.exception}"
        } catch { _ -> 
            // do nothing; it's OK to raise a different exception.
        }
    }
    method assert(value) hasType (Desired) {
        match (value)
            case { _:Desired -> countOneAssertion }
            case { _ ->  failBecause "{value} does not have type {Desired}" }
}
method assertType(T:Type) describes (value) {
        def missingFromT = protocolOf(value) notCoveredBy(T)
        assert (missingFromT.isEmpty) description (missingFromT)
}

method methodsIn(DesiredType) missingFrom (value) -> String is confidential {
        def vMethods = mirror.reflect(value).methodNames
        def tMethods = DesiredType.methodNames
        def missing = tMethods -- vMethods
        if (missing.size == 0) then {
            ProgrammingError.raise "{value} seems to have all the methods of {DesiredType}"
        } else {
            var s := ""
            missing.do { each -> s := s ++ each } 
                separatedBy { s := s ++ ", " }
            s
        }
}
method protocolOf(value) notCoveredBy (Q:Type) -> String is confidential {
        var s := ""
        def vMethods = set.withAll(mirror.reflect(value).methodNames)
        def qMethods = set.withAll(Q.methodNames)
        def missing = (vMethods -- qMethods).filter{m -> 
            (! m.endsWith "()object") && (m != "outer")}.asSet
        if (missing.isEmpty.not) then {
            s := "{Q.asString} is missing "
            missing.do { each -> s := s ++ each } 
                separatedBy { s := s ++ ", " }
        }
        return s
}
method deny(value) hasType (Undesired:Type) {
        match (value)
            case { _:Undesired ->
                failBecause "{value} has type {Undesired}"
            }
            case { _ -> 
                countOneAssertion 
            }
}




