use std::thread;
use std::sync::{Mutex, Arc};

/*
 * This is from the rust book!
 *   https://doc.rust-lang.org/stable/book/dining-philosophers.html
 */

struct Philosopher {
    name: String,
    left: usize,
    right: usize,
}

struct Table {
    forks: Vec<Mutex<()>>,
}

impl Philosopher {
    pub fn new(name: &str, l: usize, r: usize) -> Philosopher {
        Philosopher {
            name: name.to_string(),
            left: l,
            right: r,
        }
    }
    pub fn eat(&self, t: &Table) -> () {
        let _left = t.forks[self.left].lock().unwrap();
        let _right = t.forks[self.right].lock().unwrap();

        println!("{} started eating ...", self.name);
        thread::sleep_ms(1000);
        println!("{} is done eating!", self.name);
    }
}

pub fn run() -> () {
    let table = Arc::new(Table {forks: vec![
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
    ]});
    let philosophers : Vec<Philosopher> = vec![
        Philosopher::new("1", 0, 1),
        Philosopher::new("2", 1, 2),
        Philosopher::new("3", 2, 3),
        Philosopher::new("4", 3, 4),
        Philosopher::new("5", 0, 4),
    ];

    println!("Running dining philosophers...");

    let handles: Vec<_> = philosophers.into_iter().map(|p| {
        let table = table.clone();
        thread::spawn(move || {
            p.eat(&table);
        })
    }).collect();

    for h in handles {
        h.join().unwrap();
    }
}
