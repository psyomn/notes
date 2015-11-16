extern crate chat;

use std::io;
use std::io::Write;

use chat::Client;

fn main() -> () {
    let nick: String = read_nick();

    let mut client = match Client::from_address("localhost:44444".to_owned(), nick) {
        Ok(v) => v,
        Err(e) => panic!("Could not start client: {}", e),
    };

    send_loop(&mut client);
}

/// Simple helper to read the nick
fn read_nick() -> String {
    let mut nick: String = String::new();

    print!("nick: ");
    io::stdout().flush().unwrap();
    loop {
        match io::stdin().read_line(&mut nick) {
            Ok(1...4) => {
                println!("bigger nick required");
                nick.clear();
                print!("nick: ");
                io::stdout().flush().unwrap();
            },
            Ok(..) => {
                break
            },
            Err(..) => {
                println!("Error, please enter a valid nickname");
                print!("nick: ");
            },
        }
    }

    nick.trim().into()
}

fn send_loop(c: &mut Client) -> () {
    let mut message: String = String::new();

    loop {
        message.clear();
        let read_ret = io::stdin().read_line(&mut message);
        match read_ret {
            Ok(..) => {
                println!("read a line");
                match c.send(message.clone()) {
                    Ok(..) => println!("Received 200!"),
                    Err(e) => println!("Something went wrong: {}", e),
                }
            },
            Err(..) => continue,
        }
    }
}

