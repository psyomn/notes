#![feature(macro_rules)]

macro_rules! my_expr(
    ($inp:ty $sp:path) => (
        match $inp {
            $sp(x) => { x + x + x * x }
            _ => {}
        }
    );

)

#[bench]
fn bench_with_macro() {
}

#[bench]
fn benc_without_macro() {
}

fn main() {
    println!("Hello world");
    my_expr!();
}
