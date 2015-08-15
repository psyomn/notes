extern crate scraps;
extern crate getopts;

use scraps::{
    methodchain,
    tomlexamples,
    philosophers,
    enumtest,
};

use getopts::Options;
use std::env;

fn main() -> () {
    let opts = make_opts();
    let args: Vec<String> = env::args().collect();

    let tests: Vec<(fn() -> (), &str)> = vec!(
        (tomlexamples::run, "toml examples"),
        (methodchain::run, "method chaining from tutorials"),
        (philosophers::run, "dining philosophers in rust (example from book)"),
        (enumtest::run, "eumeration tests, some from the book"),
    );

    let matches = match opts.parse(&args[1..]) {
        Ok(v) => v,
        Err(e) => panic!("problem parsing args: {}", e),
    };

    if matches.opt_present("h") {
        let brief = format!("Usage: scraps [options]");
        println!("scraps {}", opts.usage(&brief));
        return;
    }

    if matches.opt_present("l") {
        println!("Current tests:");
        for (counter, t) in tests.iter().enumerate() {
            let &(_, d) = t;
            println!("  [{}] - {}", counter + 1, d);
        }
        return;
    }

    if matches.opt_present("t") {
        let val = match matches.opt_str("t") {
            Some(v) => v,
            None => "0".to_string(),
        };

        let mut val_i: i32 = match val.parse() {
            Ok(v) => v,
            Err(..) => 0,
        };

        /* We present the list with +1, so we need to fix input when re receive some */
        val_i -= 1;

        let f = tests.iter().nth(val_i as usize);

        match f {
            Some(v) => match v {
                &(l, _) => l(),
            },
            None => {
                println!("No such test");
                return;
            },
        }
    }
}

fn make_opts() -> Options {
    let mut opts = Options::new();
    opts.optopt("t", "test", "run the test number TEST", "TEST");
    opts.optflag("h", "help", "print help");
    opts.optflag("l", "list-tests", "list available tests");
    opts
}


