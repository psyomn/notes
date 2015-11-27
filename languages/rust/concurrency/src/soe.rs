//! Just some idea I had in the mean time that if one number is found to divide the next term, then
//! the parallel parts may bail, and wait for the next order from the master thread


fn main() -> () {
    println!("{:?}", simple_soe(500_000));
}

/// Alg. Desc:
///
///    Init:
///
///       Make a starting array A of elements [2, 3, 5, 7]
///       Make 1 master
///       Make n worker where n are the cores
///       Each worker takes a slice of array A
///
///    Actions:
///
///       Master attempts the next term k + 2 (ignoring even terms)
///       Master sends term k + 2 to all workers
///       All workers try to see if the terms they know about divide k + 2
///       First worker that succeeds, notifies Master
///       Master stops all running workers
///       Master cyclicly distributes newfound primes to workers
///       Back to first step of Actions
///
///    Output:
///
///       List of prime numbers
///

fn multi_soe() -> () {}

fn soe_master() -> () {}

mod masters {
    use std::sync::mpsc::{Sender, Receiver, channel};
    use std::thread::JoinHandle;
    use std::thread;

    struct Master {
        workers: Vec<JoinHandle<Vec<u64>>>,
        listen: Receiver<bool>,
    }

    impl Master {
        pub fn new(cores: u16) -> Master {
            let (found_snd, found_rcv) = channel::<bool>();
            for _ in 0..cores {
            }

            Master {
                workers: vec![],
                listen: found_rcv,
            }
        }
    }
}

mod workers {
    use std::sync::mpsc::{Sender, Receiver, channel};

    enum WorkerState {
        Work,
        Listen,
        Exit,
    }

    struct SoeWorker {
        pub state: WorkerState,
        cn_to_master: Sender<bool>,
        cn_next_term: Receiver<u64>,
    }

    impl SoeWorker {
        pub fn new(msender: Sender<bool>, mterms: Receiver<u64>) -> SoeWorker {
            SoeWorker {
                state: WorkerState::Listen,
                cn_to_master: msender,
                cn_next_term: mterms,
            }
        }

        pub fn run(&self) -> () {
            loop {
                match self.state {
                    WorkerState::Work => continue,
                    WorkerState::Listen => continue,
                    WorkerState::Exit => break,
                }
            }
        }
    }
}

/// Not threaded example
fn simple_soe(max: u64) -> Vec<u64> {
    let mut n: u64 = 1;
    let mut v: Vec<u64> = vec![2];
    let mut divides: bool = false;

    while n < max {
        n += 2;

        divides = false;

        for x in v.iter() {
            divides |= n % x == 0;
            if divides { break; }
        }

        if !divides {
            v.push(n);
        }
    }

    v
}

