use std::net::{TcpListener, TcpStream};
use std::io::{Read, Write};
use std::io;
use std::thread;

pub struct Server {
    host: String,
    port: u16,
    listening_done: bool,
    //clients: Vec<Address>,
}

impl Server {
    pub fn new(h: String, p: u16) -> Server {
        Server {
            host: h,
            port: p,
            listening_done: false,
        }
    }

    pub fn listen(&mut self) -> () {
        println!("start: host {}, port {}", self.host, self.port);
        let listener: TcpListener = TcpListener::bind(format!("{}:{}", self.host, self.port).as_ref() as &str).unwrap();
        for stream in listener.incoming() {
            match stream {
                Ok(stream) => {
                    println!("Received something");
                },
                Err(e) => {
                    write!(io::stderr(), "Error!");
                },
            }
        }

        drop(listener);
    }
}
