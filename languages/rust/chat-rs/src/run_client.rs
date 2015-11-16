extern crate chat;

use chat::Client;

fn main() -> () {
    let mut client = match Client::from_address("localhost:44444".to_owned()) {
        Ok(v) => v,
        Err(e) => panic!("Could not start client: {}", e),
    };

    client.send("send a message!".to_owned());
}
