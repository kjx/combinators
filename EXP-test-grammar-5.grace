Getting Parsers
done
Got Parsers
Got Parsers
start

FAILED: 015a class Foo { }

FAILED: 015b class Foo { a; b; c }

FAILED: 015b class Foo { method a {}; method b {}; method c {}}

FAILED: 015c class Foo { def x = 0; var x := 19; a; b; c }

FAILED: 015d class Foo(a,b) { a; b; c;  }

FAILED: 015e class Foo(a : A, b : B) { a; b; c;  }

FAILED: 015f class Foo<A>(a : A, b : B) new(a : A, b : B) { a; b; c;  }

FAILED: 015g class Foo<A, B>(a : A, b : B) { a; b; c;  }
.
.
.
.
.
.

FAILED: 015ia class Foo { inherits Foo; }

FAILED: 015ib class Foo { inherits Foo; a; b; c }

FAILED: 015ib class Foo { inherits Foo(3,4); method a {}; method b {}; method c {}}

FAILED: 015ic class Foo { inherits Foo(3,4); def x = 0; var x := 19; a; b; c }

FAILED: 015id class Foo(a,b) { inherits Foo<X>(4); a; b; c;  }

FAILED: 015ie class Foo(a : A, b : B) { inherits goobles; a; b; c;  }

FAILED: 015if class Foo<A>(a : A, b : B) new(a : A, b : B) { inherits OttDtraid; a; b; c;  }

FAILED: 015ig class Foo<A, B>(a : A, b : B) { inherits Foo(2) new(4); a; b; c;  }
.
