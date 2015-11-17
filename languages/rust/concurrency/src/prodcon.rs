//! Producer/Consumer problem example
extern crate rand;
extern crate num_cpus;

use rand::Rng;
use std::sync::mpsc::{Sender, Receiver, channel};
use std::thread;
use std::thread::JoinHandle;
use std::num::Wrapping;
use std::env;

const NUMBER: u64 = 5381;

fn main() -> () {
    let args: Vec<String> = env::args().collect();

    if args.len() != 2 {
        println!("Usage:\n  prodcon <hash-num>");
        return;
    }

    let hashes_wanted: u16 = match args.iter().nth(1) {
        Some(v) => v.parse::<u16>().unwrap_or(21),
        None    => 21,
    };

    let cores = num_cpus::get() as u16;
    let grain: u16 = hashes_wanted / cores;
    let extra = hashes_wanted % cores;
    let mut v: Vec<u16> = Vec::new();
    let mut extra_count = extra;

    for _ in 0..cores {
        v.push(grain);
    }

    while extra_count > 0 {
        /* To distribute the work evenly among workers */
        let nv: u16 = v.remove(0) + 1;
        v.push(nv);
        extra_count -= 1;
    }

    println!("Your computer has {} cores, and we want {} hashes.", cores, hashes_wanted);
    println!("grain {}", grain);
    println!("extra {}", extra);
    println!("work share {:?}", v);

    let (snd, rcv): (Sender<u64>, Receiver<u64>) = channel();
    let mut workers: Vec<JoinHandle<()>> = Vec::new();
    let master: JoinHandle<()> = thread::spawn(move ||{ consumer(rcv, hashes_wanted.clone()) });

    for workload in v {
        println!("making worker with {} task(s)", workload);
        let sndc = snd.clone();
        let w = thread::spawn(move || { hash_producer(sndc, workload) });
        workers.push(w);
    }

    for w in workers {
        let _ = w.join();
    }

    let _ = master.join();
}

fn consumer(rcv: Receiver<u64>, total: u16) {
    let mut count = total;
    while count > 0 {
        let v = rcv.recv().unwrap();
        println!("[{}] {}", count, v);
        count -= 1;
    }
}

fn hash_producer(snd: Sender<u64>, hash_count: u16) -> () {
    for _ in 0..hash_count {
        match snd.send(random_djb2()) {
            Ok(..) => continue,
            Err(e) => println!("Problem sending data {}", e),
        }
    }
}

fn random_djb2() -> u64 {
   let s: String =
       rand::thread_rng()
       .gen_ascii_chars()
       .take(3000000)
       .collect();

   djb2(s)
}

fn djb2(s: String) -> u64 {
    let mut h: Wrapping<u64> = Wrapping(NUMBER);

    // djb2 http://www.cse.yorku.ca/~oz/hash.html
    for c in s.chars() {
        let cc = Wrapping(c as u64);
        h = ((h << 5) + h) + cc;
    }

    match h {
        Wrapping(v) => v,
    }
}
