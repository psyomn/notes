extern crate toml;

use toml::{Table, Value};
use toml::Value::{Table};
use std::fs::File;
use std::io::Read;

fn main() {
    let fs: Vec<fn() -> ()> = vec![
        access_table_as_btreemap,
        print_toml_table_as_string,
    ];

    for f in fs {
        f();
    }
}

fn access_table_as_btreemap() -> () {
    let mut f = match File::open("data.toml") {
        Ok(v) => v,
        Err(e) => {
            panic!("need a data.toml file to read from {}", e);
        }
    };

    let mut s: String = String::new();
    f.read_to_string(&mut s);

    // println!("File contents: \n{}", s);

    let mut parser = toml::Parser::new(&s);
    let mut results = parser.parse().unwrap();


    println!("Parser results: {:?}", results);

    println!("Attempt to access via a get from BTreeMap...");

    let inner_table = match results.get(&"myconfig1".to_string()) {
        Some(v) => {
            println!("That is totally possible");
            println!("The particular value is: {:?}", v);
            v
        }
        None => {
            panic!("IMPOSSIBLE!!");
        }
    };
}

fn print_toml_table_as_string() -> () {
    let mut f = match File::open("data.toml") {
        Ok(v) => v,
        Err(e) => {
            panic!("need a data.toml file to read from {}", e);
        }
    };

    let mut s: String = String::new();
    f.read_to_string(&mut s);

    // println!("File contents: \n{}", s);

    let mut parser = toml::Parser::new(&s);
    let mut results = parser.parse().unwrap();
    println!("Printing the toml table now");
    let toml_str = toml::encode(&results);

    println!("{}", toml_str);
}

