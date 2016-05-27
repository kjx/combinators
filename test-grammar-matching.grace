dialect "parserTestDialect"


test (matchBinding ~ end) on "a" wrongly "018a1"  //formals subsume var match
test (matchBinding ~ end) on "_" wrongly "018a1"  //formals subsume var march
test (blockFormals ~ end) on "a" correctly "018a1"  //formals subsume var match
test (blockFormals ~ end) on "_" correctly "018a1"  //formals subsume var march
test (matchBinding ~ end) on "0" correctly "018a1"
test (matchBinding ~ end) on " 0" correctly "018a1"
test (matchBinding ~ end) on "(a)" correctly "018a1"
test (matchBinding ~ end) on "(pi)" correctly "018a1"
test (matchBinding ~ end) on "\"Fii\"" correctly "018a1"
test (matchBinding ~ end) on "a : Foo" wrongly "018a1" //formals subsume var match
test (matchBinding ~ end) on "a : Foo(bar,baz)" wrongly "018a1" //no destruct
test (matchBinding ~ end) on "a : Foo(_ : Foo(a,b), _ : Foo(c,d))" wrongly "018a1" //no destruct

test (blockLiteral ~ end) on "\{ _ : Foo -> last \}" correctly "018b1"
test (blockLiteral ~ end) on "\{ 0 -> \"Zero\" \}" correctly "018b"
test (blockLiteral ~ end) on "\{ s:String -> print(s) \}" correctly "018b"
test (blockLiteral ~ end) on "\{ (pi) -> print(\"Pi = \" ++ pi) \}" correctly "018c"
test (blockLiteral ~ end) on "\{ _ : Some(v) -> print(v) \}" wrongly "018d" //no destruct
test (blockLiteral ~ end) on "\{ _ : Pair(v : Pair(p,q), a : Number) -> print(v) \}" wrongly "018e" //no destruct
test (blockLiteral ~ end) on "\{ _ : Some -> print(v) \}" correctly "018d" //no destruct
test (blockLiteral ~ end) on "\{ _ : Pair, a : Number -> print(v) \}" correctly "018e" //no destruct
test (blockLiteral ~ end) on "\{ _ -> print(\"did not match\") \}" correctly "018f"

testProgramOn "\{ _ : Foo -> last \}" correctly "019b1"
testProgramOn "\{ 0 -> \"Zero\" \}" correctly "019b"
testProgramOn "\{ s:String -> print(s) \}" correctly "019b"
testProgramOn "\{ (pi) -> print(\"Pi = \" ++ pi) \}" correctly "019c"
testProgramOn "\{ _ : Some(v) -> print(v) \}" wrongly "019d" //no destruct
testProgramOn "\{ _ : Pair(v : Pair(p,q), a : Number) -> print(v) \}" wrongly "019e" //no destruct
testProgramOn "\{ _ : Some -> print(v) \}" correctly "019d" //no destruct
testProgramOn "\{ _ : Pair, a : Number -> print(v) \}" correctly "019e" //no destruct
testProgramOn "\{ _ -> print(\"did not match\") \}" correctly "019f"


testProgramOn "       0" correctly "HUH"
