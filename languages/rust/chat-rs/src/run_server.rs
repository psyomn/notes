extern crate chat;

use chat::Server;

fn main() -> () {
    println!("I'm going to be the server");
    let mut server = Server::new("localhost".to_owned(), 44444);
    server.listen();
}
