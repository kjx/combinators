Getting Parsers
done
Got Parsers
Got Parsers
start
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.

FAILED: 016td3 type A<B,C> = B & C;

FAILED: 016td4 type A<B> = B | Noo | Bar;
.
.
.
.

FAILED: 016td9 type GenericPathType<A,X> = a.b.C<A,X>;
.
.
.
.
.
.
.
.

FAILED: 017f class Foo<A>(a : A, b : B) new(a : A, b : B) where T <: X; { a; b; c;  }

FAILED: 017g class Foo<A, B>(a : A, b : B) where A <: B; { a; b; c;  }

FAILED: 017g class Foo<A, B>(a : A, b : B) where A <: B; where A <: T<A,V,"Foo">; { a; b; c;  }

FAILED: 017g class Foo<A, B>(a : A, b : B) where A <: B; where A <: T<A,V,"Foo">; { method a where T<X; { }; method b(a : Q) where T <: X; { }; method c where SelfType <: Sortable<Foo>; { } }
