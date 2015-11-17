use std::thread;
use std::thread::sleep_ms;
use std::sync::mpsc::{Sender, Receiver, channel};

fn main() -> () {
    let (s, r) = channel();
    let (s2, r2) = channel();

    let speakers = vec![
        thread::spawn(|| { speaker1(s, r2) }),
        thread::spawn(|| { speaker2(s2, r) }),
    ];

    for speak in speakers {
        speak.join();
    }
}

fn speaker1(snd: Sender<String>, rcv: Receiver<String>) {
    loop {
        let ret = rcv.recv().unwrap();
        println!("S1 RCV: {}", ret);
        sleep_ms(1000);
        let _ = snd.send(ret);
    }
}

fn speaker2(snd: Sender<String>, rcv: Receiver<String>) {
    let mut counter = 0;
    let s: String = "Hello there!".into();
    let _ = snd.send(s);

    loop {
        let ret = rcv.recv().unwrap();
        println!("[{}] S2 RCV: {}", counter, ret);
        sleep_ms(1000);
        let _ = snd.send(ret);
        counter += 1;
    }
}
