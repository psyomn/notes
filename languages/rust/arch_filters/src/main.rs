/// Rust version this compiles against:
/// rustc 1.2.0-dev (2dd5ad0be 2015-05-18) (built 2015-05-19)
/// rustc 1.4.0-dev (8ab8581f6 2015-10-27) (works with)
extern crate rand;

use rand::Rng;
use std::thread::sleep_ms;
use std::thread::{spawn};
use std::sync::mpsc::{Sender, Receiver, channel, SendError};
use std::io::Write;

/// Will only print something if something goes wrong.
fn common_send_handle(r: Result<(), SendError<i32>>) -> () {
    match r {
        Ok(..) => {},
        Err(e) => println!("Problem when sending information: {}", e),
    };
}

/// A source, that generates random numbers. Numbers are from 0 to 100, and
/// send it to the next filter. Notice there is no receiver.
fn random_number_source(s: Sender<i32>) {
    let mut r = rand::thread_rng();

    loop {
        sleep_ms(1000);
        let r = s.send(r.gen::<i32>() % 200);
        common_send_handle(r);
    }
}

/// Whatever number is taken in, we multiply by 10, and send it to the next
/// filter
fn times_10_filter(s: Sender<i32>, r: Receiver<i32>) {
    loop {
        let n: i32 = r.recv().unwrap() * 10;
        let r =s.send(n);
        common_send_handle(r);
    }
}

/// Simply adds 2, to whatever number is received
fn plus_2_filter(s: Sender<i32>, r: Receiver<i32>) {
    loop {
        let n: i32 = r.recv().unwrap() + 2;
        let r = s.send(n);
        common_send_handle(r);
    }
}

/// Substracts a random number, where the random number is max __magnitude__ of 40.
/// NOTE: this might add numbers if gen returns a negative number
fn minus_up_to_40_filter(s: Sender<i32>, r: Receiver<i32>) {
    loop {
        let mut rand = rand::thread_rng();
        let sub: i32 = rand.gen::<i32>() % 41;
        let rslt: i32 = r.recv().unwrap() - sub;
        let r = s.send(rslt);
        common_send_handle(r);
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
        std::io::stdout().flush().unwrap();
    }
}

