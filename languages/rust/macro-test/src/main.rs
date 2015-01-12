#![feature(macro_rules)]

macro_rules! myassign {
    ($inp:ident -> (($e:expr))) => (
        $inp = $e;
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
    myassign!(a -> ((2 + 2)));
    println!("{}", a);
}
