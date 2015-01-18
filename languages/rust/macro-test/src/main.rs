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

macro_rules! myassign3 {
    ($inp:ident $e1:expr) => (
        $inp += $e1;
        );
}

macro_rules! longmac {
    ($inp:ident) => (
        $inp = $inp * 2 / 3 * 100 - 2 / 2;
        );
}

macro_rules! noinput {
    () => ( println!("noinput!") );
}

macro_rules! pass_block {
    ($bl:block) => (
        fn madefunc() $bl
    )
}

macro_rules! pass_expr {
    ($inp:expr) => ({
        println!("Before passed expression");
        $inp;
        println!("After passed expression");
    })
}

#[bench]
fn bench_with_macro() {
}

#[bench]
fn benc_without_macro() {
}

fn main() {
    let mut a : int = 0;
    let mut b : int = 0;
    let mut x : int = 0;

    myassign!(a -> ((2 + 2)));

    myassign2!(x); myassign2!(x);
    myassign2!(x); myassign2!(x);

    myassign3!(b 9+1);

    println!("{}", a);
    println!("{}", x);
    println!("{}", b);

    pass_block!({println!("potato")});
    pass_expr!(println!("potato"));
}

