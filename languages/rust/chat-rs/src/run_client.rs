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

    client.send("send a message!".to_owned());
}

/// Simple helper to read the nick
fn read_nick() -> String {
    let mut nick: String = String::new();

    print!("nick: ");
    io::stdout().flush();
    loop {
        match io::stdin().read_line(&mut nick) {
            Ok(1...4) => {
                println!("bigger nick required");
                nick.clear();
                print!("nick: ");
                io::stdout().flush();
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
