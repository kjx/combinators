#!/bin/bash

GRACE="mono --debug /Users/kjx/mwh-gre/kernan/Grace/bin/Debug/Grace.exe"

#run single test
function rt {
 if [ -f $1 ]; 
    then FILE="$1"
    elif [ -f "test-$1.grace" ]; then FILE="test-$1.grace";
    else FILE="test-grammar-$1.grace"
 fi    
$GRACE $FILE > OUT-$FILE
diff EXP-$FILE OUT-$FILE 

}

#run all tests
function runall {
 for t in test-parser*.grace test-grammar*.grace 
   do
      echo $t
      rt $t
   done
}


#updated expected output
function exp {
 if [ -f $1 ]; 
    then FILE="$1"
    elif [ -f "test-$1.grace" ]; then FILE="test-$1.grace";
    else FILE="test-grammar-$1.grace"
 fi    
$GRACE $FILE > EXP-$FILE
}
