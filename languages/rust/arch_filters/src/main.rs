use std::rand;
use std::rand::Rng;
use std::io::timer::sleep;
use std::time::duration::Duration;

/// A source, that generates random numbers. Numbers are from 0 to 100, and
/// send it to the next filter. Notice there is no receiver.
fn random_number_source(s: Sender<int>) {
    let mut r = rand::task_rng();

    loop {
        sleep(Duration::seconds(1));
        s.send(r.gen::<int>() % 200);
    }
}

/// Whatever number is taken in, we multiply by 10, and send it to the next
/// filter
fn times_10_filter(s: Sender<int>, r: Receiver<int>) {
    loop {
        let n: int = r.recv() * 10;
        s.send(n);
    }
}

/// Simply adds 2, to whatever number is received
fn plus_2_filter(s: Sender<int>, r: Receiver<int>) {
    loop {
        let n: int = r.recv() + 2;
        s.send(n);
    }
}

/// Substracts a random number, where the random number is max __magnitude__ of 40.
/// NOTE: this might add numbers if gen returns a negative number
fn minus_up_to_40_filter(s: Sender<int>, r: Receiver<int>) {
    loop {
        let mut rand = rand::task_rng();
        let sub: int = rand.gen::<int>() % 41;
        let rslt: int = r.recv() - sub;
        s.send(rslt);
    }
}

/// Main can be our sink. Let's have this setup:
///   randnumsource -> times10 -> plus2 -> minusupto40 -> sink
fn main() {
    let (s_src, r_t10)  : (Sender<int>, Receiver<int>) = channel();
    let (s_t10, r_p2)   : (Sender<int>, Receiver<int>) = channel();
    let (s_p2,  r_m40)  : (Sender<int>, Receiver<int>) = channel();
    let (s_m40, r_sink) : (Sender<int>, Receiver<int>) = channel();

    spawn(proc(){ random_number_source(s_src)         });
    spawn(proc(){ times_10_filter(s_t10, r_t10)       });
    spawn(proc(){ plus_2_filter(s_p2, r_p2)           });
    spawn(proc(){ minus_up_to_40_filter(s_m40, r_m40) });

    println!("Sink is listening...");

    loop {
        let val: int = r_sink.recv();
        print!("{}, ", val);
        std::io::stdio::flush();
    }
}

