/* rustc 1.0.0-dev (2e2372c6c 2015-01-09 09:50:06 +0000) */

macro_rules! myassign {
    ($inp:ident -> (($e:expr))) => (
        $inp = $e;
        );
}

macro_rules! myassign2 {
    ($inp:ident) => (
        $inp += 5;
        );
}

#[bench]
fn bench_with_macro() {
}

#[bench]
fn benc_without_macro() {
}

fn main() {
    let mut a : int = 0;
    let mut x : int = 0;

    myassign!(a -> ((2 + 2)));

    myassign2!(x); myassign2!(x);
    myassign2!(x); myassign2!(x);

    println!("{}", a);
    println!("{}", x);
}

