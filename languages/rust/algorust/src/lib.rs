#![feature(test)]
extern crate test;

pub mod insort;
pub mod fibonacci;

pub struct Item<T> {
    val: T,
}

use test::{Bencher, black_box};

#[bench]
fn recursive_bench(b: &mut Bencher) {
    let ret = black_box(fibonacci::recfib(1_000_000, 0, 1));
    let x = 1 + ret;
}
