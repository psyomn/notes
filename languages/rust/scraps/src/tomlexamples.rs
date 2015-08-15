extern crate toml;

use std::fs::File;
use std::io::Read;
use std::path::Path;

use self::toml::Value::{Table, Array, String};
use self::toml::Value;

pub fn run() -> () {
    let mut stack : Vec<String> = Vec::new();
    let file_path = Path::new("conf.toml");

    let mut file = match File::open(&file_path) {
        Err(e) => panic!("Could not open file: {:?}", file_path),
        Ok(f) => f,
    };

    let mut contents = String::new();

    match file.read_to_string(&mut contents) {
        Err(e) => panic!("Problem reading from file: {:?}", e),
        _ => {},
    };

    let vals = toml::Parser::new(contents.as_ref()).parse().unwrap();

    println!("{:?}", vals);

    for (k, v) in vals.iter() {
        println!("KEY: {:?} / VALUE: {:?}", k, v);
        match v {
            &Table(ref t) => stack.push(k.clone()),
            &Array(ref a) => println!("detected array!"),
            _ => {},
        }
    }

    /* Extracting a value from the TOML. */
    for key in stack.iter() {
        println!("{}", key);
        let v = &vals[key];

        match v {
            &Table(ref t) =>  {
                println!("--- {:?}", t);

                println!("List keys of stuff");
                for (i, j) in t.iter() {
                    println!(">>> {}", i);
                    match &t[i] {
                        &toml::Value::String(ref s) => println!("--->>>> {}", s),
                        _ => {},
                    }
                }

            },
            _ => {},
        }
    }
}


