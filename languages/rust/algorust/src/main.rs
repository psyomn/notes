extern crate algorust;

use algorust::insort::*;
use algorust::fibonacci::{recfib, itfib};

fn main() {
    let y = 20;

    for x in 0..y {
        println!("{}: {}", x, itfib(x));
    }
}
