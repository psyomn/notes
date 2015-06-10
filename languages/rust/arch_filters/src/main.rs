/// Rust version this compiles against:
/// rustc 1.2.0-dev (2dd5ad0be 2015-05-18) (built 2015-05-19)
extern crate rand;

use rand::Rng;
use std::thread::sleep_ms;
use std::thread::{spawn};
use std::sync::mpsc::{Sender, Receiver, channel};
use std::io::Write;

/// A source, that generates random numbers. Numbers are from 0 to 100, and
/// send it to the next filter. Notice there is no receiver.
fn random_number_source(s: Sender<i32>) {
    let mut r = rand::thread_rng();

    loop {
        sleep_ms(1000);
        s.send(r.gen::<i32>() % 200);
    }
}

/// Whatever number is taken in, we multiply by 10, and send it to the next
/// filter
fn times_10_filter(s: Sender<i32>, r: Receiver<i32>) {
    loop {
        let n: i32 = r.recv().unwrap() * 10;
        s.send(n);
    }
}

/// Simply adds 2, to whatever number is received
fn plus_2_filter(s: Sender<i32>, r: Receiver<i32>) {
    loop {
        let n: i32 = r.recv().unwrap() + 2;
        s.send(n);
    }
}

/// Substracts a random number, where the random number is max __magnitude__ of 40.
/// NOTE: this might add numbers if gen returns a negative number
fn minus_up_to_40_filter(s: Sender<i32>, r: Receiver<i32>) {
    loop {
        let mut rand = rand::thread_rng();
        let sub: i32 = rand.gen::<i32>() % 41;
        let rslt: i32 = r.recv().unwrap() - sub;
        s.send(rslt);
    }
}

/// Main can be our sink. Let's have this setup:
///   randnumsource -> times10 -> plus2 -> minusupto40 -> sink
fn main() {
    let (s_src, r_t10)  : (Sender<i32>, Receiver<i32>) = channel();
    let (s_t10, r_p2)   : (Sender<i32>, Receiver<i32>) = channel();
    let (s_p2,  r_m40)  : (Sender<i32>, Receiver<i32>) = channel();
    let (s_m40, r_sink) : (Sender<i32>, Receiver<i32>) = channel();

    spawn(||{ random_number_source(s_src)         });
    spawn(||{ times_10_filter(s_t10, r_t10)       });
    spawn(||{ plus_2_filter(s_p2, r_p2)           });
    spawn(||{ minus_up_to_40_filter(s_m40, r_m40) });

    println!("Sink is listening...");

    loop {
        let val: i32 = r_sink.recv().unwrap();
        print!("{}, ", val);
        std::io::stdout().flush();
    }
}

