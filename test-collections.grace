dialect "test"

import "collections" as col 

suite "bindingTest" do {

        test "stringification" do {
            assert ((col.key(2) value(4)).asString) shouldBe "2 :: 4"
        }
        test "bindingequality" do {
            assert ((col.key(2) value(4)) == (col.key(2) value(4))) description "2 :: 4 is not equal to itself!"
        }
        test "bindinginequalityvalue" do {
            deny ((col.key(2) value(4)) == (col.key(2) value(5))) description "2 :: 4 is equal to 2 :: 5!"
        }
        test "bindinginequalitykey" do {
            deny ((col.key(2) value(4)) == (col.key(1) value(4))) description "2 :: 4 is equal to 1 :: 4!"
        }
        test "bindinginequalitykind" do {
            deny ((col.key(2) value(4)) == "two") description "2 :: 4 is equal to \"two\""
        }
        test "extractfields" do {
            def b = col.key "one" value(1)
            assert (b.key) shouldBe "one"
            assert (b.value) shouldBe 1
        }

}

suite "rangeTest" do {

        def rangeUp = col.range.from 3 to 6
        def rangeDown = col.range.from 10 downTo 7
        def emptyUp = col.range.from 5 to 4
        def emptyDown = col.range.from 7 downTo 8
        def singleUp = col.range.from 4 to 4
        def singleDown = col.range.from 7 downTo 7

        test "rangetypecollection" do {
            def witness = col.range.from 1 to 6
            assert (witness) hasType (col.Collection<Number>)
        }
        test "rangetypesequence" do {
            def witness = col.range.from 1 to 6
            assert (witness) hasType (col.Sequence<Number>)
        }
        test "rangetypeenumerable" do {
            def witness = col.range.from 1 to 6
            assert (witness) hasType (col.Enumerable<Number>)
        }
        test "rangetypenottypewithwombat" do {
            def witness = col.range.from 1 to 6
            deny (witness) hasType (col.Collection<Number> & type { wombat })
        }

        test "rangepreconditionup1" do {
            assert {col.range.from 4.5 to 5} shouldRaise (col.RequestError)
        }

        test "rangepreconditionup2" do {
            assert {col.range.from 4 to 9.5} shouldRaise (col.RequestError)
        }

        test "rangepreconditionup3" do {
            assert {col.range.from 4 to "foo"} shouldRaise (col.RequestError)
        }

        test "rangepreconditiondown1" do {
            assert {col.range.from 4 downTo 1.5} shouldRaise (col.RequestError)
        }

        test "rangepreconditiondown2" do {
            assert {col.range.from 4 downTo 1.5} shouldRaise (col.RequestError)
        }

        test "rangepreconditiondown3" do {
            assert {col.range.from 4.5 downTo "foo"} shouldRaise (col.RequestError)
        }

        test "rangesizesup" do {
            assert (rangeUp.size) shouldBe (4)
            assert (emptyUp.size) shouldBe (0)
            assert (singleUp.size) shouldBe (1)
        }
        test "rangesizesdown" do {
            assert (rangeDown.size) shouldBe (4)
            assert (emptyDown.size) shouldBe (0)
            assert (singleDown.size) shouldBe (1)
        }
        test "rangeupcontainsin" do {
            assert (rangeUp.contains 3) description "{rangeUp} doesn't contain 3"
            assert (rangeUp.contains 4) description "{rangeUp} doesn't contain 4"
            assert (rangeUp.contains 5) description "{rangeUp} doesn't contain 5"
            assert (rangeUp.contains 6) description "{rangeUp} doesn't contain 6"
        }
        test "rangeupcontainsout" do {
            deny (rangeUp.contains 2) description "{rangeUp} contains 2"
            deny (rangeUp.contains 7) description "{rangeUp} contains 7"
            deny (rangeUp.contains 5.5) description "{rangeUp} contains 5.5"
            deny (rangeUp.contains "foo") description "{rangeUp} contains \"foo\""
        }
        test "rangeelementsup" do {
            def elements = col.list.empty
            for (rangeUp) do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.with(3, 4, 5, 6))
            assert (rangeUp.asList) shouldBe (col.list.with(3, 4, 5, 6))
        }
        test "rangeelementsupwithfold" do {
            def elements = rangeUp.fold {acc, each -> acc.add(each)}
                startingWith (col.list.empty)
            assert (elements) shouldBe (col.list.with(3, 4, 5, 6))
        }
        test "rangeupfold" do {
            def sum = rangeUp.fold {acc, each -> acc + each} startingWith 0
            assert (sum) shouldBe 18
        }
        test "rangedowncontainsin" do {
            assert (rangeDown.contains 10) description "{rangeDown} doesn't contain 10"
            assert (rangeDown.contains 9) description "{rangeDown} doesn't contain 9"
            assert (rangeDown.contains 8) description "{rangeDown} doesn't contain 8"
            assert (rangeDown.contains 7) description "{rangeDown} doesn't contain 7"
        }
        test "rangedowncontainsout" do {
            deny (rangeDown.contains 6) description "{rangeDown} contains 6"
            deny (rangeDown.contains 11) description "{rangeDown} contains 11"
            deny (rangeDown.contains 5.5) description "{rangeDown} contains 5.5"
            deny (rangeDown.contains "foo") description "{rangeDown} contains \"foo\""
        }

        test "rangeelementsdown" do {
            def elements = col.list.empty
            for (rangeDown) do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.with(10, 9, 8, 7))
        }
        test "rangeelementsemptyup" do {
            def elements = col.list.empty
            for (emptyUp) do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.empty)
        }
        test "rangeelementsemptydown" do {
            def elements = col.list.empty
            for (emptyDown) do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.empty)
        }
        test "rangeelementssingletonup" do {
            def elements = col.list.empty
            for (singleUp) do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.with(4))
        }
        test "rangeelementssingletondown" do {
            def elements = col.list.empty
            for (singleDown) do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.with(7))
        }
        test "rangeelementsdoup" do {
            def elements = col.list.empty
            (rangeUp).do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.with(3, 4, 5, 6))
        }
        test "rangekeysandvalues" do {
            var s := ""
            rangeUp.keysAndValuesDo { k, v -> s := s ++ "{k} :: {v} " }
            assert (s) shouldBe "1 :: 3 2 :: 4 3 :: 5 4 :: 6 "
        }
        test "rangeupkeysandvaluesempty" do {
            var s := ""
            emptyUp.keysAndValuesDo { k, v -> s := s ++ "{k} :: {v} " }
            assert (s) shouldBe ""
        }
        test "rangeelementsdodown" do {
            def elements = col.list.empty
            (rangeDown).do {each -> elements.add(each)}
            assert (elements) shouldBe (col.list.with(10, 9, 8, 7))
        }
        test "rangekeysandvaluesdown" do {
            var s := ""
            rangeDown.keysAndValuesDo { k, v -> s := s ++ "{k} :: {v} " }
            assert (s) shouldBe "1 :: 10 2 :: 9 3 :: 8 4 :: 7 "
        }
        test "rangedownkeysandvaluesempty" do {
            var s := ""
            emptyDown.keysAndValuesDo { k, v -> s := s ++ "{k} :: {v} " }
            assert (s) shouldBe ""
        }
        test "rangeupreverse" do {
            assert (rangeUp.reversed) shouldBe (col.range.from(6)downTo(3))
        }
        test "rangefilterexhausted" do {
            def rangeFiltered = rangeUp.filter{each -> each > 10}
            def rangeFilteredIterator = rangeFiltered.iterator
            assert(rangeFilteredIterator) hasType (col.Iterator)
            deny(rangeFilteredIterator.hasNext) description "empty rangeFilteredIterator hasNext!"
            assert{rangeFilteredIterator.next} shouldRaise (col.IteratorExhausted)
        }
        test "rangefilteremptylist" do {
            assert (rangeUp.filter{each -> each > 10}.onto(col.list)) shouldBe (col.list.empty)
        }
        test "rangefilterempty" do {
            assert (rangeUp.filter{each -> each > 10}.isEmpty)
                description "range filter by an everywhere-false predicate isn't empty"
        }
        test "rangedownreverse" do {
            assert (rangeDown.reversed) shouldBe (col.range.from(7)to(10))
        }
        test "rangeequalitywithlist" do {
            assert(rangeDown == col.list.with(10,9,8,7))
                description "col.range.from 10 downTo 7 ≠ col.list.with(10, 9, 8 ,7)"
            assert(emptyUp == col.list.empty)
                description "The empty range was not equal to the empty list"
        }
        test "rangeinequalitywithnumber" do {
            deny(rangeDown == 7) description ("rangeDown == 7")
        }
        test "rangeinequalitywithlist" do {
            assert(rangeDown != col.list.empty) description("Failed trying the empty list")
            assert(rangeDown != col.list.with(3,4,5))
                description("Range = list with a different size.")
            assert(rangeDown != col.list.with(10,9,8,5))
                description("Range = list with different contents")
        }
        test "rangeuplistconversion" do {
            assert(rangeUp.asList == col.list.with(3,4,5,6))
            assert(rangeUp.asList) hasType (col.List)
        }
        test "rangeupsequenceconversion" do {
            assert(rangeUp.asSequence == col.sequence.with(3,4,5,6))
            assert(rangeUp.asSequence) hasType (col.Sequence)
        }
        test "rangedownlistconversion" do {
            assert(rangeDown.asList == col.list.with(10,9,8,7))
            assert(rangeDown.asList) hasType (col.List)
        }
        test "rangedownsequenceconversion" do {
            assert(rangeDown.asSequence == col.sequence.with(10,9,8,7))
            assert(rangeDown.asSequence) hasType (col.Sequence)
        }
        test "rangedownat" do {
            //def naN = "foo".asNumber    //KERNAN doesn't support Nans
            assert(rangeDown.at(1)) shouldBe 10
            assert(rangeDown.at(2)) shouldBe 9
            assert(rangeDown.at(3)) shouldBe 8
            assert(rangeDown.at(4)) shouldBe 7
            assert{rangeDown.at(5)} shouldRaise (col.BoundsError)
            assert{rangeDown.at(0)} shouldRaise (col.BoundsError)
            // assert{rangeDown.at(naN)} shouldRaise (BoundsError) //KERNAN doesn't support NaNs
        }
        test "rangeupat" do {
            //def naN = "foo".asNumber
            assert(rangeUp.at(1)) shouldBe 3
            assert(rangeUp.at(2)) shouldBe 4
            assert(rangeUp.at(3)) shouldBe 5
            assert(rangeUp.at(4)) shouldBe 6
            assert{rangeUp.at(5)} shouldRaise (col.BoundsError)
            assert{rangeUp.at(0)} shouldRaise (col.BoundsError)
            //assert{rangeUp.at(naN)} shouldRaise (col.BoundsError) //KERNAN doesn't support NANs
        }
        test "rangeupasdictionary" do {
            assert(rangeUp.asDictionary) shouldBe
                (col.dictionary.with(col.key(1) value(3), col.key(2) value(4), col.key(3) value(5), col.key(4) value(6)))
        }
        test "rangedownasdictionary" do {
            assert(rangeDown.asDictionary) shouldBe
                (col.dictionary.with(col.key(1) value(10), col.key(2) value(9), col.key(3) value(8), col.key(4) value(7)))
        }

}

suite "sequenceTest" do {

        def oneToFive = col.sequence.with(1, 2, 3, 4, 5)
        def evens = col.sequence.with(2, 4, 6, 8)
        def empty = col.sequence.empty

        test "sequencetypecollection" do {
            def witness =col.sequence<Number>.with(1,3)
            assert (witness) hasType (col.Collection<Number>)
        }
        test "sequencetypesequence" do {
            def witness =col.sequence<Number>.with(1,3)
            assert (witness) hasType (col.Sequence<Number>)
        }
        test "sequencetypeenumerable" do {
            def witness =col.sequence<Number>.with(1,3)
            assert (witness) hasType (col.Enumerable<Number>)
        }
        test "emptysequencetypecollection" do {
            def witness = col.sequence.empty
            assert (witness) hasType (col.Collection)
        }
        test "emptysequencetypesequence" do {
            def witness = col.sequence.empty
            assert (witness) hasType (col.Sequence)
        }
        test "emptysequencetypeenumerable" do {
            def witness = col.sequence.empty
            assert (witness) hasType (col.Enumerable)
        }
        test "filteredsequencetypeenumerable" do {
            def witness =col.sequence<Number>.with(1,3).filter{x -> true}
            assert (witness) hasType (col.Enumerable<Number>)
        }
        test "sequencenottypewithwombat" do {
            def witness =col.sequence<Number>.with(1,3)
            deny (witness) hasType (col.Collection<Number> & type { wombat })
        }
        test "sequencesize" do {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }
        
        test "sequenceemptydo" do {
            empty.do {each -> failBecause "emptySequence.do did with {each}"}
            assert(true)
        }

        test "sequenceequalityempty" do {
            assert(empty == col.sequence.empty) description "emptycol.sequence ≠ itself!"
            assert(empty == col.list.empty) description "emptycol.sequence ≠ empty list"
        }

        test "sequenceinequalityempty" do {
            deny(empty == col.sequence.with(1))
            assert(empty != col.sequence.with(1))
            deny(empty == 3)
            deny(empty == evens)
        }

        test "sequenceinequalityfive" do {
            deny(oneToFive == col.sequence.with(1, 2, 3, 4, 6))
            assert(oneToFive != col.sequence.with(1, 2, 3, 4, 6))
        }

        test "sequenceequalityfive" do {
            def isEqual = (oneToFive == col.sequence.with(1, 2, 3, 4, 5))
            assert(isEqual)
            deny(oneToFive != col.sequence.with(1, 2, 3, 4, 5))
        }

        test "sequenceonetofivedo" do {
            var element := 1
            oneToFive.do { each ->
                assert (each) shouldBe (element)
                element := element + 1
            }
        }
        test "sequencecontains" do {
            assert (oneToFive.contains(1)) description "oneToFive does not contain 1"
            assert (oneToFive.contains(5)) description "oneToFive does not contain 5"
            deny (oneToFive.contains(0)) description "oneToFive contains 0"
            deny (oneToFive.contains(6)) description "oneToFive contains 6"
        }

        test "sequencefirst" do {
            assert{empty.first} shouldRaise (col.BoundsError)
            assert(evens.first) shouldBe (2)
            assert(oneToFive.first) shouldBe (1)
        }

        test "sequenceat" do {
            //def naN = "fff".asNumber //Kernan
            assert {empty.at(1)} shouldRaise (col.BoundsError)
            assert (oneToFive.at(1)) shouldBe (1)
            assert (oneToFive[1]) shouldBe (1)
            assert (oneToFive.at(5)) shouldBe (5)
            assert (evens.at(4)) shouldBe (8)
            assert {evens.at(5)} shouldRaise (col.BoundsError)
            //assert {evens.at(naN)} shouldRaise (col.BoundsError)
        }

        test "sequenceordinals" do {
            assert {empty.first} shouldRaise (col.BoundsError)
            assert (oneToFive.first) shouldBe (1)
            assert (oneToFive.second) shouldBe (2)
            assert (oneToFive.third) shouldBe (3)
            assert (evens.fourth) shouldBe (8)
            assert {evens.fifth} shouldRaise (col.BoundsError)
        }

        test "sequenceconcatwithempty" do {
            assert(empty ++ oneToFive)shouldBe(oneToFive)
            assert(oneToFive ++ empty)shouldBe(oneToFive)
        }

        test "sequenceconcatwithnonempty" do {
            assert(oneToFive ++ evens) shouldBe(col.sequence.with(1, 2, 3, 4, 5, 2, 4, 6, 8))
            assert(evens ++ oneToFive) shouldBe(col.sequence.with(2, 4, 6, 8, 1, 2, 3, 4, 5))
        }

        test "sequenceindicesandkeys" do {
            def seq = oneToFive ++ evens
            def totalSize = oneToFive.size + evens.size
            assert (seq.indices) shouldBe (col.range.from(1) to(totalSize))
            assert (seq.indices) shouldBe (seq.keys)
        }

        test "sequencefold" do {
            assert(oneToFive.fold{a, each -> a + each}startingWith(0))shouldBe(15)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }

        test "sequencedoseparatedby" do {
            var s := ""
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert (s) shouldBe ("2, 4, 6, 8")
        }

        test "sequencedoseparatedbyempty" do {
            var s := "nothing"
            empty.do { failBecause "do did whencol.sequence is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "sequencedoseparatedbysingleton" do {
            var s := "nothing"
            col.sequence.with(1).do { each -> assert(each)shouldBe(1) }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "sequencekeysandvaluesdo" do {
            def accum = col.dictionary.empty
            var n := 1
            evens.keysAndValuesDo { k, v ->
                accum.at(k)put(v)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (col.dictionary.with(col.key(1) value(2), col.key(2) value(4), col.key(3) value(6), col.key(4) value(8)))
        }

        test "sequencereversedonetofive" do {
            assert (oneToFive.reversed) shouldBe (col.sequence.with(5, 4, 3, 2, 1))
        }

        test "sequencereversedevens" do {
            assert (evens.reversed) shouldBe (col.sequence.with(8, 6, 4, 2))
            assert (evens.reversed.reversed) shouldBe (evens)
        }

        test "sequencereversedempty" do {
            assert (empty.reversed) shouldBe (empty)
        }

        test "sequenceasstringnonempty" do {
            assert (evens.asString) shouldBe ("⟨2, 4, 6, 8⟩")
        }

        test "sequenceasstringempty" do {
            assert (empty.asString) shouldBe ("⟨⟩")
        }

        test "sequencemapempty" do {
            assert (empty.map{x -> x * x}.onto(col.list)) shouldBe (col.list.empty)
        }

        test "sequencemapevens" do {
            assert(evens.map{x -> x + 1}.onto(col.list)) shouldBe (col.list.with(3, 5, 7, 9))
        }

        test "sequencemapevensinto" do {
            assert(evens.map{x -> x + 10}.into(col.list.withAll(evens)))
                shouldBe (col.list.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        test "sequencefilternone" do {
            deny(oneToFive.filter{x -> false}.iterator.hasNext)
        }

        test "sequencefilterempty" do {
            assert(empty.filter{x -> (x % 2) == 1}.isEmpty)
        }

        test "sequencefilterodd" do {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(col.list))
                shouldBe (col.list.with(1, 3, 5))
        }

        test "sequencemapandfilter" do {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.onto(col.list))
                shouldBe (col.list.with(11, 13, 15))
        }

        test "sequencetolist1to5" do {
            assert (oneToFive.asList) shouldBe (col.list.with(1, 2, 3, 4, 5))
            assert (oneToFive.asList) hasType (col.List)
        }

        test "sequencetolistempty" do {
            assert (empty.asList) shouldBe (col.list.empty)
            assert (empty.asList) hasType (col.List)
        }

        test "sequencetoset1to5" do {
            assert (oneToFive.asSet) shouldBe (col.set.with(1, 2, 3, 4, 5))
            assert (oneToFive.asSet) hasType (col.Set)
        }

        test "sequencetosetempty" do {
            assert (empty.asSet) shouldBe (col.set.empty)
            assert (empty.asSet) hasType (col.Set)
        }
        test "sequencetosetduplicates" do {
            def theSet = col.sequence.with(1,1,2,2,4).asSet
            assert (theSet) shouldBe (col.set.with(1, 2, 4))
            assert (theSet) hasType (col.Set)
        }
        test "sequenceiteratorempty" do {
            deny (empty.iterator.hasNext)
                description "empty iterator has an element"
        }
        test "sequenceiteratornonempty" do {
            def accum = col.set.empty
            def iter = oneToFive.iterator
            while {iter.hasNext} do { accum.add(iter.next) }
            assert (accum) shouldBe (col.set.with(1, 2, 3, 4, 5))
        }
        test "sequenceiteratortosetduplicates" do {
            def accum = col.set.empty
            def iter = col.sequence.with(1, 1, 2, 2, 4).iterator
            while {iter.hasNext} do { accum.add(iter.next) }
            assert (accum) shouldBe (col.set.with(1, 2, 4))
        }
        test "sequencesorted" do {
            def input = col.sequence.with(5, 3, 11, 7, 2)
            def output = input.sorted
            assert (output) shouldBe (col.sequence.with(2, 3, 5, 7, 11))
            assert (output.asString.startsWith (col.sequence.empty.asString.first)) description
                ".sorted does not look like a col.sequence"
            assert (output) hasType (col.Sequence)
        }
        test "sequencesortedby" do {
            def input = col.sequence.with(5, 3, 11, 7, 2)
            def output = input.sortedBy {l, r ->
                if (l == r) then {0}
                    elseif (l < r) then {1}
                    else {-1}
                }
            assert (input) shouldBe (col.sequence.with(5, 3, 11, 7, 2))
            assert (output) shouldBe (col.sequence.with(11, 7, 5, 3, 2))
            assert (output.asString.startsWith (col.sequence.empty.asString.first)) description
                "sorted does not look like acol.sequence"
            assert (output) hasType (col.Sequence)
        }
        test "sequenceasdictionary" do {
            assert(evens.asDictionary) shouldBe
                (col.dictionary.with(col.key(1) value(2), col.key(2) value(4), col.key(3) value(6), col.key(4) value(8)))
        }
        test "lazyConcat" do {
            def s1 = oneToFive.filter{x -> (x % 2) == 1}
            def s2 = evens.filter{x -> true}
            assert(s1 ++ s2) shouldBe (col.sequence.with(1, 3, 5, 2, 4, 6, 8))
        }
}

suite "listTest" do {

        def oneToFive = col.list.with(1, 2, 3, 4, 5)
        def evens = col.list.with(2, 4, 6, 8)
        def empty = col.list.empty

        test "listtypecollection" do {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (col.Collection<Number>)
        }
        test "listtypelist" do {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (col.List<Number>)
        }
        test "listtypesequence" do {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (col.Sequence<Number>)
        }
        test "listtypenottypewithwombat" do {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            deny (witness) hasType (col.list<Number> & type { wombat })
        }

        test "listsize" do {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }

        test "listemptydo" do {
            empty.do {each -> failBecause "emptyList.do did with {each}"}
            assert(true)
        }

        test "listequalityempty" do {
            assert(empty == col.list.empty) description "empty list ≠ itself!"
            assert(empty == col.sequence.empty) description "empty list ≠ emptycol.sequence"
        }

        test "listinequalityempty" do {
            deny(empty == col.list.with(1))
            assert(empty != col.list.with(1))
            deny(empty == 3)
            deny(empty == evens)
        }

        test "listinequalityfive" do {
            deny(oneToFive == col.list.with(1, 2, 3, 4, 6))
            assert(oneToFive != col.list.with(1, 2, 3, 4, 6))
        }

        test "listequalityfive" do {
            def isEqual = (oneToFive == col.list.with(1, 2, 3, 4, 5))
            assert(isEqual)
            deny(oneToFive != col.list.with(1, 2, 3, 4, 5))
        }

        test "listonetofivedo" do {
            var element := 1
            oneToFive.do { each ->
                assert (each) shouldBe (element)
                element := element + 1
            }
        }
        test "listcontains" do {
            assert (oneToFive.contains(1)) description "oneToFive does not contain 1"
            assert (oneToFive.contains(5)) description "oneToFive does not contain 5"
            deny (oneToFive.contains(0)) description "oneToFive contains 0"
            deny (oneToFive.contains(6)) description "oneToFive contains 6"
        }

        test "listfirst" do {
            assert{empty.first} shouldRaise (col.BoundsError)
            assert(evens.first) shouldBe (2)
            assert(oneToFive.first) shouldBe (1)
        }

        test "listat" do {
            //def naN = "foo".asNumber
            assert {empty.at(1)} shouldRaise (col.BoundsError)
            assert (oneToFive.at(1)) shouldBe (1)
            assert (oneToFive[1]) shouldBe (1)
            assert (oneToFive.at(5)) shouldBe (5)
            assert (evens.at(4)) shouldBe (8)
            assert {evens.at(5)} shouldRaise (col.BoundsError)
            //assert {evens.at(naN)} shouldRaise (col.BoundsError)
        }

        test "listordinals" do {
            assert {empty.first} shouldRaise (col.BoundsError)
            assert (oneToFive.first) shouldBe (1)
            assert (oneToFive.second) shouldBe (2)
            assert (oneToFive.third) shouldBe (3)
            assert (evens.fourth) shouldBe (8)
            assert {evens.fifth} shouldRaise (col.BoundsError)
        }

        test "listatput" do {
            //def naN = "foo".asNumber
            oneToFive.at(1) put (11)
            assert (oneToFive.at(1)) shouldBe (11)
            oneToFive.at(2) put (12)
            assert (oneToFive[2]) shouldBe (12)
            assert (oneToFive.at(3)) shouldBe (3)
            assert {evens.at 6 put 10} shouldRaise (col.BoundsError)
            assert {evens.at 0 put 0} shouldRaise (col.BoundsError)
            //assert {evens.at(naN) put 0} shouldRaise (col.BoundsError)
        }

        test "listatputextend" do {
            assert (empty.at 1 put 99) shouldBe (col.list.with 99)
            oneToFive.at(6) put 6
            assert (oneToFive.at 6) shouldBe 6
            oneToFive.at(7) put 7
            assert (oneToFive[7]) shouldBe 7
            assert (oneToFive) shouldBe (1 .. 7)
        }

        test "listremovepresent" do {
            assert (oneToFive.remove(3)) shouldBe (col.list.with(1, 2, 4, 5))
            assert (oneToFive) shouldBe (col.list.with(1, 2, 4, 5))
        }
        test "listremovemultiplepresent" do {
            assert (oneToFive.remove(1, 4, 5)) shouldBe (col.list.with(2, 3))
            assert (oneToFive) shouldBe (col.list.with(2, 3))
        }
        test "listremoveabsentexception" do {
            assert {oneToFive.remove(1, 7, 5)} shouldRaise (NoSuchObject)
        }
        test "listremovelast" do {
            assert (oneToFive.removeLast) shouldBe 5
            assert (oneToFive) shouldBe (col.list.with(1, 2, 3, 4))
        }
        test "listremovelastempty" do {
            assert {empty.removeLast} shouldRaise (col.BoundsError)
        }
        test "listpop" do {
            assert (oneToFive.pop) shouldBe 5
            assert (oneToFive) shouldBe (col.list.with(1, 2, 3, 4))
        }
        test "listpopempty" do {
            assert {empty.pop} shouldRaise (col.BoundsError)
        }
        test "listremoveabsentactionblock" do {
            var absent := false
            assert (oneToFive.remove 9 ifAbsent {absent := true}) 
                shouldBe (col.list.with(1, 2, 3, 4, 5))
            assert (absent) description "9 was found in list 1..5"
        }
        test "listremovesomeabsent" do {
            var absent := false
            assert (oneToFive.remove(1, 9, 2) ifAbsent {absent := true})
                shouldBe (col.list.with(3, 4, 5))
            assert (absent) description "9 was found in list 1..5"
        }
        test "listindexofpresent" do {
            assert (evens.indexOf 6) shouldBe 3
            assert (evens.indexOf 4 ifAbsent {"missing"}) shouldBe 2
        }
        test "listindexofabsent" do {
            assert {evens.indexOf 3} shouldRaise (NoSuchObject)
            assert (evens.indexOf 5 ifAbsent {"missing"}) shouldBe "missing"
        }
        test "listaddlast" do {
            assert (empty.addLast(9)) shouldBe (col.list.with(9))
            assert (evens.addLast(10)) shouldBe (col.list.with(2, 4, 6, 8, 10))
        }
        test "addall" do {
            evens.addAll(oneToFive)
            assert (evens) shouldBe (col.list.with(2, 4, 6, 8, 1, 2, 3, 4, 5))
        }
        test "listadd" do {
            assert (empty.add(9)) shouldBe (col.list.with(9))
            assert (evens.add(10)) shouldBe (col.list.with(2, 4, 6, 8, 10))
        }
        test "listremoveatempty" do {
            assert {empty.removeAt(1)} shouldRaise (col.BoundsError)
        }
        test "listremoveat1" do {
            assert (evens.removeAt(1)) shouldBe (2)
            assert (evens) shouldBe (col.list.with(4, 6, 8))
        }
        test "listremoveat2" do {
            assert (evens.removeAt(2)) shouldBe (4)
            assert (evens) shouldBe (col.list.with(2, 6, 8))
        }
        test "listremoveat3" do {
            assert (evens.removeAt(3)) shouldBe (6)
            assert (evens) shouldBe (col.list.with(2, 4, 8))
        }
        test "listremoveat4" do {
            assert (evens.removeAt(4)) shouldBe (8)
            assert (evens) shouldBe (col.list.with(2, 4, 6))
        }
        test "listremoveat5" do {
            assert {evens.removeAt(5)} shouldRaise (col.BoundsError)
        }
        test "listaddfirst" do {
            assert (evens.addFirst(0)) shouldBe (col.list.with(0, 2, 4, 6, 8))
            assert (evens.size) shouldBe (5)
            assert (evens.first) shouldBe (0)
            assert (evens.second) shouldBe (2)
        }
        test "listaddfirstmultiple" do {
            assert (evens.addFirst(-4, -2, 0)) shouldBe (col.list.with(-4, -2, 0, 2, 4, 6, 8))
            assert (evens.size) shouldBe 7
            assert (evens.first) shouldBe (-4)
            assert (evens.second) shouldBe (-2)
            assert (evens.third) shouldBe 0
            assert (evens.fourth) shouldBe 2
            assert (evens.fifth) shouldBe 4
            assert (evens.last) shouldBe 8
            assert (evens.at(3)) shouldBe 0
        }
        test "listremovefirst" do {
            def removed = oneToFive.removeFirst
            assert (removed) shouldBe (1)
            assert (oneToFive.size) shouldBe (4)
            assert (oneToFive) shouldBe (col.list.with(2, 3, 4, 5))
        }
        test "listchaining" do {
            oneToFive.at(1)put(11).at(2)put(12).at(3)put(13)
            assert(oneToFive.at(1))shouldBe(11)
            assert(oneToFive.at(2))shouldBe(12)
            assert(oneToFive.at(3))shouldBe(13)
        }
        test "listpushandexpand" do {
            evens.push(10)
            evens.push(12)
            evens.push(14)
            evens.push(16)
            evens.push(18)
            evens.push(20)
            assert (evens) shouldBe (col.list.with(2, 4, 6, 8, 10, 12, 14, 16, 18, 20))
        }

        test "listreversedonetofive" do {
            def ofr = oneToFive.reversed
            assert (ofr) shouldBe (col.list.with(5, 4, 3, 2, 1))
            assert (oneToFive) shouldBe (col.list.with(1, 2, 3, 4, 5))
        }

        test "listreversedevens" do {
            def er = evens.reversed
            assert (er) shouldBe (col.list.with(8, 6, 4, 2))
            assert (evens) shouldBe (col.list.with(2, 4, 6, 8))
            assert (er.reversed) shouldBe (evens)
        }

        test "listreversedempty" do {
            assert (empty.reversed) shouldBe (empty)
        }

        test "listreverseonetofive" do {
            def ofr = oneToFive.reverse
            assert (identical(ofr, oneToFive)) description "reverse does not return self"
            assert (ofr) shouldBe (col.list.with(5, 4, 3, 2, 1))
            assert (oneToFive) shouldBe (col.list.with(5, 4, 3, 2, 1))
            oneToFive.reverse
            assert (oneToFive) shouldBe (col.list.with(1, 2, 3, 4, 5))
        }

        test "listreverseevens" do {
            def er = evens.reverse
            assert (identical(er, evens)) description "reverse does not return self"
            assert (er) shouldBe (col.list.with(8, 6, 4, 2))
            assert (evens) shouldBe (col.list.with(8, 6, 4, 2))
            assert (er.reversed) shouldBe (col.list.with(2, 4, 6, 8))
        }

        test "listreverseempty" do {
            def er = empty.reverse
            assert (empty.reverse.size) shouldBe 0
        }

        test "listconcatwithempty" do {
            assert(empty ++ oneToFive)shouldBe(oneToFive)
            assert(oneToFive ++ empty)shouldBe(oneToFive)
        }

        test "listconcatwithnonempty" do {
            assert(oneToFive ++ evens) shouldBe(col.list.with(1, 2, 3, 4, 5, 2, 4, 6, 8))
            assert(evens ++ oneToFive) shouldBe(col.list.with(2, 4, 6, 8, 1, 2, 3, 4, 5))
        }

        test "listindicesandkeys" do {
            def lst = oneToFive ++ evens
            def siz = oneToFive.size + evens.size
            assert (lst.indices) shouldBe (1 .. siz)
            assert (lst.indices) shouldBe (lst.keys.asSequence)
        }

        test "listfold" do {
            assert(oneToFive.fold{a, each -> a + each}startingWith(0))shouldBe(15)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }

        test "listdoseparatedby" do {
            var s := ""
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert (s) shouldBe ("2, 4, 6, 8")
        }

        test "listdoseparatedbyempty" do {
            var s := "nothing"
            empty.do { failBecause "do did when list is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "listdoseparatedbysingleton" do {
            var s := "nothing"
            col.list.with(1).do { each -> assert(each)shouldBe(1) }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "listkeysandvaluesdo" do {
            def accum = col.dictionary.empty
            var n := 1
            evens.keysAndValuesDo { k, v ->
                accum.at(k)put(v)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (col.dictionary.with(col.key(1) value(2), col.key(2) value(4), coo.key(3) value(6), col.key(4) value(8)))
        }

        test "listasstringnonempty" do {
            assert (evens.asString) shouldBe ("[2, 4, 6, 8]")
        }

        test "listasstringempty" do {
            assert (empty.asString) shouldBe ("[]")
        }

        test "listmapempty" do {
            assert (empty.map{x -> x * x}.onto(col.list)) shouldBe (col.list.empty)
        }

        test "listmapevens" do {
            assert(evens.map{x -> x + 1}.onto(col.list)) shouldBe (col.list.with(3, 5, 7, 9))
        }

        test "listmapevensinto" do {
            assert(evens.map{x -> x + 10}.into(col.list.withAll(evens)))
                shouldBe (col.list.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        test "listfilternone" do {
            deny(oneToFive.filter{x -> false}.iterator.hasNext)
        }

        test "listfilterempty" do {
            deny(empty.filter{x -> (x % 2) == 1}.iterator.hasNext)
        }

        test "listfilterodd" do {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(col.list))
                shouldBe (col.list.with(1, 3, 5))
        }

        test "listmapandfilter" do {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.onto(col.list))
                shouldBe (col.list.with(11, 13, 15))
        }

        test "listcopy" do {
            def evensCopy = evens.copy
            evens.removeFirst
            evens.removeFirst
            assert (evens.size) shouldBe 2
            assert (evensCopy) shouldBe (col.list.with(2, 4, 6, 8))
            assert (evensCopy.second) shouldBe 4
        }

        test "listtosequence1to5" do {
            assert (oneToFive.asSequence) shouldBe (col.sequence.with(1, 2, 3, 4, 5))
            assert (oneToFive.asSequence) hasType (col.Sequence)
        }

        test "listtosequenceempty" do {
            assert (empty.asSequence) shouldBe (col.sequence.empty)
            assert (empty.asSequence) hasType (col.Sequence)
        }

        test "listtoset1to5" do {
            assert (oneToFive.asSet) shouldBe (col.set.with(1, 2, 3, 4, 5))
            assert (oneToFive.asSet) hasType (col.Set)
        }

        test "listtosetempty" do {
            assert (empty.asSet) shouldBe (col.set.empty)
            assert (empty.asSet) hasType (col.Set)
        }
        test "listtosetduplicates" do {
            def theSet = col.list.with(1,1,2,2,4).asSet
            assert (theSet) shouldBe (col.set.with(1, 2, 4))
            assert (theSet) hasType (col.Set)
        }
        test "listiteratorempty" do {
            deny (empty.iterator.hasNext)
                description "empty iterator has an element"
        }
        test "listiteratornonempty" do {
            def accum = col.set.empty
            def iter = oneToFive.iterator
            while { iter.hasNext } do { accum.add(iter.next) }
            assert (accum) shouldBe (col.set.with(1, 2, 3, 4, 5))
        }
        test "listiteratortosetduplicates" do {
            def accum = col.set.empty
            def iter = col.list.with(1, 1, 2, 2, 4).iterator
            while { iter.hasNext } do { accum.add(iter.next) }
            assert (accum) shouldBe (col.set.with(1, 2, 4))
        }
        test "listsort" do {
            def input = col.list.with(7, 6, 4, 1)
            def output = col.list.with(1, 4, 6, 7)
            assert (input.sort) shouldBe (output)
            assert (input) shouldBe (output)
        }
        test "listsortblock" do {
            def input = col.list.with(6, 7, 4, 1)
            def output = col.list.with(7, 6, 4, 1)
            assert (input.sortBy{a, b -> b - a}) shouldBe (output)
            assert (input) shouldBe (output)
        }
        test "listsorted" do {
            def input = col.list.with(7, 6, 4, 1)
            def output = col.list.with(1, 4, 6, 7)
            assert (input.sorted) shouldBe (output)
            assert (input) shouldBe (col.list.with(7, 6, 4, 1))
        }
        test "listsortedblock" do {
            def input = col.list.with(6, 7, 4, 1)
            def output = col.list.with(7, 6, 4, 1)
            assert (input.sortedBy{a, b -> b - a}) shouldBe (output)
            assert (input) shouldBe (col.list.with(6, 7, 4, 1))
        }
        test "listasdictionary" do {
            assert(evens.asDictionary) shouldBe
                (col.dictionary.with(col.key(1) value(2), col.key(2) value(4), col.key(3) value(6), col.key(4) value(8)))
        }
        test "listfailfastiterator" do {
          def input = col.list.with(1, 2, 3, 4, 5)
          def iter = input.iterator
          input.at(3)put(6)
          assert {iter.next} shouldRaise (ConcurrentModification)
          def iter2 = input.iterator
          assert {iter2.next} shouldntRaise (ConcurrentModification)
          def iter3 = input.iterator
          input.remove(2)
          assert {iter3.next} shouldRaise (ConcurrentModification)
          def iter4 = input.iterator
          input.removeAt(1)
          assert {iter4.next} shouldRaise (ConcurrentModification)
        }
}

suite "setTest" do {

        def oneToFive = col.set.with(1, 2, 3, 4, 5)
        def evens = col.set.with(2, 4, 6, 8)
        def empty = col.set.empty

        test "settypecollection" do {
            def witness = set<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (col.Collection<Number>)
        }
        test "settypeset" do {
            def witness = set<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (col.Set<Number>)
        }
        test "settypenotsequence" do {
            def witness = set<Number>.with(1, 2, 3, 4, 5, 6)
            deny (witness) hasType (col.Sequence<Number>)
        }

        test "setsize" do {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }

        test "setsizeafterremove" do {
            oneToFive.remove(1, 3, 5)
            assert(oneToFive.size) shouldBe 2
        }

        test "setemptydo" do {
            empty.do {each -> failBecause "emptySet.do did with {each}"}
            assert(true)
        }

        test "setequalityempty" do {
            assert(empty == col.set.empty)
            deny (empty != col.set.empty)
        }

        test "setinequalityempty" do {
            deny(empty == col.set.with(1))
            assert(empty != col.set.with(1))
            deny(empty == 3)
            deny(empty == evens)
        }

        test "setinequalityfive" do {
            deny(oneToFive == col.set.with(1, 2, 3, 4, 6))
            assert(oneToFive != col.set.with(1, 2, 3, 4, 6))
        }

        test "setequalityfive" do {
            def isEqual = (oneToFive == col.set.with(1, 2, 3, 4, 5))
            assert(isEqual)
            deny(oneToFive != col.set.with(1, 2, 3, 4, 5))
        }

        test "setonetofivedo" do {
            def accum = col.set.empty
            var n := 1
            oneToFive.do { each ->
                accum.add(each)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (oneToFive)
        }

        test "setadd" do {
            assert (empty.add(9)) shouldBe (col.set.with(9))
            assert (evens.add(10)) shouldBe (col.set.with(2, 4, 6, 8, 10))
        }

        test "setremove2" do {
            assert (evens.remove(2)) shouldBe (col.set.with(4, 6, 8))
            assert (evens) shouldBe (col.set.with(4, 6, 8))
        }
        test "setremove4" do {
            assert (evens.remove(4)) shouldBe (col.set.with(2, 6, 8))
            assert (evens) shouldBe (col.set.with(2, 6, 8))
        }
        test "setremove6" do {
            assert (evens.remove(6)) shouldBe (col.set.with(2, 4, 8))
            assert (evens) shouldBe (col.set.with(2, 4, 8))
        }
        test "setremove8" do {
            assert (evens.remove(8)) shouldBe (col.set.with(2, 4, 6))
            assert (evens) shouldBe (col.set.with(2, 4, 6))
        }
        test "setremovemultiple" do {
            assert (evens.remove(4, 6, 8)) shouldBe (col.set.with(2))
            assert (evens) shouldBe (col.set.with(2))
        }
        test "setremove5" do {
            assert {evens.remove(5)} shouldRaise (NoSuchObject)
        }

        test "setchaining" do {
            oneToFive.add(11).add(12).add(13)
            assert (oneToFive) shouldBe (col.set.with(1, 2, 3, 4, 5, 11, 12, 13))
        }
        test "setpushandexpand" do {
            evens.add(10)
            evens.add(12)
            evens.add(14)
            evens.add(16, 18, 20)
            assert (evens) shouldBe (col.set.with(2, 4, 6, 8, 10, 12, 14, 16, 18, 20))
        }
        test "emptyiterator" do {
            deny (empty.iterator.hasNext) description "the empty iterator has an element"
        }
        test "evensiterator" do {
            def ei = evens.iterator
            assert (evens.size == 4) description "evens doesn't contain 4 elements!"
            assert (ei.hasNext) description "the evens iterator has no elements"
            def copySet = col.set.with(ei.next, ei.next, ei.next, ei.next)
            deny (ei.hasNext) description "the evens iterator has more than 4 elements"
            assert (copySet) shouldBe (evens)
        }
        test "setfold" do {
            assert(oneToFive.fold{a, each -> a + each}startingWith(5))shouldBe(20)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }

        test "setdoseparatedby" do {
            var s := ""
            evens.remove(2).remove(4)
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert ((s == "6, 8") || (s == "8, 6"))
                description "{s} should be \"8, 6\" or \"6, 8\""
        }

        test "setdoseparatedbyempty" do {
            var s := "nothing"
            empty.do { failBecause "do did when list is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "setdoseparatedbysingleton" do {
            var s := "nothing"
            col.set.with(1).do { each -> assert(each)shouldBe(1) }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "setasstringnonempty" do {
            evens.remove(6).remove(8)
            assert ((evens.asString == "set\{2, 4\}") || (evens.asString == "set\{4, 2\}"))
                description "set\{2, 4\}.asString is {evens.asString}"
        }

        test "setasstringempty" do {
            assert (empty.asString) shouldBe ("set\{\}")
        }

        test "setmapempty" do {
            assert (empty.map{x -> x * x}.onto(set)) shouldBe (col.set.empty)
        }

        test "setmapevens" do {
            assert(evens.map{x -> x + 1}.onto(set)) shouldBe (col.set.with(3, 5, 7, 9))
        }

        test "setmapevensinto" do {
            assert(evens.map{x -> x + 10}.into(col.set.withAll(evens)))
                shouldBe (col.set.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        test "setfilternone" do {
            assert(oneToFive.filter{x -> false}.isEmpty)
                description "filtered(false) set isn't empty"
        }

        test "setfilterempty" do {
            assert(evens.filter{x -> (x % 2) == 1}.isEmpty)
                description "filtered(odd) set isn't empty"
        }

        test "setfilterodd" do {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(set))
                shouldBe (col.set.with(1, 3, 5))
        }

        test "setmapandfilter" do {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.onto(set))
                shouldBe (col.set.with(11, 13, 15))
        }

        test "setcopy" do {
            def evensCopy = evens.copy
            evens.remove(2, 4)
            assert (evens.size) shouldBe 2
            assert (evensCopy) shouldBe (col.set.with(2, 4, 6, 8))
        }
        test "setunion" do {
            assert (oneToFive ++ evens) shouldBe (col.set.with(1, 2, 3, 4, 5, 6, 8))
        }
        test "setdifference" do {
            assert (oneToFive -- evens) shouldBe (col.set.with(1, 3, 5))
        }
        test "setintersection" do {
            assert (oneToFive ** evens) shouldBe (col.set.with(2, 4))
        }
        test "setfailfastiterator" do {
            def input = col.set.with(1, 5, 3, 2, 4)
            def iter = input.iterator
            input.add(6)
            assert {iter.next} shouldRaise (ConcurrentModification)
            def iter2 = input.iterator
            assert {iter2.next} shouldntRaise (ConcurrentModification)
            def iter3 = input.iterator
            input.remove(2)
            assert {iter3.next} shouldRaise (ConcurrentModification)
        }
}

suite "dictionaryTest" do {
        def oneToFive = col.dictionary.with( (col.key("one") value(1)),  (col.key("two") value(2)),  (col.key("three") value(3)),
             (col.key("four") value(4)),  (col.key("five") value(5)))
        def evens = col.dictionary.with( (col.key("two") value(2)),  (col.key("four") value(4)),  (col.key("six") value(6)),  (col.key("eight") value(8)))
        def empty = col.dictionary.empty


        test "dictionarytypecollection" do {
            assert (oneToFive) hasType (Collection<Binding<String,Number>>)
        }
        test "dictionarytypedictionary" do {
            assert (oneToFive) hasType (Dictionary<String,Number>)
        }
        test "dictionarytypenottypewithwombat" do {
            deny (oneToFive) hasType (Dictionary<String,Number> & type { wombat })
        }

        test "dictionarysize" do {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }

        test "dictionarysizeafterremove" do {
            oneToFive.removeKey "one"
            deny(oneToFive.containsKey "one") description "\"one\" still present"
            oneToFive.removeKey "two"
            oneToFive.removeKey "three"
            assert(oneToFive.size) shouldBe 2
        }

        test "dictionarycontentsaftermultipleremove" do {
            oneToFive.removeKey("one", "two", "three")
            assert(oneToFive.size) shouldBe 2
            deny(oneToFive.containsKey "one") description "\"one\" still present"
            deny(oneToFive.containsKey "two") description "\"two\" still present"
            deny(oneToFive.containsKey "three") description "\"three\" still present"
            assert(oneToFive.containsKey "four")
            assert(oneToFive.containsKey "five")
        }

        test "asstring" do {
            def dict2 = col.dictionary.with( (col.key("one") value(1)),  (col.key("two") value(2)))
            def dStr = dict2.asString
            assert((dStr == "dict⟬one :: 1, two :: 2⟭").orElse{dStr == "dict⟬two :: 2, one :: 1⟭"})
                description "\"{dStr}\" should be \"dict⟬one :: 1, two :: 2⟭\""
        }

        test "asstringempty" do {
            assert(empty.asString) shouldBe "dict⟬⟭"
        }

        test "dictionaryemptydo" do {
            empty.do {each -> failBecause "emptySet.do did with {each}"}
            assert (true)   // so that there is always an assert
        }

        test "dictionaryequalityempty" do {
            assert(empty == col.dictionary.empty)
            deny(empty != col.dictionary.empty)
        }
        test "dictionaryinequalityempty" do {
            deny(empty == col.dictionary.with( (col.key("one") value(1))))
                description "empty dictionary equals dictionary with \"one\" :: 1"
            assert(empty != col.dictionary.with( (col.key("two") value(2))))
                description "empty dictionary equals dictionary with \"two\" :: 2"
            deny(empty == 3)
            deny(empty == evens)
        }
        test "dictionaryinequalityfive" do {
            evens.at "ten" put 10
            assert(evens.size == oneToFive.size) description "evens.size should be 5"
            deny(oneToFive == evens)
            assert(oneToFive != evens)
        }
        test "dictionaryequalityfive" do {
            assert(oneToFive == col.dictionary.with( (col.key("one") value(1)),  (col.key("two") value(2)),  (col.key("three") value(3)),
                 (col.key("four") value(4)),  (col.key("five") value(5))))
        }
        test "dictionarykeysandvaluesdo" do {
            def accum = col.dictionary.empty
            var n := 1
            oneToFive.keysAndValuesDo { k, v ->
                accum.at(k)put(v)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (oneToFive)
        }
        test "dictionaryemptybindingsiterator" do {
            deny (empty.bindings.iterator.hasNext)
                description "the empty bindings iterator has elements"
        }
        test "dictionaryevensbindingsiterator" do {
            def ei = evens.bindings.iterator
            assert (evens.size == 4) description "evens doesn't contain 4 elements!"
            assert (ei.hasNext) description "the evens iterator has no elements"
            def copyDict = col.dictionary.with(ei.next, ei.next, ei.next, ei.next)
            deny (ei.hasNext) description "the evens iterator has more than 4 elements"
            assert (copyDict) shouldBe (evens)
        }
        test "dictionaryadd" do {
            assert (empty.at "nine" put(9))
                shouldBe (col.dictionary.with( (col.key("nine") value(9))))
            assert (evens.at "ten" put(10).values.onto(set))
                shouldBe (col.set.with(2, 4, 6, 8, 10))
        }
        test "dictionaryremovekeytwo" do {
            assert (evens.removeKey "two".values.onto(set)) shouldBe (col.set.with(4, 6, 8))
            assert (evens.values.onto(set)) shouldBe (col.set.with(4, 6, 8))
        }
        test "dictionaryremovevalue4" do {
            assert (evens.size == 4) description "evens doesn't contain 4 elements"
            evens.removeValue(4)
            assert (evens.size == 3)
                description "after removing 4, 3 elements should remain"
            assert (evens.containsKey "two") description "Can't find key \"two\""
            assert (evens.containsKey "six") description "Can't find key \"six\""
            assert (evens.containsKey "eight") description "Can't find key \"eight\""
            deny (evens.containsKey "four") description "Found key \"four\""
            assert (evens.removeValue(4).values.onto(set)) shouldBe (col.set.with(2, 6, 8))
            assert (evens.values.onto(set)) shouldBe (col.set.with(2, 6, 8))
            assert (evens.keys.onto(set)) shouldBe (col.set.with("two", "six", "eight"))
        }
        test "dictionaryremovemultiple" do {
            evens.removeValue(4, 6, 8)
            assert (evens) shouldBe (dictionary.at"two"put(2))
        }
        test "dictionaryremove5" do {
            assert {evens.removeKey(5)} shouldRaise (NoSuchObject)
        }
        test "dictionaryremovekeyfive" do {
            assert {evens.removeKey("Five")} shouldRaise (NoSuchObject)
        }
        test "dictionarychaining" do {
            oneToFive.at "eleven" put(11).at "twelve" put(12).at "thirteen" put(13)
            assert (oneToFive.values.onto(set)) shouldBe (col.set.with(1, 2, 3, 4, 5, 11, 12, 13))
        }
        test "dictionarypushandexpand" do {
            evens.removeKey "two"
            evens.removeKey "four"
            evens.removeKey "six"
            evens.at "ten" put(10)
            evens.at "twelve" put(12)
            evens.at "fourteen" put(14)
            evens.at "sixteen" put(16)
            evens.at "eighteen" put(18)
            evens.at "twenty" put(20)
            assert (evens.values.onto(set))
                shouldBe (col.set.with(8, 10, 12, 14, 16, 18, 20))
        }

        test "dictionaryfold" do {
            assert(oneToFive.fold{a, each -> a + each}startingWith(5))shouldBe(20)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }

        test "dictionarydoseparatedby" do {
            var s := ""
            evens.removeValue(2, 4)
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert ((s == "6, 8") || (s == "8, 6"))
                description "{s} should be \"8, 6\" or \"6, 8\""
        }

        test "dictionarydoseparatedbyempty" do {
            var s := "nothing"
            empty.do { failBecause "do did when list is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "dictionarydoseparatedbysingleton" do {
            var s := "nothing"
            col.set.with(1).do { each -> assert(each)shouldBe(1) }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        test "dictionaryasstringnonempty" do {
            evens.removeValue(6, 8)
            assert ((evens.asString == "dict⟬two :: 2, four :: 4⟭") ||
                        (evens.asString == "dict⟬four :: 4, two :: 2⟭"))
                        description "evens.asString = {evens.asString}"
        }

        test "dictionaryasstringempty" do {
            assert (empty.asString) shouldBe ("dict⟬⟭")
        }

        test "dictionarymapempty" do {
            assert (empty.map{x -> x * x}.onto(set)) shouldBe (col.set.empty)
        }

        test "dictionarymapevens" do {
            assert(evens.map{x -> x + 1}.onto(set)) shouldBe (col.set.with(3, 5, 7, 9))
        }

        test "dictionarymapevensinto" do {
            assert(evens.map{x -> x + 10}.into(col.set.withAll(evens)))
                shouldBe (col.set.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        test "dictionaryfilternone" do {
            assert(oneToFive.filter{x -> false}.isEmpty)
        }

        test "dictionaryfilterempty" do {
            assert(empty.filter{x -> (x % 2) == 1}.isEmpty)
        }

        test "dictionaryfilterodd" do {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(set))
                shouldBe (col.set.with(1, 3, 5))
        }

        test "dictionarymapandfilter" do {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.asSet)
                shouldBe (col.set.with(11, 13, 15))
        }
        test "dictionarybindings" do {
            assert(oneToFive.bindings.onto(set)) shouldBe (
                col.set.with( (col.key("one") value(1)),  (col.key("two") value(2)),  (col.key("three") value(3)),  (col.key("four") value(4)),  (col.key("five") value(5))))
        }
        test "dictionarykeys" do {
            assert(oneToFive.keys.onto(set)) shouldBe (
                col.set.with("one", "two", "three", "four", "five") )
        }
        test "dictionaryvalues" do {
            assert(oneToFive.values.onto(set)) shouldBe (
                col.set.with(1, 2, 3, 4, 5) )
        }

        test "dictionarycopy" do {
            def evensCopy = evens.copy
            evens.removeKey("two")
            evens.removeValue(4)
            assert (evens.size) shouldBe 2
            assert (evensCopy) shouldBe
                (col.dictionary.with( (col.key("two") value(2)),  (col.key("four") value(4)),  (col.key("six") value(6)),  (col.key("eight") value(8))))
        }

        test "dictionaryasdictionary" do {
            assert(evens.asDictionary) shouldBe (evens)
        }

        test "dictionaryvaluesempty" do {
            def vs = empty.values
            assert(vs.isEmpty)
            assert(vs) shouldBe (col.sequence.empty)
        }
        test "dictionarykeysempty" do {
            assert(empty.keys) shouldBe (col.sequence.empty)
        }
        test "dictionaryvaluessingle" do {
            assert(col.dictionary.with( (col.key("one") value(1))).values) shouldBe
                (col.sequence.with 1)
        }
        test "dictionarykeyssingle" do {
            assert(col.dictionary.with( (col.key("one") value(1))).keys) shouldBe
                (col.sequence.with "one")
        }
        test "dictionarybindingsevens" do {
            assert(evens.bindings.asSet) shouldBe
                (col.set.with( (col.key("two") value(2)),  (col.key("four") value(4)),  (col.key("six") value(6)),  (col.key("eight") value(8))))
        }
        test "dictionarysortedonvalues" do {
            assert(evens.bindings.sortedBy{b1, b2 -> b1.value.compare(b2.value)})
                shouldBe (col.sequence.with( (col.key("two") value(2)),  (col.key("four") value(4)),  (col.key("six") value(6)),  (col.key("eight") value(8))))
        }
        test "dictionarysortedonkeys" do {
            assert(evens.bindings.sortedBy{b1, b2 -> b1.key.compare(b2.key)})
                shouldBe (col.sequence.with( (col.key("eight") value(8)),  (col.key("four") value(4)),  (col.key("six") value(6)),  (col.key("two") value(2))))
        }
        test "dictionaryfailfastiteratorvalues" do {
            def input = col.dictionary.with( (col.key("one") value(1)),  (col.key("five") value(5)),  (col.key("three") value(3)),  (col.key("two") value(2)),  (col.key("four") value(4)))
            def iter = input.iterator
            input.at "three" put(100)
            assert {iter.next} shouldRaise (ConcurrentModification)
            def iter2 = input.iterator
            input.at "three"
            assert {iter2.next} shouldntRaise (ConcurrentModification)
            def iter3 = input.iterator
            input.removeValue(2)
            assert {iter3.next} shouldRaise (ConcurrentModification)
            def iter4 = input.iterator
            input.removeKey("four")
            assert {iter4.next} shouldRaise (ConcurrentModification)
        }
        test "dictionaryfailfastiteratorkeys" do {
            def input = col.dictionary.with( (col.key("one") value(1)),  (col.key("five") value(5)),  (col.key("three") value(3)),  (col.key("two") value(2)),  (col.key("four") value(4)))
            def iter = input.keys.iterator
            input.at "three" put(100)
            assert {iter.next} shouldRaise (ConcurrentModification)
            def iter2 = input.keys.iterator
            input.at "three"
            assert {iter2.next} shouldntRaise (ConcurrentModification)
            def iter3 = input.keys.iterator
            input.removeValue(2)
            assert {iter3.next} shouldRaise (ConcurrentModification)
            def iter4 = input.keys.iterator
            input.removeKey("four")
            assert {iter4.next} shouldRaise (ConcurrentModification)
        }
        test "dictionaryfailfastiteratorbindings" do {
            def input = col.dictionary.with( (col.key("one") value(1)),  (col.key("five") value(5)),  (col.key("three") value(3)),  (col.key("two") value(2)),  (col.key("four") value(4)))
            def iter = input.bindings.iterator
            input.at "three" put(100)
            assert {iter.next} shouldRaise (ConcurrentModification)
            def iter2 = input.bindings.iterator
            input.at "three"
            assert {iter2.next} shouldntRaise (ConcurrentModification)
            def iter3 = input.bindings.iterator
            input.removeValue(2)
            assert {iter3.next} shouldRaise (ConcurrentModification)
            def iter4 = input.bindings.iterator
            input.removeKey("four")
            assert {iter4.next} shouldRaise (ConcurrentModification)
        }
}

suite "lazyEnumTest" do {
        def oneToFive = (col.range.from 1 to 5).filter{ x -> true }
        def empty = (col.range.from 1 to 5).filter{ x -> false }

        test "lazyfold" do {
            def sum = oneToFive.fold{ a, x -> a + x } startingWith 0
            assert (sum) shouldBe 15
        }
        test "lazyfoldempty" do {
            def sum = empty.fold{ a, x -> a + x } startingWith 0
            assert (sum) shouldBe 0
        }
        test "lazyequality" do {
            assert (oneToFive) shouldBe (1 .. 5)
        }
        test "lazyequalityempty" do {
            assert (empty) shouldBe (col.sequence.empty)
        }
        test "lazyfailfast" do {
            def o25List = oneToFive.asList
            def o25Iter = o25List.iterator
            def first = o25Iter.next
            assert (first) shouldBe 1
            o25List.addFirst 0
            assert {o25Iter.next} shouldRaise (ConcurrentModification)
        }
}

